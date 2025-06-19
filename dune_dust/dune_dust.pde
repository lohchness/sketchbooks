Dot dot;

void setup() {
    size(500, 500);
    noFill();
    stroke(0);
    
    dot = new Dot();
}

void draw() {
    background(255);
    strokeWeight(2.5);
    stroke(0);
    dot.update();
    
    point(dot.center.x, dot.center.y);
    ellipse(dot.center.x, dot.center.y, dot.radius * 2, dot.radius * 2);
    
    strokeWeight(10);
    stroke(255, 0, 0);
    point(dot.target.x, dot.target.y);
    stroke(0, 0, 255);
    point(dot.position.x, dot.position.y);

}

class Dot {
    PVector center;
    PVector position;
    PVector target;
    
    float easing = .1;
    
    float radius = 100;
    
    Dot() {
        center = new PVector(width / 2, height / 2);
        position = new PVector(width / 2, height / 2); 
        new_target();
    }
    
    void new_target() {
        float r = random(radius);
        float theta = random(TWO_PI);
        
        float newX = center.x + r * cos(theta);
        float newY = center.y + r * sin(theta);
        
        target = new PVector(newX, newY);
    }
    
    void update() {
        PVector v = PVector.sub(target,position);
        position.add(v.mult(easing));
        
        //if (PVector.dist(target,position) < 1) {
        if (frameCount % 50 == 0) {
            new_target();
        }
    }
}
