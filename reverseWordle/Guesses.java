/**
 *  Class to find a 5-clique within a graph
 *
 *  @author Emma Ruckle, Molly Neu, Heather Robertson
 *  @version 1.0
 *  References:
 *  - N/A
 *
 */

import java.util.*;
import com.google.common.graph.*;
import java.io.*;

public class Guesses
{
  //class to create/handle a list of 5 guess words
  private ArrayList<String> guesses;

  /** Guesses constructor that reads in saved guesses in order to save time */
  public Guesses()
  {
    guesses = new ArrayList<String>();
    try 
    {
      Scanner input = new Scanner(new File("Guesses.txt"));
      while (input.hasNextLine()) 
        guesses.add(input.nextLine());
    }
    catch (Exception e)
    {
      
    }
  }

  /** getGuesses accessor to @return list of 5 guess words*/
  public ArrayList<String> getGuesses()
  {
    return this.guesses;
  }

  /** findCliques method
  * given a graph and its cliques of size count represented as an ArrayList,
  * return a list of cliques of size count + 1
  * functions recursively up to size 5
  * if two cliques of size n share n-1 points and there
  * exists a line in the graph between the unshared
  * points, the two cliques combine to form a clique
  * of size n+1
  * @param graph
  * @param ArrayList of k-cliques in graph
  * @param int k
  * @return ArrayList of 5-cliques
  */
  public static ArrayList<ArrayList<String>> findCliques(int count, ArrayList<ArrayList<String>> cliques, MutableGraph<String> graph)
  {
    ArrayList<ArrayList<String>> newCliques = new ArrayList<ArrayList<String>>(); 
    ArrayList<MutableGraph<String>> dupeChecker = new ArrayList<MutableGraph<String>>();
    if (count >= 5)
      return cliques;
    else
    {
      for (ArrayList<String> x : cliques)
      {
        for (ArrayList<String> y : cliques)
        {
          ArrayList<String> shared = new ArrayList<String>();
          MutableGraph<String> g = GraphBuilder.undirected().build();
          for (String a : x)
          {
            for (String b : y)
            {
              if (a.equals(b))
              {
                shared.add(a);
                g.addNode(a);
              }
            }
          }
          if (shared.size() == count-1)
          {
            String p1 = "";
            String p2 = "";
            for (String a : x)
            {
              if (!shared.contains(a))
              {
                shared.add(a);
                g.addNode(a);
                p1 = a.toString();
              }
            }
            for (String b : y)
            {
              if (!shared.contains(b))
              {
                g.addNode(b);
                shared.add(b);
                p2 = b.toString();
              }
            }
            if (graph.hasEdgeConnecting(p1,p2))
            {
              if (!dupeChecker.contains(g))
              {
                dupeChecker.add(g);
                newCliques.add(shared); 
              }
            }
          }
        }
      }
    }
    System.out.println(newCliques.size());
    return findCliques(count+1, newCliques, graph);
  }

  /** findClique method
  * Worst-case clique search method. 
  * Not actually used in this program 
  * @param graph
  * @return ArrayList of 5 guess words
  */
  public static ArrayList<String> findClique(MutableGraph<String> graph)
  {
    ArrayList<String> clique = new ArrayList<String>();
    int acount = 0;
    int bcount = 0;
    int ccount = 0;
    for (String a : graph.nodes())
    {
      System.out.println(acount++);
      for (String b : graph.nodes())
      {
        System.out.println("  " + bcount++);
        for (String c : graph.nodes())
        {
          System.out.println("    " + ccount++);
          for (String d : graph.nodes())
          {
            for (String e : graph.nodes())
            {
              if (graph.hasEdgeConnecting(a,b) && graph.hasEdgeConnecting(a,c) && graph.hasEdgeConnecting(a,d) && graph.hasEdgeConnecting(a,e) && graph.hasEdgeConnecting(b,c) && graph.hasEdgeConnecting(b,d) && graph.hasEdgeConnecting(b,e) && graph.hasEdgeConnecting(c,d) && graph.hasEdgeConnecting(c,e) && graph.hasEdgeConnecting(d,e))
              {
                clique.add(a);
                clique.add(b);
                clique.add(c);
                clique.add(d);
                clique.add(e);
                return clique;
              }
            }
          }
        }
        ccount = 0;
      }
      bcount = 0;
    }
    return clique;
  }

  /** cliques method
  * given a graph, loop through each node, sending the
  * induced subraph of each node to findCliques. This 
  * allows the findCliques method to run more quickly
  * by cutting out Nodes we already know are  
  * unconnected before calling the method 
  * @param graph
  */
  public static void cliques(MutableGraph<String> g) throws IOException
  {
    for (String x : g.nodes())
    {
      System.out.println(x);
      ArrayList<String> sub = new ArrayList<String>(g.successors(x));
      sub.add(x);
      MutableGraph<String> graph = Graphs.inducedSubgraph(g,sub);
      ArrayList<ArrayList<String>> cliques = new ArrayList<ArrayList<String>>();
      for (EndpointPair<String> y : graph.edges())
      {
        ArrayList<String> clique = new ArrayList<String>();
        clique.add(y.nodeU());
        clique.add(y.nodeV());
        cliques.add(clique);
      }
     // System.out.println(graph);
      try
      {
        ArrayList<ArrayList<String>> found = findCliques(2,cliques,graph);
        if (found.size() > 0)
        {
          System.out.println(found);
          PrintWriter out = new PrintWriter(new FileWriter("Guesses.txt"));
          for (String guess : found.get(0))
            out.println(guess);
          out.close();
          return;
        }
        
      } 
      catch (FileNotFoundException e) 
      {
        System.out.println("Double-check file name");
      }
    }
  }
  
}