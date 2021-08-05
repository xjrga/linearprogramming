package io.github.xjrga.linearprogram;

/**
 * Created by jr on 5/23/2017.
 */
public class LPFormat {

    private final StringBuilder sb;

    public LPFormat() {

        sb = new StringBuilder();
    }

    public void clear(){
        sb.setLength(0);
    }

    public void objectiveToLp(double[] coefficients) {

        sb.append("/* Objective function */");
        sb.append("\n");

        sb.append("min: ");

        for (int i = 0; i < coefficients.length; i++) {

            double c = coefficients[i];
            sb.append(c);
            sb.append(" ");
            sb.append("x");
            sb.append(i);
            sb.append(" + ");

        }

        sb.deleteCharAt(sb.length() - 1);
        sb.deleteCharAt(sb.length() - 1);
        sb.deleteCharAt(sb.length() - 1);
        sb.append(";");
        sb.append("\n");

        sb.append("/* Variable bounds */");
        sb.append("\n");

    }

    public void constraintToLp(double[] coefficients, int rel, double value) {

        String relationship = "";

        relationship = getRelationship(rel);

        sb.append("");

        for (int i = 0; i < coefficients.length; i++) {

            double c = coefficients[i];
            sb.append(c);
            sb.append(" ");
            sb.append("x");
            sb.append(i);
            sb.append(" + ");

        }

        sb.deleteCharAt(sb.length() - 1);
        sb.deleteCharAt(sb.length() - 1);

        sb.append(relationship);
        sb.append(" ");
        sb.append(value);
        sb.append(";");
        sb.append("\n");

    }

    private String getRelationship(int rel) {

        String relationship = "";

        switch (rel) {
            case 1:
                relationship = ">=";
                //
                break;
            case 2:
                //
                relationship = "<=";
                break;
            case 3:
                //
                relationship = "=";
                break;
        }

        return relationship;

    }

    public String getModel() {
        return sb.toString();
    }

}
