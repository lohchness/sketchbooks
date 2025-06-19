class Square {
    int base_size = 50;
    float curr_size = base_size;
    int x, y;

    Square(int xp, int yp) {
        x = xp;
        y = yp;
    }

    void resize() {
        float distance =  dist(x, y, mouseX, mouseY);
        float x = (distance - curr_size) * .5;
        curr_size = min(x, base_size);
        
    }
}
