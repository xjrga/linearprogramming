package io.github.xjrga;

import io.github.xjrga.linearprogram.LPModel;
import java.sql.Array;
import java.sql.SQLException;
import org.hsqldb.jdbc.JDBCArrayBasic;

import org.testng.Assert;
import org.testng.annotations.*;


/*
 * @author  Jorge Garcia de Alba
 */
public class TestLPModelTest {

    public TestLPModelTest() {

        /*

        Problem

        Acme Foods, Inc., wishes to minimize ingredient cost of its veggies and beans salad
        while at the same time it wishes the product meets the minimum daily fiber requirement
        for an adult. The ratio of veggies to beans must be 2 to 1.

        Facts

        1) Cost must be lowest.
        2) Veggies amount must be twice as much as beans.
        3) Veggies cost $4/Kg and they provide 4 g of fiber per 100 g serving.
        4) Beans cost $2/Kg and they provide 9 g of fiber per 100 g serving.
        5) Daily recommended fiber intake is 40g.

        Questions

        a) What is minimum cost combination of ingredients that satisfies all constraints?
        b) What is the minimum cost?

        Problem can be represented this way

        Minimize

        .002 x0 + 0.004 x1;

        subject to

        0.09 x0 + 0.04 x1 >=  40.0;
       -2.00 x0 + 1.00 x1  =  00.0;

        Solution

        cost = $ 2.35294117647059
        x0 = 235.294117647059 g
        x1 = 470.588235294118 g

        As an exercise, substitute the veggies and beans with your favorite foods to
        find out how much you would have to eat to meet the minimum daily fiber requirement.

        How much more or less would you have to eat?

         */
    }

    @Test
    public void testSolve() {

        LPModel.clearModel();

        //Cost objective function
        double[] coefficients0 = new double[]{.002, 0.004};
        LPModel.addLinearObjectiveFunctionPrimitive(coefficients0);

        //Fiber constraint
        double[] coefficients1 = new double[]{0.09, 0.04};
        double amount1 = 40;
        LPModel.addLinearConstraintPrimitive(coefficients1, LPModel.GEQ, amount1);

        //Ratio constraint
        double[] coefficients2 = new double[]{-2, 1};
        double amount2 = 0;
        LPModel.addLinearConstraintPrimitive(coefficients2, LPModel.EQ, amount2);

        //Print model
        System.out.println(LPModel.printModel());

        //Solution
        LPModel.solveModel();

        //Test
        String expectedModel = "/* Objective function */\n"
                + "min: 0.002 x0 + 0.004 x1;\n"
                + "/* Variable bounds */\n"
                + "0.09 x0 + 0.04 x1 >= 40.0;\n"
                + "-2.0 x0 + 1.0 x1 = 0.0;\n";
        String actualModel = LPModel.printModel();

        double[] expectedQuantity = new double[]{235.294117647059, 470.588235294118};
        double[] actualQuantity = LPModel.getSolutionPointPrimitive();

        double expectedCost = 2.35294117647059;
        double actualCost = LPModel.getSolutionCost();

        Assert.assertEquals(expectedModel, actualModel);
        Assert.assertEquals(actualQuantity, expectedQuantity, .00001);
        Assert.assertEquals(expectedCost, actualCost, .00001);

    }

    @Test
    public void testSolveUsingArray() {

        LPModel.clearModel();

        //Cost objective function
        Object[] oar = new Object[]{.002, 0.004};
        Array coefficients0 = new JDBCArrayBasic(oar, org.hsqldb.types.Type.SQL_DOUBLE);
        LPModel.addLinearObjectiveFunction(coefficients0);

        //Fiber constraint
        oar = new Object[]{0.09, 0.04};
        Array coefficients1 = new JDBCArrayBasic(oar, org.hsqldb.types.Type.SQL_DOUBLE);
        double amount1 = 40;
        LPModel.addLinearConstraint(coefficients1, LPModel.GEQ, amount1);

        //Ratio constraint
        double[] coefficients2 = new double[]{-2, 1};
        double amount2 = 0;
        LPModel.addLinearConstraintPrimitive(coefficients2, LPModel.EQ, amount2);

        //Print model
        System.out.println(LPModel.printModel());

        //Solution
        LPModel.solveModel();

        //Test
        String expectedModel = "/* Objective function */\n"
                + "min: 0.002 x0 + 0.004 x1;\n"
                + "/* Variable bounds */\n"
                + "0.09 x0 + 0.04 x1 >= 40.0;\n"
                + "-2.0 x0 + 1.0 x1 = 0.0;\n";
        String actualModel = LPModel.printModel();

        double[] expectedQuantity = new double[]{235.294117647059, 470.588235294118};
        double[] actualQuantity = LPModel.getSolutionPointPrimitive();

        double expectedCost = 2.35294117647059;
        double actualCost = LPModel.getSolutionCost();

        Assert.assertEquals(expectedModel, actualModel);
        Assert.assertEquals(actualQuantity, expectedQuantity, .00001);
        Assert.assertEquals(expectedCost, actualCost, .00001);

    }

    //@Test
    public void testConversion() {
        Object[] oar = new Object[]{.002, 0.004};
        Array array = new JDBCArrayBasic(oar, org.hsqldb.types.Type.SQL_DOUBLE);
        print(convert(array));
    }

    private double[] convert(Array array) {
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

    private void print(double[] array) {
        for (int i = 0; i < array.length; i++) {
            double d = array[i];
            System.out.println(i + ": " + d);
        }
    }
}
