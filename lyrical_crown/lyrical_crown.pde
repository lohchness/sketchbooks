//import processing.sound.*;

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

final int WIDTH = 1000, HEIGHT = 500;
float BLUR_PARAM = .9;
String audioFileName = "spaceplusone.wav", title;
float smooth_factor = .2;

// Global variables
AudioPlayer track;
FFT fft;
Minim minim;

BeatDetect beat;
//BeatListener bl;
   
// General
int bands = 900; // must be multiple of two
float[] spectrum = new float[bands];
float[] sum = new float[bands];

Spray spray;

// Graphics
float unit;
int groundLineY;
PVector center;
//color[] hex_values = new color[];
// #ec8c00  #e5cd00   #931fe6

PFont font;

// other constants
float STROKE_MULT = 4;
int BANDS_PER_OCTAVE = 8;


float fftStream[];


void settings() {
    size(WIDTH, HEIGHT);
    smooth(8); // if errors reduce to 4 or 3 (default)
}

void setup() {
    frameRate(60);
    
    //graphics
    //unit = height / 100;
    //strokeWeight(unit / STROKE_MULT);
    //groundLineY = height * 3 / 4;
    //center = new PVector(width / 2, height * 3 / 4);
    
    spray = new Spray();
    
    minim = new Minim(this);
    track = minim.loadFile(audioFileName, 4096);
    beat = new BeatDetect();
    track.loop();
    track.setGain(-40);
    //track.mute();

    
    initializeFFT();
    
    //title = audioFileName.substring(0, audioFileName.lastIndexOf("."));
    font = createFont("Gotham Bold", 90);
    textFont(font);
    title = "";
}

void initializeFFT() {

    fft = new FFT(track.bufferSize(), track.sampleRate());
    
    //fft.linAverages(bands); // draw_bars_1
    fft.logAverages( 100 , 20 );
    fft.window(FFT.HAMMING);
    fft.forward(track.mix);
    //fft.logAverages(22,3);

    //fft.linAverages(BARS * 2);
    //fftStream = new float[BARS];
    
    bar_length = new float[fft.specSize()];
    target_length = new float[fft.specSize()];
    for (int i=0; i<fft.specSize(); i++) {
        bar_length[i] = 0;
        target_length[i] = 0; //<>//
    }
    
}



void draw() {
    fft.forward(track.mix);
    beat.detect(track.mix);
     //<>//
    spectrum = new float[bands];
    for (int i = 0; i < fft.avgSize(); i++)
        {
        spectrum[i] = fft.getAvg(i) / 2;
        
        // Smooth the FFT spectrum data by smoothing factor
        sum[i] += (abs(spectrum[i]) - sum[i]) * smooth_factor;
    }
    
    //Reset canvas
    fill(0);
    noStroke();
    rect(0, 0, width, height);
    noFill();
    
    //drawAll(sum);
    sprayDots();
    //filter(BLUR, BLUR_PARAM);
    
    draw_base();
    
    fill(#ec8c00);
    draw_bars();
    //draw_bars_2();
    //draw_bars_3();
    
    //draw title
    fill(255);
    text(title.toUpperCase(), startX - (BAR_GAP * NUM_BARS), startY + 90);
}


void keyPressed() {
    switch (key) {
        case 'l':
            track.skip(10000);
            break;
        case 'p':
            track.loop();
            break;
        case 'k':
            if (track.isPlaying()) track.pause();
            else track.play();
            break;
        case 'j':
            track.skip(-10000);
            break;
        case 'r':
            track.rewind();
            spray = new Spray();
            track.pause();
            break;
        case 'm':
            if (track.isMuted()) track.unmute();
            else track.mute();
            break;
        case 'q':
            for (Dot dot : spray.dots) {
                dot.curr_diameter = dot.base_diameter * 1.25;   
            }
            break;
        default:
            break;
    }
}



// ---------------------------------------


int sphereRadius;

float spherePrevX;
float spherePrevY;

int yOffset;

void drawAll(float[] sum) {
    
    //center sphere
    sphereRadius = 15 * round(unit);
    spherePrevX = spherePrevY = 0;
    yOffset = round(sin(radians(150)) * sphereRadius);
    
    //Surrounding lines
    float x = 0, y = 0;
    
    //lines extending from center sphere
    
    float extendingLinesMin = sphereRadius * 0.5;
    float extendingLinesMax = sphereRadius * 2.0;
    
    float xDestination, yDestination;
    
    //incremental ray tracer
    for (int angle = 0; angle <= 240; angle += 2) {
        float extendingSphereLinesRadius = map(noise(angle * 0.3), 0, 1, extendingLinesMin, extendingLinesMax);
        //radius mapped differently for highs, mids, and lows
        // alter higher mapping number for different result (eg 0.8 to 0.2 in the highs)
        if (sum[0] != 0) {
           if (angle >= 0 && angle <= 30) {
                extendingSphereLinesRadius = map(sum[240 - round(map((angle), 0, 30, 0, 80))], 0, 0.8, extendingSphereLinesRadius - extendingSphereLinesRadius / 8, extendingLinesMax * 1.5); // Highs
            }
            
            else if (angle > 30 && angle <= 90) {
                extendingSphereLinesRadius = map(sum[160 - round(map((angle - 30), 0, 60, 0, 80))], 0, 3, extendingSphereLinesRadius - extendingSphereLinesRadius / 8, extendingLinesMax * 1.5); // Mids
            }
            
            else if (angle > 90 && angle <= 120) {
                extendingSphereLinesRadius = map(sum[80 - round(map((angle - 90), 0, 30, 65, 80))], 0, 40, extendingSphereLinesRadius - extendingSphereLinesRadius / 8, extendingLinesMax); // Bass
            }
            
            else if (angle > 120 && angle <= 150) {
                extendingSphereLinesRadius = map(sum[0 + round(map((angle - 120), 0, 30, 0, 15))], 0, 40, extendingSphereLinesRadius - extendingSphereLinesRadius / 8, extendingLinesMax); // Bass
            }
            
            else if (angle > 150 && angle <= 210) {
                extendingSphereLinesRadius = map(sum[80 + round(map((angle - 150), 0, 60, 0, 80))], 0, 3, extendingSphereLinesRadius - extendingSphereLinesRadius / 8, extendingLinesMax * 1.5); // Mids
            }
            
            else if (angle > 210) {
                extendingSphereLinesRadius = map(sum[160 + round(map((angle - 240), 0, 30, 0, 80))], 0, 0.8, extendingSphereLinesRadius - extendingSphereLinesRadius / 8, extendingLinesMax * 1.5); // Highs
            }
        }
        
        // makes sure lines dont go past sine wave ground line
        
        // makes line start at perimeter of sphere
        x = round(cos(radians(angle + 150)) * sphereRadius + center.x);
        y = round(sin(radians(angle + 150)) * sphereRadius + groundLineY - yOffset);
        
        xDestination = x;
        yDestination = y;
        
        for (int i = sphereRadius; i <= extendingSphereLinesRadius; i++) {
            int x2= round(cos(radians(angle + 150)) * i + center.x);
            int y2= round(sin(radians(angle + 150)) * i + groundLineY - yOffset);
            
            //if (y2 <= getGroundY(x2)) { // Make sure it doesnt go into ground
            xDestination = x2;
            yDestination = y2;
        //}
        }
        
        stroke(map(extendingSphereLinesRadius, extendingLinesMin, extendingLinesMax, 200, 255));
        
        //if(yDestination > 100) yDestination = 100;
        
        //if(y <= getGroundY(x))  {
        if (track.isPlaying()) {
            line(x, y, xDestination, yDestination);
        }
//}
    }
    
    //Ground line
    //for (int groundX = 0; groundX <= width; groundX++) {
    
    //float groundY = getGroundY(groundX);
    
    //noStroke();
    //fill(255);
    //circle(groundX, groundY, 1.8 * unit / STROKE_MULT);
    //noFill();
//}
    
}


// Get the Y position at position X of ground sine wave
float getGroundY(float groundX) {
    
    float angle = 1.1 * groundX / unit * STROKE_MULT;
    
    float groundY = sin(radians(angle + frameCount * 2)) * unit * 1.25 + groundLineY - unit * 1.25;
    
    return groundY;
}
