SET SCHEMA Model;
--ProblemId, ProblemName, LpModel
call Problem_Merge(0,'Veggies and Beans Salad Problem','Empty',-1.0);
--ProblemId,VariableId, VariableName
call Variable_Merge(0,0,'Beans',-1);
call Variable_Merge(0,1,'Veggies',-1);
--ProblemId, ConstraintId, ConstraintName, ConstraintValue,Relationship
call ConstraintRhs_Merge(0,0,'Fiber Constraint',40.0,1);
call ConstraintRhs_Merge(0,1,'Veggie/Bean Ratio',0.0,3);
--ProblemId, ConstraintId, VariableId, CoefficientValue, SolutionValue
call ConstraintLhs_Merge(0,0,0,0.09,-1.0);
call ConstraintLhs_Merge(0,0,1,0.04,-1.0);
call ConstraintLhs_Merge(0,1,0,-2.00,-1.0);
call ConstraintLhs_Merge(0,1,1,1.00,-1.0);
--ProblemId, VariableId, ConstraintLhsValue
call Objective_Merge(0,0,0.002);
call Objective_Merge(0,1,0.004);
