// Obstacle Class
class Obstacle extends Objects {
  float offset;
  color colour;
  int speed;
  PImage obstacle;

  Obstacle(float x, float y, int size, int speed, PImage obstacle)
  {
    super(x, y, size);
    this.speed = speed;
    this.obstacle = obstacle;
  }
  
  // Display
  void display(float offsetW, float offsetH) {
    image(obstacle, x+offsetW, y+offsetH, size, size/1.2);
  }
  
  // Move
  void move() {
    x += random(speed)*0.5;
    y += random(speed)*0.5;
    
    // Bounce off right or left edge of screen
    if (x < -abs(Width) || x > Width) {
      speed = speed *-1;
    }
    
    // Bounce off top or bottom of screen
    if (y < -abs(Height) || y > Height) {
      speed = speed *-1;
    }
  }
}
