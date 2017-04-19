import java.util.ArrayList;

public class Node{
   final byte[] ip;
   final ID identifier;
   Node pred;
   Node[] fingers;
   Boolean online;
   
   Node(byte[] ip){
      this.ip = ip;
      pred = null;
      identifier = new ID(ip);
      fingers = new Node[160];
      online = false;
   }
     
   // Evan
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
   
   public void initFingerTable(Node nPrime){
      
   }
   
   public Node findSucessor(ID iden){
      if(this == this.fingers[0]) // if there's only one node
         return this;
      else
         return findPredecesor(iden).fingers[0];
   }
   
   public Node findPredecesor(ID iden){
      Node nPrime = this;
      
      // id not in (nPrime.id, nPrime.sucessor.id]
      while( !(iden.compareTo(nPrime.identifier) > 0 
            && iden.compareTo(nPrime.fingers[0].identifier) <= 0) ){
         nPrime = nPrime.findClosestPrecedingFinger(iden);
      }
      return nPrime;
   }
   
   public Node findClosestPrecedingFinger(ID iden){
      for(int i = fingers.length - 1; i >= 0; i++){
         // fingers[i].id in (this.id, iden)
         if(  this.fingers[i].identifier.compareTo(this.identifier) > 0
              && this.fingers[i].identifier.compareTo(iden) < 0)
            return this.fingers[i];

      }
      return this;
   }
   
   // Ethan
   public void updateOthers(){
   
   }
   
   public void updateFingerTable(Node s, int i){
   
   }
   
   
   // Harvey
   
   public void stabilize(){
   
   }
   
   public void notify(Node nPrime){
   
   }
   
   public void fixFingers(){
   
   }
   
   
}