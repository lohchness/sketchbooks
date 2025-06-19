
void setup() {
    size(800, 800);
    
    textSize(25);
    fill(0);
}

float target_rad = 0;
float current_rad = 0;

void draw() {
    background(255);
    
    target_rad = sin(frameCount / (3 * PI)) / 10;
    var deg = degrees(target_rad);
    
    // Hairs
    add_letter("s", 344, 128, 45 + deg, 2, 5);
    add_letter("s", 300, 174, 30 + deg, 2, 4);
    add_letter("c", 290, 100, 50 + deg, 2, 4);
    add_letter("s", 315, 217, 20 + deg, 2, 4);
    add_letter("s", 260, 280, 10 + deg, 3, 6);
    add_letter("s", 233, 389, 20 + deg, 2, 6);
    add_letter("s", 300, 310, 15 + deg, 1, 4);
    add_letter("s", 272, 500, 5 + deg, 2, 5);
    add_letter("s", 300, 475, -10 + deg, 2, 7);
    
    add_letter("c", 490, 109, 300 + deg, -3, 6);
    add_letter("j", 450, 150, -10 + deg, 2, -5);
    add_letter("s", 500, 370, -20 + deg, -2, 5);
    
    // Face
    add_letter("j", 400, 320, 290, -2, 4);
    add_letter("_", 460, 260, 110, 6, 1);
    
    add_letter("O", 340, 240, 0, 4, 3);
    add_letter("O", 410, 240, 0, 4, 3);
    
    add_letter("j", 380, 180, 260, 2, 2);
    add_letter("j", 430, 180, 280, 2, -1.5);
    
    add_letter("<", 388, 290, 0, 1, 1);
    add_letter("3", 418, 280, 270, .5, 1);
    add_letter(")", 405, 290, 90, .5, .8);
    
    add_letter("y", 370, 500, -20, 10, 10);
}


void add_letter(String s, int x, int y, float degrees, float scalex, float scaley) {

    fill(0);
    
    pushMatrix();
    translate(x, y);
    rotate(radians(degrees));
    scale(scalex, scaley);
    text(s, 0, 0);
    popMatrix();
}
