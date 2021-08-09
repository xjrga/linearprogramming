/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package io.github.xjrga;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.testng.Assert;
import org.testng.annotations.Test;

/**
 *
 * @author Jorge R Garcia de Alba &lt;jorge.r.garciadealba@gmail.com&gt;
 */
public class TestStorage {

    private final Map<Integer, List> coefficients = new HashMap();
    private List currentStorage;

    public TestStorage() {

    }

    public void addStorage(int id) {
        coefficients.put(id, new ArrayList<Double>());
    }

    public void setStorage(int id) {
        currentStorage = getStorage(id);
    }

    public void addCoefficient(double c) {
        currentStorage.add(c);
    }

    private List getStorage(int id) {
        return coefficients.get(id);
    }

    private double[] convert(List<Double> list) {
        double[] dar = new double[list.size()];
        for (int i = 0; i < dar.length; i++) {
            dar[i] = list.get(i);
        }
        return dar;
    }

    @Test
    public void testA() {
        TestStorage storage = new TestStorage();
        storage.addStorage(0);
        storage.addStorage(1);
        storage.setStorage(0);
        for (int i = 0; i < 10; i++) {
            storage.addCoefficient(i * 10);
        }
        List test = storage.getStorage(0);
        for (int i = 0; i < 10; i++) {
            double d = (double) test.get(i);
            Assert.assertEquals(i * 10, d);
        }
    }

    @Test
    public void testB() {
        TestStorage storage = new TestStorage();
        storage.addStorage(0);
        storage.addStorage(1);
        storage.setStorage(1);
        for (int i = 0; i < 10; i++) {
            storage.addCoefficient(i * 20);
        }
        List test = storage.getStorage(1);
        for (int i = 0; i < 10; i++) {
            double d = (double) test.get(i);
            Assert.assertEquals(i * 20, d);
        }
    }

    @Test
    public void testC() {
        TestStorage storage = new TestStorage();
        storage.addStorage(0);
        if (storage.getStorage(1) == null) {
            Assert.assertEquals(true, true);
        } else {
            Assert.assertEquals(true, false);
        }
    }
}
