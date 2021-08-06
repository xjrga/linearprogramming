SET SCHEMA LinearProgramming;
/
CREATE PROCEDURE solveModel01 (
)
MODIFIES SQL DATA BEGIN ATOMIC
--
DECLARE v_geq INT;
DECLARE v_leq INT;
DECLARE v_eq INT;
DECLARE  v_objective DOUBLE ARRAY;
DECLARE  v_constraint0 DOUBLE ARRAY;
DECLARE v_constraint0_value DOUBLE;
DECLARE  v_constraint1 DOUBLE ARRAY;
DECLARE v_constraint1_value DOUBLE;
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
CALL addLinearObjectiveFunction(v_objective);
CALL  addLinearConstraint(v_constraint0, v_geq, v_constraint0_value);
CALL  addLinearConstraint(v_constraint1, v_eq, v_constraint1_value);
CALL solveModel();
--
END;
/
