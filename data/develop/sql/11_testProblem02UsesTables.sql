SET SCHEMA Model;
--ProblemId, ProblemName, LpModel,ProblemCost
call deleteProblem(1);
call addProblem(1,'Maximum contribution to overheads and profits');
--ProblemId,VariableId, VariableName
call addVariable(1,0,'Product X');
call addVariable(1,1,'Product Y');
--ProblemId, VariableId, CoefficientValue
call addObjectiveCoefficient(1,0,300);
call addObjectiveCoefficient(1,1,200);
--ProblemId, ConstraintId, ConstraintName, Relationship, ConstraintValue
call addConstraint(1,0,'Process 1',2,32);
--ProblemId, ConstraintId, VariableId, CoefficientValue, SolutionValue
call addConstraintCoefficient(1,0,0,8);
call addConstraintCoefficient(1,0,1,4);
--ProblemId, ConstraintId, ConstraintName, Relationship, ConstraintValue
call addConstraint(1,1,'Process 2',2,30);
--ProblemId, ConstraintId, VariableId, CoefficientValue, SolutionValue
call addConstraintCoefficient(1,1,0,6);
call addConstraintCoefficient(1,1,1,5);
--ProblemId, ConstraintId, ConstraintName, Relationship, ConstraintValue
call addConstraint(1,2,'Process 3',2,40);
--ProblemId, ConstraintId, VariableId, CoefficientValue, SolutionValue
call addConstraintCoefficient(1,2,0,5);
call addConstraintCoefficient(1,2,1,8);
--Run
CALL LinearProgramming.clearModel();
CALL LinearProgramming.setMaximize();
call model.solveModel(1);
--Save
call model.saveModel(1);
--Print
call model.getProblemValue(1);
call model.getVariableValue(1);
call model.getConstraintValue(1);

