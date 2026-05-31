// Images for the game
PImage background;
PImage bubbleImg;
PImage itemImg;

//Obstacle Image
PImage[] obstacleImg = new PImage[2];

PImage nemoImg;
PImage nemoRightImg;
PImage nemoLeftImg;
PImage nemoUpImg;
PImage nemoDownImg;

// Mode of game
int gameMode;
final int MAIN_MENU = 0;
final int PLAYING = 1;
final int PAUSED = 2;
final int GAME_OVER = 3;

// Level of game
int gameLevel = 0;

// Initialise offset vaules for background
float offsetW = 0;
float offsetH = 0;

// Initialise pos vaules for objects in game
float xpos;
float ypos;

// Size of screen
float Width;
float Height;

// Player score & level
int score;
int level;

// Random size and speed for entities
int size;
int speed;
int randomIndex;

// Entity Arrays 
ArrayList<Entity> entities = new ArrayList<Entity>();

// Set to null
Player player = null;
Obstacle obstacle = null;
Bubble bubble = null;
Collectable collectables = null;

void setup() {
  fullScreen();
}

void gameSetup() {
  entities.clear();
  
  // Background image
  background = loadImage("bg.png");
  background.resize(displayWidth, displayHeight);
  
  // Objects images
  bubbleImg = loadImage("bubble.png");
  itemImg = loadImage("crab_meat.png");
  obstacleImg[0] = loadImage("pufferfishLeft.png");
  obstacleImg[1] = loadImage("pufferfishRight.png");
  
  // Player images
  nemoUpImg = loadImage("nemoUp.png");
  nemoDownImg = loadImage("nemoDown.png");
  nemoRightImg = loadImage("nemoRight.png");
  nemoLeftImg = loadImage("nemoLeft.png");
 
  
  // Initailise player
  entities.add(new Player(width/2, height/2, 1, nemoRightImg));
  for (int i = 0; i < entities.size(); i++) {
    if (entities.get(i) instanceof Player) {
      player = (Player) entities.get(i); 
      break; 
    }
  }
  
  // 250 of each object
  for (int i=0; i<200; i++)
  {  
     // Bacground grid
     for(int col=-5; col<5; col++) {
       for(int row=-5; row<5; row++) {
         image(background, width*col, height*row);
         
         // Random posistion for entities around the background
         xpos = (float) random(-width*col, width*col);
         ypos = (float) random(-height*row, height*row);
         
         // Store Grid Width and Height
         Width = displayWidth*col;
         Height = displayHeight*row;
       }
    }
    
    // Collectable size
    int coinSize = 30;
    
    // Random size and speed for entities
    size  = (int) random(60, 100);
    speed = (int) random(-25, 30);
    
    // Flick between two images
    randomIndex = (int) random(obstacleImg.length);
    
    // Add bubbles, obstacles and collectables to the array list
    entities.add(new Bubble(xpos, ypos, (int) random(30), bubbleImg));
    entities.add(new Obstacle(xpos, ypos, size, speed, obstacleImg[randomIndex]));
    entities.add(new Collectable(xpos, ypos, coinSize, itemImg));
  }
}

void draw() {
  gameOptions();
  switch(gameMode) {
    
    // Start menu
    case MAIN_MENU:
      gameSetup();
      Menu();
      break;
      
    case PLAYING:
    // Draw Image
      backgroundImage();
      for (int i = 0; i < entities.size(); i++) {
        Entity entity = entities.get(i);
        
        //  Get and displays Bubble
        if (entities.get(i) instanceof Bubble) {
          bubble = (Bubble) entity;
          bubble.display(offsetW, offsetH);
          bubble.move();
        }
        
        // Get and displays Obstacle
        else if (entities.get(i) instanceof Obstacle) {
          obstacle = (Obstacle) entity;
          obstacle.display(offsetW, offsetH);
          obstacle.move();
          
          // Ends game if player dies
          if(obstacle.Collision(player)){
            entities.remove(i);
            gameMode = GAME_OVER;
            i--;
          }
        }
        
        // Get and displays Collectable
        else if (entities.get(i) instanceof Collectable) {
          collectables = (Collectable) entity; 
          collectables.display(offsetW, offsetH);
          
          // Removes and add point to score
          if(collectables.Collision(player)){
            entities.remove(i);
            i--;
            score+=1;
            updateLevel();
          }
        }
      }
      
      // Save players info if exited while playing
      PrintWriter Playing = createWriter("playerInfo");
      Playing.println("Player: Exited Game");
      Playing.println("Score: " + score + "\nLevel: " + level);
      Playing.close();
      break;
    
    // Game over splash screen
    case GAME_OVER:
      textAlign(CENTER, CENTER);
      textSize(150);
      translate(width/2, height/2);
      fill(255, 0, 0);
      text("GAME OVER", 0, 0);
      
      // Save players info if player dies
      PrintWriter gameOver = createWriter("playerInfo");
      gameOver.println("Player: Defeated");
      gameOver.println("Score: " + score + "\nLevel: " + level);
      gameOver.close();
      
      // Exit game
      gameMode = MAIN_MENU;
      
      // Reset player info
      score = 0;
      level = 0;
      break;
    
    // Paused splash screen
    case PAUSED:
      textAlign(CENTER, CENTER);
      textSize(150);
      translate(width/2, height/2);
      text("GAME PAUSED", 0, 0);
      fill(0, 0, 40);
      
      // Save players info if exited while playing
      PrintWriter paused = createWriter("playerInfo");
      paused.println("Player: Exited Game");
      paused.print("Score: " + score + "\nLevel: " + level);
      paused.close();
      
      break;
  }
}

void backgroundImage() {
  
  // Center background image
  imageMode(CENTER);
  
  // Create background grid
  for(int col=-5; col<5; col++) {
    for(int row=-5; row<5; row++) {
      image(background, offsetW+(width*col), offsetH+(height*row));
      HUD();
    }
  } 
  
  // Boundaries for player
  offsetW = constrain(offsetW, -abs(Width - player.x - 5), Width - player.x - 5);
  offsetH = constrain(offsetH, -abs(Height - player.y - 5), Height - player.y - 5);
  

  keyPressed();
}

void keyPressed() {
  
  // Movement of background & Flip player image
  if (keyCode == UP || key == 'w' || key == 'W') {
    nemoImg = nemoUpImg;
    offsetH = offsetH + 5;
    
  } else if (keyCode == DOWN || key == 's' || key == 'S') {
    nemoImg = nemoDownImg;
    offsetH = offsetH - 5;
    
  } else if (keyCode == RIGHT || key == 'd' || key == 'D') {
    nemoImg = nemoRightImg;
    offsetW = offsetW - 5;
    
  } else if (keyCode == LEFT || key == 'a' || key == 'A') {
    nemoImg = nemoLeftImg;
    offsetW = offsetW + 5;
  }
  
  // Render roatated player image
  player.renderRotated(nemoImg);
}


void updateLevel() {
  switch(gameLevel) {
    case 0:
      
      //Update level
      if (score >= 5) {
        gameLevel = 1;
        level+=1;
        addObstacles(20);
      }
      break;
    
    case 1:
      if (score >= 15) {
        gameLevel = 2;
        level+=1;
        addObstacles(40);
      }
      break;
    
    case 2: 
      if (score >= 40) {
        gameLevel = 3;
        level+=1;     
        addObstacles(60);
      }
      break;
    
    case 3:
      if (score >= 70) {
        gameLevel = 4;
        level+=1;
        addObstacles(200);
      }
      break;
  }
}

void addObstacles(int num) {
  for (int i = 0; i < num; i++) {
    
    // Random size and speed for entities
    int new_size  = (int) random(60, 120);
    int new_speed = (int)  random(-25, 30);
    
    // Add new pos for objects
    float new_xpos = random(-abs(Width), Width);
    float new_ypos = random(-abs(Height), Height);
    
    entities.add(new Obstacle(new_xpos, new_ypos, new_size, new_speed, obstacleImg[randomIndex]));
  }
}

// Head up display
void HUD() {
  textAlign(LEFT, TOP);
  textSize(40);
  fill(255, 255, 255);
  text("LEVEL: " + level + "\nSCORE: " + score, 60, 60);
  
  textAlign(LEFT, BOTTOM);
  textSize(10);
  text("PRESS P TO PAUSE GAME \nPRESS R TO PAUSE GAME \nPRESS ESC TO EXIT GAME", 25, height - 25);
}

// Select Game Mode
void gameOptions() {
  
  //PLAY
  if  (gameMode != PAUSED) {
    if (keyCode == ENTER) {
      gameMode = PLAYING;
    }
  }
  
  // PAUSE GAME
  if (gameMode == PLAYING) {
    if (key == 'P' || key == 'p') {
      gameMode = PAUSED;
    }
  }
  
  // RESUME GAME 
  if (gameMode == PAUSED) {
    if (key == 'R' || key == 'r') {
        gameMode = PLAYING;
    }
  }
}


// Main Menu
void Menu() {
  
  imageMode(CORNER);
  image(background, 0, 0, width, height);
  
  textAlign(CENTER, CENTER);
  textSize(60);
  translate(width/2, height/2);
  fill(255, 255, 255);
  text("PRESS 'ENTER' KEY TO START", 0, 0);
}
