
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Random;
import javax.swing.JOptionPane;
import java.util.Scanner;
import java.util.Set;
import java.util.Arrays;
import java.util.Map;

public class Simulation {

    HashMap<Integer, Node> actives;
    ArrayList<Node> deactives;

    JOptionPane removeNotify;
    int nodeIDs = 0;
    /*
    public static void main(String[] args) {
        Simulation s = new Simulation();
        Scanner in = new Scanner(System.in);
        String str;
        do {
            // output
            System.out.println("\nWhat would you like to do?");
            System.out.println("'o':  options");
            str = in.nextLine();

            // options
            if (str.equals("o")){
               System.out.println("'a':  Add a Node");
               System.out.println("'a1': Add a previously removed Node");
               System.out.println("'r':  Remove a Node");
               System.out.println("'d':  Go to display options");
               System.out.println("'s':  Stabilize and fix fingers");
               System.out.println("'q':  Quit");
               
            // add
            } else if (str.equals("a")) {
                s.addNode(true);
                System.out.println("Node added");

                // add old
            } else if (str.equals("a1")) {
                s.addNode(false);
                System.out.println("Node added");

                // remove
            } else if (str.equals("r")) {
                if (s.actives.size() < 1) {
                    System.out.println("No nodes active");
                } else {
                    Set<Integer> keys = s.actives.keySet();
                    System.out.println("Possible Options for removal: " +
                            Arrays.toString(keys.toArray()));

                    s.removeNode();
                }
                
            
            // Stabilize
            } else if (str.equals("s")){
               s.stabilize();
               
               
            // enter display options
            } else if (str.equals("d")) {
                displayMode(s, in);
            }
        } while (!str.equals("q"));
    }
    */

    // For error checking a simulation
    public void displayMode(Simulation s, Scanner in) {
        String str;
        do {
            System.out.println("\nDisplay menu");
            System.out.println("'o':  options");
            str = in.nextLine();

            // options
            if (str.equals("o")){
               System.out.println("'d':  Nodes and thier numbers");
               System.out.println("'df': Display Nodes, thier numbers and thier fingers");
               System.out.println("'f':  Get the fingers for a particular node");
               System.out.println("'r':  Get the deactivated nodes and thier numbers");
               System.out.println("'L':  Leave display options");
               
            // Display
            } else if (str.equals("d")) {
                for (Map.Entry<Integer, Node> entry : s.actives.entrySet()) {
                    System.out.println("Key = " + entry.getKey() + ", Node = " + entry.getValue());
                }

                // Display with fingers
            } else if (str.equals("df")) {
                Node current;
                for (Map.Entry<Integer, Node> entry : s.actives.entrySet()) {
                    current = entry.getValue();

                    System.out.println("\nKey = " + entry.getKey() + ", Node = " + entry.getValue());
                    System.out.println("\tPred = " + entry.getValue().pred);
                    System.out.println("\tFingers are:");
                    System.out.print("\t\tIndex : 0, is node : ");
                    if (current.fingers[0] == current) 
                        System.out.println("Itself");
                    else
                     System.out.println(current.fingers[0]);
                    
                    for (int i = 1; i < current.fingers.length; i++) {
                        if(current.fingers[i - 1] != current.fingers[i]){
                           System.out.print("\t\tIndex : " + i + ", is node : ");
                           if (current.fingers[i] == current) 
                              System.out.println("Itself");
                           else
                              System.out.println(current.fingers[i]);
                        }
                    }
                }

                // Display a finger table for a node
            } else if (str.equals("f")) {
                System.out.println("Enter a key");
                try {
                    int key = Integer.parseInt(in.nextLine());
                    Node current = s.actives.get(key);
                    System.out.println("Key = " + key + ", Node = " + current);
                    System.out.println("\tPred = " + current.pred);
                    System.out.println("\tFingers are:");
                    for (int i = 0; i < current.fingers.length; i++) {
                        System.out.print("\t\tIndex : " + i + ", is node : ");
                        System.out.println(current.fingers[i]);
                    }
                } catch (NumberFormatException e) {
                    System.out.println("That is not an Integer");
                }


                // Display deactivated nodes
            } else if (str.equals("r")) {
                for (Node node : s.deactives) {
                    System.out.println("Node = " + node);
                }
            }
        } while (!str.equals("L"));
    }


    Simulation() {
        actives = new HashMap<Integer, Node>();
        deactives = new ArrayList<Node>();
    }

    /**
     * calls stabilize and fixFingers on each active node in the network
     */
    public void stabilize() {
        for (Map.Entry<Integer, Node> entry : this.actives.entrySet()) {
            //System.out.println("Fixing Node: " + entry.getValue());
            entry.getValue().stabilize();
            entry.getValue().fixFingers();
        }
    }

    /**
     * This function will add a new node to our simulation set. When the boolean variable newNode is set it will attempt
     * to pull it from the deactive set of nodes. If that cannot be for whatever reason the function will add a new
     * node instead.
     *
     * @param newNode - Whether or not the node should be selected from the deactive set.
     */
    public SimulationNode addNode(boolean newNode) {
        if (!newNode) {
            if (deactives.size() > 0) {
                Node oldNode = deactives.remove(0);

                if (actives.size() > 0) {
                    Integer integer = actives.keySet().iterator().next();
                    oldNode.join(actives.get(integer));
                } else {
                    oldNode.join(null);
                }
                actives.put(nodeIDs++, oldNode);
                return new SimulationNode(oldNode, nodeIDs - 1);
            }
        }

        Random rand = new Random(System.currentTimeMillis());
        byte[] ip = new byte[5];
        rand.nextBytes(ip);
        Node node = new Node(ip);

        if (actives.size() > 0) {
            Integer integer = actives.keySet().iterator().next();
            node.join(actives.get(integer));
        } else {
            node.join(null);
        }



        actives.put(nodeIDs++, node);

        return new SimulationNode(node, nodeIDs - 1);
    }
    
    /**
     * Returns a LookUpBoxingClass, or null if method didn't successed
     */
    public LookUpBoxingClass generateLookUp(){
        String input = JOptionPane.showInputDialog("What Node Should LookUp Start From?");
        LookUpBoxingClass theNode = null;
        try {
            int index = Integer.parseInt(input);
            if (actives.get(index) == null) 
                JOptionPane.showMessageDialog(null, "Node " + index + " is not on Chord",
                        "Alert", JOptionPane.ERROR_MESSAGE);
            else{
                theNode = new LookUpBoxingClass();
                theNode.node = actives.get(index);
                Random rand = new Random(System.currentTimeMillis());
                byte[] ip = new byte[5];
                rand.nextBytes(ip);
                theNode.id = new ID(ip);
                JOptionPane.showMessageDialog(null, "Node " + index + " at " + 
                      theNode.node.identifier.getPercentage() + "\nWill look up node preceding location " 
                      + theNode.id.getPercentage());
            }
        } catch (NumberFormatException e) {
            JOptionPane.showMessageDialog(null, "That is not an integer",
                    "Alert", JOptionPane.ERROR_MESSAGE);
        }
        
        return theNode;
    }
    
    /**
     * removes a node from the "network"
     */
    public SimulationNode removeNode() {
        String input = JOptionPane.showInputDialog("What Node Should Be Removed?");
        try {
            int index = Integer.parseInt(input);
            if (actives.get(index) == null) {
                JOptionPane.showMessageDialog(null, "Node " + index + " is not on Chord",
                        "Alert", JOptionPane.ERROR_MESSAGE);
                return null;
            }
            else {
                actives.get(index).leave();
                deactives.add(actives.remove(index));
                return new SimulationNode(actives.get(index), index);
            }
        } catch (NumberFormatException e) {
            JOptionPane.showMessageDialog(null, "That is not an integer",
                    "Alert", JOptionPane.ERROR_MESSAGE);
        }

        return null;
    }
}