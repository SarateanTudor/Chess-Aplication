import static org.junit.Assert.*;

import Controller.PolynomialParser;
import org.junit.Test;

import Controller.PolynomialCalculator;
import Model.PolynomialImplementation;
import Model.*;
import Controller.*;

public class PolynomialCalculatorTest {
    public String firstPolynomialString;
    public String secondPolynomialString;
    public Polynomial firstPolynomial;
    public Polynomial secondPolynomial;
    public PolynomialCalculator calculator;
    public PolynomialParser parser;
    public PolynomialFormatter formatter;

    public PolynomialCalculatorTest(){
        calculator = new PolynomialCalculator();
        formatter = new PolynomialFormatter();
        parser = new PolynomialParser();
    }
    @Test
    public void additionTest() throws IllegalFormatException, DivisionByZeroException{
        firstPolynomialString = "X^2 - 5X - 2";
        secondPolynomialString = "3X^2 + 2X^1 + 1";
        firstPolynomial = parser.parsePolynomial(firstPolynomialString);
        secondPolynomial = parser.parsePolynomial(secondPolynomialString);
        Polynomial result = calculator.addition(firstPolynomial, secondPolynomial);
        assertEquals("4X^2 - 3X - 1", formatter.formatPolynomial(result.getPolynomial()));

        firstPolynomialString = "[23, 0, 0, 1]"; /// 23X^3 + 1
        secondPolynomialString = "-3X^3 + 2x + 1";
        firstPolynomial = parser.parsePolynomial(firstPolynomialString);
        secondPolynomial = parser.parsePolynomial(secondPolynomialString);
        result = calculator.addition(firstPolynomial, secondPolynomial);
        assertEquals("20X^3 + 2X + 2", formatter.formatPolynomial(result.getPolynomial()));
    }

    @Test
    public void subtractTest() throws IllegalFormatException{
        firstPolynomialString = "X^2 + x + 1";
        secondPolynomialString = "x  ^ 2 +            x         -1";
        firstPolynomial = parser.parsePolynomial(firstPolynomialString);
        secondPolynomial = parser.parsePolynomial(secondPolynomialString);
        Polynomial result = calculator.subtraction(firstPolynomial, secondPolynomial);
        assertEquals("2", formatter.formatPolynomial(result.getPolynomial()));

        firstPolynomialString = "[4 3 2 1]";
        secondPolynomialString = "[1 2 3 4]";
        firstPolynomial = parser.parsePolynomial(firstPolynomialString);
        secondPolynomial = parser.parsePolynomial(secondPolynomialString);
        result = calculator.subtraction(firstPolynomial, secondPolynomial);
        assertEquals("3X^3 + X^2 - X - 3", formatter.formatPolynomial(result.getPolynomial()));
    }

    @Test
    public void multiplicationTest() throws IllegalFormatException{
        firstPolynomialString = "X^2 + 2X + 1";
        secondPolynomialString = "X^2 + 2X + 1";
        firstPolynomial = parser.parsePolynomial(firstPolynomialString);
        secondPolynomial = parser.parsePolynomial(secondPolynomialString);
        Polynomial result = calculator.multiplication(firstPolynomial, secondPolynomial);
        assertEquals("X^4 + 4X^3 + 6X^2 + 4X + 1", formatter.formatPolynomial(result.getPolynomial()));

        firstPolynomialString = "[1 1 1    1  1 1]"; /// X^5 + X^4 + X^3 + X^2 + X + 1
        secondPolynomialString = "[1 2 3]"; /// X^2 + 2X + 3
        firstPolynomial = parser.parsePolynomial(firstPolynomialString);
        secondPolynomial = parser.parsePolynomial(secondPolynomialString);
        result = calculator.multiplication(firstPolynomial, secondPolynomial);
        assertEquals("X^7 + 3X^6 + 6X^5 + 6X^4 + 6X^3 + 6X^2 + 5X + 3", formatter.formatPolynomial(result.getPolynomial()));
        /// atata da pe cuvant
    }

    @Test
    public void divisionTest() throws IllegalFormatException, DivisionByZeroException{
        firstPolynomialString = "X^2 + 2X + 1";
        secondPolynomialString = "X + 1";
        firstPolynomial = parser.parsePolynomial(firstPolynomialString);
        secondPolynomial = parser.parsePolynomial(secondPolynomialString);
        Polynomial[] result = calculator.division(firstPolynomial, secondPolynomial);
        assertEquals("X + 1", formatter.formatPolynomial(result[0].getPolynomial()));
        assertEquals("0", formatter.formatPolynomial(result[1].getPolynomial()));

        firstPolynomialString = "X^3 + 2X^2 + 3X + 4";
        secondPolynomialString = "X^2 + 2X + 3";
        firstPolynomial = parser.parsePolynomial(firstPolynomialString);
        secondPolynomial = parser.parsePolynomial(secondPolynomialString);
        result = calculator.division(firstPolynomial, secondPolynomial);
        assertEquals("X", formatter.formatPolynomial(result[0].getPolynomial()));
        assertEquals("4", formatter.formatPolynomial(result[1].getPolynomial()));
    }

    @Test
    public void integrationTest() throws IllegalFormatException{
        firstPolynomialString = "X^2 + 2X + 1";
        firstPolynomial = parser.parsePolynomial(firstPolynomialString);
        Polynomial result = calculator.integration(firstPolynomial);
        assertEquals("0.33X^3 + X^2 + X", formatter.formatPolynomial(result.getPolynomial()));

        firstPolynomialString = "X^3 + 2X^2 + 3X + 4";
        firstPolynomial = parser.parsePolynomial(firstPolynomialString);
        result = calculator.integration(firstPolynomial);
        assertEquals("0.25X^4 + 0.67X^3 + 1.50X^2 + 4X", formatter.formatPolynomial(result.getPolynomial()));

    }

    @Test
    public void differentiationTest() throws IllegalFormatException{
        firstPolynomialString = "X^2 + 2X + 1";
        firstPolynomial = parser.parsePolynomial(firstPolynomialString);
        Polynomial result = calculator.differentiation(firstPolynomial);
        assertEquals("2X + 2", formatter.formatPolynomial(result.getPolynomial()));

        firstPolynomialString = "X^3 + 2X^2 + 3X + 4";
        firstPolynomial = parser.parsePolynomial(firstPolynomialString);
        result = calculator.differentiation(firstPolynomial);
        assertEquals("3X^2 + 4X + 3", formatter.formatPolynomial(result.getPolynomial()));
    }

    @Test
    public void testClear() throws IllegalFormatException{
        firstPolynomialString = "X^2 + 2X + 1";
        firstPolynomial = parser.parsePolynomial(firstPolynomialString);
        firstPolynomial.clear();
        assertEquals("0", formatter.formatPolynomial(firstPolynomial.getPolynomial()));
    }
}
