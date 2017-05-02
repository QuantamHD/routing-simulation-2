
/**
 * Created by ethan on 5/1/17.
 */
public class SimulationNode {
    Node node;
    int id;

    public SimulationNode(Node node, int id) {
        this.node = node;
        this.id = id;
    }
    
    public boolean equals(Object oObject){
      if(oObject instanceof SimulationNode){
        SimulationNode other = (SimulationNode) oObject;
        return node.identifier.compareTo(other.node.identifier) == 0;
      }
      
      return false;
    }
}