Box boxes[] = new Box[5];

void setup() {
    size(500, 500);
    fill(0);
    
    boxes[0] = new Box(160, 96, 175, 415, -1, 0); // going left
    boxes[1] = new Box(160, 400, 351, 415, 0, 1); // going down
    boxes[2] = new Box(336, 256, 351, 415, 1, 0); // going right
    boxes[3] = new Box(160, 96, 351, 111, 0, -1); // going up
    
    boxes[4] = new Box(256, 96, 271, 351, 1, 0);
}

void draw() {
    background(255);
    
    //float time = 500 * sin((frameCount)/ (10 * PI)) + 500;
    float time = 500 * pow(sin(frameCount / (10 * PI )), 5) + 500;
    
    for (int i=0; i < 5; i++) {
        boxes[i].draw_box(time);
    }
}


class Box {
    int start_x;
    int start_y;
    int end_x;
    int end_y;
    
    int move_direction_x;
    int move_direction_y;
    
    Box(int x1, int y1, int x2, int y2, int x3, int y3) {
        start_x = x1;
        start_y = y1;
        end_x = x2;
        end_y = y2;
        
        move_direction_x = x3;
        move_direction_y = y3;
    }
    
    void draw_box(float time) {
        float dx = ((((start_x + (time * move_direction_x)) % width) + width) % width);
        float dy = ((((start_y + (time * move_direction_y)) % width) + width) % width);
        
        pushMatrix();
        translate(dx, dy);
        rect(0, 0, end_x - start_x, end_y - start_y);
        popMatrix();
    }
}
