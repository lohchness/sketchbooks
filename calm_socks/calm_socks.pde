float zoom = -200;
final int MAX_ZOOM_IN = 200, MAX_ZOOM_OUT = -200;
final ArrayList<Star> stars = new ArrayList<>();
final ArrayList<Path> paths = new ArrayList<>();
final int WIDTH = 1000, HEIGHT = 800, DEPTH = 1000;
final int MAX_STARS = 100;
float mZ;
boolean clicked = false;
Star currStar = null;

void setup() {
    size(1000, 800, P3D);
    textSize(20);
  
    addnames();
    generate_stars();
    noCursor();
}

void draw() {
    if (keyPressed) {
      if (key == 'w' && zoom < MAX_ZOOM_IN) {
          zoom += 10;
      } else if (key == 's' && zoom > MAX_ZOOM_OUT) {
          zoom -= 10;
      }
    }
  background(0);
  float mX = mouseX;
  float mY = mouseY;
  mZ = (height/2) / tan(PI/6) - zoom;
  camera(mX, mY, mZ, 
          mX, mY, 0, 
          0, 1, 0);
          
  draw_text();
  
  translate(width/2, height/2, -100);
  draw_stars();
  draw_paths();
}

void generate_stars() {
    
    for (int i=0; i < MAX_STARS; i++) {
        stars.add(new Star( starSystems.get(i % starSystems.size()) ));
    }
    
}

void addnames() {
    for (String name : starnames) {
        starSystems.add(name);
    }
}

void draw_text() {
    noFill();
    stroke(255);
    ellipse(mouseX, mouseY, 10, 10);
    Star considered = null;
    
    for (Star star : stars) {
        if (dist(star.getLoc().x, star.getLoc().y, mouseX, mouseY) >= star.getSize() + 10 ) continue;
        if (star.loc.z > mZ) continue;
        
        // overlapping planets
        if (considered == null) considered = star;
        else { 
            if (considered.loc.z > star.loc.z) continue;
            considered = star;
            println("Planet: " + considered.name);
            
        }
    }
    if (considered != null) {
        if (!clicked) {
            if (mousePressed == true) {
                clicked = true;
                currStar = considered;
                print("First selected " + currStar.name + "\n");
            }
        } else { // already selected a star
            if (mousePressed == true && currStar != considered) {
                paths.add(new Path(currStar, considered));
                currStar = considered;
                print("selected " + currStar.name + "\n");
            }
        }
        text(considered.getName(), mouseX + 10, mouseY + 10);
    }
}

void draw_paths() {
    stroke(255);
    strokeWeight(3);

    for (Path path : paths) {
        pushMatrix();
        translate(-WIDTH / 2, -HEIGHT / 2);

        line(path.start.x, path.start.y, path.start.z, path.end.x, path.end.y, path.end.z);
        popMatrix();
    }

}

void draw_stars() {
    fill(255);
    stroke(0);
    for (Star star : stars) {
        pushMatrix();
        //translate(star.getLoc().x, star.getLoc().y, star.getLoc().z);
        translate(-WIDTH / 2, -HEIGHT / 2, star.getLoc().z);
        //ellipse(0,0,star.getSize(), star.getSize());
        
        //fill(255, 255 * (0.5), 255 * (0.5));
        ellipse(star.getLoc().x, star.getLoc().y, star.getSize(), star.getSize());
        
        popMatrix();
    }
    
}
