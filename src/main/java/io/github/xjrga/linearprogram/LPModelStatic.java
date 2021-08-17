/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package io.github.xjrga.linearprogram;

import java.sql.Array;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author Jorge R Garcia de Alba &lt;jorge.r.garciadealba@gmail.com&gt;
 */
public class LPModelStatic {

    private static final Map<Long, LPModelConcrete> map = new HashMap();

    public LPModelStatic() {

    }

    public static void createModel() {
        map.put(getThreadId(), new LPModelConcrete());
    }

    public static void addLinearObjectiveFunction(int storageId) {
        LPModelConcrete lpm = map.get(getThreadId());
        lpm.addLinearObjectiveFunction(storageId);
    }

    public static void addLinearConstraint(int storageId, int rel, double amount) {
        LPModelConcrete lpm = map.get(getThreadId());
        lpm.addLinearConstraint(storageId, rel, amount);
    }

    public static void setMaximize() {
        LPModelConcrete lpm = map.get(getThreadId());
        lpm.setMaximize();
    }

    public static void solveModel() {
        LPModelConcrete lpm = map.get(getThreadId());
        lpm.solveModel();
    }

    public static String printModel() {
        LPModelConcrete lpm = map.get(getThreadId());
        return lpm.printModel();
    }

    public static void addCoefficientSpace(int storageId) {
        LPModelConcrete lpm = map.get(getThreadId());
        lpm.addCoefficientSpace(storageId);
    }

    public static void setCoefficientSpace(int storageId) {
        LPModelConcrete lpm = map.get(getThreadId());
        lpm.setCoefficientSpace(storageId);
    }

    public static void addCoefficient(double coefficient) {
        LPModelConcrete lpm = map.get(getThreadId());
        lpm.addCoefficient(coefficient);
    }

    public static Array getSolutionPoint() {
        LPModelConcrete lpm = map.get(getThreadId());
        return lpm.getSolutionPoint();
    }

    public static double getSolutionPointValueAt(int x) {
        LPModelConcrete lpm = map.get(getThreadId());
        return lpm.getSolutionPointValueAt(x);
    }

    public static double getSolutionCost() {
        LPModelConcrete lpm = map.get(getThreadId());
        return lpm.getSolutionCost();
    }

    public static int getVariableCount() {
        LPModelConcrete lpm = map.get(getThreadId());
        return lpm.getVariableCount();
    }

    public static int getConstraintCount() {
        LPModelConcrete lpm = map.get(getThreadId());
        return lpm.getConstraintCount();
    }

    public static Array getLhsByConstraint(int y) {
        LPModelConcrete lpm = map.get(getThreadId());
        return lpm.getLhsByConstraint(y);
    }

    public static Array getLhsByVariable(int x) {
        LPModelConcrete lpm = map.get(getThreadId());
        return lpm.getLhsByVariable(x);
    }

    public static double getLhsValueAt(int y, int x) {
        LPModelConcrete lpm = map.get(getThreadId());
        return lpm.getLhsValueAt(y, x);
    }

    public static Array getRhs() {
        LPModelConcrete lpm = map.get(getThreadId());
        return lpm.getRhs();
    }

    public static double getRhsByConstraint(int y) {
        LPModelConcrete lpm = map.get(getThreadId());
        return lpm.getRhsByConstraint(y);
    }

    private static long getThreadId() {
        long id = Thread.currentThread().getId();
        return id;
    }
}
