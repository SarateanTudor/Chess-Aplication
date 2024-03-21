package Model;

import java.util.Comparator;
import java.util.SortedMap;

/*
* Interfata Polyonmial reprezinta o abstractizare a obiectului de tip Polynom
* Aceasta va contine toate metodele pe care o clasa care implementeaza aceasta interfata
  va trebui sa le aiba
* Aceasta va putea fi folosita ulterior in Unit Testing
 */
public interface Polynomial {
    // Functia get va returna obiectul de tip Polynom sau a clasei care implementeaza interfata
    SortedMap<Integer, Double> getPolynomial();

    // Metoda pentru recunoasterea ordinii de sortare descrescatoare a rangurilor
    // in SortedMap;
    Comparator<Integer> getCustomComparator();

    // Functie pentru adaugarea pe rangul i a unui monom cu acelasi rang
    // inmultit cu un coeficient, intr-un polinom
    void addToRank(Integer rang, Double coefficient);

    // Metoda pentru transferul de monoame dintr-un alt polinom in
    // corpul obiectului prezent
    void getMonomesFrom(Polynomial from);

    // Metoda pentru stergerea tuturor monoamelor din componenta polinomului
    void clear();

    /// Definirea reprezentarii unui polinom in interfata
    String toString();
}
