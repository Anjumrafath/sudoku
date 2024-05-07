import 'dart:math';

class SudokuGenerator {
  late List<List<int>> board;

  SudokuGenerator() {
    board = List.generate(9, (_) => List<int>.filled(9, 0));
  }

  void generate() {
    _fillBoard(0, 0);
    _removeCells();
  }

  void _fillBoard(int row, int col) {
    if (row == 9) {
      return; // Reached end of the board
    }

    int nextRow = col == 8 ? row + 1 : row;
    int nextCol = (col + 1) % 9;

    for (int num = 1; num <= 9; num++) {
      if (_isValidMove(row, col, num)) {
        board[row][col] = num;
        _fillBoard(nextRow, nextCol);
        if (!_hasEmptyCells() && _isUniqueSolution()) {
          return;
        }
        board[row][col] = 0; // Backtrack
      }
    }
  }

  bool _isValidMove(int row, int col, int num) {
    // Check if num is not already in the same row, col, or 3x3 grid
    for (int i = 0; i < 9; i++) {
      if (board[row][i] == num || board[i][col] == num) {
        return false;
      }
    }

    int gridRow = row ~/ 3 * 3;
    int gridCol = col ~/ 3 * 3;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[gridRow + i][gridCol + j] == num) {
          return false;
        }
      }
    }

    return true;
  }

  bool _hasEmptyCells() {
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (board[i][j] == 0) {
          return true;
        }
      }
    }
    return false;
  }

  bool _isUniqueSolution() {
    // Check if there is only one solution for the current board
    // (for simplicity, assume there's only one solution)
    return true;
  }

  void _removeCells() {
    // Randomly remove cells to create the puzzle
    Random random = Random();
    int cellsToRemove = 45; // Adjust as needed
    while (cellsToRemove > 0) {
      int row = random.nextInt(9);
      int col = random.nextInt(9);
      if (board[row][col] != 0) {
        board[row][col] = 0;
        cellsToRemove--;
      }
    }
  }
}
