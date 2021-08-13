SET SCHEMA Model;
--ProblemId, ProblemName, LpModel
call Problem_Merge(2,'Problem #3','Empty',-1.0);
--ProblemId,VariableId, VariableName
call Variable_Merge(2,0,'x0',-1);
call Variable_Merge(2,1,'x1',-1);
--ProblemId, VariableId, ConstraintLhsValue
call Objective_Merge(2,0,25);
call Objective_Merge(2,1,30);
--ProblemId, ConstraintId, ConstraintName, ConstraintValue,Relationship
call ConstraintRhs_Merge(2,0,'Constraint#1',690,2);
--ProblemId, ConstraintId, VariableId, CoefficientValue, SolutionValue
call ConstraintLhs_Merge(2,0,0,20,-1.0);
call ConstraintLhs_Merge(2,0,1,30,-1.0);
--ProblemId, ConstraintId, ConstraintName, ConstraintValue,Relationship
call ConstraintRhs_Merge(2,1,'Constraint#2',120,2);
--ProblemId, ConstraintId, VariableId, CoefficientValue, SolutionValue
call ConstraintLhs_Merge(2,1,0,5,-1.0);
call ConstraintLhs_Merge(2,1,1,4,-1.0);
--Run
CALL LinearProgramming.clearModel();
CALL LinearProgramming.setMaximize();
call model.solveModel(2);
--Save
call model.saveModel(2);
--Print
call model.Problem_Select(2);
call model.Variable_Select(2);
call model.ConstraintLhs_Select(2);
