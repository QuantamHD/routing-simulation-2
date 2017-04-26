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
   
   public void stabilize(){
      for(int i = 0; i < actives.size(); i++){
    	  actives.get(i).stabilize();
    	  actives.get(i).fixFingers();
      }
   }
   
   public void addNode(boolean newNode){
      
   }
   
   public void removeNode(){
<<<<<<< HEAD
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
=======
	   
>>>>>>> origin/master
   }
}