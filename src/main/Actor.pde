
import java.util.ArrayList;

/**
 * Created by ethan on 5/1/17.
 */
public abstract class Actor {
    private Position position;
    private float mheight, mwidth;

    public boolean isMouseColliding(int mouseX, int mouseY){
        if(mouseX > position.getX() && mouseY > position.getY()){
            if(mouseX < (position.getX() + mwidth) && mouseY < position.getY() + mheight){
                return true;
            }
        }
        return false;
    }
   
    
    public void clicked(){
    }
    
    
    public void hover(){
    }
   
    
    public abstract void draw();
}