package Controller;
import Model.*;

import java.util.*;

public class PolynomialCalculator {
    /*
     * Metoda ScalarProductAddition va realiza functionalitatea de aditie a doua polinoame, cu functionalitati aditionale
     * Primul parametru va fi polinomul care va repreznta suma finala fi returnat la final
     * Al doilea parametru va fi polinomul care va fi aduagat la primul, dar mai intai acesta va fi inmultit
     * cu un monom de rang "rank" si coeficientul "coeficient"
     * In cazul unei aditii normale, coeficientul va fi 1 si rankul 0
     * Am ales abordarea cu returnarea primului polinom pentru a folosi memoria degeaba cu atribuiri new de fiecare
     * data
     */
    public Polynomial scalarProductAddition(Polynomial firstPolynomial, Polynomial secondPolynomial, Double coeficient, Integer rank){
        // Mai intai vom adauga toate monoamele din primul polinom intr-un polinom auxiliar
        PolynomialImplementation finalPolynomial = new PolynomialImplementation();
        finalPolynomial.getMonomesFrom(firstPolynomial);
        // Mai apoi vom adauga toate monoamele cu coeficientii acestora din polinomul al doilea
        // in polinomul auxiliar (desigur cu inmultirea scalara cu monomul parametru)
        for(Integer monomeRank : secondPolynomial.getPolynomial().keySet()){
            Integer newRank = monomeRank + rank;
            Double newCoeficient = secondPolynomial.getPolynomial().get(monomeRank) * coeficient;
                finalPolynomial.addToRank(newRank, newCoeficient);
        }
        return finalPolynomial; // returnam polinomul cu toti coeficientii adaugati

        /// Posibile leakuri de memorie, sau overflow !!!
    }
    /*
    * Metoda Addition reprezinta o particularizare a metodei scalarProductAddition
    * Aceasta reprezinta cazul normal in care pur si simplu adaugam doua polinoame
     */
    public Polynomial addition(Polynomial firstPolynomial, Polynomial secondPolynomial){
        return scalarProductAddition(firstPolynomial, secondPolynomial, 1., 0);
    }

    /*
    * Metoda subraction pur si simplu realizeaza scaderea folosindu-se de adunarea cu un polinom
    * inmultit cu -1
     */
    public Polynomial subtraction(Polynomial firstPolynomial, Polynomial secondPolynomial){
        return scalarProductAddition(firstPolynomial, secondPolynomial, -1., 0);
    }

    /*
    *
     */
    public Polynomial multiplication(Polynomial firstPolynomial, Polynomial secondPolynomial){
        Polynomial finalPolynomial = new PolynomialImplementation();
        for(Integer monomeRank : secondPolynomial.getPolynomial().keySet()){
            finalPolynomial = scalarProductAddition(finalPolynomial, firstPolynomial,
                    secondPolynomial.getPolynomial().get(monomeRank), monomeRank - 1);
        }
        return finalPolynomial;
    }
    /// Primul element este Catul
    /// Al doilea element este Restul
    public Polynomial[] division(Polynomial firstPolynomial, Polynomial secondPolynomial) throws DivisionByZeroException{
        if(secondPolynomial.getPolynomial().size() == 0){
            throw new DivisionByZeroException("ERROR: Division by zero not permitted");
        }
        Polynomial[] finalResult = new PolynomialImplementation[2];
        Polynomial quotient = new PolynomialImplementation();
        Polynomial rest = new PolynomialImplementation();
        if(firstPolynomial.getPolynomial().size() > 0){
            Integer rankA = firstPolynomial.getPolynomial().firstKey();
            Integer rankB = secondPolynomial.getPolynomial().firstKey();
            while(rankA >= rankB){
//                System.out.println(rankA + " " + rankB + " " + firstPolynomial.getPolynomial().get(rankA) + " " + secondPolynomial.getPolynomial().get(rankB));
                Double newCoeficient = (firstPolynomial.getPolynomial().get(rankA))/(secondPolynomial.getPolynomial().get(rankB));
                Integer newRank = rankA - rankB;
                quotient.addToRank(newRank + 1, newCoeficient);
                firstPolynomial = scalarProductAddition(firstPolynomial, secondPolynomial, -newCoeficient, newRank);
                if(firstPolynomial.getPolynomial().size() > 0){
                    rankA = firstPolynomial.getPolynomial().firstKey();
                } else {
                    rankA = 0;
                }
            }
        }
        rest.getMonomesFrom(firstPolynomial);

        finalResult[0] = quotient;
        finalResult[1] = rest;
        return finalResult;
    }

    public Polynomial differentiation(Polynomial polynomial){
        Polynomial finalPolynomial = new PolynomialImplementation();
        for(Map.Entry<Integer, Double> entry : polynomial.getPolynomial().entrySet()){
            Integer rank = entry.getKey();
            Double coeficient = entry.getValue();
            if(rank != 1){
                coeficient = coeficient * (rank - 1);
                rank = rank - 1;
                finalPolynomial.addToRank(rank, coeficient);
            }
        }
        return finalPolynomial;
    }

    public Polynomial integration(Polynomial polynomial){
        Polynomial finalPolynomial = new PolynomialImplementation();
        for(Map.Entry<Integer, Double> entry : polynomial.getPolynomial().entrySet()){
            Integer rank = entry.getKey();
            Double coeficient = entry.getValue();
            rank = rank + 1;
            coeficient = coeficient / (rank - 1);
            finalPolynomial.addToRank(rank, coeficient);
        }
        return finalPolynomial;
    }
}
