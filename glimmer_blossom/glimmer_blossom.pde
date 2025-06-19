float time = 0;
float speed = 90;
float frames = 0;

int amt = 40000;

int curr = 0, max = 4;
float targetx = 0;
float targety = 0;
float[] currx = new float[amt];
float[] curry = new float[amt];


void setup() {
    size(800, 800);
    strokeWeight(.5);
    stroke(255);
    
    // initial coords
    for (int i=0; i<amt; i++) {
        float initialX = i % 200;
        float initialY = i / 200;
        // Offsets
        float horizontal = initialX / 8 - 12;
        float vertical = initialY / 8 - 12;
        PVector v = wave1(initialX, initialY, horizontal, vertical);
        currx[i] = v.x;
        curry[i] = v.y;
    }
}

void draw() {
    background(0);

    time += PI / speed;
    frames = frameCount;


    for (int i = 0; i < amt; i++) {
        float initialX = i % 200;
        float initialY = i / 200;
        // Offsets
        float horizontal = initialX / 8 - 12;
        float vertical = initialY / 8 - 12;
        
        PVector v;
        
        switch (curr) {
            case 0:
                v = wave1(initialX, initialY, horizontal, vertical);
                break;
            case 1:
                v = wave4(initialX, initialY, horizontal, vertical);
                break;
            case 2:
                v = wave3(initialX, initialY, horizontal, vertical);
                break;
            case 3:
                v = wave2(initialX, initialY, horizontal, vertical);
                break;
            default:
                v = wave1(initialX, initialY, horizontal, vertical);
                break;
        }
        
        targetx = v.x;
        targety = v.y;
        
        currx[i] = lerp(currx[i], targetx, .02);
        curry[i] = lerp(curry[i], targety, .05);
        point(currx[i], curry[i]);
    }
}

void keyPressed() {
    curr += 1;
    if (curr == max) curr = 0;
}

PVector wave1(float initialX, float initialY, float horizontal, float vertical) {
    // Transformation
    float distance = 2 - mag(horizontal, vertical) / ((sin((frames)/90)) + 3.5);
    //float distance = (sin(horizontal * 3) / sin(vertical * 2));
    float wave = 3 * (sin(horizontal / 10) * cos(vertical / 2));
    //float wave = 2 - mag(horizontal, vertical) / ((sin((t2)/30)) + 3.5);
    //float wave = (sin(horizontal * 2) * cos(vertical * 2))
    
    // Final positions with wave and distance transformations
    float x = ((initialX + wave * horizontal * 4 +
        wave * horizontal * sin(wave + time)) * 0.7
        + horizontal * distance * 2 + 130) * 2;
    
    float y = ((initialY + wave * initialY / 5 +
        wave * vertical * cos(wave + time + distance) *
        sin(time + wave)) * 1 +
        vertical * distance + 70) * 2;
    
    return new PVector(x,y);
}

PVector wave2(float initialX, float initialY, float horizontal, float vertical) {
    float distance2 = (sin(horizontal * 3) / sin(vertical * 2));
    float wave2 = 3 * (sin(horizontal / 10) * cos(vertical / 2));

    float x2 = ((initialX + wave2 * horizontal * 8 +
                wave2 * horizontal * sin(wave2 + time)) * 0.7
             + horizontal * distance2 * 2 + 130) * 2;

    float y2 = ((initialY + wave2 * initialY / 10 +
                wave2 * vertical * distance2 * cos(wave2 + time + distance2) *
                sin(time + wave2 + vertical)) * 1 +
                vertical * distance2 + 70) * 2;
    
    targetx = x2;
    targety = y2;
    
    return new PVector(x2,y2);
}

PVector wave3(float initialX, float initialY, float horizontal, float vertical) {
    float distance2 = 2 - mag(horizontal, vertical) / ((sin((frames)/100)) + 3.5);
    float wave2 = (sin(horizontal * 3));

    float x2 = ((initialX + wave2 * atan(horizontal +
                wave2 * horizontal * wave2 + time) * 0.7)
             + vertical * distance2 * 1 + 100) * 2;

    float y2 = ((initialY + (wave2 * (initialY / 2 +
                wave2) * horizontal * sin(wave2 + time + distance2))) * 2 
                + horizontal + 1500) * .2;
    
    targetx = x2;
    targety = y2;
    
    return new PVector(x2,y2);
    
}

PVector wave4(float initialX, float initialY, float horizontal, float vertical) {
    float distance2 = (sin(horizontal * 3));
    float wave2 = 2 - mag(horizontal, vertical) / ((sin((frames)/100)) + 3.5);

    float x2 = ((initialX + wave2 * sin(horizontal * 8 +
                wave2 * horizontal * tan(wave2 + time))) * 0.7
             + horizontal * distance2 * 2 + 130) * 2;

    float y2 = ((initialY + wave2 * initialY / 2 +
                wave2 * horizontal * cos(wave2 + time + distance2)) * 2 
                + vertical + 100) * 1.5;
    
    targetx = x2;
    targety = y2;
    
    return new PVector(x2,y2);
    
}
