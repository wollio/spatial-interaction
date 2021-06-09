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
        
        for(int i = 0; i < this.persons.size(); i++) {
          if (!this.persons.get(i).updated) {
            float currentDist = newPerson.distanceToPerson(this.persons.get(i));
            if (dist == null || currentDist < dist) {
              dist = currentDist;
              index = i;
            }
          }
        }
      }
    }
    
    this.displayPersons();
  }
  
  public void displayPersons() {
    for (Person p : this.persons) {
       p.render(); 
    }
  }
}
