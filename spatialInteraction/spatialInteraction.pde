// import everything necessary to make sound.
import javax.sound.sampled.*;
import java.util.ArrayList;

import ddf.minim.*;
import ddf.minim.ugens.*;

import ch.bildspur.vision.*;
import ch.bildspur.vision.result.*;

import processing.core.PApplet;
import processing.core.PConstants;
import processing.core.PImage;
import processing.video.Capture;

// create all of the variables that will need to be accessed in
// more than one methods (setup(), draw(), stop()).
Capture cam;
DeepVision deepVision = new DeepVision(this);
YOLONetwork yolo;
ResultList<ObjectDetectionResult> detections;
PersonTracker tracker;

boolean muted = true;

float freq = 100.0;
float ampl = 0.1;

int textSize = 12;
int camIndex = 0;
int clientId = 0;

int alarmDist = 120;

ArrayList<Mushroom> mushrooms = new ArrayList<Mushroom>();

// setup is run once at the beginning
void setup()
{
  // initialize the drawing window
  size(640, 480, FX2D);

  colorMode(HSB, 360, 100, 100);
  
  Mixer.Info[] mixerInfo = AudioSystem.getMixerInfo();
  int mushroomId = 0;
  for(int i = 0; i < mixerInfo.length; i++) {
    println(i + " = " + mixerInfo[i].getName());
    if (mixerInfo[i].getName().equals("Gigaport 1") || mixerInfo[i].getName().equals("Gigaport 2") || mixerInfo[i].getName().equals("Gigaport 3")) {
      mushrooms.add(new Mushroom(new Minim(this), mixerInfo[i], mushroomId));
      mushroomId++;
    }
  }
 
  println("creating model...");
  yolo = deepVision.createYOLOv4Tiny();

  println("loading yolo model...");
  yolo.setup();
  
  String[] cameras = Capture.list();
  printArray(cameras);
  
  tracker = new PersonTracker();

  cam = new Capture(this, cameras[1]);
  cam.start();
}

// draw is run many times
void draw()
{
  // erase the window to black
  background( 0 );
  
  if (cam.available()) {
    cam.read();
  }

  image(cam, 0, 0);

  if (cam.width == 0) {
    return;
  }

  yolo.setConfidenceThreshold(0.2f);
  detections = yolo.run(cam);

  strokeWeight(3f);
  textSize(textSize);
  
  for (ObjectDetectionResult detection : detections) {
    int hue = (int)(360.0 / yolo.getLabels().size() * detection.getClassId());

    noFill();
    stroke(hue, 80, 100);
    rect(detection.getX(), detection.getY(), detection.getWidth(), detection.getHeight());

    fill(hue, 80, 100);
    rect(detection.getX(), detection.getY() - (textSize + 3), textWidth(detection.getClassName()) + 4, textSize + 3);

    fill(0);
    textAlign(LEFT, TOP);
    text(detection.getClassName(), detection.getX() + 2, detection.getY() - textSize - 3);
  }
  
  tracker.handleDetections(detections);

  surface.setTitle("Webcam YOLO Test - FPS: " + Math.round(frameRate));
  
  for (Person p : this.tracker.getPersons()) {
    for (Mushroom m : this.mushrooms) {
      if (p.getPosition().dist(m.position) < alarmDist) {
        m.personsInRange++;
      }
    }
  }
  
  for (Mushroom m : this.mushrooms) {
    m.render();
  }
  
}

void chooseCam() {
  cam.stop();
  String[] cameras = Capture.list();
  printArray(cameras);
  println(camIndex);
  camIndex++;
  if (camIndex > cameras.length - 1) {
     camIndex = 0;
  }
  cam = new Capture(this, cameras[camIndex]);
  cam.start();
}

void keyPressed() {
  //77 = m
  if (keyCode == 77) {
    muted = !muted;
  }
  
  if (keyCode == 68) {
    chooseCam();
  }
  
  if (keyCode == 49) {
    setMushroomLocation(0);
  }
  
  if (keyCode == 50) {
    setMushroomLocation(1);
  }
  
  if (keyCode == 51) {
    setMushroomLocation(2);
  }
  
}

void setMushroomLocation(int spotNumber) {
  
  for (Mushroom m : this.mushrooms) {
    if (m.id == spotNumber) {
      m.setPosition(mouseX, mouseY);
    }
  }
  
  println(mouseX + " "+ mouseY);
}
