// import everything necessary to make sound.
import ddf.minim.*;
import ddf.minim.ugens.*;

import javax.sound.sampled.*;
import javax.sound.sampled.Line;

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
  
    mixerInfo = AudioSystem.getMixerInfo();
  
  for(int i = 0; i < mixerInfo.length; i++)
  {
  println(i + " = " + mixerInfo[i].getName());
    
} 
  
  
  Mixer mixer = AudioSystem.getMixer(AudioSystem.getMixerInfo()[5]);
  println(mixer.getMixerInfo().getName());
  
  try {
    for (Line.Info lineInfo : mixer.getTargetLineInfo()) {
      Line thisLine = mixer.getLine(lineInfo);
      thisLine.open();
      println(lineInfo);
    }
  }
  catch(LineUnavailableException e) {
    e.printStackTrace();
    println(e);
  }
  
  //minim.setOutputMixer(mixer);
  
  out = minim.getLineOut(Minim.MONO, 1024, 44100, 16);;
  
  // play another note with the myNote object
  //out.playNote(3.5, 2.6, myNote );
  


  sineOsc = new Oscil( 60.3f, 0.9, Waves.TRIANGLE );
  sineOsc.patch(out);
  
}

void on() {
  on = true;
  sineOsc.setAmplitude(0.05);
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
