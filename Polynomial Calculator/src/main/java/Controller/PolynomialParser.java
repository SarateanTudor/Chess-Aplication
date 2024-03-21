package Controller;

import Model.*;
import java.util.regex.*;

public class PolynomialParser {

    public Polynomial parsePolynomial(String polynomialString) throws IllegalFormatException{
        if(polynomialString.contains("[")){
            if(isBracketPolynomialValid(polynomialString)){
                return parseBracketPolynomial(polynomialString);
            } else {
                throw new IllegalFormatException("Invalid polynomial");
            }
        } else {
            if (isNormalPolynomiaValid(polynomialString)){
                return parseNormalPolynomial(polynomialString);
            } else {
                throw new IllegalFormatException("Invalid polynomial");
            }
        }
    }
    public boolean isBracketPolynomialValid(String polynomialString){
        Pattern pattern = Pattern.compile("[ ]*([-+]*)(\\d+)\\,[ ]*\\]|\\[[ ]*\\,([-+]*)(\\d+)|[\\,\\[][ ]*[+-][ ]*\\]*\\,|[\\,\\[\\s][ ]\\d*[ ]*[+-][ ]*[\\]]*|[\\,\\[][ ]*[+-]?[ ]*\\d*[ ]*[+-][ ]*[\\]\\,]|\\d[ ]*[+-][ ]*[\\]]|\\[.*?\\[|\\].*?\\]|\\,[ ]*\\,");
        Matcher matcher = pattern.matcher(polynomialString);
        return !matcher.find();
    }

    public boolean isNormalPolynomiaValid(String polynomialString){
        Pattern pattern = Pattern.compile("[^Xx\\^\\+\\-\\s\\d]|[^xX\\s][ ]*[\\^]|[\\^][ ]*[^\\d\\s]|[\\+\\-][ ]*[\\+\\-]|[\\^\\+\\-][ ]*$|^[ ]*[\\^]|[xX][ ]*\\d[ ]*[xX]");
        Matcher matcher = pattern.matcher(polynomialString);
        return !matcher.find();
    }

    public Polynomial parseBracketPolynomial(String polynomialString){
        Pattern pattern = Pattern.compile("[ ]*([-+]*)[ ]*(\\d+)\\,*[ ]*");
        Matcher matcher = pattern.matcher(polynomialString);
        Matcher matcherCount = pattern.matcher(polynomialString);
        int iterator = 0;
        while(matcherCount.find()){
            iterator++;
        }
        return PolynomialCreator.createBracketPolynomial(matcher, iterator);
    }

    public Polynomial parseNormalPolynomial(String polynomialString){
        Pattern pattern = Pattern.compile("([\\+\\-]?)[ ]*([\\d]+[ ]*\\**[ ]*(?:[xX]*[ ]*\\^?[ ]*\\d*)*)|([\\+\\-]?)[ ]*([\\d]*[ ]*\\**[ ]*(?:[xX]+[ ]*\\^?[ ]*\\d*)+)");
        Matcher matcher = pattern.matcher(polynomialString);
        Polynomial newPolynomial = new PolynomialImplementation();
        while(matcher.find()){
            String operator;
            if(matcher.group(3) != null){
                operator = matcher.group(3);
            } else {
                operator = matcher.group(1);
            }
            if(operator.equals("+") || operator.isEmpty()){
                if(matcher.group(2) != null){
                    PolynomialCreator.addToNewPolynomial(newPolynomial, matcher.group(2), 1.);
                } else {
                    PolynomialCreator.addToNewPolynomial(newPolynomial, matcher.group(4), 1.);
                }
            } else if(operator.equals("-")){
                if(matcher.group(2) != null){
                    PolynomialCreator.addToNewPolynomial(newPolynomial, matcher.group(2), -1.);
                } else {
                    PolynomialCreator.addToNewPolynomial(newPolynomial, matcher.group(4), -1.);
                }
            }
        }
        return newPolynomial;
    }

}
