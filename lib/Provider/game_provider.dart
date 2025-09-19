import 'package:flutter/material.dart';

class GameProvider extends ChangeNotifier {
  List<String> board = List.filled(9, '');
  String currentPlayer = 'X';
  bool gameOver = false;
  String resultMessage = '';
  Set<int> winningIndices = {};
  Map<String, int> score = {'X': 0, 'O': 0, 'Draws': 0};
  final List<int> _moveStack = [];

  void playMove(int index) {
    if (gameOver || board[index].isNotEmpty) return;

    board[index] = currentPlayer;
    _moveStack.add(index);

    final winner = _checkWinner();
    if (winner != '') {
      gameOver = true;
      winningIndices = _winningLineFor(winner);
      resultMessage = 'Player $winner wins!';
      score[winner] = (score[winner] ?? 0) + 1;
    } else if (!board.contains('')) {
      gameOver = true;
      resultMessage = 'It\'s a draw!';
      score['Draws'] = (score['Draws'] ?? 0) + 1;
    } else {
      currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
    }
    notifyListeners();
  }

  String _checkWinner() {
    const lines = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6],
    ];
    for (var line in lines) {
      final a = line[0], b = line[1], c = line[2];
      if (board[a].isNotEmpty &&
          board[a] == board[b] &&
          board[b] == board[c]) {
        return board[a];
      }
    }
    return '';
  }

  Set<int> _winningLineFor(String winner) {
    const lines = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6],
    ];
    for (var line in lines) {
      final a = line[0], b = line[1], c = line[2];
      if (board[a] == winner && board[b] == winner && board[c] == winner) {
        return {a, b, c};
      }
    }
    return {};
  }

  void restartKeepScore() {
    board = List.filled(9, '');
    currentPlayer = 'X';
    gameOver = false;
    resultMessage = '';
    winningIndices.clear();
    _moveStack.clear();
    notifyListeners();
  }

  void resetEverything() {
    restartKeepScore();
    score = {'X': 0, 'O': 0, 'Draws': 0};
    notifyListeners();
  }

  void undo() {
    if (_moveStack.isEmpty || gameOver) return;
    final last = _moveStack.removeLast();
    board[last] = '';
    currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
    notifyListeners();
  }
}
