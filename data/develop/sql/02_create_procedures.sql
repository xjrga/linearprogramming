SET SCHEMA LinearProgramming;
/

CREATE PROCEDURE Problem_Merge (
IN v_ProblemId INTEGER,
IN v_ProblemName LONGVARCHAR,
IN v_ProblemModel LONGVARCHAR
)
MODIFIES SQL DATA BEGIN ATOMIC
MERGE INTO Problem USING ( VALUES (
v_ProblemId,
v_ProblemName,
v_ProblemModel
) ) ON (
ProblemId = v_ProblemId
)
WHEN MATCHED THEN UPDATE SET
ProblemName = v_ProblemName,
ProblemModel = v_ProblemModel
WHEN NOT MATCHED THEN INSERT VALUES
v_ProblemId,
v_ProblemName,
v_ProblemModel;
END;
/

CREATE PROCEDURE Problem_Update (
IN v_ProblemId INTEGER,
IN v_ProblemModel LONGVARCHAR
)
MODIFIES SQL DATA BEGIN ATOMIC
UPDATE
Problem
SET
ProblemModel = v_ProblemModel
WHERE
ProblemId = v_ProblemId;
END;
/

CREATE PROCEDURE Constraint_Merge (
IN v_ProblemId INTEGER,
IN v_ConstraintId INTEGER,
IN v_ConstraintName LONGVARCHAR,
IN v_ConstraintValue DOUBLE,
IN v_ConstraintRelationship INTEGER
)
MODIFIES SQL DATA BEGIN ATOMIC
MERGE INTO Constraint USING ( VALUES (
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
IN v_VariableName LONGVARCHAR
)
MODIFIES SQL DATA BEGIN ATOMIC
MERGE INTO Variable USING ( VALUES (
v_ProblemId,
v_VariableId,
v_VariableName
) ) ON (
ProblemId = v_ProblemId
AND
VariableId = v_VariableId
)
WHEN MATCHED THEN UPDATE SET
VariableName = v_VariableName
WHEN NOT MATCHED THEN INSERT VALUES
v_ProblemId,
v_VariableId,
v_VariableName;
END;
/

CREATE PROCEDURE Coefficient_Merge (
IN v_ProblemId INTEGER,
IN v_ConstraintId INTEGER,
IN v_VariableId INTEGER,
IN v_CoefficientValue DOUBLE
)
MODIFIES SQL DATA BEGIN ATOMIC
MERGE INTO Coefficient USING ( VALUES (
v_ProblemId,
v_ConstraintId,
v_VariableId,
v_CoefficientValue
) ) ON (
ProblemId = v_ProblemId
AND
ConstraintId = v_ConstraintId
AND
VariableId = v_VariableId
)
WHEN MATCHED THEN UPDATE SET
CoefficientValue = v_CoefficientValue
WHEN NOT MATCHED THEN INSERT VALUES
v_ProblemId,
v_ConstraintId,
v_VariableId,
v_CoefficientValue;
END;
/

CREATE PROCEDURE Solution_Merge (
IN v_ProblemId INTEGER,
IN v_VariableId INTEGER,
IN v_VariableQuantity INTEGER
)
MODIFIES SQL DATA BEGIN ATOMIC
MERGE INTO Solution USING ( VALUES (
v_ProblemId,
v_VariableId,
v_VariableQuantity
) ) ON (
ProblemId = v_ProblemId
AND
VariableId = v_VariableId
)
WHEN MATCHED THEN UPDATE SET
VariableQuantity = v_VariableQuantity
WHEN NOT MATCHED THEN INSERT VALUES
v_ProblemId,
v_VariableId,
v_VariableQuantity;
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
RETURN (SELECT ARRAY_AGG(CoefficientValue ORDER BY VariableId) FROM Coefficient WHERE ProblemId = v_ProblemId AND ConstraintId = v_ConstraintId)
/

CREATE FUNCTION getConstraintValue(v_problemId INTEGER,v_constraintId INTEGER) RETURNS DOUBLE
READS SQL DATA
RETURN (SELECT ConstraintValue FROM Constraint WHERE ProblemId = v_ProblemId AND ConstraintId = v_ConstraintId)
/

CREATE FUNCTION getConstraintRelationship(v_problemId INTEGER,v_constraintId INTEGER) RETURNS INTEGER
READS SQL DATA
RETURN (SELECT ConstraintRelationship FROM Constraint WHERE ProblemId = v_ProblemId AND ConstraintId = v_ConstraintId)
/

CREATE PROCEDURE saveModel (
)
MODIFIES SQL DATA BEGIN ATOMIC
--ProblemId, VariableId, VariableQuantity
CALL Solution_Merge(0,0,getSolutionPointVariableValue(0,0));
CALL Solution_Merge(0,1,getSolutionPointVariableValue(0,1));
CALL Problem_Update(0,printModel());
--
END;
/
