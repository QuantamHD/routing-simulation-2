/*
 * https://pdos.csail.mit.edu/papers/chord:sigcomm01/chord_sigcomm.pdf
 */
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
      fingers[0] = nPrime.findSucessor(this.identifier);
      pred = fingers[0].pred;
      fingers[0].pred = this;
      for(int i = 0; i < fingers.length - 1; i++){
         // if the next finger is between this and the previous finger
         // then we just set it to the last finger. Will leave this optimization
         // commented for now
         /* if(pred.fingers[i + 1].identifier.compareTo(this.identifier) >= 0 &&
            pred.fingers[i + 1].identifier.compareTo(fingers[i].identifier) < 0)
            fingers[i + 1] = fingers[i];
            else*/
            fingers[i + 1] = 
               nPrime.findPredecesor(pred.fingers[i + 1].identifier);
         }
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
	   if (online == true){
		   Node p = this.fingers[0].pred;
		   if (p.online && p.pred == this){
			   this.fingers[0] = p;
		   }
		   this.fingers[0].notify(this);
	   }
   }
   
   public void notify(Node nPrime){
	   if (online == true){
		   
	   }
   }
   
   public void fixFingers(){
   
   }
   
   
}