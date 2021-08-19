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
DECLARE v_constraint0_value DOUBLE;
DECLARE v_constraint1_value DOUBLE;
--
DECLARE solutionPointValueAt CURSOR FOR SELECT LinearProgramming.getSolutionPointValueAt(i) as SolutionPoint FROM (SELECT rownum()-1 as i FROM INFORMATION_SCHEMA.Columns) WHERE i < 2;
DECLARE solutionCost CURSOR FOR SELECT LinearProgramming.getSolutionCost() as SolutionCost FROM (VALUES(0));
DECLARE solutionModel CURSOR FOR SELECT LinearProgramming.printModel() as Model FROM (VALUES(0));
DECLARE solutionPointValue CURSOR FOR SELECT LinearProgramming.getSolutionPoint() as SolutionPoint FROM (VALUES(0));
DECLARE LhsByConstraint CURSOR FOR SELECT LinearProgramming.getLhsByConstraint(i) as ConstraintRow FROM (SELECT rownum()-1 as i FROM INFORMATION_SCHEMA.Columns) WHERE i < 2;
DECLARE LhsByVariable CURSOR FOR SELECT LinearProgramming.getLhsByVariable(i) as ConstraintColumn FROM (SELECT rownum()-1 as i FROM INFORMATION_SCHEMA.Columns) WHERE i < 2;
DECLARE LhsValueAt CURSOR FOR SELECT LinearProgramming.getLhsValueAt(y,x) as ConstraintElementValue FROM (SELECT x, y FROM (SELECT rownum() -1 AS x FROM INFORMATION_SCHEMA.Columns WHERE rownum() -1 < 2) a, (SELECT rownum() -1 AS y FROM INFORMATION_SCHEMA.Columns WHERE rownum() -1 < 2) b);
DECLARE Rhs CURSOR FOR SELECT LinearProgramming.getRhs() as ConstraintValue FROM (VALUES(0));
DECLARE RhsByConstraint CURSOR FOR SELECT LinearProgramming.getRhsByConstraint(i) as ConstraintValue FROM (SELECT rownum()-1 as i FROM INFORMATION_SCHEMA.Columns) WHERE i < 2;
--
SET v_geq = 1;
SET v_leq = 2;
SET v_eq = 3;
SET v_constraint0_value = 40;
SET v_constraint1_value = 0;
--
CALL LinearProgramming.createModel();
--
CALL LinearProgramming.setNumberOfVariables(2);
CALL LinearProgramming.setNumberOfConstraints(2);
--
CALL LinearProgramming.addCoefficientSpace(0);
CALL LinearProgramming.setCoefficientSpace(0);
CALL LinearProgramming.addCoefficient(.002);
CALL LinearProgramming.addCoefficient(.004);
CALL LinearProgramming.addLinearObjectiveFunction(0);
--
CALL LinearProgramming.addCoefficientSpace(1);
CALL LinearProgramming.setCoefficientSpace(1);
CALL LinearProgramming.addCoefficient(.09);
CALL LinearProgramming.addCoefficient(.04);
CALL  LinearProgramming.addLinearConstraint(1, v_geq, v_constraint0_value);
--
CALL LinearProgramming.addCoefficientSpace(2);
CALL LinearProgramming.setCoefficientSpace(2);
CALL LinearProgramming.addCoefficient(-2);
CALL LinearProgramming.addCoefficient(1);
CALL  LinearProgramming.addLinearConstraint(2, v_eq, v_constraint1_value);
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

--drop procedure testProblem01;
--call testProblem01();
