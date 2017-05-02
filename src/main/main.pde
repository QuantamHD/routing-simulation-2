Visualization nodeVisualization;

void setup(){
  size(1920, 1080);
  nodeVisualization = new Visualization();
}
    
void draw(){
    
    background(0xCFD8DC);
    nodeVisualization.render();
}

void mouseReleased(){
  nodeVisualization.clicked(); 
}