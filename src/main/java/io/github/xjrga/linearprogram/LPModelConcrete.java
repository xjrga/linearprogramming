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
public class LPModelConcrete implements LPModel {

    private final ArrayList<LinearConstraint> constraints = new ArrayList();
    private LinearObjectiveFunction linearObjectiveFunction = null;
    private double[] point = new double[]{-1.0, -1.0};
    private double cost = -1.0;
    private final LPFormat lpFormat = new LPFormat();
    public final int GEQ = 1;
    public final int LEQ = 2;
    public final int EQ = 3;
    private GoalType goalType = GoalType.MINIMIZE;
    private final Map<Integer, List> coefficientsMap = new HashMap();
    private List<Double> currentStorage = null;
    private int numberOfVariables = -1;
    private int numberOfConstraints = -1;

    public LPModelConcrete() {
    }

    @Override
    public void setNumberOfVariables(int n) {
        this.numberOfVariables = n;
    }

    @Override
    public void setNumberOfConstraints(int n) {
        this.numberOfConstraints = n;
    }
    
    @Override
    public void addLinearObjectiveFunction(int storageId) {
        double[] coefficients = listToDoubleArrayPrimitive(getStorage(storageId));
        byte constantTerm = 0;
        linearObjectiveFunction = new LinearObjectiveFunction(coefficients, constantTerm);
        lpFormat.objectiveToLp(coefficients);
        ///printThreadInfo("addLinearObjectiveFunction");
    }

    @Override
    public void addLinearConstraint(int storageId, int rel, double amount) {
        int actualNumberOfConstraints = constraints.size();
        if (actualNumberOfConstraints < numberOfConstraints) {
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
            //printThreadInfo("addLinearConstraint");
        } else {
            throw new IllegalStateException(actualNumberOfConstraints + " is out of range");
        }
    }

    @Override
    public void setMaximize() {
        goalType = GoalType.MAXIMIZE;
        lpFormat.setMaximize();
        //printThreadInfo("setMaximize");
    }

    @Override
    public void solveModel() {
        SimplexSolver s = new SimplexSolver();
        LinearConstraintSet linearConstraintSet = new LinearConstraintSet(constraints);
        NonNegativeConstraint nonNegativeConstraint = new NonNegativeConstraint(true);
        OptimizationData[] data = new OptimizationData[]{linearObjectiveFunction, linearConstraintSet, goalType, nonNegativeConstraint};
        PointValuePair optimize = s.optimize(data);
        point = optimize.getPoint();
        cost = optimize.getSecond();
        //printThreadInfo("solveModel");
    }

    @Override
    public String printModel() {
        //printThreadInfo("printModel");
        return lpFormat.getModel();
    }

    @Override
    public void addCoefficientSpace(int storageId) {
        int actualNumberOfConstraints = constraints.size();
        if (actualNumberOfConstraints < numberOfConstraints) {
            coefficientsMap.put(storageId, new ArrayList<Double>());
            //printThreadInfo("addCoefficientSpace");
        } else {
            throw new IllegalStateException(actualNumberOfConstraints + " is out of range");
        }
    }

    @Override
    public void setCoefficientSpace(int storageId) {
        currentStorage = getStorage(storageId);
        //printThreadInfo("setCoefficientSpace");
    }

    @Override
    public void addCoefficient(double coefficient) {
        currentStorage.add(coefficient);
        //printThreadInfo("addCoefficient");
    }

    @Override
    public Array getSolutionPoint() {
        Array array = doubleToArray(getSolutionPointPrimitive());
        //printThreadInfo("getSolutionPoint");
        return array;
    }

    @Override
    public double getSolutionPointValueAt(int x) {
        double d = -1;
        if (x > -1 && x < numberOfVariables) {
            d = point[x];
        } else {
            throw new IllegalStateException(x + "is out of range");
        }
        //printThreadInfo("getSolutionPointValueAt");
        return d;
    }

    @Override
    public double getSolutionCost() {
        //printThreadInfo("getSolutionCost");
        return cost;
    }

    @Override
    public int getVariableCount() {
        //printThreadInfo("getVariableCount");
        return numberOfVariables;
    }

    @Override
    public int getConstraintCount() {
        //printThreadInfo("getConstraintCount");
        return numberOfConstraints;
    }

    @Override
    public Array getLhsByConstraint(int y) {
        Array array = doubleToArray(getLhsByConstraintPrimitive(y));
        //printThreadInfo("getLhsByConstraint");
        return array;
    }

    @Override
    public Array getLhsByVariable(int x) {
        Array array = doubleToArray(getLhsByVariablePrimitive(x));
        //printThreadInfo("getLhsByVariable");
        return array;
    }

    @Override
    public double getLhsValueAt(int y, int x) {
        double d;
        if (y > -1 && y < numberOfConstraints) {
            double[] coeffs = constraints.get(y).getCoefficients().toArray();
            if (x > -1 && x < numberOfVariables) {
                d = coeffs[x] * point[x];
            } else {
                throw new IllegalStateException(x + "is out of range");
            }
        } else {
            throw new IllegalStateException(y + "is out of range");
        }
        //printThreadInfo("getLhsValueAt");
        return d;
    }

    @Override
    public Array getRhs() {
        Array array = doubleToArray(getRhsByConstraintPrimitive());
        //printThreadInfo("getRhs");
        return array;
    }

    @Override
    public double getRhsByConstraint(int y) {
        double rhsValue = 0;
        double[] coeffs = constraints.get(y).getCoefficients().toArray();
        for (int x = 0; x < numberOfVariables; x++) {
            rhsValue += coeffs[x] * point[x];
        }
        //printThreadInfo("getRhsByConstraint");
        return rhsValue;
    }

    //Private methods
    private double[] getRhsByConstraintPrimitive() {
        double[] rowArray = new double[numberOfConstraints];
        for (int y = 0; y < numberOfConstraints; y++) {
            rowArray[y] = getRhsByConstraint(y);
        }
        return rowArray;
    }

    private double[] getSolutionPointPrimitive() {
        return point;
    }

    private double[] getLhsByConstraintPrimitive(int y) {
        double[] rowArray = new double[numberOfVariables];
        if (y > -1 && y < numberOfConstraints) {
            double[] coeffs = constraints.get(y).getCoefficients().toArray();
            for (int x = 0; x < numberOfVariables; x++) {
                rowArray[x] = coeffs[x] * point[x];
            }
        } else {
            throw new IllegalStateException(y + "is out of range");
        }
        return rowArray;
    }

    private double[] getLhsByVariablePrimitive(int x) {
        double[] columnArray = new double[numberOfConstraints];
        if (x > -1 && x < numberOfVariables) {
            for (int y = 0; y < numberOfConstraints; y++) {
                double[] coeffs = constraints.get(y).getCoefficients().toArray();
                columnArray[y] = coeffs[x] * point[x];
            }
        } else {
            throw new IllegalStateException(x + "is out of range");
        }
        return columnArray;
    }

    private List getStorage(int storageId) {
        return coefficientsMap.get(storageId);
    }

    private double[] listToDoubleArrayPrimitive(List<Double> list) {
        double[] dar = new double[list.size()];
        for (int i = 0; i < dar.length; i++) {
            dar[i] = list.get(i);
        }
        return dar;
    }

    private Array doubleToArray(double[] dar) {
        Object[] objects = new Object[dar.length];
        for (int i = 0; i < dar.length; i++) {
            objects[i] = dar[i];
        }
        Array array = new JDBCArrayBasic(objects, org.hsqldb.types.Type.SQL_DOUBLE);
        return array;
    }

    private void printThreadInfo(String s) {
        try {
            Thread currentThread = Thread.currentThread();
            System.out.println(s + ":" + System.currentTimeMillis() + "," + currentThread.getId() + "," + currentThread.getName());
            //Adjust sleep value for testing
            Thread.sleep(0);
        } catch (InterruptedException ex) {
        }
    }
}
