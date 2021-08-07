DROP SCHEMA LinearProgramming IF EXISTS CASCADE;
/
CREATE SCHEMA LinearProgramming;
/
SET SCHEMA LinearProgramming;
/
CREATE PROCEDURE  addLinearObjectiveFunction(IN a DOUBLE ARRAY)
NO SQL
LANGUAGE JAVA 
PARAMETER STYLE JAVA
EXTERNAL NAME 'CLASSPATH:io.github.xjrga.linearprogram.LPModel.addLinearObjectiveFunction'
/
CREATE PROCEDURE  addLinearConstraint(IN coefficients DOUBLE ARRAY, IN rel INT, IN amount DOUBLE)
NO SQL
LANGUAGE JAVA 
PARAMETER STYLE JAVA
EXTERNAL NAME 'CLASSPATH:io.github.xjrga.linearprogram.LPModel.addLinearConstraint'
/
CREATE PROCEDURE  solveModel()
NO SQL
LANGUAGE JAVA 
PARAMETER STYLE JAVA
EXTERNAL NAME 'CLASSPATH:io.github.xjrga.linearprogram.LPModel.solveModel'
/
CREATE FUNCTION printModel() RETURNS LONGVARCHAR
LANGUAGE JAVA DETERMINISTIC NO SQL
EXTERNAL NAME 'CLASSPATH:io.github.xjrga.linearprogram.LPModel.printModel'
/
CREATE FUNCTION getSolutionCost() RETURNS DOUBLE
LANGUAGE JAVA DETERMINISTIC NO SQL
EXTERNAL NAME 'CLASSPATH:io.github.xjrga.linearprogram.LPModel.getSolutionCost'
/
CREATE FUNCTION getSolutionPoint() RETURNS DOUBLE ARRAY
LANGUAGE JAVA DETERMINISTIC NO SQL
EXTERNAL NAME 'CLASSPATH:io.github.xjrga.linearprogram.LPModel.getSolutionPoint'
/
CREATE FUNCTION getSolutionPointVariableValue(v_problemId INTEGER,v_variableId INTEGER) RETURNS DOUBLE
BEGIN ATOMIC
DECLARE v_corrected_variable INTEGER;
SET v_corrected_variable = v_variableId + 1;
RETURN getSolutionPoint()[v_corrected_variable];
END
/
CREATE PROCEDURE  clearModel()
NO SQL
LANGUAGE JAVA 
PARAMETER STYLE JAVA
EXTERNAL NAME 'CLASSPATH:io.github.xjrga.linearprogram.LPModel.clearModel'
/
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
CREATE FUNCTION getObjectiveCoefficients(v_problemId INTEGER) RETURNS DOUBLE ARRAY
READS SQL DATA
RETURN (SELECT ARRAY_AGG(CoefficientValue ORDER BY VariableId) FROM Objective WHERE ProblemId = v_ProblemId)
/
CREATE FUNCTION getConstraintCoefficients(v_problemId INTEGER,v_constraintId INTEGER) RETURNS DOUBLE ARRAY
READS SQL DATA
RETURN (SELECT ARRAY_AGG(CoefficientValue ORDER BY VariableId) FROM ConstraintLhs WHERE ProblemId = v_ProblemId AND ConstraintId = v_ConstraintId)
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
DECLARE solutionPointVariableValue DOUBLE;
DECLARE solutionCost DOUBLE;
DECLARE lpformatModel LONGVARCHAR;
DECLARE solutionConstraintLhsSolutionValue DOUBLE;
--
FOR SELECT variableid FROM variable WHERE problemid = v_problemId DO
--
SET solutionPointVariableValue =  LinearProgramming.getSolutionPointVariableValue(v_problemId,variableid);
SET solutionCost = LinearProgramming.getSolutionCost();
SET lpformatModel = LinearProgramming.printModel();
--
CALL Variable_Update(v_problemId,variableid,solutionPointVariableValue);
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
DECLARE v_objective_coefficients DOUBLE ARRAY;
DECLARE v_constraint_coefficients DOUBLE ARRAY;
DECLARE v_constraint_relationship INTEGER;
DECLARE v_constraint_value DOUBLE;
--
CALL LinearProgramming.clearModel();
--
SET v_objective_coefficients = getObjectiveCoefficients(v_problemId);
--
CALL  LinearProgramming.addLinearObjectiveFunction(v_objective_coefficients);
--
FOR SELECT constraintid FROM constraintrhs DO
--
SET  v_constraint_coefficients = getConstraintCoefficients(v_problemId,constraintid);
SET v_constraint_relationship = getConstraintRelationship(v_problemId,constraintid);
SET v_constraint_value = getConstraintValue(v_problemId,constraintid);
--
CALL  LinearProgramming.addLinearConstraint(v_constraint_coefficients, v_constraint_relationship, v_constraint_value);
--
END FOR;
--
CALL LinearProgramming.solveModel();
--
CALL saveModel(v_problemId);
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
