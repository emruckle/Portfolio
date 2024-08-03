/**
 *  Class to read in a dictionary ordered by word popularity
 *
 *  @author Emma Ruckle, Molly Neu, Heather Robertson
 *  @version 1.0
 *  References:
 *  - N/A
 *
 */

import java.util.*;
import java.io.*;

public class Ranking {
  ArrayList<String> rankedList = new ArrayList<String>();

/** Ranking constructor 
*
* @author Emma Ruckle, Molly Neu, Heather Robertson
* @version 1.0
* @since   <12/10/22>
*/
  public Ranking()
  {
    try 
    {
      Scanner input = new Scanner(new File("RankingsWordleDict.txt"));
      while (input.hasNextLine()) 
      {
        String word = input.nextLine().toLowerCase();
        int len = word.length();
        if (len == 5) {
          rankedList.add(word);
        }
      }
    } 
    catch (FileNotFoundException e) 
    {
    }
  }
  public ArrayList<String> getRanking() {
    return this.rankedList;
  }
}