import 'dart:math';

import 'package:flutter/material.dart';

import 'puzzle_cell.dart';

enum GameState {
  idle,
  loading,
  running,
  finished,
}

class PuzzleNotifier extends ChangeNotifier {
  static const Duration animationDuration = Duration(milliseconds: 300);
  List<List<int>> board = List.empty();
  List<PuzzleCell> cells = List.empty();
  int moves = 0;

  GameState _state = GameState.idle;
  GameState get state => _state;
  set state(GameState newState) {
    _state = newState;
    notifyListeners();
  }

  void start({int shuffle = 1}) async {
    state = GameState.loading;

    for (int i = 0; i < shuffle; i++) {
      board = createRandomBoard();
      cells = [];
      createPuzzleCellData(board);
      await Future.delayed(PuzzleNotifier.animationDuration);
    }

    state = GameState.running;
    notifyListeners();
  }

  void moveTile(int x, int y) {
    List<int> dirY = [0, -1, 0, 1];
    List<int> dirX = [-1, 0, 1, 0];

    for (int i = 0; i < dirX.length; i++) {
      int a = x + dirX[i];
      int b = y + dirY[i];
      // print('checking $a, $b');
      if (_isEmptyTile(a, b)) {
        // print('found empty at $a,$b');
        _swapTile(x, y, a, b);
        moves++;
        notifyListeners();
        return;
      }
    }
  }

  bool _isEmptyTile(int x, int y) {
    if (x < 0 || x > 2 || y < 0 || y > 2) {
      return false;
    }
    return board[x][y] == 0;
  }

  void _swapTile(int x, int y, int a, int b) {
    int value = board[x][y];
    board[x][y] = board[a][b];
    board[a][b] = value;

    cells.firstWhere((element) => element.dx == x && element.dy == y)
      ..dx = a
      ..dy = b;
  }

  void createPuzzleCellData(List<List<int>> box) {
    // print('creating cells from: ');
    // print(box);
    int count = 0;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (box[i][j] != 0) {
          cells.add(
            PuzzleCell(
                value: box[i][j],
                dx: i,
                dy: j,
                color: Colors.primaries[count++]),
          );
        }
      }
    }
  }

  List<List<int>> createRandomBoard() {
    int size = 3;
    List<List<int>> board = [];
    for (int i = 0; i < size; i++) {
      List<int> temp = [];
      for (int j = 0; j < size; j++) {
        temp.add(0);
      }
      board.add(temp);
    }

    List<int> s = [];
    for (int i = 0; i < (size * size); i++) {
      s.add(i);
    }

    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        int item = s[Random().nextInt(s.length)];
        board[i][j] = item;
        s.remove(item);
      }
    }
    return board;
  }

  Function(int moves)? onGameFinished;

  void checkFinish() {
    int count = 1;
    int mismatched = 0;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (!(i == 2 && j == 2)) {
          //print('Board value: ${board[j][i]} and count: $count');
          if (board[j][i] != count) {
            mismatched++;
          }
          count++;
        }
      }
    }

    if (mismatched == 0) {
      //print(mismatched);
      onGameFinished?.call(moves);
      state = GameState.finished;
      notifyListeners();
    }
  }

  void reset() {
    moves = 0;
    cells = List.empty();
    board = List.empty();
    state = GameState.idle;
  }
}
