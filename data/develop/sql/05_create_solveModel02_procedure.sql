CREATE PROCEDURE solveModel02 (
)
MODIFIES SQL DATA BEGIN ATOMIC
--
DECLARE  v_objective DOUBLE ARRAY;
DECLARE  v_constraint0 DOUBLE ARRAY;
DECLARE v_constraint0_value DOUBLE;
DECLARE v_constraint0_relationship INTEGER;
DECLARE  v_constraint1 DOUBLE ARRAY;
DECLARE v_constraint1_value DOUBLE;
DECLARE v_constraint1_relationship INTEGER;
--
SET v_objective = getObjectiveCoefficients(0);
SET  v_constraint0 = getConstraintCoefficients(0,0);
SET v_constraint0_value = getConstraintValue(0,0);
SET v_constraint0_relationship = getConstraintRelationship(0,0);
SET  v_constraint1 = getConstraintCoefficients(0,1);
SET v_constraint1_value = getConstraintValue(0,1);
SET v_constraint1_relationship = getConstraintRelationship(0,1);
--
CALL addLinearObjectiveFunction(v_objective);
CALL  addLinearConstraint(v_constraint0, v_constraint0_relationship, v_constraint0_value);
CALL  addLinearConstraint(v_constraint1, v_constraint1_relationship, v_constraint1_value);
CALL solveModel();
--
END;
/
