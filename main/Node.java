import java.util.ArrayList;

public class Node{
   final byte[] ip;
   final ID identifier;
   Node pred;
   Node[] fingers;
   Boolean online;
   
   Node(byte[] ip){
      this.ip = ip;
      identifier = new ID(ip);
      fingers = new Node[160];
      online = false;
   }
   
   public void join(Node nPrime){
      online = true;
      if(nPrime != null){
         initFingerTable(nPrime);
         updateOthers();
      }else{
         pred = this;
         for(int i = 0; i < fingers.length; i++)
            fingers[i] = this;
      }
   }
   
   public void leave(){
      online = false;
      
   }
   
   public Node findSucessor(ID iden){
      return null;
   }
   
   public void initFingerTable(Node nPrime){
   
   }
   
   public void updateOthers(){
   
   }
   
   public void updateFingerTable(Node s, int i){
   
   }
   
   public Node findPredecesor(ID iden){
      return null;
   }
   
   public Node findClosestPrecedingFinger(ID iden){
      return null;
   }
   
   public void stabilize(){
   
   }
   
   public void notify(Node nPrime){
   
   }
   
   public void fixFingers(){
   
   }
   
   
}