SET SCHEMA Model;
--ProblemId, ProblemName, LpModel
call Problem_Merge(4,'Problem #5','Empty',-1.0);
--ProblemId,VariableId, VariableName
call Variable_Merge(4,0,'x0',-1);
call Variable_Merge(4,1,'x1',-1);
call Variable_Merge(4,2,'x2',-1);
--ProblemId, VariableId, ConstraintLhsValue
call Objective_Merge(4,0,12);
call Objective_Merge(4,1,3);
call Objective_Merge(4,2,1);
--ProblemId, ConstraintId, ConstraintName, ConstraintValue,Relationship
call ConstraintRhs_Merge(4,0,'Constraint#1',100,2);
--ProblemId, ConstraintId, VariableId, CoefficientValue, SolutionValue
call ConstraintLhs_Merge(4,0,0,10,-1.0);
call ConstraintLhs_Merge(4,0,1,2,-1.0);
call ConstraintLhs_Merge(4,0,2,1,-1.0);
--ProblemId, ConstraintId, ConstraintName, ConstraintValue,Relationship
call ConstraintRhs_Merge(4,1,'Constraint#2',77,2);
--ProblemId, ConstraintId, VariableId, CoefficientValue, SolutionValue
call ConstraintLhs_Merge(4,1,0,7,-1.0);
call ConstraintLhs_Merge(4,1,1,3,-1.0);
call ConstraintLhs_Merge(4,1,2,2,-1.0);
--
--ProblemId, ConstraintId, ConstraintName, ConstraintValue,Relationship
--CALL  LinearProgramming.addLinearConstraint(3,2,80);
call ConstraintRhs_Merge(4,2,'Constraint#3',80,2);
--ProblemId, ConstraintId, VariableId, CoefficientValue, SolutionValue
call ConstraintLhs_Merge(4,2,0,2,-1.0);
call ConstraintLhs_Merge(4,2,1,4,-1.0);
call ConstraintLhs_Merge(4,2,2,1,-1.0);
--
--Run
CALL LinearProgramming.clearModel();
CALL LinearProgramming.setMaximize();
call model.solveModel(4);
--Save
call model.saveModel(4);
--Print
call model.Problem_Select(4);
call model.Variable_Select(4);
call model.ConstraintLhs_Select(4);
