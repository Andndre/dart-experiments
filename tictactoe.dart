class TicTacToeBoard {
  List<List<String>> _rows = [];

  late int _size;

  List<List<String>> toList() {
    return _rows;
  }

  int get size {
    return _size;
  }

  TicTacToeBoard(int size) {
    this._size = size;
    for (int y = 0; y < size; y++) {
      _rows.add([]);
      for (int x = 0; x < size; x++) {
        _rows[y].add(' ');
      }
    }
  }

  /**
   * Counts from top left corner
  */
  void set(row, col, newStr) {
    if (row > size) {
      print('[ERROR] TicTacToeBoard: Out of bounds for Row --> Row must be in range of 1 to size (in your case is $size)');
      return;
    }
    if (col > size) {
      print('[ERROR] TicTacToeBoard: Out of bounds for Column --> Column must be in range of 1 to size (in your case is $size)');
      return;
    }
    _rows[row - 1][col - 1] = newStr;
  }

  void display() {
    String underScore = '_';
    for (int i = 0; i < _rows.length * 4; i++) {
      underScore += '_';
    }
    print(underScore);
    _rows.forEach((element) {
      String row = "| ";
      element.forEach((element1) {
        row += element1 + ' | ';
      });
      print(row);
      print(underScore);
    });
  }

  String getWinner() {
    // Horizontal and vertical
    for (int i = 0; i <= 1; i++) {
      bool first = true;
      String winner = ' ';
      bool isWinner = false;
      for (int y = 0; y < _rows.length; y++) {
        for (int x = 0; x < _rows[y].length; x++) {
          String curr = (i == 0) ? _rows[y][x] : _rows[x][y];
          if (first) {
            winner = curr;
            first = false;
            isWinner = winner == ' ' ? false : true;
            if (!isWinner) break;
          } else {
            // if it's doesn't same dont continue
            if (winner != curr) {
              isWinner = false;
              break;
            }
            if (x == _rows.length - 1) {
              if (isWinner) {
                return winner;
              } else {
                // loop back
                first = true;
              }
            }
          }
        }
      }
    }

    // Diagonal
    for (int i = 0; i <= 1; i++) {
      bool first = true;
      String winner = ' ';
      bool isWinner = false;
      for (int y = 0; y < _rows.length; y++) {
        String curr = i == 0 ? _rows[2 - y][y] : _rows[y][y];
        if (first) {
          winner = curr;
          first = false;
          isWinner = winner == ' ' ? false : true;
          if (!isWinner) break;
        } else {
          if (winner != curr) {
            isWinner = false;
            break;
          }
          if (y == _rows.length - 1) {
            if (isWinner) {
              return winner;
            } else {
              first = true;
            }
          }
        }
      }
    }
    return ' ';
  }
}
