SET SCHEMA Model;
--ProblemId, ProblemName, LpModel
call deleteProblem(2);
call addProblem(2,'Problem #3');
--ProblemId,VariableId, VariableName
call addVariable(2,0,'x0');
call addVariable(2,1,'x1');
--ProblemId, VariableId, CoefficientValue
call addObjectiveCoefficient(2,0,25);
call addObjectiveCoefficient(2,1,30);
--ProblemId, ConstraintId, ConstraintName,Relationship,ConstraintValue
call addConstraint(2,0,'Constraint#1',2,690);
--ProblemId, ConstraintId, VariableId, CoefficientValue, SolutionValue
call addConstraintCoefficient(2,0,0,20);
call addConstraintCoefficient(2,0,1,30);
--ProblemId, ConstraintId, ConstraintName,Relationship,ConstraintValue
call addConstraint(2,1,'Constraint#2',2,120);
--ProblemId, ConstraintId, VariableId, CoefficientValue, SolutionValue
call addConstraintCoefficient(2,1,0,5);
call addConstraintCoefficient(2,1,1,4);
--Run
CALL LinearProgramming.createModel();
CALL LinearProgramming.setMaximize();
call model.solveModel(2);
--Save
call model.saveModel(2);
--Print
call model.getProblemValue(2);
call model.getVariableValue(2);
call model.getConstraintValue(2);

