DROP SCHEMA Model IF EXISTS CASCADE;

CREATE SCHEMA Model;

SET SCHEMA Model;

CREATE TABLE Problem
(
ProblemId INTEGER,
ProblemName LONGVARCHAR,
ProblemModel LONGVARCHAR,
ProblemCost DOUBLE,
CONSTRAINT Problem_primaryKey PRIMARY KEY (ProblemId)
);

CREATE TABLE ConstraintRhs
(
ProblemId INTEGER,
ConstraintId INTEGER,
ConstraintName LONGVARCHAR,
ConstraintRelationship INTEGER,
ConstraintValue DOUBLE,
CONSTRAINT ConstraintRhs_primaryKey PRIMARY KEY (ProblemId, ConstraintId)
);

CREATE TABLE Variable
(
ProblemId INTEGER,
VariableId INTEGER,
VariableName LONGVARCHAR,
SolutionValue DOUBLE,
CONSTRAINT Variable_primaryKey PRIMARY KEY (ProblemId, VariableId)
);

CREATE TABLE ConstraintLhs
(
ProblemId INTEGER,
ConstraintId INTEGER,
VariableId INTEGER,
CoefficientValue DOUBLE,
SolutionValue DOUBLE,
CONSTRAINT ConstraintLhs_primaryKey PRIMARY KEY (ProblemId, ConstraintId, VariableId)
);

CREATE TABLE Objective
(
ProblemId INTEGER,
VariableId INTEGER,
CoefficientValue DOUBLE,
CONSTRAINT Objective_primaryKey PRIMARY KEY (ProblemId, VariableId)
);

ALTER TABLE ConstraintRhs ADD CONSTRAINT R0_Problem_ConstraintRhs FOREIGN KEY ( ProblemId ) REFERENCES Problem ( ProblemId ) ON DELETE CASCADE;

ALTER TABLE Variable ADD CONSTRAINT R1_Problem_Variable FOREIGN KEY ( ProblemId ) REFERENCES Problem ( ProblemId ) ON DELETE CASCADE;

ALTER TABLE ConstraintLhs ADD CONSTRAINT R2_Problem_ConstraintLhs FOREIGN KEY ( ProblemId ) REFERENCES Problem ( ProblemId ) ON DELETE CASCADE;

ALTER TABLE Objective ADD CONSTRAINT R3_Problem_Objective FOREIGN KEY ( ProblemId ) REFERENCES Problem ( ProblemId ) ON DELETE CASCADE;

ALTER TABLE ConstraintLhs ADD CONSTRAINT R4_ConstraintRhs_ConstraintLhs FOREIGN KEY ( ProblemId,ConstraintId ) REFERENCES ConstraintRhs ( ProblemId,ConstraintId ) ON DELETE CASCADE;

ALTER TABLE ConstraintLhs ADD CONSTRAINT R5_Variable_ConstraintLhs FOREIGN KEY ( ProblemId,VariableId ) REFERENCES Variable ( ProblemId,VariableId ) ON DELETE CASCADE;

ALTER TABLE Objective ADD CONSTRAINT R6_Variable_Objective FOREIGN KEY ( ProblemId,VariableId ) REFERENCES Variable ( ProblemId,VariableId ) ON DELETE CASCADE;

