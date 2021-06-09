class Person {
  
  private color c;
  private PVector position;
  private PVector oldPosition;
  private float stepSize;
  public boolean updated = false;
  
  
  public Person(int x, int y) {
    this.c = color(random(0, 360), 100, 100);
    this.position = new PVector(x, y);
  }
  
  public Person(Person p) {
    this.position = p.getPosition();
  }
  
  public void tick() {
    this.stepSize = dist(this.position.x, this.position.y, this.oldPosition.x, this.oldPosition.y);
    this.oldPosition = this.position;
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
  
  public void setPosition(PVector p) {
    this.oldPosition = new PVector(this.position.x, this.position.y);
    this.position = p;
  }
  
}
