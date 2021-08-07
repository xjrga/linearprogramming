/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package io.github.xjrga.linearprogram;

import java.sql.Array;
import java.sql.SQLException;
import java.util.ArrayList;
import org.apache.commons.math3.optim.OptimizationData;
import org.apache.commons.math3.optim.PointValuePair;
import org.apache.commons.math3.optim.linear.LinearConstraint;
import org.apache.commons.math3.optim.linear.LinearConstraintSet;
import org.apache.commons.math3.optim.linear.LinearObjectiveFunction;
import org.apache.commons.math3.optim.linear.NonNegativeConstraint;
import org.apache.commons.math3.optim.linear.Relationship;
import org.apache.commons.math3.optim.linear.SimplexSolver;
import org.apache.commons.math3.optim.nonlinear.scalar.GoalType;
import org.hsqldb.jdbc.JDBCArrayBasic;

/**
 *
 * @author Jorge R Garcia de Alba &lt;jorge.r.garciadealba@gmail.com&gt;
 */
public class LPModel {

    private static final ArrayList<LinearConstraint> constraints = new ArrayList();
    private static LinearObjectiveFunction linearObjectiveFunction;
    private static double[] point;
    private static double cost;
    private static final LPFormat lpFormat = new LPFormat();
    public static final int GEQ = 1;
    public static final int LEQ = 2;
    public static final int EQ = 3;

    public LPModel() {
    }

    public static void clearModel() {
        constraints.clear();
        lpFormat.clear();
        point = new double[]{-1.0,-1.0};
        cost = -1.0;
    }

    public static void addLinearObjectiveFunctionPrimitive(double[] coefficients) {
        byte constantTerm = 0;
        linearObjectiveFunction = new LinearObjectiveFunction(coefficients, constantTerm);
        lpFormat.objectiveToLp(coefficients);
    }

    public static void addLinearObjectiveFunction(Array coefficients) {
        double[] doubleArray = LPModel.convert(coefficients);
        LPModel.addLinearObjectiveFunctionPrimitive(doubleArray);
    }

    public static void addLinearConstraintPrimitive(double[] coefficients, int rel, double amount) {
        Relationship relationship = null;
        switch (rel) {
            case 1:
                relationship = Relationship.GEQ;
                break;
            case 2:
                relationship = Relationship.LEQ;
                break;
            case 3:
                relationship = Relationship.EQ;
                break;
            default:
                relationship = Relationship.GEQ;
                break;
        }
        constraints.add(new LinearConstraint(coefficients, relationship, amount));
        lpFormat.constraintToLp(coefficients, rel, amount);
    }

    public static void addLinearConstraint(Array coefficients, int rel, double amount) {
        double[] doubleArray = LPModel.convert(coefficients);
        LPModel.addLinearConstraintPrimitive(doubleArray, rel, amount);
    }

    public static void solveModel() {
        SimplexSolver s = new SimplexSolver();
        LinearConstraintSet linearConstraintSet = new LinearConstraintSet(constraints);
        GoalType GOALTYPE = GoalType.MINIMIZE;
        NonNegativeConstraint nonNegativeConstraint = new NonNegativeConstraint(true);
        OptimizationData[] data = new OptimizationData[]{linearObjectiveFunction, linearConstraintSet, GOALTYPE, nonNegativeConstraint};
        PointValuePair optimize = s.optimize(data);
        point = optimize.getPoint();
        cost = optimize.getSecond();
    }

    public static double[] getSolutionPointPrimitive() {
        return point;
    }

    public static Array getSolutionPoint() {
        Object[] objects = new Object[point.length];
        for (int i = 0; i < point.length; i++) {
            objects[i] = point[i];
        }
        Array array = new JDBCArrayBasic(objects, org.hsqldb.types.Type.SQL_DOUBLE);
        return array;
    }

    public static double getSolutionCost() {
        return cost;
    }

    public static String printModel() {
        return lpFormat.getModel();
    }

    private static double[] convert(Array array) {
        double[] dar = null;
        try {
            Object[] object = (Object[]) array.getArray();
            dar = new double[object.length];
            int size = object.length;
            for (int i = 0; i < size; i++) {
                Object o = object[i];
                dar[i] = (double) o;
            }
        } catch (SQLException ex) {

        }
        return dar;
    }

}
