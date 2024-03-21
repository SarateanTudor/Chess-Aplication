package Controller;

import Model.Polynomial;
import Model.PolynomialImplementation;

import java.util.regex.*;

public class PolynomialCreator {
    public static Polynomial createBracketPolynomial(Matcher matcher, Integer iterator){
        Polynomial newPolynomial = new PolynomialImplementation();
        Integer cpyOfIterator = iterator; // the rank of the polynomial
        while(matcher.find()){
            Double coeficient = 1.;
            Integer rank = cpyOfIterator;
            if(matcher.group(1).isEmpty() || matcher.group(1).equals("+")){

                    coeficient = Double.parseDouble(matcher.group(2));
            } else if (matcher.group(1).equals("-")){
                    coeficient = -Double.parseDouble(matcher.group(2));
            }
            newPolynomial.addToRank(rank, coeficient);
            cpyOfIterator --;
        }

        return newPolynomial;
    }

    public static void addToNewPolynomial(Polynomial newPolynomial, String monome, Double sign){
        Pattern pattern = Pattern.compile("\\**[ ]*(\\d*)[ ]*[xX][ ]*\\^?[ ]*(\\d*)|(\\d+)[ ]*([xX]*)[ ]*\\^?[ ]*\\d*");
        Matcher matcher = pattern.matcher(monome);
        Integer finalRank = 1;
        Double finalCoeficient = 1.;
        while(matcher.find()){
            /// rankul initial va fi 1 daca nu se gaseste un rank adica X^1
            Integer newRank = 1;
            Double newCoeficient = 1.;
            if(matcher.group(1) != null && !matcher.group(1).isEmpty()){
                newCoeficient = Double.parseDouble(matcher.group(1));
            }
            if(matcher.group(2) != null && !matcher.group(2).isEmpty()){
                newRank = Integer.parseInt(matcher.group(2));
            }
            if(matcher.group(3) != null && !matcher.group(3).isEmpty()){
                newCoeficient = Double.parseDouble(matcher.group(3));
                newRank = 0;
            }

            finalCoeficient *= newCoeficient;
            finalRank += newRank;
        }
        newPolynomial.addToRank(finalRank, finalCoeficient * sign);
    }
}
