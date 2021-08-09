/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package io.github.xjrga.linearprogram;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.commons.math3.optim.OptimizationData;
import org.apache.commons.math3.optim.PointValuePair;
import org.apache.commons.math3.optim.linear.LinearConstraint;
import org.apache.commons.math3.optim.linear.LinearConstraintSet;
import org.apache.commons.math3.optim.linear.LinearObjectiveFunction;
import org.apache.commons.math3.optim.linear.NonNegativeConstraint;
import org.apache.commons.math3.optim.linear.Relationship;
import org.apache.commons.math3.optim.linear.SimplexSolver;
import org.apache.commons.math3.optim.nonlinear.scalar.GoalType;

/**
 *
 * @author Jorge R Garcia de Alba &lt;jorge.r.garciadealba@gmail.com&gt;
 */
public class LPModel02 {

    private static final ArrayList<LinearConstraint> constraints = new ArrayList();
    private static LinearObjectiveFunction linearObjectiveFunction;
    private static double[] point;
    private static double cost;
    private static final LPFormat lpFormat = new LPFormat();
    public static final int GEQ = 1;
    public static final int LEQ = 2;
    public static final int EQ = 3;
    private static GoalType goalType = GoalType.MINIMIZE;
    private static final Map<Integer, List> coefficients = new HashMap();
    private static List currentStorage;

    public LPModel02() {
    }

    public static void clearModel() {
        goalType = GoalType.MINIMIZE;
        constraints.clear();
        linearObjectiveFunction = null;
        point = new double[]{-1.0, -1.0};
        cost = -1.0;
        lpFormat.clear();
        coefficients.clear();
        currentStorage = null;
    }

    public static void addLinearObjectiveFunction(int constraintId) {
        double[] coefficients = convert(getStorage(constraintId));
        byte constantTerm = 0;
        linearObjectiveFunction = new LinearObjectiveFunction(coefficients, constantTerm);
        lpFormat.objectiveToLp(coefficients);
    }

    public static void addLinearConstraint(int constraintId, int rel, double amount) {
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
        double[] coefficients = convert(getStorage(constraintId));
        constraints.add(new LinearConstraint(coefficients, relationship, amount));
        lpFormat.constraintToLp(coefficients, rel, amount);
    }

    public static void setMaximize() {
        goalType = GoalType.MAXIMIZE;
        lpFormat.setMaximize();
    }

    public static void solveModel() {
        SimplexSolver s = new SimplexSolver();
        LinearConstraintSet linearConstraintSet = new LinearConstraintSet(constraints);
        NonNegativeConstraint nonNegativeConstraint = new NonNegativeConstraint(true);
        OptimizationData[] data = new OptimizationData[]{linearObjectiveFunction, linearConstraintSet, goalType, nonNegativeConstraint};
        PointValuePair optimize = s.optimize(data);
        point = optimize.getPoint();
        cost = optimize.getSecond();
    }

    public static double getSolutionPointVariable(int i) {
        double d = -1;
        if (i > -1 && i < point.length) {
            d = point[i];
        } else {
            throw new IllegalStateException(i+"is out of range");
        }
        return d;
    }

    public static double getSolutionCost() {
        return cost;
    }

    public static String printModel() {
        return lpFormat.getModel();
    }

    public static void addCoefficientSpace(int id) {
        coefficients.put(id, new ArrayList<Double>());
    }

    public static void setCoefficientSpace(int id) {
        currentStorage = getStorage(id);
    }

    public static void addCoefficient(double c) {
        currentStorage.add(c);
    }

    private static List getStorage(int id) {
        return coefficients.get(id);
    }

    private static double[] convert(List<Double> list) {
        double[] dar = new double[list.size()];
        for (int i = 0; i < dar.length; i++) {
            dar[i] = list.get(i);
        }
        return dar;
    }

}
