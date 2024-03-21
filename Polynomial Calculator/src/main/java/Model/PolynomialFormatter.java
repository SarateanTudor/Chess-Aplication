package Model;

import java.util.Map;
import java.util.SortedMap;

public class PolynomialFormatter {
    public String formatPolynomial(SortedMap<Integer, Double> polynomial){
        StringBuilder finalString = new StringBuilder();
        if(polynomial.isEmpty()){
            return "0";
        }
        for(Map.Entry<Integer, Double> entry : polynomial.entrySet()){
            finalString.append(formatSign(polynomial, entry.getValue(), entry.getKey()));
            finalString.append(formatCoefficient(entry.getValue(), entry.getKey()));
            finalString.append(formatPower(entry.getKey()));
        }
        return finalString.toString();
    }

    private String formatCoefficient(Double value, Integer key){
        double absCoefficient = Math.abs(value);
        String coefficient = String.format("%.2f", absCoefficient);
        if(coefficient.endsWith(".00")){
            coefficient = coefficient.substring(0, coefficient.length() - 3);
        }
        if(absCoefficient > 0){
            if(key == 1){
                return coefficient;
            } else if(absCoefficient >= 1.001 || absCoefficient <= 0.999){
                return coefficient;
            }
        }
        return "";
    }

    private String formatSign(SortedMap<Integer, Double> polynomial, Double value, Integer key){
        if(key.equals(polynomial.firstKey())){
            if(value < 0){
                return "-";
            }
        } else {
            if(value < 0){
                return " - ";
            } else {
                return " + ";
            }
        }
        return "";
    }

    private String formatPower(Integer key){
        if(key != 1 && key != 2) {
            return "X^" + (key - 1);
        } else if(key == 2){
            return "X";
        }
        return "";
    }
}
