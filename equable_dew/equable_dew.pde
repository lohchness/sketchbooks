
//Square square;

ArrayList<Square> squares;

int width = 500;
int height = 500;

void setup() {
    background(100);
    size(500, 500);
    rectMode(CENTER);
    noStroke();
    
    squares = new ArrayList();
    
    for (int i = 0; i < width / 50; i++) {
        for (int j = 0; j < width / 50; j++) {
            Square square = new Square(
                25 + (50 * j),
                25 + (50 * i)
            );
            squares.add(square);
        }
    }
}

void draw() {
    background(100);
    
    for (Square square : squares) {
        rect(square.x, square.y, square.curr_size, square.curr_size);
        square.resize();
    }
    
}
