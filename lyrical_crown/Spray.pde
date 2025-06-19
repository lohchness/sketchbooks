class Spray {
    ArrayList<Dot> dots;
    
    Spray() {
        dots = new ArrayList<Dot>();
    }
    
    void addDot(Dot dot) {
        dots.add(dot);
    }
    
    void removeDot(Dot dot) {
        dots.remove(dot);
    }
    
}


void sprayDots() {
    if (frameCount % 5 == 0) {
        spray.addDot(new Dot()); 
    }
    float curr_level = track.mix.level();
    
    fill(255);
    for (Dot dot : spray.dots) {
        
        ellipse(dot.position.x, dot.position.y, dot.curr_diameter, dot.curr_diameter);

        //dot.position.x += dot.vector.x * pow((curr_level + 1.5),2);
        //dot.position.y += dot.vector.y * pow((curr_level + 1.5),2);
        
        //dot.position.x += dot.vector.x * 8/3 * exp(curr_level - 1);
        //dot.position.y += dot.vector.y * 8/3 * exp(curr_level - 1);
        
        //dot.position.x += dot.vector.x * 3 * pow((curr_level + .7),2);
        //dot.position.y += dot.vector.y * 3 * pow((curr_level + .7),2);
        
        dot.position.x += dot.vector.x * 8/3 * exp(4 * curr_level - 2);
        dot.position.y += dot.vector.y * 8/3 * exp(4 * curr_level - 2);
        
        
        
        
        if (dot.curr_diameter > dot.base_diameter) {
            dot.curr_diameter -= 0.05;
        }
        
        //if (beat.isRange(5, 15, 2)) {
        //if (beat.isKick() || beat.isHat() || beat.isSnare()) {
            
        //if (beat.isKick() || beat.isSnare() ) {
        //    dot.position.x += dot.vector.x * 1.5;
        //    dot.position.y += dot.vector.y * 1.5;
        //}
        
        if (beat.isOnset()) {
            dot.curr_diameter = dot.base_diameter * 1.25;           

        }
        
        
    }
    
    
    //clean up
    for (int i = 0; i < spray.dots.size(); i++) {
        Dot dot = spray.dots.get(i);
        if (dot.position.x > WIDTH + dot.curr_diameter || dot.position.y > HEIGHT + dot.curr_diameter) {
            spray.removeDot(dot);
        }
    }
    
}
