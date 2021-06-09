import ch.bildspur.vision.*;
import ch.bildspur.vision.result.*;

import processing.core.PApplet;
import processing.core.PConstants;
import processing.core.PImage;
import processing.video.Capture;
import processing.net.*;

import java.util.ArrayList;

Capture cam;
Client myClient; 
DeepVision deepVision = new DeepVision(this);
YOLONetwork yolo;
ResultList<ObjectDetectionResult> detections;
PersonTracker tracker;

int textSize = 12;
int camIndex = 0;
int clientId = 0;

public void setup() {
  size(640, 480, FX2D);

  colorMode(HSB, 360, 100, 100);

  println("creating model...");
  yolo = deepVision.createYOLOv4Tiny();

  println("loading yolo model...");
  yolo.setup();
  
  String[] cameras = Capture.list();
  printArray(cameras);
  
  clientId = round(random(0, 1000));
  tracker = new PersonTracker();
  myClient = new Client(this, "127.0.0.1", 5204);

  cam = new Capture(this, cameras[1]);
  cam.start();
}

public void draw() {
  background(55);

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
  if (keyCode == 68) {
    chooseCam();
  }
  
  //49 --> 1
  //50 --> 2
  //51 --> 3
  
  if (keyCode == 49) {
    sendMouseLocation(0);
  }
  
  if (keyCode == 50) {
    sendMouseLocation(1);
  }
  
  if (keyCode == 51) {
    sendMouseLocation(2);
  }
}

void sendMouseLocation(int spotNumber) {
  myClient.write("spotNumber" + ":" + spotNumber + ":" + mouseX + ":" + mouseY);
}
