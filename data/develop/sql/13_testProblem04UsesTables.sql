SET SCHEMA Model;
--ProblemId, ProblemName, LpModel
call deleteProblem(3);
call addProblem(3,'Problem #4');
--ProblemId,VariableId, VariableName
call addVariable(3,0,'x0');
call addVariable(3,1,'x1');
call addVariable(3,2,'x2');
--ProblemId, VariableId, CoefficientValue
call addObjectiveCoefficient(3,0,0.5);
call addObjectiveCoefficient(3,1,0.66);
call addObjectiveCoefficient(3,2,0.833);
--ProblemId, ConstraintId, ConstraintName,Relationship,ConstraintValue
call addConstraint(3,0,'Constraint#1',2,60);
--ProblemId, ConstraintId, VariableId, CoefficientValue, SolutionValue
call addConstraintCoefficient(3,0,0,3);
call addConstraintCoefficient(3,0,1,4);
call addConstraintCoefficient(3,0,2,2);
--ProblemId, ConstraintId, ConstraintName,Relationship,ConstraintValue
call addConstraint(3,1,'Constraint#2',2,40);
--ProblemId, ConstraintId, VariableId, CoefficientValue, SolutionValue
call addConstraintCoefficient(3,1,0,2);
call addConstraintCoefficient(3,1,1,1);
call addConstraintCoefficient(3,1,2,2);
--
--ProblemId, ConstraintId, ConstraintName,Relationship,ConstraintValue
call addConstraint(3,2,'Constraint#3',2,80);
--ProblemId, ConstraintId, VariableId, CoefficientValue, SolutionValue
call addConstraintCoefficient(3,2,0,1);
call addConstraintCoefficient(3,2,1,3);
call addConstraintCoefficient(3,2,2,2);
--
--Run
CALL LinearProgramming.clearModel();
CALL LinearProgramming.setMaximize();
call model.solveModel(3);
--Save
call model.saveModel(3);
--Print
call model.getProblemValue(3);
call model.getVariableValue(3);
call model.getConstraintValue(3);
