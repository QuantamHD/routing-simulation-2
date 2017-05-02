/*
 * https://pdos.csail.mit.edu/papers/chord:sigcomm01/chord_sigcomm.pdf
 */

import java.math.BigInteger;
import java.util.Arrays;

public class Node {
    final BigInteger base;
    final byte[] ip;
    final ID identifier;
    Node pred;
    Node[] fingers;
    Boolean online;
   
    {
        base = BigInteger.valueOf(2);
    }
   
    Node(byte[] ip) {
        this.ip = ip;
        pred = null;
        identifier = new ID(ip);
        fingers = new Node[160];
        online = false;
    }

    // Evan
    public void join(Node nPrime) {
        pred = null;
        online = true;
        if (nPrime != null) {
            initFingerTable(nPrime);
            updateOthers();
        } else {
            pred = this;
            for (int i = 0; i < fingers.length; i++)
                fingers[i] = this;
        }
    }

    public void leave() {
        online = false;
    }

    public void initFingerTable(Node nPrime) {
        fingers[0] = nPrime.findSuccessor(this.identifier);
        pred = fingers[0].pred;
        fingers[0].pred = this;
        if(fingers[0].fingers[0] == fingers[0])
            fingers[0].fingers[0] = this;
        //System.out.println("Init table");
        for (int i = 1; i < fingers.length; i++) {
            fingers[i] = nPrime.findSuccessor(this.identifier.createNew(base.pow(i), true));
            //System.out.println(", found successor: = " + fingers[i]);   
        }
    }
    /**
     * returns an array list containing the path to the given key space
     * @param ID iden
     * @return ArrayList<ID>
     */
    public ArrayList<ID> findPath(ID iden){
        ArrayList<ID> path = new ArrayList<ID>();
        ID next = iden;
        Node nPrime;
        path.add(this.identifier);
        do{
            nPrime = findPredecessor(next, path);
            next = nPrime.fingers[0].identifier.createNew(BigInteger.valueOf(1), true);
        }while(!nPrime.fingers[0].online);
        return path;
    }
    /**
     * this functions acts the exact same way as the other findPredecessor, but it keeps track of an
     * ArrayList containing the current node lookup path.
     * @param ID iden
     * @param ArrayList<ID> path
     * @return Node nPrime
     */
    public Node findPredecessor(ID iden, ArrayList<ID> path){
        Node nPrime = this;
        Node oldPrime = this;
        
        while(!iden.inRange(nPrime.identifier, nPrime.fingers[0].identifier, false, true)){
            nPrime = nPrime.findClosestPrecedingFinger(iden, path); 
            if(nPrime == oldPrime)
              break;
              
            path.add(nPrime.identifier);
            oldPrime = nPrime;
        }
        return nPrime;
    }
    /**
     * this funcitons acts the exact same way as the other findClosestPrecedingFinger, except it 
     * adds a new entry into the arrayList path when a new node is found
     * @param ID iden
     * @param ArrayList<ID> path
     * @return Node nPrime
     */
    public Node findClosestPrecedingFinger(ID iden, ArrayList<ID> path){
        for (int i = fingers.length-1; i >= 0; i--){
            if (fingers[i].identifier.inRange(this.identifier, iden, false, false)){
                if(path.get(path.size()-1) != this.identifier)
                    path.add(fingers[i].identifier);
                return this.fingers[i]; 
            }
        }
        return this;
    }
    
    public Node findSuccessor(ID iden){
        ID next = iden;
        Node nPrime;
        do{
            nPrime = findPredecessor(next);
            next = nPrime.fingers[0].identifier.createNew(BigInteger.valueOf(1), true);
        }while(!nPrime.fingers[0].online);
        //System.out.println("Found sucsessor for: " + iden + ", which is: " + nPrime.fingers[0].identifier + ", Using predecessor " + nPrime.identifier);  
        return nPrime.fingers[0];
    }

    public Node findPredecessor(ID iden) {
        Node nPrime = this;
        Node oldPrime = this;
        
        // id not in (nPrime.id, nPrime.sucessor.id]
        while (!iden.inRange(nPrime.identifier, nPrime.fingers[0].identifier, false, true)) {
            nPrime = nPrime.findClosestPrecedingFinger(iden);
            if(nPrime == oldPrime)
               break;
            oldPrime = nPrime;
        }
        return nPrime;
    }

    public Node findClosestPrecedingFinger(ID iden) {
        for (int i = fingers.length - 1; i >= 0; i--) {
            // System.out.print("Closestpredfing not (id, iden) ");
            // fingers[i].id in (this.id, iden)
            if (fingers[i].identifier.inRange(this.identifier, iden, false, false))
                return this.fingers[i];
        }
        return this;
    }

    public void updateOthers() {
        //System.out.println("Update others");
        for (int i = 1; i < fingers.length; i++) {
            // p = predecessor(this.ID - 2^i)
            Node p = findPredecessor(this.identifier.createNew(base.pow(i), false));
            //System.out.println(", Found Predecessor: "+ p);
            p.updateFingerTable(this, i);
        }
    }

    public void updateFingerTable(Node s, int i) {
        // s in range [this, finger[i]))
        if (s.identifier.inRange(this.identifier, this.fingers[i].identifier, true, false) ){
            fingers[i] = s;  //findPredecessor(fingers[i].identifier);
            Node p = pred;
            p.updateFingerTable(s, i);
        }
    }


    // Harvey

    public void stabilize() {
        if (online == true) {
            // ch
            Node x = this.fingers[0].pred;
            // x in range (this, fingers[0])
            if(x.online && x.identifier.inRange(this.identifier, fingers[0].identifier, false, false)){
                this.fingers[0] = x;
            }
            this.fingers[0].notify(this);
        }
    }

    public void notify(Node nPrime) {
        if (online)
            // nPrime in range (pred, this)
            if (!pred.online || pred == null ||
                    nPrime.identifier.inRange(pred.identifier, this.identifier, false, false)) {
                pred = nPrime;
            }
    }
    public void fixFingers() {
        for (int i = 0; i < fingers.length; i++) {
            fingers[i] = this.findSuccessor(this.identifier.createNew(base.pow(i), true));
            //System.out.println(", found successor: = " + fingers[i]);   
            /*
    			 * runs until an online node has been found, 
    			 * and there arent two entries of the same node in the finger table.
    			 *
                while (!fingers[i].online) {
                    fingers[i] = fingers[i].findSuccessor(fingers[i].identifier);
                }*/
        }
    }

    @Override
    public String toString() {
        String ip = "";
        for(int i = 0; i < this.ip.length; i++){
          int a = this.ip[i] & 0xFF;
          
          if(i == this.ip.length - 1)
            ip += a;
          else
            ip += a + ".";
          
        }
        
        String percentage = "\nPercentage: " + identifier.getPercentage() + "\n";
        
        
        String fingerTable = "...Finger Table...\n";
        
        Node current = this;
        
        if (current.fingers[0] == current) 
         fingerTable += ("Itself\n");
        else
         fingerTable += ("\t\tIndex : " + 0 + ", is node : ") + (current.fingers[0].identifier.getPercentage()) + "\n";

               
        for (int i = 1; i < current.fingers.length; i++) {
            if(current.fingers[i - 1] != current.fingers[i]){
                fingerTable += ("\t\tIndex : " + i + ", is node : ");
               if (current.fingers[i] == current)
                  fingerTable += ("Itself\n");
               else
                  fingerTable += (current.fingers[i].identifier.getPercentage()) + "\n";
            }
        }
        
        
        return "IP: " + ip 
        + percentage
        + "\n\n" 
        +  fingerTable;
    }
}