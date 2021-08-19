SET SCHEMA Model;
--ProblemId, ProblemName, LpModel
call deleteProblem(4);
call addProblem(4,'Problem #5');
--ProblemId,VariableId, VariableName
call addVariable(4,0,'x0');
call addVariable(4,1,'x1');
call addVariable(4,2,'x2');
--ProblemId, VariableId, CoefficientValue
call addObjectiveCoefficient(4,0,12);
call addObjectiveCoefficient(4,1,3);
call addObjectiveCoefficient(4,2,1);
--ProblemId, ConstraintId, ConstraintName,Relationship,ConstraintValue
call addConstraint(4,0,'Constraint#1',2,100);
--ProblemId, ConstraintId, VariableId, CoefficientValue, SolutionValue
call addConstraintCoefficient(4,0,0,10);
call addConstraintCoefficient(4,0,1,2);
call addConstraintCoefficient(4,0,2,1);
--ProblemId, ConstraintId, ConstraintName,Relationship,ConstraintValue
call addConstraint(4,1,'Constraint#2',2,77);
--ProblemId, ConstraintId, VariableId, CoefficientValue, SolutionValue
call addConstraintCoefficient(4,1,0,7);
call addConstraintCoefficient(4,1,1,3);
call addConstraintCoefficient(4,1,2,2);
--
--ProblemId, ConstraintId, ConstraintName,Relationship,ConstraintValue
call addConstraint(4,2,'Constraint#3',2,80);
--ProblemId, ConstraintId, VariableId, CoefficientValue, SolutionValue
call addConstraintCoefficient(4,2,0,2);
call addConstraintCoefficient(4,2,1,4);
call addConstraintCoefficient(4,2,2,1);
--
--Run
CALL LinearProgramming.createModel();
CALL LinearProgramming.setMaximize();
--
CALL LinearProgramming.setNumberOfVariables(3);
CALL LinearProgramming.setNumberOfConstraints(3);
--
call solveModel(4);
--Save
call saveModel(4);
--Print
call getProblemValue(4);
call getVariableValue(4);
call getConstraintValue(4);
--
CALL LinearProgramming.clean();
--
