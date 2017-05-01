
import java.util.ArrayList;

/**
 * Created by ethan on 5/1/17.
 */
public abstract class Actor {
    private Position position;
    private double height, width;

    public boolean isMouseColliding(int mouseX, int mouseY){
        if(mouseX > position.getX() && mouseY > position.getY()){
            if(mouseX < position.getX() + width && mouseY < position.getY() + height){
                return true;
            }
        }
        return false;
    }
    
    public abstract void draw();
}