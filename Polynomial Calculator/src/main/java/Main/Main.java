package Main;
import View.*;
import Controller.*;
import Model.*;

public class Main {
    public static void main(String[] args) {
        GUI view = new GUI();
        OperationController controller = new OperationControllerImplementation(view);
    }
}
