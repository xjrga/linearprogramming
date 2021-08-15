/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package io.github.xjrga.linearprogram;

import java.sql.Array;
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
    private static GoalType goalType = GoalType.MINIMIZE;
    private static final Map<Integer, List> coefficientsMap = new HashMap();
    private static List currentStorage;

    public LPModel() {
    }

    public static void clearModel() {
        goalType = GoalType.MINIMIZE;
        constraints.clear();
        linearObjectiveFunction = null;
        point = new double[]{-1.0, -1.0};
        cost = -1.0;
        lpFormat.clear();
        coefficientsMap.clear();
        currentStorage = null;
    }

    public static void addLinearObjectiveFunction(int storageId) {
        double[] coefficients = listToDoubleArrayPrimitive(getStorage(storageId));
        byte constantTerm = 0;
        linearObjectiveFunction = new LinearObjectiveFunction(coefficients, constantTerm);
        lpFormat.objectiveToLp(coefficients);
        printThreadInfo("addLinearObjectiveFunction");
    }

    public static void addLinearConstraint(int storageId, int rel, double amount) {
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
        double[] coefficients = listToDoubleArrayPrimitive(getStorage(storageId));
        constraints.add(new LinearConstraint(coefficients, relationship, amount));
        lpFormat.constraintToLp(coefficients, rel, amount);
        printThreadInfo("addLinearConstraint");
    }

    public static void setMaximize() {
        goalType = GoalType.MAXIMIZE;
        lpFormat.setMaximize();
        printThreadInfo("setMaximize");
    }

    public static void solveModel() {
        SimplexSolver s = new SimplexSolver();
        LinearConstraintSet linearConstraintSet = new LinearConstraintSet(constraints);
        NonNegativeConstraint nonNegativeConstraint = new NonNegativeConstraint(true);
        OptimizationData[] data = new OptimizationData[]{linearObjectiveFunction, linearConstraintSet, goalType, nonNegativeConstraint};
        PointValuePair optimize = s.optimize(data);
        point = optimize.getPoint();
        cost = optimize.getSecond();
        printThreadInfo("solveModel");
    }

    public static String printModel() {
        printThreadInfo("printModel");
        return lpFormat.getModel();
    }

    public static void addCoefficientSpace(int storageId) {
        coefficientsMap.put(storageId, new ArrayList<Double>());
        printThreadInfo("addCoefficientSpace");
    }

    public static void setCoefficientSpace(int storageId) {
        currentStorage = getStorage(storageId);
        printThreadInfo("setCoefficientSpace");
    }

    public static void addCoefficient(double coefficient) {
        currentStorage.add(coefficient);
        printThreadInfo("addCoefficient");
    }

    public static Array getSolutionPoint() {
        Array array = doubleToArray(getSolutionPointPrimitive());
        printThreadInfo("getSolutionPoint");
        return array;
    }

    public static double getSolutionPointValueAt(int x) {
        double d = -1;
        if (x > -1 && x < point.length) {
            d = point[x];
        } else {
            throw new IllegalStateException(x + "is out of range");
        }
        printThreadInfo("getSolutionPointValueAt");
        return d;
    }

    public static double getSolutionCost() {
        printThreadInfo("getSolutionCost");
        return cost;
    }

    public static int getVariableCount() {
        printThreadInfo("getVariableCount");
        return point.length;
    }

    public static int getConstraintCount() {
        printThreadInfo("getConstraintCount");
        return constraints.size();
    }

    public static Array getLhsByConstraint(int y) {
        Array array = doubleToArray(getLhsByConstraintPrimitive(y));
        printThreadInfo("getLhsByConstraint");
        return array;
    }

    public static Array getLhsByVariable(int x) {
        Array array = doubleToArray(getLhsByVariablePrimitive(x));
        printThreadInfo("getLhsByVariable");
        return array;
    }

    public static double getLhsValueAt(int y, int x) {
        double d;
        if (y > -1 && y < constraints.size()) {
            double[] coeffs = constraints.get(y).getCoefficients().toArray();
            if (x > -1 && x < point.length) {
                d = coeffs[x] * point[x];
            } else {
                throw new IllegalStateException(x + "is out of range");
            }
        } else {
            throw new IllegalStateException(y + "is out of range");
        }
        printThreadInfo("getLhsValueAt");
        return d;
    }

    public static Array getRhs() {
        Array array = doubleToArray(getRhsByConstraintPrimitive());
        printThreadInfo("getRhs");
        return array;
    }

    public static double getRhsByConstraint(int y) {
        double rhsValue = 0;
        double[] coeffs = constraints.get(y).getCoefficients().toArray();
        for (int x = 0; x < point.length; x++) {
            rhsValue += coeffs[x] * point[x];
        }
        printThreadInfo("getRhsByConstraint");
        return rhsValue;
    }

    //Private methods

    private static double[] getRhsByConstraintPrimitive() {
        double[] rowArray = new double[constraints.size()];
        for (int y = 0; y < constraints.size(); y++) {
            rowArray[y] = getRhsByConstraint(y);
        }
        return rowArray;
    }

    private static double[] getSolutionPointPrimitive() {
        return point;
    }

    private static double[] getLhsByConstraintPrimitive(int y) {
        double[] rowArray = new double[point.length];
        if (y > -1 && y < constraints.size()) {
            double[] coeffs = constraints.get(y).getCoefficients().toArray();
            for (int x = 0; x < point.length; x++) {
                rowArray[x] = coeffs[x] * point[x];
            }
        } else {
            throw new IllegalStateException(y + "is out of range");
        }
        return rowArray;
    }

    private static double[] getLhsByVariablePrimitive(int x) {
        double[] columnArray = new double[constraints.size()];
        if (x > -1 && x < point.length) {
            for (int y = 0; y < constraints.size(); y++) {
                double[] coeffs = constraints.get(y).getCoefficients().toArray();
                columnArray[y] = coeffs[x] * point[x];
            }
        } else {
            throw new IllegalStateException(x + "is out of range");
        }
        return columnArray;
    }

    private static List getStorage(int storageId) {
        return coefficientsMap.get(storageId);
    }

    private static double[] listToDoubleArrayPrimitive(List<Double> list) {
        double[] dar = new double[list.size()];
        for (int i = 0; i < dar.length; i++) {
            dar[i] = list.get(i);
        }
        return dar;
    }

    private static Array doubleToArray(double[] dar) {
        Object[] objects = new Object[dar.length];
        for (int i = 0; i < dar.length; i++) {
            objects[i] = dar[i];
        }
        Array array = new JDBCArrayBasic(objects, org.hsqldb.types.Type.SQL_DOUBLE);
        return array;
    }

    private static void printThreadInfo(String s){
        try {
            Thread currentThread = Thread.currentThread();
            System.out.println(s+":"+System.currentTimeMillis()+","+currentThread.getId()+","+currentThread.getName());
            //Adjust sleep value for testing
            Thread.sleep(0);
        } catch (InterruptedException ex) {
        }
    }
}

//Do I need to worry about this?
//Every class loaded by the VM has exactly one class-level lock
//A thread must get exclusive access to the class-level lock before entering method