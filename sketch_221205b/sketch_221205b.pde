PImage img;
PShape globe;

void setup() {
  // Load an image
  img = loadImage("earth.jpg");
  globe = createShape(SPHERE, 50);
  // Automatically texture the shape with the image
  globe.setTexture(img);
}
