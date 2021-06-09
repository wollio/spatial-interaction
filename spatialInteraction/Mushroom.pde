class Mushroom {
  
  int id;

  PVector position;
  float frquency;
  float amplitude;
  int personsInRange;
  
  float maxAmplitude = 0.05;
  float amplitudeStep = 0.005;
  
  Minim minim;
  Mixer mixer; 
  AudioOutput out;
  AudioPlayer player;
  Oscil sineOsc;
  
  boolean on = false;
  
  public Mushroom(Minim minim, Mixer.Info audioInterface, int mushroomId) {
    this.id = mushroomId;
    this.minim = minim;
    this.mixer = AudioSystem.getMixer(audioInterface);
    this.position = new PVector(0, 0);
    
    this.minim.setOutputMixer(this.mixer);
    
    this.out = minim.getLineOut(Minim.MONO, 1024, 44100, 16);
    
    println(out);
    
    this.sineOsc = new Oscil( 90.3f, 0.0, Waves.TRIANGLE );
    if (out != null) {
      this.sineOsc.patch(out);
    }
  }
  
  void render() {
    push();
    fill(60, 100, 100, 100);
    noStroke();
    circle(position.x, position.y, 60);
    noFill();
    stroke(60, 100, 100, 100);
    circle(position.x, position.y, alarmDist);
    
    if (personsInRange > 0 && this.amplitude < this.maxAmplitude ) {
      this.amplitude += this.amplitudeStep;
    } else if (personsInRange == 0 && this.amplitude > 0) {
      this.amplitude -= this.amplitudeStep;
    }
    
    this.setAmplitude(this.amplitude);
    
    fill(0, 0, 0);
    text(this.id + ": " + personsInRange, position.x, position.y);
    
    this.personsInRange = 0;
    
    pop();
  }
  
  void setAmplitude(float a) {
    sineOsc.setAmplitude(a);
  }
  
  void setFrequency(float f) {
    sineOsc.setFrequency(f);
  }
  
  void setPosition(int x, int y) {
    this.position.set(x, y);
  }
}
