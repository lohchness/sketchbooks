int amount = 500; 
int scalarIndex = 0; 
float circleRadius = 150; 
float frequencyX = random(100); 
float frequencyY = random(100); 
float currentScalar = 0; 
float targetScalar = 0; 
float[] scalarOptions = new float[]{21.985073, 36.485073, 45.214672, 51.985073, 71.714676, 72.714676, 82.815246, 89.62983, 90.17334, 90.316246, 90.714676, 91.53582, 107.816246, 118.03582, 126.714676, 127.753944, 130.31622, 160.75392, 176.93164, 183.06836, 292.25394}; 
//float[] scalarOptions = new float[]{0, 180, 215.40811, 224.63919};
float lerpSpeed = .1f;

PVector position;

void setup() {
  size(1000, 1000, P2D);
  frameRate(60);
  smooth();
  strokeWeight(1);
  stroke(0, 64);
  textSize(14);
  textAlign(CENTER);
  position = new PVector(0, 0);
  
  currentScalar = targetScalar = scalarOptions[0];
}

void draw() {

    
  currentScalar = lerp(currentScalar, targetScalar, lerpSpeed);
  //position.set((noise(frequencyX) - .5) * width, (noise(frequencyY) - .5) * height);
  //frequencyX += .01;
  //frequencyY += .01;
  
  background(255);
  
  translate(width * .5, height * .5);
  for (int i = 0; i < amount; i++) {
    float radiansVal = radians(i * 360.0 / amount);
    float initialX = cos(radiansVal) * (circleRadius + (noise(cos(radiansVal) * circleRadius * .005 + frameCount * .01, sin(radiansVal) * circleRadius * .005 - frameCount * .01) - .5) * circleRadius * .25);
    float initialY = sin(radiansVal) * (circleRadius + (noise(sin(radiansVal) * circleRadius * .005 - frameCount * .01 + 6.43, cos(radiansVal) * circleRadius * .005 + frameCount * .01 - 11.19) - .5) * circleRadius * .25);
    
    pushMatrix();
    translate(initialX, initialY);
    rotate(radians(((i - amount / 2) * currentScalar)));
    line(0, 0, noise(i * .005 + frameCount * .005 + 12.09) * circleRadius * 4, 0);
    popMatrix();
  }
  
  //fill(255, 0, 0);
  //text(targetScalar + "x", width * .1, height * .95);
  
  //if (frameCount % 20 == 0) {
  //    scalarIndex = (scalarIndex + 1 + scalarOptions.length) % scalarOptions.length;
  //    targetScalar = scalarOptions[scalarIndex];
  //}
}

void keyReleased() {
  if (key == CODED) {
      if (keyCode == LEFT) {
          scalarIndex = (scalarIndex - 1 + scalarOptions.length) % scalarOptions.length;
          //targetScalar -= 3;
  }
      else if (keyCode == RIGHT) {
          scalarIndex = (scalarIndex + 1 + scalarOptions.length) % scalarOptions.length;
          //targetScalar += 3;
  }
      targetScalar = scalarOptions[scalarIndex];
      //targetScalar += 3;
      print(targetScalar);
      print("\n");
  }
}
