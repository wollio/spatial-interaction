class Person {
  
  private color c;
  private PVector position;
  private PVector oldPosition;
  private float stepSize;
  public boolean updated = false;
  public int emptyTicks = 25;
  
  public Person(int x, int y) {
    this.c = color(random(0, 360), 100, 100);
    this.position = new PVector(x, y);
  }
  
  public Person(Person p) {
    this.position = p.getPosition();
  }
  
  public void tick() {
    if (this.oldPosition != null && this.position != null) {
      this.stepSize = dist(this.position.x, this.position.y, this.oldPosition.x, this.oldPosition.y);
    }
    this.oldPosition = this.position;

    //if not updated
    if (!this.updated) {
      this.emptyTicks--;
    } else {
      this.emptyTicks = 25;
    }
    
    this.updated = false;
  }
  
  public float distanceToPosition(PVector p) {
    return dist(this.position.x, this.position.y, p.x, p.y);
  }
  
  public void render() {
    push();
    fill(this.c);
    circle(this.position.x, this.position.y, 20);
    pop();
    this.tick();
  }
  
  public float getStepSize() {
    return this.stepSize;
  }
  
  public PVector getPosition() {
    return this.position;
  }
  
  public boolean isReadyForDeletion() {
    return this.emptyTicks < 1;
  }
  
  public void setPosition(PVector p) {
    this.oldPosition = new PVector(this.position.x, this.position.y);
    this.position = p;
    this.updated = true;
  }
}
