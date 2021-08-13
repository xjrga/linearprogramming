SET SCHEMA Model;
--ProblemId, ProblemName, LpModel
call Problem_Merge(3,'Problem #4','Empty',-1.0);
--ProblemId,VariableId, VariableName
call Variable_Merge(3,0,'x0',-1);
call Variable_Merge(3,1,'x1',-1);
call Variable_Merge(3,2,'x2',-1);
--ProblemId, VariableId, ConstraintLhsValue
call Objective_Merge(3,0,0.5);
call Objective_Merge(3,1,0.66);
call Objective_Merge(3,2,0.833);
--ProblemId, ConstraintId, ConstraintName, ConstraintValue,Relationship
call ConstraintRhs_Merge(3,0,'Constraint#1',60,2);
--ProblemId, ConstraintId, VariableId, CoefficientValue, SolutionValue
call ConstraintLhs_Merge(3,0,0,3,-1.0);
call ConstraintLhs_Merge(3,0,1,4,-1.0);
call ConstraintLhs_Merge(3,0,2,2,-1.0);
--ProblemId, ConstraintId, ConstraintName, ConstraintValue,Relationship
call ConstraintRhs_Merge(3,1,'Constraint#2',40,2);
--ProblemId, ConstraintId, VariableId, CoefficientValue, SolutionValue
call ConstraintLhs_Merge(3,1,0,2,-1.0);
call ConstraintLhs_Merge(3,1,1,1,-1.0);
call ConstraintLhs_Merge(3,1,2,2,-1.0);
--
--ProblemId, ConstraintId, ConstraintName, ConstraintValue,Relationship
call ConstraintRhs_Merge(3,2,'Constraint#3',2,80);
--ProblemId, ConstraintId, VariableId, CoefficientValue, SolutionValue
call ConstraintLhs_Merge(3,2,0,1,-1.0);
call ConstraintLhs_Merge(3,2,1,3,-1.0);
call ConstraintLhs_Merge(3,2,2,2,-1.0);
--
--Run
CALL LinearProgramming.clearModel();
CALL LinearProgramming.setMaximize();
call model.solveModel(3);
--Save
call model.saveModel(3);
--Print
call model.Problem_Select(3);
call model.Variable_Select(3);
call model.ConstraintLhs_Select(3);
