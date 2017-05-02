
/**
 * Created by ethan on 5/1/17.
 */
public class NodeVisual extends Actor{
    SimulationNode node;
    
  
    public NodeVisual(Position pos, SimulationNode node){
        super();
        super.mheight = 60;
        super.mwidth = 60;
        super.position = pos;
        this.node = node;
    }
    @Override 
    public boolean isMouseColliding(int mouseX, int mouseY){
        if(mouseX > super.position.getX() - (super.mwidth/2.0)&& mouseY > super.position.getY() - (super.mheight/2.0)){
            if(mouseX < (super.position.getX() + super.mwidth) && mouseY < super.position.getY() + super.mheight){
                return true;
            }
        }
        return false;
    }
    
    @Override
    public void draw() {
        color(0xFF29B6F6);
        fill(0xFF3F51B5);
        ellipse(super.position.getX(), super.position.getY(), super.mheight, super.mwidth);
        
        
        textSize(32);
        fill(0xFFFAFAFA);
        text(node.id + "", super.position.getX() - 10 , super.position.getY() + 10);
        
    }
}