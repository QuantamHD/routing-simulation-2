package main;

import java.util.HashMap;
import javax.swing.JOptionPane;
import java.util.Scanner;
import java.util.Set;
import java.util.Arrays;

public class Simulation{
   HashMap<Integer, Node> actives;
   HashMap<Integer, Node> deactives;
   JOptionPane removeNotify;
   
   public static void main(String[] args){
      Simulation s = new Simulation();
      Scanner in = new Scanner(System.in);
      String str;
      do{
         // output
         System.out.println("\nWhat would you like to do?");
         System.out.println("'a':  Add a Node");
         System.out.println("'a1': Add a previously removed Node");
         System.out.println("'r':  Remove a Node");
         System.out.println("'d':  Go to display options");
         str = in.nextLine();
         
         // add
         if(str.equals("a")){
            s.addNode(true);
            System.out.println("Node added");
            
         // add old
         }else if(str.equals("a1")){
            s.addNode(false);
            System.out.println("Node added");
            
         // remove
         }else if(str.equals("r")){
            if(s.actives.size() < 1){
               System.out.println("No nodes active");
            }else{
               Set<Integer> keys = s.actives.keySet();
               System.out.println("Possible Options for removal: " +
                     Arrays.toString(keys.toArray()));
               
               s.removeNode();
            }
         
         // enter display options
         }else if(str.equals("d")){
            displayMode(s, in);
         }
      }while(!str.equals("q"));
   }
   
   // For error checking a simulation
   public static void displayMode(Simulation s, Scanner in){
   
   }
   
   
   Simulation(){
      actives = new HashMap<Integer, Node>();
      deactives = new HashMap<Integer, Node>();
   }
   /**
    * calls stabilize and fixFingers on each active node in the network
    */
   public void stabilize(){
      for(int i = 0; i < actives.size(); i++){
    	  actives.get(i).stabilize();
    	  actives.get(i).fixFingers();
      }
   }
   /**
    * adds a new node to the "network"
    * @param newNode specifies if the node will be active or inactive
    */
   public void addNode(boolean newNode){
      
   }
   /**
    * removes a node from the "network"
    */
   public void removeNode(){
      String input = JOptionPane.showInputDialog("What Node Should Be Removed?");
      try{
         int index = Integer.parseInt(input);
         if(actives.get(index) == null)
            JOptionPane.showMessageDialog(null, "Node " + index + " is not on Chord", 
                                       "Alert", JOptionPane.ERROR_MESSAGE);
         else{
            actives.get(index).leave();
            deactives.put(index, actives.remove(index));
         }
      }catch(NumberFormatException e){
         JOptionPane.showMessageDialog(null, "That is not an integer", 
                                       "Alert", JOptionPane.ERROR_MESSAGE);
      }
   }
}