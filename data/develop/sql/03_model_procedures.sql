SET SCHEMA Model;
/
CREATE PROCEDURE addProblem (
IN v_ProblemId INTEGER,
IN v_ProblemName LONGVARCHAR
)
MODIFIES SQL DATA BEGIN ATOMIC
INSERT INTO Problem (
ProblemId,
ProblemName
) VALUES (
v_ProblemId,
v_ProblemName
);
END;
/
CREATE PROCEDURE updateProblem (
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
CREATE PROCEDURE deleteProblem (
IN v_ProblemId INTEGER
)
MODIFIES SQL DATA BEGIN ATOMIC
DELETE FROM
Problem
WHERE
ProblemId = v_ProblemId;
END;
/
CREATE PROCEDURE addConstraint (
IN v_ProblemId INTEGER,
IN v_ConstraintId INTEGER,
IN v_ConstraintName LONGVARCHAR,
IN v_ConstraintRelationship INTEGER,
IN v_ConstraintValue DOUBLE
)
MODIFIES SQL DATA BEGIN ATOMIC
INSERT INTO ConstraintRhs (
ProblemId,
ConstraintId,
ConstraintName,
ConstraintRelationship,
ConstraintValue
) VALUES (
v_ProblemId,
v_ConstraintId,
v_ConstraintName,
v_ConstraintRelationship,
v_ConstraintValue
);
END;
/
CREATE PROCEDURE addVariable (
IN v_ProblemId INTEGER,
IN v_VariableId INTEGER,
IN v_VariableName LONGVARCHAR
)
MODIFIES SQL DATA BEGIN ATOMIC
INSERT INTO Variable (
ProblemId,
VariableId,
VariableName
) VALUES (
v_ProblemId,
v_VariableId,
v_VariableName
);
END;
/
CREATE PROCEDURE updateVariable (
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
CREATE PROCEDURE addConstraintCoefficient (
IN v_ProblemId INTEGER,
IN v_ConstraintId INTEGER,
IN v_VariableId INTEGER,
IN v_CoefficientValue DOUBLE
)
MODIFIES SQL DATA BEGIN ATOMIC
INSERT INTO ConstraintLhs (
ProblemId,
ConstraintId,
VariableId,
CoefficientValue
) VALUES (
v_ProblemId,
v_ConstraintId,
v_VariableId,
v_CoefficientValue
);
END;
/
CREATE PROCEDURE updateConstraintCoefficient (
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
CREATE PROCEDURE addObjectiveCoefficient (
IN v_ProblemId INTEGER,
IN v_VariableId INTEGER,
IN v_CoefficientValue DOUBLE
)
MODIFIES SQL DATA BEGIN ATOMIC
INSERT INTO Objective (
ProblemId,
VariableId,
CoefficientValue
) VALUES (
v_ProblemId,
v_VariableId,
v_CoefficientValue
);
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
CREATE PROCEDURE getProblemValue (
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
CALL updateVariable(v_problemId,variableid,solutionPointValueAt);
SET n = n + 1;
--
END FOR;
--
FOR SELECT constraintid,variableid FROM constraintlhs WHERE problemid = v_problemId DO
--
SET solutionConstraintLhsSolutionValue = calculateConstraintLhsSolutionValue(v_problemId,constraintid, variableid);
--
CALL updateConstraintCoefficient(v_problemId, constraintid, variableId, solutionConstraintLhsSolutionValue);
--
END FOR;
--
CALL updateProblem(v_problemId,lpformatModel,solutionCost);
--
END;
/
CREATE PROCEDURE getVariableValue (
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
CREATE PROCEDURE getConstraintValue (
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
