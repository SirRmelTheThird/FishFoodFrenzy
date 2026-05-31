// Collectables Class
class Collectable extends Objects {
  PImage item;

  Collectable(float x, float y, int size, PImage item) {
    super(x, y, size);
    this.item = item;
  }
  
  //Display
  void display(float offsetW, float offsetH) {
    image(item, x+offsetW, y+offsetH, size, size);
  }
}
