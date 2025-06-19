boolean first = true;
int prevX, prevY;
int lineCount = 0;
PFont f;

void setup() {
  size(400, 400);
  strokeWeight(3);
  background(204);
  
  f = createFont("Arial", 16, true);
}

void draw() {

  if (mousePressed) {
    
    if (first) {
      line(mouseX, mouseY, mouseX, mouseY);
      first = false;
    }
    else {
      line(mouseX, mouseY, prevX, prevY);
    }
    
    prevX = mouseX;
    prevY = mouseY;
    
    lineCount++;
    
    textFont(f, 16);
    fill(0);
    text(lineCount, 10, 100);
  }
}
