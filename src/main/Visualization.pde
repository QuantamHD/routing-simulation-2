
import java.util.ArrayList;

/**
 * Created by ethan on 5/1/17.
 */
public class Visualization {
    private ArrayList<Actor> actors;
    private ArrayList<Button> buttons;
    private Simulation simulation;
    private float radius;
    
    private ArrayList<ID> routingPath = null;


    public Visualization() {
        this.actors = new ArrayList<Actor>();
        this.simulation = new Simulation();
        this.radius = height * 0.9;
        
        Button addButton = new Button(new Position(width, height), "Add Node");
        Button remButton = new Button(new Position(width, height - 80), "Rem Node");
        Button stabilizeButton = new Button(new Position(width, height - 160), "Stabilize");
        final Button routeButton = new Button(new Position(width, height - 240), "Route");
        
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
        
        routeButton.setAction(new Action(){
          public void run(){
            
            if(routingPath != null){
              routingPath = null;
              routeButton.text = "Route";
              return;
            }
            
            
            LookUpBoxingClass lookup = simulation.generateLookUp();
            if(lookup == null){
               return;
            }
            
            routeButton.text = "Hide Route";
            routingPath = lookup.node.findPath(lookup.id);
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
      drawRoutingPath();
      for(Actor actor: actors){
        actor.hover();
      }
    }
    
    private void drawRoutingPath(){
      if(routingPath == null)
        return;
        
      System.out.println(routingPath.size());

      for(int i = 0; i < routingPath.size() - 1; i++){
         stroke(0xFFF4511E);
         strokeWeight(3);
         Position id1 = getPercentagePosition(routingPath.get(i));
         Position id2 = getPercentagePosition(routingPath.get(i + 1));
         
         line(id1.getX(), id1.getY(), id2.getX(), id2.getY());
         stroke(0);
         strokeWeight(1);
      }
    }
    
    private Position getPercentagePosition(ID id){
      double percentage = id.getPercentage();
      double twoPi = Math.PI * 2;

      Position pos = new Position(
            (float)(Math.cos(twoPi * percentage)*(radius/2.0) + width/2.0),
            (float)(Math.sin(twoPi * percentage)*(radius/2.0) + height/2.0)
      );
      
      return pos;
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