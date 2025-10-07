int sizeBoard = 500;
int boxSize = sizeBoard / 9;
int[][] board = new int[9][9];
int selR = -1, selC = -1;

void setup() {
  size(500, 650);
  textAlign(CENTER, CENTER);
  textSize(boxSize * 0.5);

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

  for (int r = 0; r < 9; r++) {
    for (int c = 0; c < 9; c++) {
      board[r][c] = int(puzzle[r].charAt(c) - '0');
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
  for (int i = 0; i <= 9; i++) {
    strokeWeight(i % 3 == 0 ? 4 : 1);
    line(i * boxSize, 0, i * boxSize, sizeBoard);
    line(0, i * boxSize, sizeBoard, i * boxSize);
  }
}

void drawNumbers() {
  fill(0);
  for (int r = 0; r < 9; r++) {
    for (int c = 0; c < 9; c++) {
      int v = board[r][c];
      if (v != 0) {
        text(v, c * boxSize + boxSize / 2, r * boxSize + boxSize / 2);
      }
    }
  }
}

void drawSelected() {
  if (selR >= 0 && selC >= 0) {
    noFill();
    stroke(0, 100, 200);
    strokeWeight(3);
    rect(selC * boxSize, selR * boxSize, boxSize, boxSize);
  }
}

void drawButtons() {
  int btnSize = width / 10;
  int y = sizeBoard + 30;
  fill(220);
  stroke(0);
  rectMode(CENTER);
  textSize(24);

  for (int i = 1; i <= 9; i++) {
    int x = (i - 1) % 5 * btnSize + btnSize / 2 + 20;
    int yy = y + ((i - 1) / 5) * (btnSize + 10);
    fill(200);
    rect(x, yy, btnSize - 10, btnSize - 10, 10);
    fill(0);
    text(i, x, yy);
  }

  int xX = width - btnSize;
  int yX = y;
  fill(255, 150, 150);
  rect(xX, yX, btnSize - 10, btnSize - 10, 10);
  fill(0);
  text("X", xX, yX);
}

void mousePressed() {
  int c = mouseX / boxSize;
  int r = mouseY / boxSize;

  if (c >= 0 && c < 9 && r >= 0 && r < 9 && mouseY < sizeBoard) {
    selR = r;
    selC = c;
  } else {
    checkButtons(mouseX, mouseY);
  }
}

void checkButtons(int x, int y) {
  int btnSize = width / 10;
  int yy = sizeBoard + 30;


  for (int i = 1; i <= 9; i++) {
    int bx = (i - 1) % 5 * btnSize + 20;
    int by = yy + ((i - 1) / 5) * (btnSize + 10);
    if (x > bx && x < bx + btnSize && y > by - btnSize / 2 && y < by + btnSize / 2) {
      if (selR >= 0 && selC >= 0) {
        board[selR][selC] = i;
      }
    }
  }

  int bx = width - btnSize;
  int by = yy;
  if (x > bx - btnSize / 2 && x < bx + btnSize / 2 && y > by - btnSize / 2 && y < by + btnSize / 2) {
    if (selR >= 0 && selC >= 0) {
      board[selR][selC] = 0;
    }
  }
}
