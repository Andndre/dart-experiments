import 'dart:math';

enum SudokuLevel_Old {
  EASY, // 3-5 clue/chunk
  MEDIUM, // 2-3 clue/chunk
  HARD, // 1-2 clue/chunk
  VERY_HARD, // 0-1 clue/chunk
}

class Sudoku_Old {
  // There are 3X3 squares(Chunk) that also Has 3X3 Tiles inside of each of them
  // Each of thoose Tiles only achive a Number between 1(inclusive) to 9(inclusive)
  // Numbers of tiles inside one chunk cannot be the same
  // Numbers from left side of the board all the way to the right side of the Board also cannot be the same(Horizontal)
  // (Same too for vertical direction)

  Sudoku_Old(SudokuLevel_Old level) {
    _generateHint(level);
  }

  void forEachChunk(void func(element)) {
    for (int i = 0; i <= 8; i++) {
      func(getChunkAt(i));
    }
  }

  void _generateHint(SudokuLevel_Old level) {
    for (int i = 0; i < 3; i++) {
      List<_Chunk> row = _rows[i];
      for (int j = 0; j < 3; j++) {
        _Chunk chunk = row[j];
        List<int> hintIndexes = [];
        int totalHintTarget = level == SudokuLevel_Old.EASY
            ? Random().nextInt(3) + 3
            : level == SudokuLevel_Old.MEDIUM
                ? Random().nextInt(2) + 2
                : level == SudokuLevel_Old.HARD
                    ? Random().nextInt(2) + 1
                    : level == SudokuLevel_Old.VERY_HARD
                        ? Random().nextInt(2)
                        : 0;
        while (true) {
          if (hintIndexes.length == totalHintTarget) break;
          int index = Random().nextInt(9);
          while (hintIndexes.contains(index)) {
            index = Random().nextInt(9);
          }
          hintIndexes.add(index);
          // print('1: index: $index , chunkRow: $i, rowIndex: $j');
          List<int> available = getAvailableNumberAt(getIndex(i, j), index);
          // print('2: available: $available');

          if (available.length == 0) continue;

          chunk.getTileAt(index).value =
              available[Random().nextInt(available.length)];
        }
      }
    }
  }

  List<List<_Chunk>> _rows = [
    [_Chunk(), _Chunk(), _Chunk()],
    [_Chunk(), _Chunk(), _Chunk()],
    [_Chunk(), _Chunk(), _Chunk()],
  ];

  _Chunk getChunkAt(int index) {
    int rowIndex = _getRowIndex(index, 3);
    int indexInRow = _getColumnIndex(index, 3);
    return _rows[rowIndex][indexInRow];
  }

  void set(int chunkIndex, int indexInChunk, int newValue) {
    _SBLoc location =
        _SBLoc(chunkI: chunkIndex, iChunk: indexInChunk, board: this);
    if (location.chunkI > 8 || location.iChunk > 8) {
      print(
          'Out of bounds, must be in range 0..8:{${location.chunkI} or ${location.iChunk}}');
      return;
    }
    if (newValue <= 0 || newValue >= 10) {
      print('Set value must be in range 1..9:$newValue');
      return;
    }
    getChunkAt(location.chunkI).getTileAt(location.iChunk).value = newValue;
  }

  void display() {
    print('____________________________');
    for (int i = 0; i < 8; i += 3) {
      for (int r = 0; r < 3; r++) {
        String str = '| ';
        for (int j = i; j < i + 3; j++) {
          for (int k = 0; k < 3; k++) {
            str += '${getChunkAt(j)._tileRows[r][k].toString()} ';
          }
          str += ' | ';
        }
        print(str);
      }
      print('|__________________________|');
    }
  }

  List<int> getAvailableNumberAt(int chunkIndex, int tileIndex) {
    if (getChunkAt(chunkIndex).getTileAt(tileIndex).value != null) {
      print(
          'There\'s already a number in chunkIndex: $chunkIndex, tileIndex: $tileIndex');
      return [];
    }

    _SBLoc sbLoc = _SBLoc(chunkI: chunkIndex, iChunk: tileIndex, board: this);
    return sbLoc.availableNumbers;
  }
}

// List<int> _topIndexes = [0, 1, 2];
// List<int> _bottomIndexes = [6, 7, 8];
final List<int> _leftIndexes = [0, 3, 6];
final List<int> _rightIndexes = [2, 5, 8];

class _SBLoc {
  int chunkI;
  int iChunk;
  Sudoku_Old board;

  _SBLoc({required this.chunkI, required this.iChunk, required this.board});

  /// [cI] ==> chunkIndexInsideBoard
  /// [tI] ==> tileIndexInsideChunk
  bool hasTop(int cI, int tI) {
    return cI > 2 || tI > 2;
  }

  bool hasRight(int cI, int tI) {
    return (!_rightIndexes.contains(cI)) || (!_rightIndexes.contains(tI));
  }

  bool hasLeft(int cI, int tI) {
    return (!_leftIndexes.contains(cI)) || (!_leftIndexes.contains(tI));
  }

  bool hasBottom(int cI, int tI) {
    return cI < 6 || tI < 6;
  }

  List<int> get availableNumbers {
    List<int> taken = [];
    List<int> result = [];
    int cI = chunkI;
    int tI = iChunk;

    _Chunk initialChunk = board.getChunkAt(cI);
    taken.addAll(initialChunk.availableNumbers);
    taken = _invertAvailable(taken);

    while (hasTop(cI, tI)) {
      // print('hasTop');

      if (tI < 3) {
        cI -= 3;
        tI += 6;
      } else {
        tI -= 3;
      }

      _Chunk currChunk = board.getChunkAt(cI);
      // print(currChunk.toString());
      _Tile currTile = currChunk.getTileAt(tI);
      if (currTile.value != null) {
        // print(currTile.value!);

        taken.add(currTile.value!);
      }
    }

    cI = chunkI;
    tI = iChunk;
    while (hasBottom(cI, tI)) {
      // print('hasBottom');

      if (tI >= 6) {
        cI += 3;
        tI -= 6;
      } else {
        tI += 3;
      }

      _Chunk currChunk = board.getChunkAt(cI);
      _Tile currTile = currChunk.getTileAt(tI);
      if (currTile.value != null) {
        taken.add(currTile.value!);
      }
    }

    cI = chunkI;
    tI = iChunk;
    while (hasLeft(cI, tI)) {
      // print('hasLeft');

      if (_leftIndexes.contains(tI)) {
        tI += 2;
        cI -= 1;
      } else {
        tI--;
      }

      _Chunk currChunk = board.getChunkAt(cI);
      _Tile currTile = currChunk.getTileAt(tI);
      if (currTile.value != null) {
        taken.add(currTile.value!);
      }
    }

    cI = chunkI;
    tI = iChunk;
    while (hasRight(cI, tI)) {
      // print('hasRight');

      if (_rightIndexes.contains(tI)) {
        tI -= 2;
        cI += 1;
      } else {
        tI++;
      }

      _Chunk currChunk = board.getChunkAt(cI);
      _Tile currTile = currChunk.getTileAt(tI);
      if (currTile.value != null) {
        taken.add(currTile.value!);
      }
    }

    result = _invertAvailable(taken);
    return result;
  }
}

List<int> _invertAvailable(List<int> available) {
  List<int> result = [];
  for (int i = 1; i <= 9; i++) {
    if (!available.contains(i)) {
      result.add(i);
    }
  }
  return result;
}

int _getRowIndex(int index, int rowLength) {
  return (((index + 1) / rowLength).ceil()) - 1;
}

int _getColumnIndex(int index, int columnLength) {
  return ((index + 1) % columnLength == 0)
      ? (columnLength - 1)
      : (((index + 1) % columnLength) - 1);
}

int getIndex(int rowIndex, int colIndex) {
  return colIndex + (3 * rowIndex);
}

class _Chunk {
  List<List<_Tile>> _tileRows = [
    [_Tile(), _Tile(), _Tile()],
    [_Tile(), _Tile(), _Tile()],
    [_Tile(), _Tile(), _Tile()],
  ];

  _Tile getTileAt(int index) {
    int rowIndex = _getRowIndex(index, 3);
    int indexInRow = _getColumnIndex(index, 3);

    return _tileRows[rowIndex][indexInRow];
  }

  List<int> get availableNumbers {
    List<int> onBoard = [];

    for (int i = 0; i <= 8; i++) {
      String str = getTileAt(i).toString();
      if (str != ' ') {
        onBoard.add(int.parse(str));
      }
    }

    List<int> result = [];

    for (int i = 1; i <= 9; i++) {
      if (!onBoard.contains(i)) result.add(i);
    }

    return result;
  }

  void forEachTile(void func(tile)) {
    for (int i = 0; i <= 8; i++) {
      func(getTileAt(i));
    }
  }

  @override
  String toString() {
    return _tileRows.toString();
  }
}

class _Tile {
  int? value;

  void remove() {
    value = null;
  }

  _Tile({this.value});
  @override
  String toString() {
    return value?.toString() ?? ' ';
  }
}
