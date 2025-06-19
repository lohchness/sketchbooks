int n = 150;
int r = 100;
int g = 100;

float[] cr;
float[] beta;
float[] theta;
float[] zeta;
float[] eta;


void setup() {
    
    size(1000, 1000);
    strokeWeight(1);
    
    cr = new float[0];
    beta = new float[0];
    theta = new float[0];
    zeta = new float[0];
    eta = new float[0];
    
    for (int i=0; i < n; i++) {
        cr = append(cr, (i*TWO_PI) / n);
        beta = append(beta, (i*TWO_PI) / n);
        theta = append(theta, (i*TWO_PI) / n);
        zeta = append(zeta, (i*TWO_PI) / n);
        eta = append(eta, (i*TWO_PI) / n);
    }
}

void draw() {
    background(10, 100);
    translate(width / 2, height / 2);
    noFill();
    
    for (int i=0; i<n; i++) {
        theta[i] = theta[i] + PI / 150;
        zeta[i] = zeta[i] + PI / 200;
        if (theta[i] >= PI) beta[i] = beta[i] + PI / 350;
        if (zeta[i] >= TWO_PI) eta[i] = eta[i] + PI / 300;
        float x1 = r * cr[i] * cos(theta[i]);
        float y1 = r * cr[i] * sin(theta[i]);
        float x2 = r * cr[i] * cos(beta[i]);
        float y2 = r * cr[i] * sin(beta[i]);
        float x3 = g * cr[i] * cos(zeta[i]);
        float y3 = g * cr[i] * sin(zeta[i]);
        float x4 = g * cr[i] * cos(eta[i]);
        float y4 = g * cr[i] * sin(eta[i]);
        
        stroke(0, 0, 255);
        point(x3, y3);
        beginShape();
        vertex(x1, y1);
        vertex(x2, y2);
        endShape();
        beginShape();
        vertex(x3, y3);
        vertex(x4, y4);
        endShape();
        
        if (theta[i] >= 3 * TWO_PI) theta[i] = 0;
        if (theta[i] <= PI) beta[i] = beta[i] - PI / 175;
        if (zeta[i] >= 5 * TWO_PI) zeta[i] = 0;
        if (zeta[i] <= TWO_PI) eta[i] = eta[i] - PI / 150;
    }
    
}
