//import ddf.minim.analysis.*;
//import ddf.minim.*;

//Minim       minim;
//AudioPlayer jingle;
//FFT         fft;
//float[] spectrum;
//float decay = 0.9, heightScale = 20;

//void setup()
//{
//  size(512, 200, P3D);  
//  minim = new Minim(this);  
//  jingle = minim.loadFile("spaceplusone.mp3", 1024);  
//  jingle.loop();  
//  fft = new FFT( jingle.bufferSize(), jingle.sampleRate() );
//  spectrum = new float[fft.specSize()];
//}

//void draw()
//{
//  background(0);
//  stroke(255);

//  fft.forward( jingle.mix );  
//  for(int i = 0; i < fft.specSize(); i++) {
//    spectrum[i] *= decay;
//    spectrum[i] += fft.getBand(i);
//    line( i, height, i, height - (spectrum[i] <= 0 ? 0 : log(spectrum[i])) * heightScale );
//  }
//}








// ----------------------------------------------------------------------------------------






//import ddf.minim.*;
//import ddf.minim.analysis.*;

//Minim minim;
//AudioPlayer song;
//FFT fft;

//int sampleRate = 44100;

///* a bufferSize of 512 results in the sharpest, most responsive movement - change 
// bufferSize to 1024 or 2048 and note how the movement appears more sluggish */

//int bufferSize = 512; // this is actually called timeSize

///* if the number for fft_band_per_oct is higher than 1, it will still result in 9 octaves / bands 
// because the number of bands you get is equal to log2 of bufferSize ie. log2(512) = 9 */

//// 512 returns 86hz bandwidth which allows 9 octaves / bands
//// 1024 returns 43hz bandwidth which allows 10 octaves / bands
//// 2048 returns 21hz bandwidth which allows 11 octaves / bands

//int fft_base_freq = 86; // size of the smallest octave to use (in Hz) so we calculate averages based on a miminum octave width of 86 Hz 
//int  fft_band_per_oct = 1; // how many bands to split each octave into? in this case split each octave into 1 band

//int numZones = 0;

//int yPos = 270;

//void setup() {
//  size(960, 540);
//  smooth();
//  colorMode(HSB, 360, 100, 100);

//  minim = new Minim(this);
//  song = minim.loadFile("spaceplusone.mp3", bufferSize);
//  song.loop();

//  fft = new FFT( bufferSize, sampleRate ); // make a new fft

//  // first parameter specifies the size of the smallest octave to use (in Hz), second is how many bands to split each octave into.
//  fft.logAverages(fft_base_freq, fft_band_per_oct); // results in 9 bands

//  fft.window(FFT.HAMMING);

//  numZones = fft.avgSize(); // avgSize() returns the number of averages currently being calculated
//  // println("numZones: " + numZones); // returns 9 bands

//  rectMode(CENTER);
//  noStroke();
//}

//void draw() {
//  background(0);

//  fft.forward(song.mix); // perform forward FFT on songs mix buffer

//  // println("Bandwidth: " + fft.getBandWidth() + " Hz"); // returns 86 Hz

//  int highZone = numZones - 1;

//  for (int i = 0; i < numZones; i++) { // 9 bands / zones / averages

//    float average = fft.getAvg(i); // return the value of the requested average band, ie. returns averages[i]
//    // println("Averages " + i + " : " + average);

//    float avg = 0;
//    int lowFreq;

//    if ( i == 0 ) {
//      lowFreq = 0;
//    } 
//    else {
//      lowFreq = (int)((sampleRate/2) / (float)Math.pow(2, numZones - i)); // 0, 86, 172, 344, 689, 1378, 2756, 5512, 11025
//    }
//    int hiFreq = (int)((sampleRate/2) / (float)Math.pow(2, highZone - i)); // 86, 172, 344, 689, 1378, 2756, 5512, 11025, 22050

//    // ***** ASK FOR THE INDEX OF lowFreq & hiFreq USING freqToIndex ***** //

//    // freqToIndex returns the index of the frequency band that contains the requested frequency

//    int lowBound = fft.freqToIndex(lowFreq);
//    int hiBound = fft.freqToIndex(hiFreq);

//    // println("lowFreq: " + lowFreq + " Hz");
//    // println("hiFreq: " + hiFreq + " Hz");
//    // println("lowBound: " + lowBound);
//    // println("hiBound: " + hiBound);

//    // ***** NB: THE BELOW PRINTS THE RANGES 0 - 8, THEIR RESPECTIVE FREQENCIES & INDEXES ***** //

//    // println("range " + i + " = " + "Freq: " + lowFreq + " Hz - " + hiFreq + " Hz " + "indexes: " + lowBound + "-" + hiBound);

//    for (int j = lowBound; j <= hiBound; j++) { // j is 0 - 256

//      float spectrum = fft.getBand(j); // return the amplitude of the requested frequency band, ie. returns spectrum[offset]
//      // println("Spectrum " + j + " : " +  spectrum); // j is 0 - 256

//      avg += spectrum; // avg += spectrum[j];
//      // println("avg: " + avg);
//    }

//    avg /= (hiBound - lowBound + 1);
//    average = avg; // averages[i] = avg;

//    // ***** THIS IS WHERE WE CAN ISOLATE SPECIFIC FREQUENCIES. THERE ARE 9 FREQUENCY BANDS (0 - 8) ***** //

//    // ***** 0 Hz - 86 Hz ***** //

//    if (i == 0) {  // if the frequency band is equal to 0 ie. between 0 Hz and 86 Hz

//      // println(average); // printing the average to the console is super helpful as you can see the loudness of each frequency band & further isolate parts of a track, for example just the peak

//      if (average > 40.0) {
//        fill(96, 100, 100);
//      }
//      else {
//        fill(255, 100, 100);
//      }

//      if (average > 20.0) {
//        rect(75, yPos, average * 3, average * 3);
//      }
//      else {
//        rect(75, yPos, 50, 50);
//      }
//    }

//    // ***** 86 Hz - 172 Hz ***** //

//    if (i == 1) { 

//      fill(265, 100, 100); 
//      if (average > 20) {
//        rect(176, yPos, average * 2, average * 2);
//      }
//      else {
//        rect(176, yPos, 50, 50);
//      }

//      if (average > 40 && average < 50) {
//        strokeWeight(20); 
//        stroke(96, 100, 100);
//      } 
//      else {
//        strokeWeight(5); 
//        stroke(0, 0, 100);
//      }

//      if (average > 20 && average < 50) {
//        line(0, 0, width, height);
//      }
//    }

//    // ***** 172 Hz - 344 Hz ***** //

//    if (i == 2) { 

//      fill(272, 100, 100);
//      if (average > 20) {
//        rect(277, yPos, average * 2, average * 2);
//      }
//      else {
//        rect(277, yPos, 50, 50);
//      }
//    }

//    // ***** 344 Hz - 689 Hz ***** //

//    if (i == 3) { 

//      fill(281, 100, 100);
//      if (average > 8) {
//        rect(378, yPos, average * 2, height);
//      }
//      else {
//        rect(378, yPos, 1, height);
//      }    

//      strokeWeight(6);

//      if (average > 10.0 && average < 20.0) {

//        for (int y = 60; y < height; y += 150) { 
//          for (int x = 40; x < width; x += 150) { 
//            stroke(0, 0, 100);
//            point (x, y);
//          }
//        }
//      }
//    }

//    noStroke();

//    // ***** 689 Hz - 1378 Hz ***** //

//    if (i == 4) { 

//      if (average > 2) {
//        fill(96, 100, 100);
//        rect(480, yPos, average * 20, average * 20);
//      }
//      else {
//        fill(287, 100, 100);
//        rect(480, yPos, 50, 50);
//      }
//    }

//    // ***** 1378 Hz - 2756 Hz ***** //

//    if (i == 5) { 

//      fill(295, 100, 100);     
//      if (average > 1) {
//        rect(581, yPos, average * 40, average * 40);
//      }
//      else {
//        rect(581, yPos, 50, 50);
//      }
//    }

//    // ***** 2756 Hz - 5512 Hz ***** //

//    if (i == 6) { 

//      if (average > 2) {
//        fill(96, 100, 100);
//      }
//      else {
//        fill(312, 100, 100);
//      }

//      if (average > 1) {
//        rect(682, yPos, average * 40, average * 40);
//      }
//      else {
//        rect(682, yPos, 50, 50);
//      }
//    }

//    // ***** 5512 Hz - 11025 Hz ***** //

//    if (i == 7) { 

//      fill(332, 100, 100);

//      if (average > 1) {
//        rect(783, yPos, average * 60, average * 60);
//      }
//      else {
//        rect(783, yPos, 50, 50);
//      }
//    }

//    // ***** 11025 Hz - 22050 Hz ***** //

//    if (i == 8) { 

//      fill(349, 100, 100);      
//      float newSize = map(average, 0.0, 0.3, 50.0, 150.0);     
//      rect(885, yPos, newSize, newSize);
//    }

//    // ********** //
//  }
//}

//void stop() {
//  song.close(); // always close Minim audio classes when you are finished with them
//  minim.stop(); // always stop Minim before exiting
//}






// ----------------------------------------------------------------------------------------






//import ddf.minim.signals.*;
//import ddf.minim.*;
//import ddf.minim.analysis.*;
//import ddf.minim.effects.*;

//import ddf.minim.*;

//Minim minim;
//AudioPlayer song;
//BeatDetect beat;
//BeatListener bl;
//ArrayList balls = new ArrayList();

//void setup()
//{
//  size(640, 480);
//  // always start Minim before you do anything with it
//  minim = new Minim(this);
//  frameRate( 30 );
//  smooth();
//  song = minim.loadFile("spaceplusone.mp3", 2048);

//  beat = new BeatDetect(song.bufferSize(), song.sampleRate());

//  beat.setSensitivity(0); 
//  bl = new BeatListener(beat, song);  

//  song.play();
//  noStroke();
//}

//void draw()
//{
  
//  fill( 0, 0, 0, 45 );
//  rect(0, 0, width, height);
//  // use the mix buffer to draw the waveforms.
//  // because these are MONO files, we could have used the left or right buffers and got the same data
//  boolean kick = beat.isKick();
//  boolean hat = beat.isHat();
//  boolean snare = beat.isSnare();
//  if( beat.isRange( 5, 15, 2 ) )
//  {
//    color col = color( random(255), random(255), random(255) );
//    for( int j = 0; j < abs(song.mix.level() * 50); j++ )
//    {
//      float y = random( height );
//    float x = random( width );
//      for (int i = 0; i < abs(song.mix.level()*100); i++)
//      {
//        balls.add( new Ball( x, y, song.mix.get(0)*70, col ) );
//      }
//    }
//  }
//  for( int i = 0; i < balls.size(); i++ )
//  {
//    Ball b = (Ball)balls.get(i);
//    b.update();
//    if( !b.alive )
//    {
//      balls.remove( b );
//      i--; 
//    }
//  } 
//}

//void stop()
//{
//  // always close Minim audio classes when you are done with them
//  song.close();
//  minim.stop();

//  super.stop();
//}

//public class Ball
//{
//  PVector loc = new PVector();
//  PVector speed = new PVector( random( -2, 2 ), random( -2, 2 ) );
//  color col;
//  boolean alive = true;
//  int age = 0;

//  public Ball( float x, float y, float mag, color col )
//  {
//    loc.x = x;
//    loc.y = y; 
//    speed.normalize();
//    speed.mult( mag );
//    this.col = col;
//  }

//  public void update()
//  {
//    age += 3;
//    speed.y += .1; 
//    loc.add( speed );
//    if( loc.y > height || age >= 255 )
//      alive = false;
//    fill( red(col), blue(col), green(col), 255 - age );
//    ellipse( loc.x, loc.y, 5, 5 );
//  }

//}

//class BeatListener implements AudioListener
//{
//  private BeatDetect beat;
//  private AudioPlayer source;

//  BeatListener(BeatDetect beat, AudioPlayer source)
//  {
//    this.source = source;
//    this.source.addListener(this);
//    this.beat = beat;
//  }

//  void samples(float[] samps)
//  {
//    beat.detect(source.mix);
//  }

//  void samples(float[] sampsL, float[] sampsR)
//  {
//    beat.detect(source.mix);
//  }
//}




// --------------------------------------------------------------------------



//import ddf.minim.analysis.*;
//import ddf.minim.*;

//Minim minim;
//AudioPlayer track;
//FFT fft;

//// the number of bands per octave
//int bandsPerOctave = 8;

//// the spacing between bars
//int barSpacing = 3;
//float maxAmp = 100;
//float FFT_MAX = 100;
//int barCount = 63;

//void setup()
//{
//  size(512, 200);

//  minim = new Minim(this);

//  track = minim.loadFile("spaceplusone.mp3", 1024);
//  track.loop();

//  fft = new FFT(track.bufferSize(), track.sampleRate());

//  // calculate averages based on a miminum octave width of 22 Hz
//  // split each octave into a number of bands
//  fft.logAverages(22, bandsPerOctave);

//  rectMode(CORNERS);
//}

//void draw()
//{
//  background(0);
//  stroke(255);

//  // perform a forward FFT on the samples in song's mix buffer
//  fft.forward(track.mix);

//  // avgWidth() returns the number of frequency bands each average represents
//  // we'll use it as the width of our rectangles
//  int w = int(width/fft.avgSize());
  
//  for (int a = 0; a < barCount; a++) {

//        float raw = fft.getAvg(a );
//        // Calculate the upper bound
//        if (raw > maxAmp) {
//            maxAmp = min(FFT_MAX, raw);
//            //System.out.println("New FFT Max: " + maxAmp);
//        }

//        fftStream[a] = raw; // fftStream is a float[]
//    }

//    // Convert the raw values into scalar values between 0 and 1
//    for (int b = 0; b < barCount; b++) {
//        fftStream[b] = norm(fftStream[b], 0, maxAmp);
//        rect(b * w, b * w + w - barSpacing, bandHeight);
//    }
        
//  //for(int i = 0; i < fft.avgSize(); i++)
//  //{
//  //  // get the amplitude of the frequency band
//  //  float amplitude = fft.getAvg(i);

//  //  // convert the amplitude to a DB value. 
//  //  // this means values will range roughly from 0 for the loudest
//  //  // bands to some negative value.
//  //  float bandDB = 20 * log(2 * amplitude / fft.timeSize());
//  //  // so then we want to map our DB value to the height of the window
//  //  // given some reasonable range
//  //  float bandHeight = map(bandDB, 0, -150, 0, height);

//  //  // draw a rectangle for the band
//  //  rect(i*w, height, i*w + w - barSpacing, bandHeight);
//  //}
//}

void keyPressed() {
    switch (key) {
        case 'l':
            jingle.skip(10000);
            break;
        case 'p':
            jingle.loop();
            break;
        case 'k':
            if (jingle.isPlaying()) jingle.pause();
            else jingle.play();
            break;
        case 'j':
            jingle.skip(-10000);
            break;
        case 'r':
            jingle.rewind();
            //spray = new Spray();
            jingle.pause();
            break;
        case 'm':
            if (jingle.isMuted())jingle.unmute();
            else jingle.mute();
            
        default:
            break;
    }
}


// ---------------------------------------------------------

//public void initializeFFT() {

//        fft = new FFT(Main.instance.audio.bufferSize(), Main.instance.audio.sampleRate());
//        fft.window(FFT.HAMMING);
//        fft.linAverages(barCount * 2);
//        fftStream = new float[barCount];
//}

//public void updateFFT() {
//        fft.forward(Main.instance.audio.mix);
//        for (int a = 0; a < barCount; a++) {

//            float raw = fft.getAvg(a );
//            // Calculate the upper bound
//            if (raw > maxAmp) {
//                maxAmp = Math.min(FFT_MAX, raw);
//                //System.out.println("New FFT Max: " + maxAmp);
//            }

//            fftStream[a] = raw; // fftStream is a float[]
//        }

//        // Convert the raw values into scalar values between 0 and 1
//        for (int b = 0; b < barCount; b++)
//            fftStream[b] = Main.norm(fftStream[b], 0, maxAmp);
//}


// ---------------------------------------------------
//import ddf.minim.*;
//import ddf.minim.analysis.*;

//Minim minim;
//AudioPlayer song;
//FFT fft;

//int sampleRate = 44100;
//int timeSize = 1024;

//void setup() {
//  size(500, 500);
//  smooth();

//  minim = new Minim(this);
//  song = minim.loadFile("spaceplusone.mp3", 2048);
//  song.loop();
//  fft = new FFT( song.bufferSize(), song.sampleRate() ); // make a new fft

//  // calculate averages based on a miminum octave width of 11 Hz
//  // split each octave into 1 bands - this should result in 12 averages
//  fft.logAverages(11, 1); // results in 12 averages, each corresponding to an octave, the first spanning 0 to 11 Hz. 
//}

//void draw() {
//  background(0);
//  noStroke();

//  fft.forward(song.mix); // perform forward FFT on songs mix buffer

//  // float bw = fft.getBandWidth(); // returns the width of each frequency band in the spectrum (in Hz).
//  // println(bw); // returns 21.5332031 Hz for spectrum [0] & [512]

//  for (int i = 0; i < 12; i++) {  // 12 is the number of bands 
  
//    int lowFreq;

//    if ( i == 0 ) {
//      lowFreq = 0;
//    } 
//    else {
//      lowFreq = (int)((sampleRate/2) / (float)Math.pow(2, 12 - i));
//    }

//    int hiFreq = (int)((sampleRate/2) / (float)Math.pow(2, 11 - i));

//    // we're asking for the index of lowFreq & hiFreq
//    int lowBound = fft.freqToIndex(lowFreq); // freqToIndex returns the index of the frequency band that contains the requested frequency
//    int hiBound = fft.freqToIndex(hiFreq); 

//    //println("range " + i + " = " + "Freq: " + lowFreq + " Hz - " + hiFreq + " Hz " + "indexes: " + lowBound + "-" + hiBound);

//    // calculate the average amplitude of the frequency band
//    float avg = fft.calcAvg(lowBound, hiBound);
//    // println(avg);

//    if ((lowBound >= 32) && ( hiBound <= 64)) {
//      fill(255);
//      ellipseMode(CENTER);
//      ellipse(250, 250, avg/1, avg/1);
//    }
    
//    if ((lowBound >= 256) && ( hiBound <= 512)) {
//      noFill();
//      stroke(255);
//      strokeWeight(2);
//      ellipseMode(CENTER);
//      ellipse(250, 250, avg*20, avg*20);
//    }    
    
//  }
//}

//void stop() {  
//  song.close(); // always close Minim audio classes when you are finished with them
//  minim.stop(); // always stop Minim before exiting
//  super.stop(); // this closes the sketch
//}

// ------------------------------------
//import ddf.minim.analysis.*;
//import ddf.minim.*;

//Minim minim;  
//AudioPlayer jingle;
//FFT fftLin;
//FFT fftLog;

//float height3;
//float height23;
//float spectrumScale = 4;

//PFont font;

//int MULT = 20;

//void setup()
//{
//  size(512, 480);
//  height3 = height/3;
//  height23 = 2*height/3;

//  minim = new Minim(this);
//  jingle = minim.loadFile("spaceplusone.mp3", 1024);
  
//  // loop the file
//  jingle.loop();
  
//  // create an FFT object that has a time-domain buffer the same size as jingle's sample buffer
//  // note that this needs to be a power of two 
//  // and that it means the size of the spectrum will be 1024. 
//  // see the online tutorial for more info.
//  //fftLin = new FFT( jingle.bufferSize(), jingle.sampleRate() );
  
//  // calculate the averages by grouping frequency bands linearly. use 30 averages.
//  //fftLin.linAverages( 30 );
  
//  // create an FFT object for calculating logarithmically spaced averages
//  fftLog = new FFT( jingle.bufferSize(), jingle.sampleRate() );
  
//  // calculate averages based on a miminum octave width of 22 Hz
//  // split each octave into three bands
//  // this should result in 30 averages
//  fftLog.logAverages( 22, 3 );
  
//  rectMode(CORNERS);
//  //font = loadFont("ArialMT-12.vlw");
//}

//void draw()
//{
//  background(0);
  
//  //textFont(font);
//  textSize( 18 );
 
//  float centerFrequency = 0;
  
//  // perform a forward FFT on the samples in jingle's mix buffer
//  // note that if jingle were a MONO file, this would be the same as using jingle.left or jingle.right
//  //fftLin.forward( jingle.mix );
//  fftLog.forward( jingle.mix );
 
//  // draw the full spectrum
//  //{
//  //  noFill();
//  //  for(int i = 0; i < fftLin.specSize(); i++)
//  //  {
//  //    // if the mouse is over the spectrum value we're about to draw
//  //    // set the stroke color to red
//  //    if ( i == mouseX )
//  //    {
//  //      centerFrequency = fftLin.indexToFreq(i);
//  //      stroke(255, 0, 0);
//  //    }
//  //    else
//  //    {
//  //        stroke(255);
//  //    }
//  //    line(i* MULT, height3, i* MULT, height3 - fftLin.getBand(i)*spectrumScale);
//  //  }
    
//  //  fill(255, 128);
//  //  text("Spectrum Center Frequency: " + centerFrequency, 5, height3 - 25);
//  //}
  
//  //// no more outline, we'll be doing filled rectangles from now
//  //noStroke();
  
//  //// draw the linear averages
//  //{
//  //  // since linear averages group equal numbers of adjacent frequency bands
//  //  // we can simply precalculate how many pixel wide each average's 
//  //  // rectangle should be.
//  //  int w = int( width/fftLin.avgSize() );
//  //  for(int i = 0; i < fftLin.avgSize(); i++)
//  //  {
//  //    // if the mouse is inside the bounds of this average,
//  //    // print the center frequency and fill in the rectangle with red
//  //    if ( mouseX >= i*w && mouseX < i*w + w )
//  //    {
//  //      centerFrequency = fftLin.getAverageCenterFrequency(i);
        
//  //      fill(255, 128);
//  //      text("Linear Average Center Frequency: " + centerFrequency, 5, height23 - 25);
        
//  //      fill(255, 0, 0);
//  //    }
//  //    else
//  //    {
//  //        fill(255);
//  //    }
//  //    // draw a rectangle for each average, multiply the value by spectrumScale so we can see it better
//  //    rect(i*w* MULT, height23, i*w + w* MULT, height23 - fftLin.getAvg(i)*spectrumScale);
//  //  }
//  //}
  
//  // draw the logarithmic averages
//  {
//    // since logarithmically spaced averages are not equally spaced
//    // we can't precompute the width for all averages
//    for(int i = 0; i < fftLog.avgSize(); i++)
//    {
//      centerFrequency    = fftLog.getAverageCenterFrequency(i);
//      // how wide is this average in Hz?
//      float averageWidth = fftLog.getAverageBandWidth(i);   
      
//      // we calculate the lowest and highest frequencies
//      // contained in this average using the center frequency
//      // and bandwidth of this average.
//      float lowFreq  = centerFrequency - averageWidth/2;
//      float highFreq = centerFrequency + averageWidth/2;
      
//      // freqToIndex converts a frequency in Hz to a spectrum band index
//      // that can be passed to getBand. in this case, we simply use the 
//      // index as coordinates for the rectangle we draw to represent
//      // the average.
//      int xl = (int)fftLog.freqToIndex(lowFreq);
//      int xr = (int)fftLog.freqToIndex(highFreq);
      
//      // if the mouse is inside of this average's rectangle
//      // print the center frequency and set the fill color to red
//      if ( mouseX >= xl && mouseX < xr )
//      {
//        fill(255, 128);
//        text("Logarithmic Average Center Frequency: " + centerFrequency, 5, height - 25);
//        fill(255, 0, 0);
//      }
//      else
//      {
//          fill(255);
//      }
//      // draw a rectangle for each average, multiply the value by spectrumScale so we can see it better
//      rect( xl * MULT, height, xr * MULT, height - fftLog.getAvg(i)*spectrumScale );
//    }
//  }
//}
