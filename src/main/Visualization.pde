
import java.util.ArrayList;

/**
 * Created by ethan on 5/1/17.
 */
public class Visualization {
    private ArrayList<Actor> actors;
    private Simulation simulation;
    private float radius;

    public Visualization() {
        this.actors = new ArrayList<Actor>();
        this.simulation = new Simulation();
        this.radius = height * 0.9;
    }

    public void render(){
      drawChordRing();
      drawActors();
      System.out.println(actors.size());
    }
    
    private void drawChordRing(){
      color(0);
      fill(0xFFFFFF, 0);
      ellipse(width/2.0, height/2.0, radius, radius);
    }
    
    private void drawActors(){
      for(Actor actor: actors){
        actor.draw();
      }
    }

    public void addNode(){
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