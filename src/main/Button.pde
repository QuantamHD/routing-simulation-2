public class Button extends Actor{
  
  Action action;
  String text;
  
  public Button(Position pos, String text){
        super();
        super.mheight = 60;
        super.mwidth = 250;
        super.position = new Position(pos.getX() - super.mwidth, pos.getY() - super.mheight);
        this.text = text;
  }
  
  
  public void setAction(Action action){
    this.action = action;
  }
  
  @Override
  public void clicked(){    
     if(action != null){
       action.run(); 
     }
  }
  
  
  @Override
  public void draw(){
    
    
    fill(0xFF2196F3);
    rect(super.position.getX(), super.position.getY(), super.mwidth, super.mheight);
    textSize(32);
    fill(0xFFFAFAFA);
    
    text(text, 
      (super.position.getX()) + (super.mwidth - textWidth(text))/2.0, 
      super.position.getY() + 40
      );
  } 
}