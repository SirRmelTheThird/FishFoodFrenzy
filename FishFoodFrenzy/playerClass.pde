// Player Classs
class Player extends Entity
{
  PImage nemoOriginal;

  Player(float x, float y, int size, PImage nemoOriginal)
  {
    super(x, y, size);
    this.nemoOriginal = nemoOriginal;
  }
  
  // Rotate selected image
  void renderRotated(PImage nemo) {
    if (gameMode == PLAYING) {
      if (nemo != null)
        image(nemo, x, y, nemo.width, nemo.height);
      else {
        image(nemoOriginal, x, y, nemoOriginal.width, nemoOriginal.height); // Use this if image doesnt load
      }
    }
  }
}
