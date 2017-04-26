import java.util.HashMap;

public class Simulation{
   HashMap<Integer, Node> actives;
   HashMap<Integer, Node> deactives;
   
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
   
   }
}