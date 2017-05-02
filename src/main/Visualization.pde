
import java.util.ArrayList;

/**
 * Created by ethan on 5/1/17.
 */
public class Visualization {
    private ArrayList<Actor> actors;
    private ArrayList<Button> buttons;
    private Simulation simulation;
    private float radius;


    public Visualization() {
        this.actors = new ArrayList<Actor>();
        this.simulation = new Simulation();
        this.radius = height * 0.9;
        
        Button addButton = new Button(new Position(width, height), "Add Node");
        Button remButton = new Button(new Position(width, height - 80), "Rem Node");
        Button stabilizeButton = new Button(new Position(width, height - 160), "Stabilize");
        Button routeButton = new Button(new Position(width, height - 240), "Route");
        
        this.actors.add(addButton);
        this.actors.add(remButton);
        this.actors.add(stabilizeButton);
        this.actors.add(routeButton);
        
        
        addButton.setAction(new Action(){
          public void run(){
            addNode(); 
          }
        });
        
        remButton.setAction(new Action(){
          public void run(){
             simulation.removeNode();
          }
        });
        
        stabilizeButton.setAction(new Action(){
          public void run(){
            simulation.stabilize(); 
          }
        });
        
        
    }

    public void render(){
      drawChordRing();
      drawActors();
    }
    
    public void clicked(){
      for(int i = 0; i < actors.size(); i++){
        if(actors.get(i).isMouseColliding(mouseX,mouseY)){
          actors.get(i).clicked(); 
        }
      }
    }
    
    private void drawChordRing(){
      color(0);
      fill(0xFFFFFF, 0);
      ellipse(width/2.0, height/2.0, radius, radius);
    }
    
    private void drawActors(){
      for(Actor actor: actors){
        if(actor instanceof NodeVisual){
           NodeVisual vis = (NodeVisual) actor;
           if(vis.node.node.online){
             vis.draw(); 
           }
        } else {
          actor.draw();
        }
      }
      
      for(Actor actor: actors){
        actor.hover();
      }
    }
    
    

    private void addNode(){
        SimulationNode simulationNode = simulation.addNode(true);
        double twoPi = Math.PI * 2;
        Position pos = new Position(
            (float)(Math.cos(twoPi * simulationNode.node.identifier.getPercentage())*(radius/2.0) + width/2.0),
            (float)(Math.sin(twoPi * simulationNode.node.identifier.getPercentage())*(radius/2.0) + height/2.0)
        );
        
        NodeVisual nodeVisual = new NodeVisual(pos, simulationNode);
        actors.add(nodeVisual);
    }
}