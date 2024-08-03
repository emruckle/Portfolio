/**
 *  Class to read in and filter the Wordle Dictionary
 *
 *  @author Emma Ruckle, Molly Neu, Heather Robertson
 *  @version 1.0
 *  References:
 *  - N/A
 *
 */

import java.util.*;
import java.io.*;

public class WordList
{
  //HashSet to hold all of the necessary dictionary words
  private HashSet<String> dictList = new HashSet<String>();

  /** WordList Constructor
  * Original constructor to construct HashSet for 
  * graph Nodes and clique-finding 
  * Reads in words from dictionary file. Filters them to remove all
  * words with double-letters or multiple vowels, since these cannot
  * be part of a five-clique
  */
  public WordList()
  {
    try 
    {
      Scanner input = new Scanner(new File("WordleDict2.txt"));
      while (input.hasNextLine()) 
      {
        String word = input.nextLine().toLowerCase();
        boolean add = true;
        int vowelCount = 0;
        ArrayList<Character> vowels = new ArrayList<Character>(Arrays.asList('a','e','i','o','u'));
        ArrayList<Character> letters = new ArrayList<Character>();
        for (int x = 0; x < 5; x++)
        {
          if (letters.contains(word.substring(x,x+1).toCharArray()[0]))
            add = false;
          if (vowels.contains(word.substring(x,x+1).toCharArray()[0]))
            vowelCount++;
          letters.add(word.substring(x,x+1).toCharArray()[0]);
        }
        if ((add == true) && (vowelCount <= 1))
          dictList.add(word);
      }
    } 
    catch (FileNotFoundException e) 
    {
    }
    //System.out.println(dictList);
  }

  /** Overloaded WordList constructor
  * Second WordList constructor, filters through
  * Wordle Dictionary according to the location 
  * restrictions given by the user. Constructs a
  * HashSet of words fitting the user's restrictions.
  */
  public WordList(char[] letters, char[] restrictions, char[] antiRestrictions)
  {
    char[] emptyCharArray = new char[1];
    try 
    {
      Scanner input = new Scanner(new File("WordleDict2.txt"));
      while (input.hasNextLine()) 
      {
        String word = input.nextLine().toLowerCase();
        boolean add = true;
        for (int x = 0; x < 5; x++)
        {
          char here = word.substring(x,x+1).toCharArray()[0];
          if (!(here == letters[0] || here == letters[1] || here == letters[2] || here == letters[3] || here == letters[4]))
            add = false;
          if ((here != restrictions[x]) && (restrictions[x] != emptyCharArray[0]))
            add = false;
          if ((here == antiRestrictions[x]))
            add = false;
        }
        if (add == true)
          dictList.add(word);
      }
    } 
    catch (FileNotFoundException e) 
    {
    }
    //System.out.println(dictList);
  }

  /** getList method
  * accessor for WordList
  * @return HashSet dictList
  */
  public HashSet<String> getList()
  {
    return this.dictList;
  }


  // public HashSet<String> selectWords(ArrayList<Character> l, HashSet<String> w, HashSet<String> words)
  // {
  //   if (l.size() >= 20)
  //     System.out.println(w);
  //   else
  //   {
  //     for (String x : w)
  //     {
  //       //System.out.println(x);
  //       ArrayList<Character> letters = l;
  //       boolean add = true;
  //       for (int y = 0; y < 5; y++)
  //       {
  //         if (letters.contains(x.substring(y,y+1).toCharArray()[0]))
  //           add = false;
  //       }
  //       if (add == true)
  //       {
  //         //System.out.println(x);
  //         for (int y = 0; y < 5; y++)
  //           letters.add(x.substring(y,y+1).toCharArray()[0]);
  //         words.add(x);
  //         selectWords(letters,w,words);
  //       }
  //     }
  //   }
  //   return words;
  // }
}