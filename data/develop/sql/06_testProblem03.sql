SET SCHEMA LinearProgramming;
/
CREATE PROCEDURE testProblem03 (
)
MODIFIES SQL DATA DYNAMIC RESULT SETS 3
--
BEGIN ATOMIC
--
DECLARE v_geq INT;
DECLARE v_leq INT;
DECLARE v_eq INT;
--
DECLARE solutionPointValueAt CURSOR FOR SELECT LinearProgramming.getSolutionPointValueAt(i) as SolutionPoint FROM (SELECT rownum()-1 as i FROM INFORMATION_SCHEMA.Columns) WHERE i < LinearProgramming.getVariableCount();
DECLARE solutionCost CURSOR FOR SELECT LinearProgramming.getSolutionCost() as SolutionCost FROM (VALUES(0));
DECLARE solutionModel CURSOR FOR SELECT LinearProgramming.printModel() as Model FROM (VALUES(0));
DECLARE solutionPointValue CURSOR FOR SELECT LinearProgramming.getSolutionPoint() as SolutionPoint FROM (VALUES(0));
DECLARE LhsByConstraint CURSOR FOR SELECT LinearProgramming.getLhsByConstraint(i) as ConstraintRow FROM (SELECT rownum()-1 as i FROM INFORMATION_SCHEMA.Columns) WHERE i < LinearProgramming.getConstraintCount();
DECLARE LhsByVariable CURSOR FOR SELECT LinearProgramming.getLhsByVariable(i) as ConstraintColumn FROM (SELECT rownum()-1 as i FROM INFORMATION_SCHEMA.Columns) WHERE i < LinearProgramming.getVariableCount();
DECLARE LhsValueAt CURSOR FOR SELECT LinearProgramming.getLhsValueAt(y,x) as ConstraintElementValue FROM (SELECT x, y FROM (SELECT rownum() -1 AS x FROM INFORMATION_SCHEMA.Columns WHERE rownum() -1 < LinearProgramming.getVariableCount()) a, (SELECT rownum() -1 AS y FROM INFORMATION_SCHEMA.Columns WHERE rownum() -1 < LinearProgramming.getConstraintCount()) b);
DECLARE Rhs CURSOR FOR SELECT LinearProgramming.getRhs() as ConstraintValue FROM (VALUES(0));
DECLARE RhsByConstraint CURSOR FOR SELECT LinearProgramming.getRhsByConstraint(i) as ConstraintValue FROM (SELECT rownum()-1 as i FROM INFORMATION_SCHEMA.Columns) WHERE i < LinearProgramming.getConstraintCount();
--
SET v_geq = 1;
SET v_leq = 2;
SET v_eq = 3;
--
CALL LinearProgramming.clearModel();
CALL LinearProgramming.setMaximize();
--
CALL LinearProgramming.addCoefficientSpace(0);
CALL LinearProgramming.setCoefficientSpace(0);
CALL LinearProgramming.addCoefficient(25);
CALL LinearProgramming.addCoefficient(30);
CALL LinearProgramming.addLinearObjectiveFunction(0);
--
CALL LinearProgramming.addCoefficientSpace(1);
CALL LinearProgramming.setCoefficientSpace(1);
CALL LinearProgramming.addCoefficient(20);
CALL LinearProgramming.addCoefficient(30);
CALL  LinearProgramming.addLinearConstraint(1,2,690);
--
CALL LinearProgramming.addCoefficientSpace(2);
CALL LinearProgramming.setCoefficientSpace(2);
CALL LinearProgramming.addCoefficient(5);
CALL LinearProgramming.addCoefficient(4);
CALL  LinearProgramming.addLinearConstraint(2,2,120);
--
CALL LinearProgramming.solveModel();
--
OPEN solutionPointValueAt;
OPEN solutionCost;
OPEN solutionModel;
OPEN solutionPointValue;
OPEN LhsByConstraint;
OPEN LhsByVariable;
OPEN LhsValueAt;
OPEN Rhs;
OPEN RhsByConstraint;
--
END;
/

--drop procedure testProblem03;
--call testProblem03();
