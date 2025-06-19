int cols, rows;
int scale = 20;

float[][] terrain;

void setup() {
    size(600, 600, P3D);
    
    int w = 600;
    int h = 600;
    
    cols = w / scale;
    rows = h / scale;
    
}


void draw() {
    background(0);
    noFill();
    stroke(255);
    
    translate(width / 2, height / 2);
    rotateX(PI / 3);
    
    translate(-width / 2, - height / 2);
    for (int y = 0; y < rows; y++) {
        beginShape(TRIANGLE_STRIP);
        for (int x = 0; x < cols; x++) {
            vertex(x * scale, y * scale);
            vertex(x * scale, (y+1) * scale);
        }
        endShape();
    }
    
}
