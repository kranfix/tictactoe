enum Token {
  circle,
  cross;

  factory Token.fromString(String value) {
    for (final s in Token.values) {
      if (s.name == value) return s;
    }
    throw Exception("Invalid token");
  }

  Token get other => switch (this) {
        Token.circle => Token.cross,
        Token.cross => Token.circle,
      };
}

extension type Board._(List<Token?> _tokens) {
  Board({List<Token?>? tokens})
      : assert(tokens == null || tokens.length == 9),
        _tokens = tokens ?? List.generate(9, (_) => null);

  factory Board.deserialize(String data) {
    if (data.length < 9) {
      throw BoardDeserializeError.insufficientLenth;
    }
    data = data.substring(0, 9);
    final tokens = <Token?>[];
    for (final c in data.split('')) {
      switch (c) {
        case '_':
          tokens.add(null);
        case 'o':
          tokens.add(Token.circle);
        case 'x':
          tokens.add(Token.cross);
        default:
          throw BoardDeserializeError.invalidToken;
      }
    }
    return Board(tokens: tokens);
  }

  (BoardLine, (int, int, int), Token)? calculateWinnerLine() {
    for (final (kind, (a, b, c)) in BoardLine.lines) {
      final val = _tokens[a];
      if (val == null) continue;
      if (_tokens[b] == val && _tokens[c] == val) {
        return (kind, (a, b, c), val);
      }
    }
    return null;
  }

  bool get isEnded {
    final winnerLine = calculateWinnerLine();
    if (winnerLine != null) return true;

    for (final token in _tokens) {
      if (token == null) {
        return false;
      }
    }
    return true;
  }

  Token? at(int index) {
    return _tokens[index];
  }

  bool insertTokenAt(int index, Token token) {
    if (_tokens[index] != null) return false;
    _tokens[index] = token;
    return true;
  }

  BoardSerialization serialize() {
    final sb = StringBuffer();
    for (final t in _tokens) {
      final char = switch (t) {
        null => '_',
        Token.circle => 'o',
        Token.cross => 'x',
      };
      sb.write(char);
    }
    return BoardSerialization.unsafe(sb.toString());
  }
}

enum BoardDeserializeError implements Exception {
  insufficientLenth,
  invalidToken,
}

// const tokensDemo = [
//   Token.circle, null, null, //
//   null, Token.circle, null, //
//   Token.cross, null, null
// ];

extension type BoardSerialization.unsafe(String _val) implements String {
  factory BoardSerialization.empty() => BoardSerialization.unsafe("_________");
}

enum BoardLine {
  diag,
  row,
  col;

  static const lines = [
    (BoardLine.diag, (0, 4, 8)),
    (BoardLine.diag, (2, 4, 6)),
    (BoardLine.row, (0, 1, 2)),
    (BoardLine.col, (2, 5, 8)),
    (BoardLine.row, (8, 7, 6)),
    (BoardLine.col, (6, 3, 0)),
    (BoardLine.row, (3, 4, 5)),
    (BoardLine.col, (1, 4, 7)),
  ];
}
