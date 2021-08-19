/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package io.github.xjrga.linearprogram;

import java.sql.Array;

/**
 *
 * @author Jorge R Garcia de Alba &lt;jorge.r.garciadealba@gmail.com&gt;
 */
public interface LPModel {

    void setNumberOfVariables(int n);

    void setNumberOfConstraints(int n);

    void addCoefficient(double coefficient);

    void addCoefficientSpace(int storageId);

    void addLinearConstraint(int storageId, int rel, double amount);

    void addLinearObjectiveFunction(int storageId);

    int getConstraintCount();

    Array getLhsByConstraint(int y);

    Array getLhsByVariable(int x);

    double getLhsValueAt(int y, int x);

    Array getRhs();

    double getRhsByConstraint(int y);

    double getSolutionCost();

    Array getSolutionPoint();

    double getSolutionPointValueAt(int x);

    int getVariableCount();

    String printModel();

    void setCoefficientSpace(int storageId);

    void setMaximize();

    void solveModel();

}
