//a=(x,y,d=-exp(-mag(k=w*noise(t)-x,e=w*noise(t,9)-y)/(40+145*noise(x/50,y/50))))=>[x+k*d,y+e*d]
//s=4,t=0,draw=$=>{t||createCanvas(w=400,w);noFill(t+=.02);background(248);for(y=0;y<w;y+=s)for(x=0;x<w;x+=s)triangle(...[a(x,y),a(x,y+s),a(x+s,y)].flat())}

float time = 0;
float gridStep = 4;

void setup() {
  size(400, 400);
}

void draw() {
  time += 0.02;
  background(248);
  noFill();
  
  for (float y = 0; y < width; y += gridStep) {
    for (float x = 0; x < width; x += gridStep) {
      float[] point1 = calculateOffsetPoint(x, y);
      float[] point2 = calculateOffsetPoint(x, y + gridStep);
      float[] point3 = calculateOffsetPoint(x + gridStep, y);
      triangle(point1[0], point1[1], point2[0], point2[1], point3[0], point3[1]);
    }
  }
}

float[] calculateOffsetPoint(float x, float y) {
  float noiseOffsetX = width * noise(time) - x;
  float noiseOffsetY = height * noise(time) - y;
  float distanceFactor = -exp(-mag(noiseOffsetX, noiseOffsetY) / (40 + 145 * noise(x/50, y/50)));
  return new float[]{x + noiseOffsetX * distanceFactor, y + noiseOffsetY * distanceFactor};
}
