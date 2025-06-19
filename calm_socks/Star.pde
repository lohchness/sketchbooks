final int MIN_STAR_SIZE = 1, MAX_STAR_SIZE = 5;


class Star {
    private PVector loc;
    private String name;
    private float size;
    
    Star(String name) {
        // generate random number within 0 and WIDTH, HEIGHT for x, y
        // Z axis between 0 and DEPTH
        // size between 0 and 50
        loc = new PVector( random(WIDTH), random(HEIGHT), random(DEPTH));
        this.size = random(MIN_STAR_SIZE, MAX_STAR_SIZE);
        this.name = name;
    }
    
    public String getName() {
        return this.name;
    }
    
    public PVector getLoc() {
        return this.loc;
    }
    
    public float getSize() {
        return this.size;
    }
}
