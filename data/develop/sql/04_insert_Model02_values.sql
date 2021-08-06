--ProblemId, ProblemName, LpModel
call LinearProgramming.Problem_Merge(0,'Veggies and Beans Salad Problem','Empty');
--ProblemId,VariableId, VariableName
call LinearProgramming.Variable_Merge(0,0,'Beans');
call LinearProgramming.Variable_Merge(0,1,'Veggies');
--ProblemId, ConstraintId, ConstraintName, ConstraintValue,Relationship
call LinearProgramming.Constraint_Merge(0,0,'Fiber Constraint',40.0,1);
call LinearProgramming.Constraint_Merge(0,1,'Veggie/Bean Ratio',0.0,3);
--ProblemId, ConstraintId, VariableId, CoefficientValue
call LinearProgramming.Coefficient_Merge(0,0,0,0.09);
call LinearProgramming.Coefficient_Merge(0,0,1,0.04);
call LinearProgramming.Coefficient_Merge(0,1,0,-2.00);
call LinearProgramming.Coefficient_Merge(0,1,1,1.00);
--ProblemId, VariableId, CoefficientValue
call LinearProgramming.Objective_Merge(0,0,0.002);
call LinearProgramming.Objective_Merge(0,1,0.004);
