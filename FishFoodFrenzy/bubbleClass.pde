// Bubble Class
class Bubble extends Objects {
  float gravity = random(0.02);
  PImage bubble;

  Bubble(float x, float y, int size, PImage bubble) {
    super(x, y, size);
    this.bubble = bubble;
  }

  // Bubble moves up the screen
  void move() {
    
    // Randomly increase gravity
    speed -= gravity;
    y += speed;
    
    // Bubble displaced to the bottom of map
    if (y - size / 2 < -abs(Height)) {
      y = Height + height/2;
      speed = 0;
    }
  }

  // Display
  void display(float offsetW, float offsetH) {
    image(bubble, x+offsetW, y+offsetH, size, size);
  }
}
