package Controller;

import View.GUI;
import Model.*;

public class OperationControllerImplementation implements OperationController{
    private GUI view;

    public OperationControllerImplementation(GUI view) {
        this.view = view;
        setupListeners();
    }

    private void setupListeners() {
        view.getAddButton().addActionListener(e -> performAddition());
        view.getMultiplyButton().addActionListener(e -> performMultiplication());
        view.getSubtractButton().addActionListener(e -> performSubtraction());
        view.getDivideButton().addActionListener(e -> performDivision());
        view.getDeleteButton().addActionListener(e -> performDeletion());
        view.getIntegrationButton().addActionListener(e -> performIntegration());
        view.getDerivativeButton().addActionListener(e -> performDerivative());
    }

    @Override
    public void performAddition() {
        try{
            PolynomialCalculator calculator = new PolynomialCalculator();
            Polynomial[] polynomials = getPolynomials();
            Polynomial result = calculator.addition(polynomials[0], polynomials[1]);
            view.getResultTextField().setText(result.toString());
        } catch (IllegalFormatException ife){
            view.getResultTextField().setText(view.generateExceptionText(ife));
        }
    }

    @Override
    public void performMultiplication() {
        try {
            PolynomialCalculator calculator = new PolynomialCalculator();
            Polynomial[] polynomials = getPolynomials();
            Polynomial result = calculator.multiplication(polynomials[0], polynomials[1]);
            view.getResultTextField().setText(result.toString());
        } catch (IllegalFormatException ife){
            view.getResultTextField().setText(view.generateExceptionText(ife));
        }
    }

    @Override
    public void performSubtraction() {
        try {
            PolynomialCalculator calculator = new PolynomialCalculator();
            Polynomial[] polynomials = getPolynomials();
            Polynomial result = calculator.subtraction(polynomials[0], polynomials[1]);
            view.getResultTextField().setText(result.toString());
        } catch (IllegalFormatException ife){
            view.getResultTextField().setText(view.generateExceptionText(ife));
        }
    }

    @Override
    public void performDivision() {
        try {
            PolynomialCalculator calculator = new PolynomialCalculator();
            Polynomial[] polynomials = getPolynomials();
            Polynomial result[] = calculator.division(polynomials[0], polynomials[1]);
            view.getResultTextField().setText(result[0].toString());
            view.getRestResultTextField().setText(result[1].toString());
        } catch (IllegalFormatException | DivisionByZeroException ife){
            view.getResultTextField().setText(view.generateExceptionText(ife));
        }
    }

    @Override
    public void performIntegration() {
        try{
            PolynomialCalculator calculator = new PolynomialCalculator();
            Polynomial polynomial = getPolynomial(view.getFirstPolynomTextField().getText());
            Polynomial result = calculator.integration(polynomial);
            view.getResultTextField().setText(result.toString());
        } catch (IllegalFormatException ife){
            view.getResultTextField().setText(view.generateExceptionText(ife));
        }
    }

    @Override
    public void performDerivative() {
        try {
            PolynomialCalculator calculator = new PolynomialCalculator();
            Polynomial polynomial = getPolynomial(view.getFirstPolynomTextField().getText());
            Polynomial result = calculator.differentiation(polynomial);
            view.getResultTextField().setText(result.toString());
        } catch (IllegalFormatException ife){
            view.getResultTextField().setText(view.generateExceptionText(ife));
        }
    }

    @Override
    public void performDeletion() {
        view.getFirstPolynomTextField().setText("");
        view.getSecondPolynomTextField().setText("");
        view.getResultTextField().setText("");
    }

    private Polynomial[] getPolynomials() throws IllegalFormatException{
        view.generateNormalTextFormat();
        PolynomialParser parser = new PolynomialParser();
        Polynomial firstPolynomial = parser.parsePolynomial(view.getFirstPolynomTextField().getText());
        Polynomial secondPolynomial =  parser.parsePolynomial(view.getSecondPolynomTextField().getText());
        return new Polynomial[]{firstPolynomial, secondPolynomial};
    }

    private Polynomial getPolynomial(String polynomialString) throws IllegalFormatException{
        view.generateNormalTextFormat();
        PolynomialParser parser = new PolynomialParser();
        return parser.parsePolynomial(polynomialString);

    }

}
