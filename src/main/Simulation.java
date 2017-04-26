package main;

import java.util.HashMap;
import javax.swing.JOptionPane;

public class Simulation{
   HashMap<Integer, Node> actives;
   HashMap<Integer, Node> deactives;
   JOptionPane removeNotify;
   
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