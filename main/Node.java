import java.util.ArrayList;

public class Node{
   final byte[] ip;
   final ID identifier;
   Node predecessor;
   ArrayList<Node> fingers;
   
   Node(byte[] ip){
      this.ip = ip;
      identifier = new ID(ip);
      fingers = new ArrayList<Node>();
   }
   
   public void join(Node nPrime){
      
   }
   
   public Node findSucessor(ID iden){
      return null;
   }
   
   public Node findPredecesor(ID iden){
      return null;
   }
   
   public Node findClosestPrecedingFinger(ID iden){
      return null;
   }
   
   
   
}