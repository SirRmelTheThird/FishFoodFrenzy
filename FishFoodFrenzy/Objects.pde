// Abstract parent class for only objects
  abstract class Objects extends Entity {
    Objects(float x, float y, int size) {
      super(x, y, size);
  }
  
  // All Classes required to display
  abstract void display(float offsetW, float offsetH);
  
  
  // Collision
  boolean Collision(Player other) {
    
    // Stores player position
    float playerX = this.x + offsetW;
    float playerY = this.y + offsetH;
    // Return true if collided 
    return dist(playerX, playerY, other.x, other.y) <= this.size/1.5  + other.size/1.5;
  }
}
