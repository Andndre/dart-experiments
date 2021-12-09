import 'dart:math';

class Sudoku {
  /// ```dart
  ///  [['4', '3', '5',   '2', '6', '9',   '7', '8', '1'],
  ///   ['6', '8', '2',   '5', '7', '1',   '4', '9', '3'],
  ///   ['1', '9', '7',   '8', '3', '4',   '5', '6', '2'],
  ///
  ///   ['8', '2', '6',   '1', '9', '5',   '3', '4', '7'],
  ///   ['3', '7', '4',   '6', '8', '2',   '9', '1', '5'],
  ///   ['9', '5', '1',   '7', '4', '3',   '6', '2', '8'],
  ///
  ///   ['5', '1', '9',   '3', '2', '6',   '8', '7', '4'],
  ///   ['2', '4', '8',   '9', '5', '7',   '1', '3', '6'],
  ///   ['7', '6', '3',   '4', '1', '8',   '2', '5', '9']],
  ///
  ///
  /// ```
  static final List<List<SudokuChunk>> _base = [
    [
      SudokuChunk(tiles: [
        [
          SudokuTile(value: '4'),
          SudokuTile(value: '3'),
          SudokuTile(value: '5')
        ],
        [
          SudokuTile(value: '6'),
          SudokuTile(value: '8'),
          SudokuTile(value: '2')
        ],
        [
          SudokuTile(value: '1'),
          SudokuTile(value: '9'),
          SudokuTile(value: '7'),
        ]
      ]),
      SudokuChunk(tiles: [
        [
          SudokuTile(value: '2'),
          SudokuTile(value: '6'),
          SudokuTile(value: '9')
        ],
        [
          SudokuTile(value: '5'),
          SudokuTile(value: '7'),
          SudokuTile(value: '1')
        ],
        [
          SudokuTile(value: '8'),
          SudokuTile(value: '3'),
          SudokuTile(value: '4'),
        ]
      ]),
      SudokuChunk(tiles: [
        [
          SudokuTile(value: '7'),
          SudokuTile(value: '8'),
          SudokuTile(value: '1')
        ],
        [
          SudokuTile(value: '4'),
          SudokuTile(value: '9'),
          SudokuTile(value: '3')
        ],
        [
          SudokuTile(value: '5'),
          SudokuTile(value: '6'),
          SudokuTile(value: '2'),
        ]
      ])
    ],
    [
      SudokuChunk(tiles: [
        [
          SudokuTile(value: '8'),
          SudokuTile(value: '2'),
          SudokuTile(value: '6'),
        ],
        [
          SudokuTile(value: '3'),
          SudokuTile(value: '7'),
          SudokuTile(value: '4'),
        ],
        [
          SudokuTile(value: '9'),
          SudokuTile(value: '5'),
          SudokuTile(value: '1'),
        ]
      ]),
      SudokuChunk(tiles: [
        [
          SudokuTile(value: '1'),
          SudokuTile(value: '9'),
          SudokuTile(value: '5'),
        ],
        [
          SudokuTile(value: '6'),
          SudokuTile(value: '8'),
          SudokuTile(value: '2'),
        ],
        [
          SudokuTile(value: '7'),
          SudokuTile(value: '4'),
          SudokuTile(value: '3'),
        ]
      ]),
      SudokuChunk(tiles: [
        [
          SudokuTile(value: '3'),
          SudokuTile(value: '4'),
          SudokuTile(value: '7')
        ],
        [
          SudokuTile(value: '9'),
          SudokuTile(value: '1'),
          SudokuTile(value: '5')
        ],
        [
          SudokuTile(value: '6'),
          SudokuTile(value: '2'),
          SudokuTile(value: '8'),
        ]
      ])
    ],
    [
      SudokuChunk(tiles: [
        [
          SudokuTile(value: '5'),
          SudokuTile(value: '1'),
          SudokuTile(value: '9')
        ],
        [
          SudokuTile(value: '2'),
          SudokuTile(value: '4'),
          SudokuTile(value: '8')
        ],
        [
          SudokuTile(value: '7'),
          SudokuTile(value: '6'),
          SudokuTile(value: '3'),
        ]
      ]),
      SudokuChunk(tiles: [
        [
          SudokuTile(value: '3'),
          SudokuTile(value: '2'),
          SudokuTile(value: '6')
        ],
        [
          SudokuTile(value: '9'),
          SudokuTile(value: '5'),
          SudokuTile(value: '7')
        ],
        [
          SudokuTile(value: '4'),
          SudokuTile(value: '1'),
          SudokuTile(value: '8'),
        ]
      ]),
      SudokuChunk(tiles: [
        [
          SudokuTile(value: '8'),
          SudokuTile(value: '7'),
          SudokuTile(value: '4')
        ],
        [
          SudokuTile(value: '1'),
          SudokuTile(value: '3'),
          SudokuTile(value: '6')
        ],
        [
          SudokuTile(value: '2'),
          SudokuTile(value: '5'),
          SudokuTile(value: '9'),
        ]
      ])
    ]
  ];

  List<List<SudokuChunk>> get base => _base;

  List<List<SudokuChunk>> board;

  Sudoku copy() {
    List<List<SudokuChunk>> newBoard = [];
    for (int i = 0; i < board.length; i++) {
      newBoard.add([]);
      for (int j = 0; j < board[0].length; j++) {
        SudokuChunk newChunk = board[i][j].copy();
        newBoard[i].add(newChunk);
      }
    }
    return Sudoku(board: newBoard);
  }

  static Sudoku random() {
    Sudoku sudoku = Sudoku(board: _base).copy();
    sudoku.shuffle();
    return sudoku;
  }

  Sudoku({required this.board});

  /// Combine [_shuffleChunk] and [_shuffleTile]
  void shuffle({int iteration = 5}) {
    for (int i = 0; i < iteration; i++) {
      _shuffleChunk();
      _shuffleTile();
    }
  }

  /// Re-arrange [SudokuChunk] vertically and horizontally
  void _shuffleChunk({List<List<SudokuChunk>>? board}) {
    board ??= this.board;
    List<_IntPair> horizontal = _IntPair.generateRandomSwapPairs(3);
    List<_IntPair> vertical = _IntPair.generateRandomSwapPairs(3);

    for (_IntPair sp in vertical) {
      for (int i = 0; i < 3; i++) {
        SudokuChunk tmp = board[i][sp.a];
        board[i][sp.a] = board[i][sp.b];
        board[i][sp.b] = tmp;
      }
    }

    for (_IntPair sp in horizontal) {
      for (int i = 0; i < 3; i++) {
        SudokuChunk tmp = board[sp.a][i];
        board[sp.a][i] = board[sp.b][i];
        board[sp.b][i] = tmp;
      }
    }
  }

  /// Re-arrange [SudokuTile] vertically and horizontally
  void _shuffleTile({List<List<SudokuChunk>>? board}) {
    board ??= this.board;
    // horizontal
    for (int i = 0; i < 3; i++) {
      List<_IntPair> swapPairList = _IntPair.generateRandomSwapPairs(3);
      for (_IntPair swapPair in swapPairList) {
        for (int j = 0; j < 3; j++) {
          SudokuChunk chunk = board[i][j];
          for (int k = 0; k < 3; k++) {
            SudokuTile tmp = chunk.tiles[swapPair.a][k];
            chunk.tiles[swapPair.a][k] = chunk.tiles[swapPair.b][k];
            chunk.tiles[swapPair.b][k] = tmp;
          }
        }
      }
    }

    // vertical
    for (int i = 0; i < 3; i++) {
      List<_IntPair> swapPairList = _IntPair.generateRandomSwapPairs(3);
      for (_IntPair swapPair in swapPairList) {
        for (int j = 0; j < 3; j++) {
          SudokuChunk chunk = board[j][i];
          for (int k = 0; k < 3; k++) {
            SudokuTile tmp = chunk.tiles[k][swapPair.a];
            chunk.tiles[k][swapPair.a] = chunk.tiles[k][swapPair.b];
            chunk.tiles[k][swapPair.b] = tmp;
          }
        }
      }
    }
  }

  /// Reset visibiity of this tiles and hide them by some [percentage].
  /// Note that the hidden tiles count will not be always the same
  void rehide([int percentage = 50]) {
    // board have 3 row of chunks
    for (List<SudokuChunk> row in board) {
      // row have 3 chunks
      for (SudokuChunk chunk in row) {
        // chunk.tiles have 3 row of tiles
        for (List<SudokuTile> rowTile in chunk.tiles) {
          // rowTile have 3 elements
          for (SudokuTile tile in rowTile) {
            if (Random().nextInt(100) < percentage) {
              tile.revealed = false;
            } else {
              tile.revealed = true;
            }
          }
        }
      }
      // total iteration above should be 3^4 or 81 (tile count in sudoku)
    }
  }

  //  Displays the [board] to the console
  void display() {
    print('_' * 31);
    for (List<SudokuChunk> row in board) {
      for (int i = 0; i < 3; i++) {
        String str = '| ';
        for (SudokuChunk chunk in row) {
          str +=
              '${chunk.tiles[i][0].toString()}  ${chunk.tiles[i][1].toString()}  ${chunk.tiles[i][2].toString()} | ';
        }
        print(str);
      }
      print('|' + ('_________|' * 3));
    }
  }
}

class SudokuChunk {
  List<List<SudokuTile>> tiles;
  SudokuChunk({
    required this.tiles,
  });

  SudokuChunk copy() {
    List<List<SudokuTile>> newChunk = [];
    for (int i = 0; i < tiles.length; i++) {
      newChunk.add([]);
      for (int j = 0; j < tiles[0].length; j++) {
        SudokuTile newTile = SudokuTile(value: tiles[i][j].value);
        newChunk[i].add(newTile);
      }
    }
    return SudokuChunk(tiles: newChunk);
  }

  @override
  String toString() {
    return tiles.toString();
  }
}

/// Pair of two `int`
class _IntPair {
  int a;
  int b;
  _IntPair({
    required this.a,
    required this.b,
  });

  /// Generates a [List] of random `unique` [_IntPair]s
  /// between 0(inclusive) and [size] (exclusive)
  static List<_IntPair> generateRandomSwapPairs(int size) {
    final List<_IntPair> result = [];

    final List<int> options = List.generate(size, (index) => index);

    while (options.length > 1) {
      result.add(
          _IntPair(a: options.removeAtRandom(), b: options.removeAtRandom()));
    }

    if (options.length == 1) {
      result.add(_IntPair(a: options[0], b: _randExcpt(size, options[0])));
    }

    return result;
  }

  @override
  String toString() {
    return [a, b].toString();
  }
}

class SudokuTile {
  bool revealed;
  String value;

  SudokuTile({required this.value, this.revealed = true});

  @override
  String toString() {
    return revealed ? value : ' ';
  }
}

int _randExcpt(int max, int except) {
  if (max <= 1) return -1;
  final Random rand = Random();
  int result = rand.nextInt(max);
  while (result == except) {
    result = rand.nextInt(max);
  }

  return result;
}

extension _Random on List {
  /// Removes the object at random position from this list.
  /// Returns the removed value.
  /// The list must be growable.
  int removeAtRandom() {
    int idx = Random().nextInt(length);
    return removeAt(idx);
  }
}
