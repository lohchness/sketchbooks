color colorA;
color colorB;
color bg;
int t = 0;

float delta = .2;

color[] palette = {#F565A3, #61C8EE, #ECDE50, #C476D0, #3663C3};

void setup() {
    size(1000, 600);
    pixelDensity(1);

    
    colorA = color(palette[int(random(palette.length))]);
    colorB = color(palette[int(random(palette.length))]);
    bg = color(#E7ECF2);
    
    noLoop();
}

void draw() {
    for (int i = 0; i < 180 * 5; i++) {
        float dx = map(noise(i * .01),        0, 1, -width * delta, width * (1+delta));
        float dy = map(noise(i * .01 + 1000), 0, 1, -height * delta, height * (1 + delta));
        
        float rotation = 300 * abs(sin(radians(i)));
        float diameter = 150 * abs(sin(radians(i * 2)));
                
        color c = lerpColor(colorB, colorA, diameter / 100);
        stroke(c);
        fill(bg);
        
        strokeWeight(3);
        
        float x = dx + rotation * cos(radians(t));
        float y = dy + rotation * sin(radians(t));
        
        pushMatrix();
        translate(x, y);
        rotate(radians(t * 13));
        ellipse(0, 0, diameter, diameter * .5);
        //line(diameter, 0, 0, diameter * .5);
        popMatrix();
        
        t += 2 * abs(sin(radians(i)));
    }
}
