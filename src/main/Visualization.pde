
import java.util.ArrayList;

/**
 * Created by ethan on 5/1/17.
 */
public class Visualization {
    private ArrayList<Actor> actors;
    private Simulation simulation;

    public Visualization() {
        this.actors = new ArrayList<Actor>();
        this.simulation = new Simulation();
    }

    public void render(){
        for(Actor actor: actors){
            actor.draw();
        }
    }

    public void addNode(){
        SimulationNode simulationNode = simulation.addNode(true);
    }
}