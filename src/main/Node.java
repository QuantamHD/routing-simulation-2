package main;
/*
 * https://pdos.csail.mit.edu/papers/chord:sigcomm01/chord_sigcomm.pdf
 */

import java.math.BigInteger;
import java.util.Arrays;

public class Node {
    final byte[] ip;
    final ID identifier;
    Node pred;
    Node[] fingers;
    Boolean online;

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
        fingers[0] = nPrime.findSucessor(this.identifier);
        pred = fingers[0].pred;
        fingers[0].pred = this;
        if(fingers[0].fingers[0] == fingers[0])
            fingers[0].fingers[0] = this;
        //this.fingers = fingers.clone();
        for (int i = 1; i < fingers.length; i++) {
            // if the next finger is between this and the previous finger
            // then we just set it to the last finger. Will leave this optimization
            // commented for now
        	/*if(fingers[i + 1].identifier.compareTo(this.identifier) >= 0 &&
        			fingers[i + 1].identifier.compareTo(fingers[i].identifier) < 0)
        		fingers[i + 1] = fingers[i];
            else*/
            	fingers[i] =
                    nPrime.findPredecessor(fingers[0].fingers[i].identifier);
            
        }
    }

    public Node findSucessor(ID iden) {
        Node nPrime = findPredecessor(iden);
        return nPrime.fingers[0];
    }

    public Node findPredecessor(ID iden) {
        Node nPrime = this;
        Node oldPrime = this;

        // id not in (nPrime.id, nPrime.sucessor.id]
        while (!iden.inRange(nPrime.identifier, 
               nPrime.fingers[0].identifier, 
               false, true)) {
               
            nPrime = nPrime.findClosestPrecedingFinger(iden);
            if(nPrime == oldPrime)
               break;
            oldPrime = nPrime;
        }
        return nPrime;
    }

    public Node findClosestPrecedingFinger(ID iden) {
        for (int i = fingers.length - 1; i >= 0; i--) {
            // fingers[i].id in (this.id, iden)
            if (!fingers[i].identifier.inRange(this.identifier, iden, false, false))
                return this.fingers[i];

        }
        return this;
    }

    // Ethan
    public void updateOthers() {
        BigInteger base = BigInteger.valueOf(2);
        for (int i = 1; i < fingers.length; i++) {
            // p = predecessor(this.ID - 2^i)
            Node p =
                    findPredecessor(this.identifier.
                            createNew(base.pow(i)));
            p.updateFingerTable(this, i);
        }
    }

    public void updateFingerTable(Node s, int i) {
        // s in range [this, finger[i]))
        if (s.identifier.inRange(this.identifier, this.fingers[i].identifier, true, false) ){
            // A little different from paper
            fingers[i] = findPredecessor(fingers[i].identifier);
            Node p = pred;
            p.updateFingerTable(s, i);
        }
    }


    // Harvey

    public void stabilize() {
        if (online == true) {
            Node x = this.fingers[0].pred;
            // x in range (this, fingers[0])
            if(x.identifier.inRange(this.identifier, fingers[0].identifier, false, false)){
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
        for (int i = 1; i < fingers.length; i++) {
            if (!fingers[i].online) {
                /*
    			 * runs until an online node has been found, 
    			 * and there arent two entries of the same node in the finger table.
    			 */
                while (!fingers[i].online && fingers[i] != fingers[i - 1]) {
                    fingers[i] = fingers[i].findSucessor(fingers[i].identifier);
                }
            }
        }
    }

    @Override
    public String toString() {
        return "Node{" +
                "ip=" + Arrays.toString(ip) +
                ", Location= " + identifier.getPercentage() +
                ", identifier=" + identifier +
                // ", pred=" + pred +
                // ", fingers=" + Arrays.toString(fingers) +
                ", online=" + online +
                '}';
    }
}