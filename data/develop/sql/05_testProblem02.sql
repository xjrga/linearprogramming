SET SCHEMA LinearProgramming;
/
CREATE PROCEDURE testProblem02(
)
MODIFIES SQL DATA DYNAMIC RESULT SETS 3
--
BEGIN ATOMIC
--
DECLARE v_geq INT;
DECLARE v_leq INT;
DECLARE v_eq INT;
DECLARE v_constraint0_value DOUBLE;
DECLARE v_constraint1_value DOUBLE;
DECLARE v_constraint2_value DOUBLE;
--
DECLARE solutionPointValueAt CURSOR FOR SELECT LinearProgramming.getSolutionPointValueAt(i) as SolutionPoint FROM (SELECT rownum()-1 as i FROM INFORMATION_SCHEMA.Columns) WHERE i < 2;
DECLARE solutionCost CURSOR FOR SELECT LinearProgramming.getSolutionCost() as SolutionCost FROM (VALUES(0));
DECLARE solutionModel CURSOR FOR SELECT LinearProgramming.printModel() as Model FROM (VALUES(0));
DECLARE solutionPointValue CURSOR FOR SELECT LinearProgramming.getSolutionPoint() as SolutionPoint FROM (VALUES(0));
DECLARE LhsByConstraint CURSOR FOR SELECT LinearProgramming.getLhsByConstraint(i) as ConstraintRow FROM (SELECT rownum()-1 as i FROM INFORMATION_SCHEMA.Columns) WHERE i < 3;
DECLARE LhsByVariable CURSOR FOR SELECT LinearProgramming.getLhsByVariable(i) as ConstraintColumn FROM (SELECT rownum()-1 as i FROM INFORMATION_SCHEMA.Columns) WHERE i < 2;
DECLARE LhsValueAt CURSOR FOR SELECT LinearProgramming.getLhsValueAt(y,x) as ConstraintElementValue FROM (SELECT x, y FROM (SELECT rownum() -1 AS x FROM INFORMATION_SCHEMA.Columns WHERE rownum() -1 < 2) a, (SELECT rownum() -1 AS y FROM INFORMATION_SCHEMA.Columns WHERE rownum() -1 < 3) b);
DECLARE Rhs CURSOR FOR SELECT LinearProgramming.getRhs() as ConstraintValue FROM (VALUES(0));
DECLARE RhsByConstraint CURSOR FOR SELECT LinearProgramming.getRhsByConstraint(i) as ConstraintValue FROM (SELECT rownum()-1 as i FROM INFORMATION_SCHEMA.Columns) WHERE i < 3;
--
SET v_geq = 1;
SET v_leq = 2;
SET v_eq = 3;
SET v_constraint0_value = 32.0;
SET v_constraint1_value = 30.0;
SET v_constraint2_value = 40.0;
--
CALL LinearProgramming.createModel();
CALL LinearProgramming.setMaximize();
--
CALL LinearProgramming.setNumberOfVariables(2);
CALL LinearProgramming.setNumberOfConstraints(3);
--
--Objective Function: Maximum contribution to overheads and profits
CALL LinearProgramming.addCoefficientSpace(0);
CALL LinearProgramming.setCoefficientSpace(0);
CALL LinearProgramming.addCoefficient(300);
CALL LinearProgramming.addCoefficient(200);
CALL LinearProgramming.addLinearObjectiveFunction(0);
--Constraint: Process 1
CALL LinearProgramming.addCoefficientSpace(1);
CALL LinearProgramming.setCoefficientSpace(1);
CALL LinearProgramming.addCoefficient(8);
CALL LinearProgramming.addCoefficient(4);
CALL  LinearProgramming.addLinearConstraint(1, v_leq, v_constraint0_value);
--Constraint: Process 2
CALL LinearProgramming.addCoefficientSpace(2);
CALL LinearProgramming.setCoefficientSpace(2);
CALL LinearProgramming.addCoefficient(6);
CALL LinearProgramming.addCoefficient(5);
CALL  LinearProgramming.addLinearConstraint(2, v_leq, v_constraint1_value);
--Constraint: Process 3
CALL LinearProgramming.addCoefficientSpace(3);
CALL LinearProgramming.setCoefficientSpace(3);
CALL LinearProgramming.addCoefficient(5);
CALL LinearProgramming.addCoefficient(8);
CALL  LinearProgramming.addLinearConstraint(3, v_leq, v_constraint2_value);
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
CALL LinearProgramming.clean();
--
END;
/
