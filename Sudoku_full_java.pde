int sizeBoard = 500;
int boxSize = sizeBoard / 9;
int[][] board = new int[9][9];
int[][] ownerBoard = new int[9][9];
boolean[][] wrong = new boolean[9][9];
int wrongCount = 0;
int selR = -1, selC = -1;

int player = 1;
color[] colors = {color(0), color(0,150,255), color(0,200,100)};

void setup() {
    size(500, 650);
    textAlign(CENTER, CENTER);
    textSize(boxSize * 0.5);
    selectInput("Select a Sudoku file:", "fileSelected");
    for (int r = 0; r < 9; r++) {
        for (int c = 0; c < 9; c++) {
            wrong[r][c] = false;
        }
    }
}

void fileSelected(File selection) {
    if (selection == null) {
        println("No file selected.");
    } else {
        String[] puzzle = loadStrings(selection.getAbsolutePath());
        for (int r = 0; r < 9; r++) {
            for (int c = 0; c < 9; c++) {
                board[r][c] = int(puzzle[r].charAt(c) - '0');
                ownerBoard[r][c] = 0;
            }
        }
        checkSolution();
    }
}

void draw() {
    background(255);
    drawTable();
    drawNumbers();
    drawWrong();
    drawSelected();
    drawButtons();
    fill(0);
    textSize(18);
    text("Current Player: " + player + " (A=1 / L=2)", width/2, sizeBoard + 10);
    if (wrongCount > 0) {
        fill(255, 0, 0);
        text("Errors: " + wrongCount, width/2, sizeBoard + 30);
    } else {
        fill(0, 150, 0);
        text("No errors!", width/2, sizeBoard + 30);
    }
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
    textAlign(CENTER, CENTER);
    textSize(boxSize * 0.5);
    for (int r = 0; r < 9; r++) {
        for (int c = 0; c < 9; c++) {
            int v = board[r][c];
            if (v != 0) {
                if (wrong[r][c]) {
                    fill(255, 0, 0); // red for wrong
                } else if (ownerBoard[r][c] != 0) {
                    fill(colors[ownerBoard[r][c]]);
                } else {
                    fill(0);
                }
                text(v, c * boxSize + boxSize / 2, r * boxSize + boxSize / 2);
            }
        }
    }
}

void drawSelected() {
    if (selR >= 0 && selC >= 0) {
        noFill();
        stroke(colors[player]);
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
                ownerBoard[selR][selC] = player;
                checkSolution(); // immediate re-check after change
            }
        }
    }

    int bx = width - btnSize;
    int by = yy;
    if (x > bx - btnSize / 2 && x < bx + btnSize / 2 && y > by - btnSize / 2 && y < by + btnSize / 2) {
        if (selR >= 0 && selC >= 0) {
            board[selR][selC] = 0;
            ownerBoard[selR][selC] = 0;
            checkSolution();
        }
    }
}

void keyPressed() {
    if (key == 'A') player = 1;
    if (key == 'L') player = 2; 
    if (keyCode == ENTER) checkSolution();
}

void checkSolution() {
    for (int r = 0; r < 9; r++) {
        for (int c = 0; c < 9; c++) {
            wrong[r][c] = false;
        }
    }

    for (int r = 0; r < 9; r++) {
        for (int c = 0; c < 9; c++) {
            int val = board[r][c];
            if (val == 0) continue;

            for (int i = 0; i < 9; i++) {
                if (i != c && board[r][i] == val) {
                    wrong[r][c] = true;
                    wrong[r][i] = true;
                }
            }

            for (int j = 0; j < 9; j++) {
                if (j != r && board[j][c] == val) {
                    wrong[r][c] = true;
                    wrong[j][c] = true;
                }
            }

            int startR = (r / 3) * 3;
            int startC = (c / 3) * 3;
            for (int i = 0; i < 3; i++) {
                for (int j = 0; j < 3; j++) {
                    int rr = startR + i;
                    int cc = startC + j;
                    if ((rr != r || cc != c) && board[rr][cc] == val) {
                        wrong[r][c] = true;
                        wrong[rr][cc] = true;
                    }
                }
            }
        }
    }

    // count wrong cells
    int count = 0;
    for (int r = 0; r < 9; r++) {
        for (int c = 0; c < 9; c++) {
            if (wrong[r][c]) count++;
        }
    }
    wrongCount = count;

    if (wrongCount == 0) {
        println("No duplicates found. Good job!");
    } else {
        println("Found " + wrongCount + " incorrect cell(s)!");
    }
}

void drawWrong() {
    noFill();
    stroke(255, 0, 0);
    strokeWeight(3);
    for (int r = 0; r < 9; r++) {
        for (int c = 0; c < 9; c++) {
            if (wrong[r][c]) {
                rect(c * boxSize, r * boxSize, boxSize, boxSize);
            }
        }
    }
}

