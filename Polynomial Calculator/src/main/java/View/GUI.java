package View;

import Controller.PolynomialParser;
import Model.Polynomial;

import Controller.*;
import java.awt.Color;
import java.awt.Font;
import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class GUI {
    private JPanel MainPanel;
    private JButton AddButton;
    private JButton MultiplyButton;
    private JButton SubtractButton;
    private JButton DivideButton;
    private JButton DeleteButton;
    private JButton IntegrationButton;
    private JButton DerivativeButton;
    private JTextField ResultTextField;
    private JTextField FirstPolynomTextField;
    private JTextField SecondPolynomTextField;
    private JPanel OperationPanel;
    private JPanel ResultPanel;
    private JPanel SecondPolynomPanel;
    private JLabel SecondPolynomName;
    private JLabel FirstPolynomName;
    private JLabel Result;
    private JPanel FirstPolynomPanel;
    private JTextField RestResultTextField;


    public GUI() {
        JFrame frame = new JFrame("Polynomial Calculator");
        frame.setContentPane(MainPanel);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setSize(800, 800);
        frame.setLocationRelativeTo(null);
        frame.setVisible(true);
    }

    public void generateNormalTextFormat(){
        int fontSize = 36;
        ResultTextField.setForeground(Color.BLACK);
        ResultTextField.setFont(ResultTextField.getFont().deriveFont(Font.PLAIN));
        Font font = ResultTextField.getFont().deriveFont(Font.PLAIN, fontSize);
        RestResultTextField.setForeground(Color.BLACK);
        RestResultTextField.setFont(RestResultTextField.getFont().deriveFont(Font.PLAIN));
    }
    public String generateExceptionText(Exception e){
        int fontSize = 20;
        ResultTextField.setForeground(Color.RED);
        ResultTextField.setFont(RestResultTextField.getFont().deriveFont(Font.BOLD));
        Font font = ResultTextField.getFont().deriveFont(Font.PLAIN, fontSize);
        RestResultTextField.setForeground(Color.RED);
        RestResultTextField.setFont(RestResultTextField.getFont().deriveFont(Font.BOLD));
        return e.getMessage();
    }

    public JPanel getMainPanel() {
        return MainPanel;
    }

    public JButton getAddButton() {
        return AddButton;
    }

    public JButton getMultiplyButton() {
        return MultiplyButton;
    }

    public JButton getSubtractButton() {
        return SubtractButton;
    }

    public JButton getDivideButton() {
        return DivideButton;
    }

    public JButton getDeleteButton() {
        return DeleteButton;
    }

    public JButton getIntegrationButton() {
        return IntegrationButton;
    }

    public JButton getDerivativeButton() {
        return DerivativeButton;
    }

    public JTextField getResultTextField() {
        return ResultTextField;
    }

    public JTextField getFirstPolynomTextField() {
        return FirstPolynomTextField;
    }

    public JTextField getSecondPolynomTextField() {
        return SecondPolynomTextField;
    }

    public JPanel getOperationPanel() {
        return OperationPanel;
    }

    public JPanel getResultPanel() {
        return ResultPanel;
    }

    public JPanel getSecondPolynomPanel() {
        return SecondPolynomPanel;
    }

    public JLabel getSecondPolynomName() {
        return SecondPolynomName;
    }

    public JLabel getFirstPolynomName() {
        return FirstPolynomName;
    }

    public JLabel getResult() {
        return Result;
    }

    public JPanel getFirstPolynomPanel() {
        return FirstPolynomPanel;
    }

    public JTextField getRestResultTextField() {
        return RestResultTextField;
    }






}