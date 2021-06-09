// import everything necessary to make sound.
import ddf.minim.*;
import ddf.minim.ugens.*;

import javax.sound.sampled.*;

import processing.net.*;

// create all of the variables that will need to be accessed in
// more than one methods (setup(), draw(), stop()).
Minim minim;
AudioOutput out;

Mixer.Info[] mixerInfo;
Oscil sineOsc;
Server myServer;

boolean muted = true;

float freq = 100.0;
float ampl = 0.1;


// setup is run once at the beginning
void setup()
{
  // initialize the drawing window
  size( 512, 200, P2D );
  
  myServer = new Server(this, 5204);

  // initialize the minim and out objects
  minim = new Minim( this );
  out = minim.getLineOut( Minim.MONO, 2048 );
  
  // play another note with the myNote object
  //out.playNote(3.5, 2.6, myNote );
  
  mixerInfo = AudioSystem.getMixerInfo();
 
  for(int i = 0; i < mixerInfo.length; i++)
  {println(i + " = " + mixerInfo[i].getName());} 
  
  sineOsc = new Oscil( 587.3f, 0.9, Waves.TRIANGLE );
  sineOsc.patch(out);
}

// draw is run many times
void draw()
{
  // erase the window to black
  background( 0 );
  // draw using a white stroke
  stroke( 255 );
  
  //float freq = map(mouseX, 0, width, 1, 20154);
  sineOsc.setFrequency(90f);
  
  String input;
  int[] data;
  float amplitude = 0f;
  Client c = myServer.available();
  
  if (c != null) {
    input = c.readString(); 
    input = input.substring(0, input.indexOf("\n"));  // Only up to the newline
    data = int(split(input, ':'));  // Split values into an array
    // Draw line using received coords
    //stroke(0);
    println(input);
    amplitude = map(data[2], 0, 300, 0, 0.3);
    
  }
  
  if (muted) {
    sineOsc.setAmplitude(0f);
  } else {
    sineOsc.setAmplitude(amplitude);
  }
   
}

void keyPressed() {
  //77 = m
  if (keyCode == 77) {
    muted = !muted;
  }
  println(muted);
}
