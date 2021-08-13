SET SCHEMA Model;
/
CREATE PROCEDURE Problem_Merge (
IN v_ProblemId INTEGER,
IN v_ProblemName LONGVARCHAR,
IN v_ProblemModel LONGVARCHAR,
IN v_ProblemCost DOUBLE
)
MODIFIES SQL DATA BEGIN ATOMIC
MERGE INTO Problem USING ( VALUES (
v_ProblemId,
v_ProblemName,
v_ProblemModel,
v_ProblemCost
) ) ON (
ProblemId = v_ProblemId
)
WHEN MATCHED THEN UPDATE SET
ProblemName = v_ProblemName,
ProblemModel = v_ProblemModel,
ProblemCost = v_ProblemCost
WHEN NOT MATCHED THEN INSERT VALUES
v_ProblemId,
v_ProblemName,
v_ProblemModel,
v_ProblemCost;
END;
/
CREATE PROCEDURE Problem_Update (
IN v_ProblemId INTEGER,
IN v_ProblemModel LONGVARCHAR,
IN v_ProblemCost DOUBLE
)
MODIFIES SQL DATA BEGIN ATOMIC
UPDATE
Problem
SET
ProblemModel = v_ProblemModel,
ProblemCost = v_ProblemCost
WHERE
ProblemId = v_ProblemId;
END;
/
CREATE PROCEDURE ConstraintRhs_Merge (
IN v_ProblemId INTEGER,
IN v_ConstraintId INTEGER,
IN v_ConstraintName LONGVARCHAR,
IN v_ConstraintValue DOUBLE,
IN v_ConstraintRelationship INTEGER
)
MODIFIES SQL DATA BEGIN ATOMIC
MERGE INTO ConstraintRhs USING ( VALUES (
v_ProblemId,
v_ConstraintId,
v_ConstraintName,
v_ConstraintValue,
v_ConstraintRelationship
) ) ON (
ProblemId = v_ProblemId
AND
ConstraintId = v_ConstraintId
)
WHEN MATCHED THEN UPDATE SET
ConstraintName = v_ConstraintName,
ConstraintValue = v_ConstraintValue,
ConstraintRelationship = v_ConstraintRelationship
WHEN NOT MATCHED THEN INSERT VALUES
v_ProblemId,
v_ConstraintId,
v_ConstraintName,
v_ConstraintValue,
v_ConstraintRelationship;
END;
/
CREATE PROCEDURE Variable_Merge (
IN v_ProblemId INTEGER,
IN v_VariableId INTEGER,
IN v_VariableName LONGVARCHAR,
IN v_SolutionValue DOUBLE
)
MODIFIES SQL DATA BEGIN ATOMIC
MERGE INTO Variable USING ( VALUES (
v_ProblemId,
v_VariableId,
v_VariableName,
v_SolutionValue
) ) ON (
ProblemId = v_ProblemId
AND
VariableId = v_VariableId
)
WHEN MATCHED THEN UPDATE SET
VariableName = v_VariableName,
SolutionValue = v_SolutionValue
WHEN NOT MATCHED THEN INSERT VALUES
v_ProblemId,
v_VariableId,
v_VariableName,
v_SolutionValue;
END;
/
CREATE PROCEDURE ConstraintLhs_Merge (
IN v_ProblemId INTEGER,
IN v_ConstraintId INTEGER,
IN v_VariableId INTEGER,
IN v_CoefficientValue DOUBLE,
IN v_SolutionValue DOUBLE
)
MODIFIES SQL DATA BEGIN ATOMIC
MERGE INTO ConstraintLhs USING ( VALUES (
v_ProblemId,
v_ConstraintId,
v_VariableId,
v_CoefficientValue,
v_SolutionValue
) ) ON (
ProblemId = v_ProblemId
AND
ConstraintId = v_ConstraintId
AND
VariableId = v_VariableId
)
WHEN MATCHED THEN UPDATE SET
CoefficientValue = v_CoefficientValue,
SolutionValue = v_SolutionValue
WHEN NOT MATCHED THEN INSERT VALUES
v_ProblemId,
v_ConstraintId,
v_VariableId,
v_CoefficientValue,
v_SolutionValue;
END;
/
CREATE PROCEDURE Objective_Merge (
IN v_ProblemId INTEGER,
IN v_VariableId INTEGER,
IN v_CoefficientValue DOUBLE
)
MODIFIES SQL DATA BEGIN ATOMIC
MERGE INTO Objective USING ( VALUES (
v_ProblemId,
v_VariableId,
v_CoefficientValue
) ) ON (
ProblemId = v_ProblemId
AND
VariableId = v_VariableId
)
WHEN MATCHED THEN UPDATE SET
CoefficientValue = v_CoefficientValue
WHEN NOT MATCHED THEN INSERT VALUES
v_ProblemId,
v_VariableId,
v_CoefficientValue;
END;
/
CREATE FUNCTION getConstraintValue(v_problemId INTEGER,v_constraintId INTEGER) RETURNS DOUBLE
READS SQL DATA
RETURN (SELECT ConstraintValue FROM ConstraintRhs WHERE ProblemId = v_ProblemId AND ConstraintId = v_ConstraintId)
/
CREATE FUNCTION getConstraintRelationship(v_problemId INTEGER,v_constraintId INTEGER) RETURNS INTEGER
READS SQL DATA
RETURN (SELECT ConstraintRelationship FROM ConstraintRhs WHERE ProblemId = v_ProblemId AND ConstraintId = v_ConstraintId)
/
CREATE FUNCTION calculateConstraintLhsSolutionValue (v_problemId INTEGER,v_constraintId INTEGER,v_variableId INTEGER)  RETURNS DOUBLE 
READS SQL DATA 
RETURN (SELECT a.solutionvalue*b.coefficientvalue FROM variable a, constraintlhs b WHERE a.ProblemId = b.ProblemId AND   a.VariableId = b.VariableId AND b.ProblemId = v_problemId AND b.ConstraintId = v_constraintId AND b.VariableId = v_variableId)
/
CREATE PROCEDURE Variable_Update (
IN v_ProblemId INTEGER,
IN v_VariableId INTEGER,
IN v_SolutionValue DOUBLE
)
MODIFIES SQL DATA BEGIN ATOMIC
UPDATE
Variable
SET
SolutionValue = v_SolutionValue
WHERE
ProblemId = v_ProblemId
AND
VariableId = v_VariableId;
END;
/
CREATE PROCEDURE Problem_Select (
IN v_ProblemId INTEGER
)
MODIFIES SQL DATA DYNAMIC RESULT SETS 1 BEGIN ATOMIC
DECLARE result CURSOR
FOR
SELECT
ProblemId,
ProblemName,
ProblemModel,
ProblemCost
FROM
Problem
WHERE
ProblemId = v_ProblemId;
OPEN result;
END;
/
CREATE PROCEDURE ConstraintLhs_Update (
IN v_ProblemId INTEGER,
IN v_ConstraintId INTEGER,
IN v_VariableId INTEGER,
IN v_SolutionValue DOUBLE
)
MODIFIES SQL DATA BEGIN ATOMIC
UPDATE
ConstraintLhs
SET
SolutionValue = v_SolutionValue
WHERE
ProblemId = v_ProblemId
AND
ConstraintId = v_ConstraintId
AND
VariableId = v_VariableId;
END;
/
CREATE PROCEDURE saveModel (
--
IN v_problemId INTEGER
--
)
MODIFIES SQL DATA BEGIN ATOMIC
--
DECLARE solutionCost DOUBLE;
DECLARE lpformatModel LONGVARCHAR;
DECLARE solutionConstraintLhsSolutionValue DOUBLE;
DECLARE n INTEGER;
DECLARE solutionPointValueAt DOUBLE;
--
SET solutionCost = LinearProgramming.getSolutionCost();
SET lpformatModel = LinearProgramming.printModel();
SET n = 0;
--
FOR SELECT variableid FROM variable WHERE problemid = v_problemId DO
--
SELECT LinearProgramming.getSolutionPointValueAt(n) INTO solutionPointValueAt FROM (VALUES(0));
CALL Variable_Update(v_problemId,variableid,solutionPointValueAt);
SET n = n + 1;
--
END FOR;
--
FOR SELECT constraintid,variableid FROM constraintlhs WHERE problemid = v_problemId DO
--
SET solutionConstraintLhsSolutionValue = calculateConstraintLhsSolutionValue(v_problemId,constraintid, variableid);
--
CALL ConstraintLhs_Update(v_problemId, constraintid, variableId, solutionConstraintLhsSolutionValue);
--
END FOR;
--
CALL Problem_Update(v_problemId,lpformatModel,solutionCost);
--
END;
/
CREATE PROCEDURE Variable_Select (
IN v_ProblemId INTEGER
)
MODIFIES SQL DATA DYNAMIC RESULT SETS 1 BEGIN ATOMIC
DECLARE result CURSOR
FOR
SELECT
ProblemId,
VariableId,
VariableName,
SolutionValue
FROM
Variable
WHERE
ProblemId = v_ProblemId;
OPEN result;
END;
/
CREATE PROCEDURE solveModel (
--
IN v_problemId INTEGER
--
)
--
MODIFIES SQL DATA 
--
BEGIN ATOMIC
--
DECLARE v_constraint_relationship INTEGER;
DECLARE v_constraint_value DOUBLE;
DECLARE v_ConstraintId INTEGER;
--
CALL  LinearProgramming.addCoefficientSpace(-459);
CALL  LinearProgramming.setCoefficientSpace(-459);
FOR SELECT CoefficientValue FROM Objective WHERE ProblemId = v_ProblemId ORDER BY VariableId DO
CALL  LinearProgramming.addCoefficient(CoefficientValue);
END FOR;
--
CALL  LinearProgramming.addLinearObjectiveFunction(-459);
--
FOR SELECT ConstraintId FROM ConstraintRhs WHERE ProblemId = v_ProblemId ORDER BY ConstraintId  DO
SET v_ConstraintId = ConstraintId;
CALL  LinearProgramming.addCoefficientSpace(v_ConstraintId);
CALL  LinearProgramming.setCoefficientSpace(v_ConstraintId);
FOR SELECT VariableId,CoefficientValue FROM ConstraintLhs  WHERE ProblemId = v_ProblemId AND ConstraintId = v_ConstraintId ORDER BY VariableId DO
CALL  LinearProgramming.addCoefficient(CoefficientValue);
END FOR;
SET v_constraint_relationship = getConstraintRelationship(v_problemId,v_ConstraintId);
SET v_constraint_value = getConstraintValue(v_problemId,v_ConstraintId);
--
CALL  LinearProgramming.addLinearConstraint(v_ConstraintId, v_constraint_relationship, v_constraint_value);
--
END FOR;
--
CALL LinearProgramming.solveModel();
--
END;
/
CREATE PROCEDURE ConstraintLhs_Select (
IN v_ProblemId INTEGER
)
MODIFIES SQL DATA DYNAMIC RESULT SETS 1 BEGIN ATOMIC
DECLARE result CURSOR
FOR
SELECT
ProblemId,
ConstraintId,
VariableId,
CoefficientValue,
SolutionValue
FROM
ConstraintLhs
WHERE
ProblemId = v_ProblemId;
OPEN result;
END;
/
