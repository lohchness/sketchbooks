int spacing = 7;
int w = 800;
int h = 600;
float easing = .15;


Dot[] dots;

void setup() {
    size(800, 600);
    background(0);
    stroke(255, 255, 255, 180);
    strokeWeight(2.5);
    noFill();
    
    
    dots = new Dot[0];
    
    for (int i=0; i < w; i += spacing) {
        for (int j=0; j < h; j += spacing) {
            float noiseOffset = noise(i * 0.003, j *0.002) * 500 - 200;
            Dot newdot = new Dot(i + noiseOffset, j + noiseOffset);
            dots = (Dot[]) append(dots, newdot);
        }
    }
    
}

void draw() {
    background(0);
    
        
    for (int i=0; i < dots.length; i++) {
        
        
        Dot dot = dots[i];
        
        pushMatrix();
        translate(dot.position.x, dot.position.y);
        
        dot.update();
        point(dot.targetX, dot.targetY);
        
        popMatrix();
    }
}

class Dot {
    PVector position;
    float noiseX;
    float noiseY;
    float noiseScale = .1;
    float noiseStrength = .3;
    float targetX;
    float targetY;
    
    Dot(float xpos, float ypos) {
        position = new PVector(xpos, ypos);
        noiseX = random(1000);
        noiseY = random(2000);
    }
    
    void update() {
        float noiseValX = noise(noiseX);
        float noiseValY = noise(noiseY);

        targetX = map(noiseValX, 0, 1, -noiseStrength, noiseStrength);
        targetY = map(noiseValY, 0, 1, -noiseStrength, noiseStrength);
        
        noiseX += noiseScale;
        noiseY += noiseScale;
    }
}
