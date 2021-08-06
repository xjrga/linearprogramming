DROP SCHEMA LinearProgramming IF EXISTS CASCADE;

CREATE SCHEMA LinearProgramming;

SET SCHEMA LinearProgramming;

CREATE TABLE Problem
(
ProblemId INTEGER,
ProblemName LONGVARCHAR,
ProblemModel LONGVARCHAR,
CONSTRAINT Problem_primaryKey PRIMARY KEY (ProblemId)
);

CREATE TABLE Constraint
(
ProblemId INTEGER,
ConstraintId INTEGER,
ConstraintName LONGVARCHAR,
ConstraintValue DOUBLE,
ConstraintRelationship INTEGER,
CONSTRAINT Constraint_primaryKey PRIMARY KEY (ProblemId, ConstraintId)
);

CREATE TABLE Variable
(
ProblemId INTEGER,
VariableId INTEGER,
VariableName LONGVARCHAR,
CONSTRAINT Variable_primaryKey PRIMARY KEY (ProblemId, VariableId)
);

CREATE TABLE Coefficient
(
ProblemId INTEGER,
ConstraintId INTEGER,
VariableId INTEGER,
CoefficientValue DOUBLE,
CONSTRAINT Coefficient_primaryKey PRIMARY KEY (ProblemId, ConstraintId, VariableId)
);

CREATE TABLE Solution
(
ProblemId INTEGER,
VariableId INTEGER,
VariableQuantity INTEGER,
CONSTRAINT Solution_primaryKey PRIMARY KEY (ProblemId, VariableId)
);

CREATE TABLE Objective
(
ProblemId INTEGER,
VariableId INTEGER,
CoefficientValue DOUBLE,
CONSTRAINT Objective_primaryKey PRIMARY KEY (ProblemId, VariableId)
);

ALTER TABLE Constraint ADD CONSTRAINT R0_Problem_Constraint FOREIGN KEY ( ProblemId ) REFERENCES Problem ( ProblemId ) ON DELETE CASCADE;

ALTER TABLE Variable ADD CONSTRAINT R1_Problem_Variable FOREIGN KEY ( ProblemId ) REFERENCES Problem ( ProblemId ) ON DELETE CASCADE;

ALTER TABLE Coefficient ADD CONSTRAINT R2_Problem_Coefficient FOREIGN KEY ( ProblemId ) REFERENCES Problem ( ProblemId ) ON DELETE CASCADE;

ALTER TABLE Solution ADD CONSTRAINT R3_Problem_Solution FOREIGN KEY ( ProblemId ) REFERENCES Problem ( ProblemId ) ON DELETE CASCADE;

ALTER TABLE Objective ADD CONSTRAINT R4_Problem_Objective FOREIGN KEY ( ProblemId ) REFERENCES Problem ( ProblemId ) ON DELETE CASCADE;

ALTER TABLE Coefficient ADD CONSTRAINT R5_Constraint_Coefficient FOREIGN KEY ( ProblemId,ConstraintId ) REFERENCES Constraint ( ProblemId,ConstraintId ) ON DELETE CASCADE;

ALTER TABLE Coefficient ADD CONSTRAINT R6_Variable_Coefficient FOREIGN KEY ( ProblemId,VariableId ) REFERENCES Variable ( ProblemId,VariableId ) ON DELETE CASCADE;

ALTER TABLE Solution ADD CONSTRAINT R7_Variable_Solution FOREIGN KEY ( ProblemId,VariableId ) REFERENCES Variable ( ProblemId,VariableId ) ON DELETE CASCADE;

ALTER TABLE Objective ADD CONSTRAINT R8_Variable_Objective FOREIGN KEY ( ProblemId,VariableId ) REFERENCES Variable ( ProblemId,VariableId ) ON DELETE CASCADE;

