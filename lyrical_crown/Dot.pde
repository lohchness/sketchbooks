final float MIN_VELOCITY = 0.6, MAX_VELOCITY = 2;
final float MAX_DIAMETER = 4;

// type 1 dot
final float T1_START_HEIGHT_SPAWN = HEIGHT * 1/3;
final float T1_END_HEIGHT_SPAWN = HEIGHT * 2/3;
final float T1_START_X_SPAWN = -50;
final float T1_Y_VECTOR = .1;

class Dot {
    PVector position = new PVector();
    PVector vector = new PVector();
    float base_diameter, curr_diameter;
    
    Dot() {
        position.x = T1_START_X_SPAWN;
        position.y = random(T1_START_HEIGHT_SPAWN, T1_END_HEIGHT_SPAWN);
        
        base_diameter = random(MAX_DIAMETER + 1);
        curr_diameter = base_diameter;
        
        vector.x = max( MAX_VELOCITY - map(base_diameter, 0, MAX_DIAMETER + 1, 0, MAX_VELOCITY) , MIN_VELOCITY);
        vector.y = random(-T1_Y_VECTOR, T1_Y_VECTOR);
        while (vector.y > vector.x) {
            vector.y /= 1.5;
            vector.x *= 1.5;
        }
    }
}
