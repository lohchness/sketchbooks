int lines = 500; 
int index = 0; 
float radius = 150; 
float length = 500;
float currScalar = 0; 
float targetScalar = 0; 
float[] options = new float[]{21.985073, 36.485073, 45.214672, 51.985073, 71.714676, 72.714676, 82.815246, 89.62983, 90.17334, 90.316246, 90.714676, 91.53582, 107.816246, 118.03582, 126.714676, 127.753944, 130.31622, 160.75392, 176.93164, 183.06836, 292.25394}; 
float lerpSpeed = .1f;

void setup() {
  size(1000, 1000, P2D);
  frameRate(60);
  smooth();
  strokeWeight(1);
  stroke(0, 64);
  
  currScalar = targetScalar = options[0];
}

void draw() {
  currScalar = lerp(currScalar, targetScalar, lerpSpeed);
  int frames = frameCount;
  
  background(255);
  
  translate(width * .5, height * .5);
  for (int i = 0; i < lines; i++) {
    float radians = radians(i * 360.0 / lines);
    float x = cos(radians) * (
      radius + (noise(
            cos(radians) * radius * .005 + (frames * .01) + 5, 
            sin(radians) * radius * .005 - (frames * .01) + 10
        ) - .5) 
    );
    float y = sin(radians) * (radius + (noise(sin(radians) * radius * .005 - ((frames * .01) + 6), cos(radians) * radius * .005 + frames * .01 - 11) - .5) * radius * .25);
    
    pushMatrix();
    translate(x, y);
    rotate(radians(((i - lines / 2) * currScalar)));
    line(0, 0, noise(i * .005 + frames * .005 + 12) * length , 0);
    popMatrix();
  }
}

void keyReleased() {
  if (key == CODED) {
      if (keyCode == LEFT) {
          index = (index - 1 + options.length) % options.length;
  }
      else if (keyCode == RIGHT) {
          index = (index + 1 + options.length) % options.length;
  }
      targetScalar = options[index];
      print(targetScalar, "\n");
  }
}
