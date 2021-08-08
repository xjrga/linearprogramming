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
DECLARE  v_objective DOUBLE ARRAY;
DECLARE  v_constraint0 DOUBLE ARRAY;
DECLARE v_constraint0_value DOUBLE;
DECLARE  v_constraint1 DOUBLE ARRAY;
DECLARE v_constraint1_value DOUBLE;
DECLARE  v_constraint2 DOUBLE ARRAY;
DECLARE v_constraint2_value DOUBLE;
DECLARE  v_constraint3 DOUBLE ARRAY;
DECLARE v_constraint3_value DOUBLE;
DECLARE  v_constraint4 DOUBLE ARRAY;
DECLARE v_constraint4_value DOUBLE;
DECLARE resultPoint CURSOR FOR SELECT LinearProgramming.getSolutionPoint() FROM (VALUES(0));
DECLARE resultCost CURSOR FOR SELECT LinearProgramming.getSolutionCost() FROM (VALUES(0));
DECLARE resultModel CURSOR FOR SELECT LinearProgramming.printModel() FROM (VALUES(0));
--
SET v_geq = 1;
SET v_leq = 2;
SET v_eq = 3;
SET v_objective = ARRAY [ 300.0, 200.0];
SET  v_constraint0 = ARRAY [8.0,4.0];
SET v_constraint0_value = 32.0;
SET  v_constraint1 = ARRAY [6.0,5.0];
SET v_constraint1_value = 30.0;
SET  v_constraint2 = ARRAY [5.0,8.0];
SET v_constraint2_value = 40.0;
SET  v_constraint3 = ARRAY [1.0,0.0];
SET v_constraint3_value = 0.0;
SET  v_constraint4 = ARRAY [0.0,1.0];
SET v_constraint4_value = 0.0;
--
CALL LinearProgramming.clearModel();
CALL LinearProgramming.setMaximize();
CALL LinearProgramming.addLinearObjectiveFunction(v_objective);
CALL  LinearProgramming.addLinearConstraint(v_constraint0, v_leq, v_constraint0_value);
CALL  LinearProgramming.addLinearConstraint(v_constraint1, v_leq, v_constraint1_value);
CALL  LinearProgramming.addLinearConstraint(v_constraint2, v_leq, v_constraint2_value);
CALL  LinearProgramming.addLinearConstraint(v_constraint3, v_geq, v_constraint3_value);
CALL  LinearProgramming.addLinearConstraint(v_constraint4, v_geq, v_constraint4_value);
CALL LinearProgramming.solveModel();
--
OPEN resultPoint;
OPEN resultCost;
OPEN resultModel;
--
END;
/
