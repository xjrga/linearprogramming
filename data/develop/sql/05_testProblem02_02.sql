SET SCHEMA LinearProgramming;
/
CREATE PROCEDURE testProblem02_lpmodel02(
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
DECLARE resultPointVariable01 CURSOR FOR SELECT LinearProgramming.getSolutionPointVariable(0) FROM (VALUES(0));
DECLARE resultPointVariable02 CURSOR FOR SELECT LinearProgramming.getSolutionPointVariable(1) FROM (VALUES(0));
DECLARE resultCost CURSOR FOR SELECT LinearProgramming.getSolutionCost() FROM (VALUES(0));
DECLARE resultModel CURSOR FOR SELECT LinearProgramming.printModel() FROM (VALUES(0));
--
SET v_geq = 1;
SET v_leq = 2;
SET v_eq = 3;
SET v_constraint0_value = 32.0;
SET v_constraint1_value = 30.0;
SET v_constraint2_value = 40.0;
--
CALL LinearProgramming.clearModel();
CALL LinearProgramming.setMaximize();
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
OPEN resultPointVariable01;
OPEN resultPointVariable02;
OPEN resultCost;
OPEN resultModel;
--
END;
/
