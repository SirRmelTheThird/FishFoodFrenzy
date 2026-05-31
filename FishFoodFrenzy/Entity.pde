// Abstract parent class for all entities
abstract class Entity {
  float x, y, speed;
  int size;

  Entity(float x, float y, int size) {
    this.x = x;
    this.y = y;
    this.size = size;
    }
}
