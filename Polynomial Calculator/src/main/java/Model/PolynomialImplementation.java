package Model;
import java.util.*;
import java.lang.Integer;
/*
 * Clasa Polynom ne va ajuta sa reprezentam polinoamele ca instante in GUI
 * Aceasta va implementa ulterior interfata Polynomial
 */

public class PolynomialImplementation implements Polynomial{
    // Definim variabila privata de tip SortedMap in care vom salva
    // polinomul sub forma de coeficient -> valoare double
    private SortedMap<Integer, Double> polynomial;

    // Definirea constructorului clasei
    public PolynomialImplementation(){
        this.polynomial = new TreeMap<Integer, Double>(getCustomComparator());
    }

    // metoda prin intermediul careia vom returna obiectul de tip polinom
    @Override
    public SortedMap<Integer, Double> getPolynomial() {
        return this.polynomial;
    }

    @Override
    public Comparator<Integer> getCustomComparator() {
        return new Comparator<Integer>() {
            @Override
            public int compare(Integer first, Integer second) {
                return Integer.compare(second, first);
            }
        };
    }

   // Implementare metoda de transfer monoame dintr-un polinom intr-altul
    public void getMonomesFrom(Polynomial from){
        for(Integer monomeKey : from.getPolynomial().keySet()){
            this.polynomial.put(monomeKey, from.getPolynomial().get(monomeKey));
        }
    }

    // Implementare metoda de adaugare intr-un monom de rank i a unui coeficient al altui monom de
    // acelasi rang
    public void addToRank(Integer rank, Double coeficient) {
        if (this.polynomial.containsKey(rank)) {
            Double finalCoeficient = coeficient + this.polynomial.get(rank);
            if (finalCoeficient > -0.00001 && finalCoeficient < 0.00001) {
                this.polynomial.remove(rank);
            } else {
                this.polynomial.put(rank, finalCoeficient);
            }

        } else {
            if (coeficient <= -0.00001 || coeficient >= 0.00001) {
                this.polynomial.put(rank, coeficient);
            }

        }
    }

    // Implementare metoda de stergere totala a elementelor din lista de monoame a
    // unui obiect
    public void clear(){
        this.polynomial.clear();
    }

    @Override
    public String toString() {
        PolynomialFormatter formatter = new PolynomialFormatter();
        return formatter.formatPolynomial(this.polynomial);
    }



}
