int size = 500;
int boxSize = size/9;
int[][] board = new int[9][9];
int selR = -1, selC = -1;


void setup() {
  fullScreen(); 
  textAlign(CENTER, CENTER);
  textSize(boxSize*0.5);
  
  String[] puzzle = {
    "530070000",
    "600195000",
    "098000060",
    "800060003",
    "400803001",
    "700020006",
    "060000280",
    "000419005",
    "000080079"
  };
  
  for (int r=0; r<9; r++){
    for (int c=0; c<9; c++){
      board[r][c] = int(puzzle[r].charAt(c)-'0');
    }
  }
}

void draw() {
  background(255);
  drawTable();
  drawNumbers();
  drawSelected();
  drawButtons();
}

void drawTable() {
  stroke(0);
  for (int i=0; i<=9; i++) {
    strokeWeight(i%3==0 ? 5 : 1);
    line(i*boxSize,0,i*boxSize,size);
    line(0,i*boxSize,size,i*boxSize);
  }
}

void drawNumbers() {
  fill(0);
  for (int r=0; r<9; r++){
    for (int c=0; c<9; c++){
      int v = board[r][c];
      if(v!=0){
        text(v, c*boxSize+boxSize/2, r*boxSize+boxSize/2);
      }
    }
  }
}

void drawSelected() {
  if(selR>=0 && selC>=0){
    noFill();
    stroke(0,100,200);
    strokeWeight(3);
    rect(selC*boxSize, selR*boxSize, boxSize, boxSize);
  }
}

void drawButtons() {
  int btnSize = width/10;
  int y = height - btnSize*2;
  fill(200);
  stroke(0);
  for (int i=1; i<=9; i++) {
    int x = (i-1) % 5 * btnSize + btnSize/2;
    int yy = y + ((i-1)/5) * btnSize + btnSize/2;
    rectMode(CENTER);
    rect(x, yy, btnSize-10, btnSize-10, 10);
    fill(0);
    text(i, x, yy);
    fill(200);
  }

  rect(width-btnSize/2, y+btnSize/2, btnSize-10, btnSize-10, 10);
  fill(0);
  text("X", width-btnSize/2, y+btnSize/2);
  fill(200);
}

void touchStarted() {
  int c = mouseX/boxSize;
  int r = mouseY/boxSize;
  if(c>=0 && c<9 && r>=0 && r<9 && mouseY<size){
    selR = r;
    selC = c;
  } else {
    checkButtons(mouseX, mouseY);
  }
}

void checkButtons(int x, int y) {
  int btnSize = width/10;
  int yy = height - btnSize*2;
  for (int i=1; i<=9; i++) {
    int bx = (i-1) % 5 * btnSize;
    int by = yy + ((i-1)/5) * btnSize;
    if (x>bx && x<bx+btnSize && y>by && y<by+btnSize) {
      if(selR>=0 && selC>=0) {
        board[selR][selC] = i;
      }
    }
  }
  int bx = width-btnSize;
  int by = yy;
  if (x>bx && x<bx+btnSize && y>by && y<by+btnSize) {
    if(selR>=0 && selC>=0) {
      board[selR][selC] = 0;
    }
  }
}
