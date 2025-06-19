class Path {
    public PVector start, end;
    
    public Path(Star start, Star end) {
        this.start = start.loc;
        this.end = end.loc;
    }
    
    public float getDist() {
        return dist(start.x, start.y, start.z, end.x, end.y, end.z);
    }
}
