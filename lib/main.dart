import 'package:flutter/material.dart';
import 'package:sudoku/sudokugenerator.dart';

void main() {
  SudokuGenerator sudoku = SudokuGenerator();
  sudoku.generate();
  for (int i = 0; i < 9; i++) {
    print(sudoku.board[i]);
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sudoku',
      home: SudokuGame(),
    );
  }
}

class SudokuGame extends StatefulWidget {
  @override
  _SudokuGameState createState() => _SudokuGameState();
}

class _SudokuGameState extends State<SudokuGame> {
  late List<List<int>> board = List.generate(9, (_) => List<int>.filled(9, 0));
  late int selectedRow = -1;
  late int selectedCol = -1;

  void _generateSudoku() {
    SudokuGenerator sudokuGenerator = SudokuGenerator();
    sudokuGenerator.generate();
    board = sudokuGenerator.board;
    setState(() {});
  }

  void _handleCellTap(int row, int col) {
    setState(() {
      selectedRow = row;
      selectedCol = col;
    });
  }

  void _handleNumberTap(int number) {
    setState(() {
      if (selectedRow != -1 && selectedCol != -1) {
        if (_isValidMove(selectedRow, selectedCol, number)) {
          board[selectedRow][selectedCol] = number;
        } else {
          print('Invalid move');
        }
      }
    });
  }

  bool _isValidMove(int row, int col, int num) {
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

  bool _checkWinCondition() {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sudoku'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              height: 300,
              child: GridView.builder(
                itemCount: 81,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 9,
                ),
                itemBuilder: (BuildContext context, int index) {
                  int row = index ~/ 9;
                  int col = index % 9;
                  return GestureDetector(
                    onTap: () {
                      // Handle cell tap
                      _handleCellTap(row, col);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      child: Center(
                        child: Text(
                          board[row][col] != 0
                              ? board[row][col].toString()
                              : '',
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(9, (index) {
                  int number = index + 1;
                  return ElevatedButton(
                    onPressed: () {
                      _handleNumberTap(number);
                    },
                    child: Text(number.toString()),
                  );
                }),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _generateSudoku,
              child: Text('New Game'),
            ),
          ],
        ),
      ),
    );
  }
}
