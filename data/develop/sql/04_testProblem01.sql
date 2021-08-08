SET SCHEMA LinearProgramming;
/
CREATE PROCEDURE testProblem01 (
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
DECLARE resultPoint CURSOR FOR SELECT LinearProgramming.getSolutionPoint() FROM (VALUES(0));
DECLARE resultCost CURSOR FOR SELECT LinearProgramming.getSolutionCost() FROM (VALUES(0));
DECLARE resultModel CURSOR FOR SELECT LinearProgramming.printModel() FROM (VALUES(0));
--
SET v_geq = 1;
SET v_leq = 2;
SET v_eq = 3;
SET v_objective = ARRAY [ .002, 0.004];
SET  v_constraint0 = ARRAY [ 0.09, 0.04];
SET v_constraint0_value = 40;
SET  v_constraint1 = ARRAY [-2, 1];
SET v_constraint1_value = 0;
--
CALL LinearProgramming.clearModel();
CALL LinearProgramming.addLinearObjectiveFunction(v_objective);
CALL  LinearProgramming.addLinearConstraint(v_constraint0, v_geq, v_constraint0_value);
CALL  LinearProgramming.addLinearConstraint(v_constraint1, v_eq, v_constraint1_value);
CALL LinearProgramming.solveModel();
--
OPEN resultPoint;
OPEN resultCost;
OPEN resultModel;
--
END;
/
