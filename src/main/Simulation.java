package main;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Random;
import javax.swing.JOptionPane;

public class Simulation{

   HashMap<Integer, Node> actives;
   ArrayList<Node> deactives;

   JOptionPane removeNotify;
   int nodeIDs = 0;
   
   Simulation(){
      actives = new HashMap<Integer, Node>();
      deactives = new ArrayList<Node>();
   }
   
   public void stabilize(){
      for(int i = 0; i < actives.size(); i++){
    	  actives.get(i).stabilize();
    	  actives.get(i).fixFingers();
      }
   }

   /**
    * This function will add a new node to our simulation set. When the boolean variable newNode is set it will attempt
    * to pull it from the deactive set of nodes. If that cannot be for whatever reason the function will add a new
    * node instead.
    *
    * @param newNode - Whether or not the node should be selected from the deactive set.
    */
   public void addNode(boolean newNode){
      if(!newNode){
         if(deactives.size() > 0){
            Node oldNode = deactives.remove(0);

            if(actives.size() > 0) {
               Integer integer = actives.keySet().iterator().next();
               oldNode.join(actives.get(integer));
            }else{
               oldNode.join(null);
            }
            actives.put(nodeIDs++, oldNode);
            return;
         }
      }

      Random rand = new Random(System.currentTimeMillis());
      byte[] ip = new byte[5];
      rand.nextBytes(ip);
      Node node = new Node(ip);

      if(actives.size() > 0) {
         Integer integer = actives.keySet().iterator().next();
         node.join(actives.get(integer));
      }else{
         node.join(null);
      }

      actives.put(nodeIDs++, node);
   }

   public void removeNode(){
      String input = JOptionPane.showInputDialog("What Node Should Be Removed?");
      try{
         int index = Integer.parseInt(input);
         if(actives.get(index) == null)
            JOptionPane.showMessageDialog(null, "Node " + index + " is not on Chord", 
                                       "Alert", JOptionPane.ERROR_MESSAGE);
         else{
            actives.get(index).leave();
            deactives.add(actives.remove(index));
         }
      }catch(NumberFormatException e){
         JOptionPane.showMessageDialog(null, "That is not an integer", 
                                       "Alert", JOptionPane.ERROR_MESSAGE);
      }
   }
}