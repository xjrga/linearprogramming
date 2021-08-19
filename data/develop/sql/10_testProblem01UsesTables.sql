SET SCHEMA Model;
--ProblemId, ProblemName
call deleteProblem(0);
call addProblem(0,'Veggies and Beans Salad Problem');
--ProblemId,VariableId, VariableName
call addVariable(0,0,'Beans');
call addVariable(0,1,'Veggies');
--ProblemId, VariableId, CoefficientValue
call addObjectiveCoefficient(0,0,0.002);
call addObjectiveCoefficient(0,1,0.004);
--ProblemId, ConstraintId, ConstraintName,Relationship,ConstraintValue
call addConstraint(0,0,'Fiber Constraint',1,40.0);
--ProblemId, ConstraintId, VariableId, CoefficientValue
call addConstraintCoefficient(0,0,0,0.09);
call addConstraintCoefficient(0,0,1,0.04);
--ProblemId, ConstraintId, ConstraintName,Relationship,ConstraintValue
call addConstraint(0,1,'Veggie/Bean Ratio',3,0.0);
--ProblemId, ConstraintId, VariableId, CoefficientValue
call addConstraintCoefficient(0,1,0,-2.00);
call addConstraintCoefficient(0,1,1,1.00);
--Run
CALL LinearProgramming.createModel();
--
CALL LinearProgramming.setNumberOfVariables(2);
CALL LinearProgramming.setNumberOfConstraints(2);
--
call model.solveModel(0);
--Save
call model.saveModel(0);
--Print
call model.getProblemValue(0);
call model.getVariableValue(0);
call model.getConstraintValue(0);
--
CALL LinearProgramming.clean();
--
