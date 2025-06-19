int amount = 500;

float circleRadius = 150;
float frequencyX = random(100);
float frequencyY = random(100);

float currentScalar = 0;
float targetScalar = 0;

int scalarIndex = 0;
float[] scalarOptions = new float[]{0, .5, 1, 2, 3, 4, 5, 6, 7, 8, 16, 32, 64, 100, 128, 256, 512, 1024};
PVector position;

boolean switched = false;
float background_val = 255;
float stroke_val = 0;
float stroke_alpha = 64;
float stroke_w = 1.0;

int printVal = 0;

import ddf.minim.*;
String trackname = "bastion.mp3";
Minim minim;
AudioPlayer track;

void setup() {
    size(800, 800, P2D);
    frameRate(60);
    smooth();
    strokeWeight(stroke_w);
    stroke(0, 64);
    textSize(14);
    textAlign(CENTER);
    position = new PVector(0, 0);
    
    minim = new Minim(this);
    track = minim.loadFile(trackname, 4096);
    track.setGain(-20);
    //track.loop();
    //currentScalar = 75;
    //targetScalar = 75;
    track.skip(23250);
}

void draw() {
    //if (frameCount % 10 == 0) {
    //    targetScalar += .5;
    //}
    
    targetScalar += 1/60f;
    
    currentScalar = lerp(currentScalar, targetScalar, .05);
    //currentScalar = float(frameCount * 25) / 360;

    position.set((noise(frequencyX) - .5) * width, (noise(frequencyY) - .5) * height);
    frequencyX += .01;
    frequencyY += .01;

    background(background_val);
    stroke(stroke_val, stroke_alpha);
    strokeWeight(stroke_w);

    translate(width * .5, height * .5);

    //colorMode(HSB, amount, 1, 1);
    int n_frame = frameCount / 2;

    for (int i=0; i < amount; i++) {
        float radiansVal = radians(i * 360.0 / amount);
        float initialX = cos(radiansVal) * (circleRadius + (noise(cos(radiansVal) * circleRadius * .005 + n_frame * .01, sin(radiansVal) * circleRadius * .005 - n_frame * .01) - .5) * circleRadius * .5);
        float initialY = sin(radiansVal) * (circleRadius + (noise(sin(radiansVal) * circleRadius * .005 - n_frame * .01 + 6.43, cos(radiansVal) * circleRadius * .005 + n_frame * .01 - 11.19) - .5) * circleRadius * .5);

        //float amt = float(i) / amount;
        //color c = lerpColor(color(i, 1, 1), color(, amt);
        //color c = color((i + frameCount) % amount, 1, 1);
        //stroke(c, 64);

        pushMatrix();
        translate(initialX, initialY);
        rotate(radians(( i - amount / 2) * currentScalar));
        line(0, 0, noise(i * .005 + n_frame * .005 + 12.09) * circleRadius * 4, 0);
        popMatrix();
    }

    colorMode(RGB, 255, 255, 255);
    fill(255, 0, 0);
    text(currentScalar + "x", 0, height * .47);

    update_color();
    if (int(currentScalar) > printVal) {
        printVal = int(currentScalar);
        print(printVal + "\n");
    }
}

void keyPressed() {
    if (key == ' ') {
        switched = !switched;
        stroke_w = 3;
    }
}

float increment = .05;
void update_color() {
    if (switched) {
        background_val = lerp(background_val, 0, increment);
        stroke_val = lerp(stroke_val, 255, increment);
        stroke_w = lerp(stroke_w, 1, .1);
    } else {
        background_val = lerp(background_val, 255, increment);
        stroke_val = lerp(stroke_val, 0, increment);
        stroke_w = lerp(stroke_w, 1, .1);
    }
}
