class PersonTracker {
  
  private ArrayList<Person> persons;
  
  public PersonTracker() {
      this.persons = new ArrayList<Person>();
  }
  
  /**
   * Handles the detections by deep vision
   */
  public void handleDetections(ResultList<ObjectDetectionResult> detections) {
    
    for (ObjectDetectionResult detection : detections) {
      if (detection.getClassName().equals("person")) {
        Float dist = null;
        int index = 0;
        
        Person newPerson = new Person(round(detection.getCenterX()), round(detection.getCenterY()));
        
        for(int i = 0; i < this.persons.size(); i++) {
          if (!this.persons.get(i).updated) {
            float currentDist = newPerson.distanceToPosition(this.persons.get(i).getPosition());
            if (dist == null || currentDist < dist) {
              dist = currentDist;
              index = i;
            }
          }
        }
        
        if (dist == null) {
          this.persons.add(new Person(round(detection.getCenterX()), round(detection.getCenterY())));
        } else {
          PVector p = new PVector(round(detection.getCenterX()), round(detection.getCenterY()));
          this.persons.get(index).setPosition(p);
        }
      }
      
      for (int i = this.persons.size()-1; i >= 0; i--){
          if (this.persons.get(i).isReadyForDeletion()){
              this.persons.remove(i);
          }
       }
    }
    
    this.displayPersons();
  }
  
  public ArrayList<Person> getPersons() {
    return this.persons;
  }
  
  public void displayPersons() {
    for (Person p : this.persons) {
       p.render(); 
    }
  }
}
