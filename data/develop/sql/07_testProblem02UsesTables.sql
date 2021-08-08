SET SCHEMA Model;
--ProblemId, ProblemName, LpModel,ProblemCost
call Problem_Merge(1,'Maximum contribution to overheads and profits','Empty',-1.0);
--ProblemId,VariableId, VariableName
call Variable_Merge(1,2,'Product X',-1.0);
call Variable_Merge(1,3,'Product Y',-1.0);
--ProblemId, VariableId, CoefficientValue
call Objective_Merge(1,2,300.0);
call Objective_Merge(1,3,200.0);
--ProblemId, ConstraintId, ConstraintName, ConstraintValue,Relationship
call ConstraintRhs_Merge(1,2,'Process 1',32.0,2);
call ConstraintRhs_Merge(1,3,'Process 2',30.0,2);
call ConstraintRhs_Merge(1,4,'Process 3',40.0,2);
--ProblemId, ConstraintId, VariableId, CoefficientValue, SolutionValue
call ConstraintLhs_Merge(1,2,2,8.0,-1.0);
call ConstraintLhs_Merge(1,2,3,4.0,-1.0);
call ConstraintLhs_Merge(1,3,2,6.0,-1.0);
call ConstraintLhs_Merge(1,3,3,5.0,-1.0);
call ConstraintLhs_Merge(1,4,2,5.0,-1.0);
call ConstraintLhs_Merge(1,4,3,8.0,-1.0);
--Run
CALL LinearProgramming.clearModel();
CALL LinearProgramming.setMaximize();
call model.solveModel(1);
--Save
call model.saveModel(1);
--Print
call model.Problem_Select(1);
call model.Variable_Select(1);
call model.ConstraintLhs_Select(1);

