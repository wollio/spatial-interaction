// import everything necessary to make sound.
import ddf.minim.*;
import ddf.minim.ugens.*;

import javax.sound.sampled.*;

// create all of the variables that will need to be accessed in
// more than one methods (setup(), draw(), stop()).
Minim minim;
AudioOutput out;

Mixer.Info[] mixerInfo;
Oscil sineOsc;

boolean on = false;

void setup() {

  // initialize the minim and out objects
  minim = new Minim( this );
  out = minim.getLineOut( Minim.MONO, 2048 );
  
  // play another note with the myNote object
  //out.playNote(3.5, 2.6, myNote );
  
  mixerInfo = AudioSystem.getMixerInfo();
 
  for(int i = 0; i < mixerInfo.length; i++)
  {println(i + " = " + mixerInfo[i].getName());} 
  
  sineOsc = new Oscil( 60.3f, 0.9, Waves.TRIANGLE );
  sineOsc.patch(out);
  
}

void on() {
  on = true;
  sineOsc.setAmplitude(0.1);
}

void off() {
  on = false;
  sineOsc.setAmplitude(0);
}


void draw() {
//nothing  
off();
}

void keyPressed() {
  
  on();
  sineOsc.setFrequency(keyCode + 20);
  delay(50);
  off();
}
