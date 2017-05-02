
/**
 * Created by ethan on 5/1/17.
 */
static boolean hoverDisplayed = false;
 
public class NodeVisual extends Actor{
    SimulationNode node;
    boolean displayingHoverMenu = false;
    
  
    public NodeVisual(Position pos, SimulationNode node){
        super();
        super.mheight = 60;
        super.mwidth = 60;
        super.position = pos;
        this.node = node;
    }
    @Override 
    public boolean isMouseColliding(int mouseX, int mouseY){
        /*
        if(mouseX > super.position.getX() - (super.mwidth/2.0)&& mouseY > super.position.getY() - (super.mheight/2.0)){
            if(mouseX < (super.position.getX() + super.mwidth) && mouseY < super.position.getY() + super.mheight){
                return true;
            }
        }
        return false; */
        
        return super.mwidth / 2 > Math.sqrt(Math.pow(mouseX-super.position.getX(), 2) + Math.pow(mouseY - super.position.getY(), 2));
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
    
    
    @Override
    public void hover(){
      if(isMouseColliding(mouseX, mouseY) && (!hoverDisplayed || displayingHoverMenu)){
          hoverDisplayed = true; 
          displayingHoverMenu = true;
          
          rect(mouseX,mouseY, 450,400);
          
          fill(0);
          color(0);
          textSize(16);
          text(node.node.toString(), mouseX + 32, mouseY + 32);
          
       }
        
        if(!isMouseColliding(mouseX, mouseY) && displayingHoverMenu){
          hoverDisplayed = false;
          displayingHoverMenu = false;
        }
    }
}