Line[] lines = new Line[0];
int group_number = 0;

void setup() {
    size(500, 500);
    background(255);
    stroke(0);
}


void draw() {
    //background(255);
    //for (int i=0; i<lines.length; i++) {
    //    line(lines[i].initial_position.x, lines[i].initial_position.y, lines[i].target_position.x, lines[i].target_position.y);
    //}

}


void mousePressed() {
    for (int i=0; i<3; i++) {
        Line newline = new Line(mouseX, mouseY, group_number);
        
        lines = (Line[])append(lines, newline);
        line(newline.initial_position.x, newline.initial_position.y, newline.target_position.x, newline.target_position.y);
    }
    group_number += 1;
}

class Line {
    PVector initial_position;
    PVector target_position;
    int group; // So that on mouse press the lines created at mouseX, mouseY dont intersect with each other
    
    Line(float x, float y, int group_number) {
        initial_position = new PVector(x , y);
        target_position = random_target();
        group = group_number;
        
        check_intersection();
    }
        
    PVector random_target() {
        float x = 0;
        float y = 0;
        switch(int(random(4))) {
            case 0: // top
                x = random(width);
                y = 0;
                break;
            case 1: // right
                x = width;
                y = random(height);
                break;
            case 2: // bottom
                x = random(width);
                y = height;
                break;
            case 3: // left
                x = 0;
                y = random(height);
                break;
        }
        return new PVector(x, y);
    }
    
    
    void check_intersection() {
        for (Line line : lines) {
            PVector intersection = find_intersection(line);
            if (intersection != null && line.group != this.group) target_position = intersection;
        }
    }
    
    PVector find_intersection(Line otherLine) {
        float denominator = (otherLine.target_position.y - otherLine.initial_position.y) * (target_position.x - initial_position.x) - (otherLine.target_position.x - otherLine.initial_position.x) * (target_position.y - initial_position.y);
        if (denominator == 0) return null; // Lines are parallel
      
        float ua = ((otherLine.target_position.x - otherLine.initial_position.x) * (initial_position.y - otherLine.initial_position.y) - (otherLine.target_position.y - otherLine.initial_position.y) * (initial_position.x - otherLine.initial_position.x)) /denominator;
        float ub = ((target_position.x - initial_position.x) * (initial_position.y - otherLine.initial_position.y) - (target_position.y - initial_position.y) * (initial_position.x - otherLine.initial_position.x)) / denominator;
      
        if (ua >= 0 && ua <= 1 && ub >= 0 && ub <= 1) {
            // Intersection point lies within the line segments
            float x = initial_position.x + ua * (target_position.x - initial_position.x);
            float y = initial_position.y + ua * (target_position.y - initial_position.y);
            return new PVector(x, y);
        } else {
            return null; // No intersection
        }
    }
}
