Grid grid;
boolean playerWhite = true;

void setup() {
  size(800, 600);
  background(#228b22);
  grid = new Grid();
  grid.markDeniedSquares();
}

void draw() {
  background(#228b22);
  grid.drawGrid();
  grid.drawPieces();
  
  pushStyle();
  fill(0);
  textAlign(RIGHT);
  if (playerWhite) {
    text("White turn", width - 10, height - 10);
  } else {
    text("Black turn", width - 10, height - 10);
  }
  popStyle();
  
  endGame(grid.gameEnd);
}

class Grid {
  float size;
  int segments = 8;
  int[][] pieces = new int[this.segments][this.segments];
  
  float xDiff = 0, yDiff = 0, squareSize;
  
  boolean gameEnd;
  
  Grid() {
    this.size = min(width, height);
    for (int x = 0; x < this.segments; x++) {
      for (int y = 0; y < this.segments; y++) {
        this.pieces[x][y] = 0;
      }
    }
    
    // Setup the board
    this.pieces[3][3] = 1;
    this.pieces[4][3] = 2;
    this.pieces[3][4] = 2;
    this.pieces[4][4] = 1;
    
    float diff = abs(width - height)/2;
    this.squareSize = this.size/this.segments;
    
    if (width > height) {
      this.xDiff = diff;
    } else {
      this.yDiff = diff;
    }
  }
  
  void drawGrid() {
    for (int y = 0; y < this.segments; y++) {
      for (int x = 0; x < this.segments; x++) {
        square((x * this.squareSize) + xDiff, (y * this.squareSize) + yDiff, this.squareSize);
      }
    }
  }
  
  int[] getSquare(float x, float y) {
    float xCoord = (x - xDiff)/this.squareSize;
    float yCoord = (y - yDiff)/this.squareSize;
    
    xCoord = constrain(xCoord, 0, this.segments-1);
    yCoord = constrain(yCoord, 0, this.segments-1);
    
    return new int[] {(int)xCoord, (int)yCoord};
  }
  
  boolean isValid(float x, float y) {
    int xCoord = getSquare(x, y)[0];
    int yCoord = getSquare(x, y)[1];
    
    xCoord = constrain(xCoord, 0, this.segments-1);
    yCoord = constrain(yCoord, 0, this.segments-1);
    
    if (this.pieces[xCoord][yCoord] == 0) {
      return true;
    }
    return false;
  }
  
  void placePiece(float x, float y) {
    int xCoord = getSquare(x, y)[0];
    int yCoord = getSquare(x, y)[1];
    if (playerWhite) {
      this.pieces[xCoord][yCoord] = 1;
    } else {
      this.pieces[xCoord][yCoord] = 2;
    }
  }
  
  void drawPieces() {
    pushStyle();
    for (int x = 0; x < this.segments; x++) {
      for (int y = 0; y < this.segments; y++) {
        float X = (x * this.squareSize) + xDiff;
        float Y = (y * this.squareSize) + yDiff;
        float placeX = (getSquare(X, Y)[0] * this.squareSize) + xDiff + this.squareSize/2;
        float placeY = (getSquare(X, Y)[1] * this.squareSize) + yDiff + this.squareSize/2;
        if (this.pieces[x][y] == 1) {
          fill(255);
          circle(placeX, placeY, this.squareSize/2);
        } else if (this.pieces[x][y] == 2) {
          fill(0);
          circle(placeX, placeY, this.squareSize/2);
        }
      }
    }
    popStyle();
  }
  
  void changePieces(float xRef, float yRef) {
    int col;
    if (playerWhite) {
      col = 1;
    } else {
      col = 2;
    }
    
    int xCoord = getSquare(xRef, yRef)[0];
    int yCoord = getSquare(xRef, yRef)[1];
    int x = xCoord, y = yCoord;
    
    ArrayList<int[]> coords = new ArrayList<int[]>();
    
    // Left Check
    while (x > 0) {
      x--;
      if (this.pieces[x][yCoord] == 0 || this.pieces[x][yCoord] == -1) {
        break;
      } else if (this.pieces[x][yCoord] == 3 - col) {
        coords.add(new int[] {x, yCoord});
        continue;
      } else {
        for (int[] coord : coords) {
          this.pieces[coord[0]][coord[1]] = col;
        }
        break;
      }
    }
    coords.clear();
    // END
    x = xCoord;
    y = yCoord;
    // Left-Up Check
    while (x > 0 && y > 0) {
      x--;
      y--;
      if (this.pieces[x][y] == 0) {
        break;
      } else if (this.pieces[x][y] == 3 - col) {
        coords.add(new int[] {x, y});
        continue;
      } else {
        for (int[] coord : coords) {
          this.pieces[coord[0]][coord[1]] = col;
        }
        break;
      }
    }
    coords.clear();
    // END
    x = xCoord;
    y = yCoord;
    // Up Check
    while (y > 0) {
      y--;
      if (this.pieces[xCoord][y] == 0) {
        break;
      } else if (this.pieces[xCoord][y] == 3 - col) {
        coords.add(new int[] {xCoord, y});
        continue;
      } else {
        for (int[] coord : coords) {
          this.pieces[coord[0]][coord[1]] = col;
        }
        break;
      }
    }
    coords.clear();
    // END
    x = xCoord;
    y = yCoord;
    // Right-Up Check
    while (x < this.segments-1 && y > 0) {
      x++;
      y--;
      if (this.pieces[x][y] == 0) {
        break;
      } else if (this.pieces[x][y] == 3 - col) {
        coords.add(new int[] {x, y});
        continue;
      } else {
        for (int[] coord : coords) {
          this.pieces[coord[0]][coord[1]] = col;
        }
        break;
      }
    }
    coords.clear();
    // END
    x = xCoord;
    y = yCoord;
    // Right Check
    while (x < this.segments-1) {
      x++;
      if (this.pieces[x][yCoord] == 0) {
        break;
      } else if (this.pieces[x][yCoord] == 3 - col) {
        coords.add(new int[] {x, yCoord});
        continue;
      } else {
        for (int[] coord : coords) {
          this.pieces[coord[0]][coord[1]] = col;
        }
        break;
      }
    }
    coords.clear();
    // END
    x = xCoord;
    y = yCoord;
    // Right-Down Check
    while (x < this.segments-1 && y < this.segments-1) {
      x++;
      y++;
      if (this.pieces[x][y] == 0) {
        break;
      } else if (this.pieces[x][y] == 3 - col) {
        coords.add(new int[] {x, y});
        continue;
      } else {
        for (int[] coord : coords) {
          this.pieces[coord[0]][coord[1]] = col;
        }
        break;
      }
    }
    coords.clear();
    // END
    x = xCoord;
    y = yCoord;
    // Down Check
    while (y < this.segments-1) {
      y++;
      if (this.pieces[xCoord][y] == 0) {
        break;
      } else if (this.pieces[xCoord][y] == 3 - col) {
        coords.add(new int[] {xCoord, y});
        continue;
      } else {
        for (int[] coord : coords) {
          this.pieces[coord[0]][coord[1]] = col;
        }
        break;
      }
    }
    coords.clear();
    // END
    x = xCoord;
    y = yCoord;
    // Left-Down Check
    while (x > 0 && y < this.segments-1) {
      x--;
      y++;
      if (this.pieces[x][y] == 0) {
        break;
      } else if (this.pieces[x][y] == 3 - col) {
        coords.add(new int[] {x, y});
        continue;
      } else {
        for (int[] coord : coords) {
          this.pieces[coord[0]][coord[1]] = col;
        }
        break;
      }
    }
    coords.clear();
    // END
    x = xCoord;
    y = yCoord;
    // Make surrounding squares available if '-1'.
    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        if (x + i < 0 || x + i > this.segments - 1 || y + j < 0 || y + j > this.segments - 1) {
          continue;
        }
        if (this.pieces[x+i][y+j] == -1) {
          this.pieces[x+i][y+j] = 0;
        }
      }
    }
  }
  
  void markDeniedSquares() {
    for (int i = 0; i < this.segments; i++) {
      for (int j = 0; j < this.segments; j++) {
        if (i == 0 || i == 1 || i == this.segments - 2 || i == this.segments - 1
        || j == 0 || j == 1 || j == this.segments - 2 || j == this.segments - 1) {
          this.pieces[i][j] = -1;
        }
      }
    }
  }
}

void endGame(boolean win) {
  if (win) {
    declareWinner();
    stop();
  }
}

void checkWinner() {
  grid.gameEnd = false;
  for (int i = 0; i < grid.segments; i++) {
    for (int j = 0; j < grid.segments; j++) {
      if (grid.pieces[i][j] == 0) {
        return;
      }
    }
  }
  grid.gameEnd = true;
}

void declareWinner() {
  int whiteCount = 0, blackCount = 0;
  for (int i = 0; i < grid.segments; i++) {
    for (int j = 0; j < grid.segments; j++) {
      if (grid.pieces[i][j] == 1) {
        whiteCount++;
      } else if (grid.pieces[i][j] == 2) {
        blackCount++;
      }
    }
  }
  pushStyle();
  textSize(41);
  textAlign(CENTER);
  fill(#000000);
  if (whiteCount > blackCount) {
    text("White WINS!", width/2, height/2);
  } else if (whiteCount < blackCount) {
    text("Black WINS!", width/2, height/2);
  } else {
    text("DRAW!", width/2, height/2);
  }
  popStyle();
  pushStyle();
  textSize(40);
  textAlign(CENTER);
  fill(#ffd700);
  if (whiteCount > blackCount) {
    text("White WINS!", width/2, height/2);
  } else if (whiteCount < blackCount) {
    text("Black WINS!", width/2, height/2);
  } else {
    text("DRAW!", width/2, height/2);
  }
  popStyle();
}

void mousePressed() {
  float x = mouseX;
  float y = mouseY;
  if (grid.isValid(x, y)) {
      grid.placePiece(x, y);
      grid.changePieces(mouseX, mouseY);
      playerWhite = !playerWhite;
  }
  checkWinner();
}

void keyPressed() {
  if (key == 'i') {
    println(grid.getSquare(mouseX, mouseY)[0], grid.getSquare(mouseX, mouseY)[1]);
  }
  if (key == 'c') {
    for (int i = 0; i < 5; i++) {
      println();
    }
  }
}
