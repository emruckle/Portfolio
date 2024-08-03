/**
 *  Reverse Worldle game, attempts to guess the user's 5-letter word in five guesses
 *
 *  @author Emma Ruckle, Molly Neu, Heather Robertson
 *  @version 1.0
 *  References:
 *  - https://stackoverflow.com/questions/886955/how-do-i-break-out-of-nested-loops-in-java 
 *
 */

import java.util.*;
import java.util.ArrayList;
import com.google.common.graph.*;
import com.google.common.util.concurrent.AtomicLongMap;
import com.google.common.primitives.Chars;
import java.util.Arrays;
import java.io.*;


class Main {

  /** 
  *  Determines whether the user's input is affirmative or negative
  *
  * @param
  *
  * @author  Emma Ruckle, Molly Neu, Heather Robertson
  * @version 1.0
  * @since   <12/10/22>
  */
  public static boolean yesOrNo(String input) {
    input = input.toLowerCase();
    if ((input.equals("yes")) || (input.equals("y")) || (input.equals("+")) || (input.equals("yyyyy")))
      return true;
    else if ((input.equals("no")) || (input.equals("n")) || (input.equals("-"))
        || (input.equals("nnnnn")))
      return false;
    else
      throw new IllegalArgumentException();
  }


  /** 
  * Make a graph from the passed-in list of words
  * Creates a node for each word and an edge between any two words which share no letters
  *
  * @param list HashSet<String>
  *
  * @author  <Emma Ruckle, Molly Neu, Heather Robertson>
  * @version 1.0
  * @since   <12/10/22>
  */
  public static MutableGraph<String> createGraph(HashSet<String> list) {
    MutableGraph<String> graph = GraphBuilder.undirected().build();
    for (String x : list)
      graph.addNode(x);
    for (String x : graph.nodes()) {
      boolean add = true;
      char[] xletters = x.toCharArray();
      for (String y : graph.nodes()) {
        add = true;
        char[] yletters = y.toCharArray();
        for (int a = 0; a < 5; a++) {
          for (int b = 0; b < 5; b++) {
            if (xletters[a] == yletters[b])
              add = false;
          }
        }
        if (add == true)
          graph.putEdge(x, y);
      }
    }
    return graph;
  }

  /** 
  * Returns true if user input contains a 5 character combination of Y/N/P
  *
  * @param input String
  *
  * @author  <Emma Ruckle, Molly Neu, Heather Robertson>
  * @version 1.0
  * @since   <12/10/22>
  */
  public static boolean containsOnly(String input) {
    input = input.toUpperCase();
    int len = input.length();
    for (int i = 0; i < len; i++) {
      if (!((input.substring(i, i + 1).equals("Y")) || (input.substring(i, i + 1).equals("P"))
          || (input.substring(i, i + 1).equals("N")))) {
        return false;
      }
    }
    return true;
  }

  /** 
  *  Determines if each word in the final words list includes all of the user's input letters 
  *  Creates a revised version of final words only including the words that have all the letters
  *
  * @param initialWords HashSet<String>
  * @param wordLetters char[]
  *
  * @author  Emma Ruckle, Molly Neu, Heather Robertson
  * @version 1.0
  * @since   <12/10/22>
  */
  public static HashSet<String> checkingFinalWords(HashSet<String> initialWords, char[] wordLetters) {
    HashSet<String> revisedWords = new HashSet<String>();
    Iterator<String> wordIterator = initialWords.iterator();
    String str = String.valueOf(wordLetters);
    str = str.trim();
    while (wordIterator.hasNext()) {
      String next = wordIterator.next();
      boolean hasAll = true;
      for (int i = 0; i < str.length(); i++) {
        char index = wordLetters[i];
        if (!((next.indexOf(index) == 0) || (next.indexOf(index) == 1) || (next.indexOf(index) == 2)
            || (next.indexOf(index) == 3) ||
            next.indexOf(index) == 4)) {
          hasAll = false;
        }
      }
      if (hasAll == true) {
        revisedWords.add(next);
      }
    }
    return revisedWords;
  }

  /** 
  * Iterates through final guess list, returns the word with the highest ranking in the ranking list, if no words are ranked, returns the first word in the final guess list
  *
  * @param finalWords HashSet<String>
  *
  * @author  <Emma Ruckle, Molly Neu, Heather Robertson>
  * @version 1.0
  * @since   <12/10/22>
  */
  public static String ranking(HashSet<String> finalWords) {
    Ranking rank = new Ranking();
    ArrayList<String> ranking = rank.getRanking();
    Iterator<String> guessIterator = finalWords.iterator();
    int index = -1;
    int tempIndex;
    while (guessIterator.hasNext()) {
      String word = guessIterator.next();
      if (ranking.contains(word)) {
        tempIndex = ranking.indexOf(word);
        if (index == -1) {
          index = tempIndex;
        }
        else {
          if (tempIndex < index) {
            index = tempIndex;
          }
        }
      }
    }
    if (index != -1) {
      return ranking.get(index);
    }
    else {
      String word = "";
      for (String x : finalWords) {
          word = x;
          break;
      }
      return word;
    }  
  }  

  /** 
  * Runs games and takes in user input 
  *
  * @param args String[]
  *
  * @author  <Emma Ruckle, Molly Neu, Heather Robertson>
  * @version 1.0
  * @since   <12/10/22>
  */
  public static void main(String[] args) throws IOException {
    char[] emptyCharArray = new char[1];

    // Call the first wordlist constructor and create a graph from the constructed list
    WordList wl = new WordList();
    HashSet<String> list = wl.getList();
    MutableGraph<String> g = createGraph(list);

    // create an ArrayList Representation of the graph to
    // sort through when finding cliques
    ArrayList<ArrayList<String>> cliques = new ArrayList<ArrayList<String>>();
    for (EndpointPair<String> x : g.edges()) {
      ArrayList<String> clique = new ArrayList<String>();
      clique.add(x.nodeU());
      clique.add(x.nodeV());
      cliques.add(clique);
    }

    // class to search for cliques; ignore unless you are
    // using the commented-out code below
    Guesses guess = new Guesses();

    /**
     * Uncomment the following block of code to see the
     * program find a 5-clique and write it to "Guesses.txt"
     * Estimated run time: 11 minutes, 30 seconds
     */

    ///////////////////////////////////
    // guess.cliques(g);
    ///////////////////////////////////

    // section to interact with user
    boolean again = true;
    while (again == true) {
      again = false;
      System.out.println("Pick a five-letter word, and I will try to guess it. I have six guesses.");
      System.out.println(
          "For each letter in each guess, type \"N\" if the letter is not in the word, \"P\" if it is in the word but not in that spot, and \"Y\" if it is in the right place in the word.");
      Scanner in = new Scanner(System.in);
      char[] letters = new char[5];
      char[] xLetters = new char[5];
      int nextLetter = 0;
      char[] restrictions = new char[5];
      char[] antiRestrictions = new char[5];
      outer:
      for (String word : guess.getGuesses()) {
        int yCount = 0;
        System.out.println("Is your word: " + word);
        String user = in.nextLine();
        boolean badInput = true;
        while (badInput == true) {
          int len = user.length();
          if ((len == 5) && (containsOnly(user) == true)) {
            badInput = false;
          } else {
            System.out.println("Invalid input. Please only respond a five character combination of Y/N/P");
            user = in.nextLine();
          }
        }
        try {
        for (int h = 0; h < 5; h++) {
          if (user.substring(h, h + 1).toUpperCase().equals("Y")) {
            restrictions[h] = word.substring(h, h + 1).toCharArray()[0];
            letters[nextLetter++] = (word.substring(h, h + 1).toCharArray()[0]);
            yCount++;
          } 
          else if (user.substring(h, h + 1).toUpperCase().equals("P")) {
            antiRestrictions[h] = word.substring(h, h + 1).toCharArray()[0];
            letters[nextLetter++] = (word.substring(h, h + 1).toCharArray()[0]);
          }
          if (yCount == 5) {
            break outer;
          } 
        }
      }
      catch (Exception e)  {
        System.out.println("That's longer than five letters :(");
        break;
      }
   }
      // call second WordList constructor and save the constructed list
      WordList guessList = new WordList(letters, restrictions, antiRestrictions);
      String xStr = String.valueOf(letters);
      xStr = xStr.trim();
      if (xStr.length() < 5) {
        xLetters = Arrays.copyOf(letters, 5);
        xLetters[xStr.length()] = 'x';
      }
      WordList xList = new WordList(xLetters, restrictions, antiRestrictions);
      HashSet<String> finalGuesses = guessList.getList();
      HashSet<String> xFinalGuesses = xList.getList();
      finalGuesses.addAll(xFinalGuesses);
      HashSet<String> revisedGuesses = checkingFinalWords(finalGuesses, letters);
      if (revisedGuesses.isEmpty() == true) {
        System.out.println("Your word is impossible! Play again?");
        String response = in.nextLine();
        if (yesOrNo(response)) {
          again = true;
        }
      } 
      else {
        String finalGuess = ranking(revisedGuesses);
        System.out.println("Is your word: " + finalGuess);
        String user = in.nextLine();
        if (user.equals("YYYYY"))
          System.out.println("Yay! I guessed your word! Play again?");
        else if (yesOrNo(user) == true) {
          System.out.println("Yay! I guessed your word! Play again?");
        } 
        else {
          System.out.println("Congratulations! I couldn't guess your word. Would you like to see all my guesses?");
        user = in.nextLine();
          if (yesOrNo(user)) {
            System.out.println(revisedGuesses);
          }
          System.out.println("Play again?");
        }
        user = in.nextLine();
        if (yesOrNo(user)) {
          again = true;
        }
      }
    }
  }
}