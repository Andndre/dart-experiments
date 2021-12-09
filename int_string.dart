import 'double_str.dart';

/// It's basically a `String` object but can behave just like an
/// `int` with more fitures like unlimited digits, etc.
class IntStr implements Comparable<IntStr> {
  String _val;
  int _sign;

  /// If you are not sure if the value is valid or not,
  /// you can use `IntStr.isValid(String)` before assigning it
  /// to [val] parameter
  IntStr([String val = '0'])
      : _val = val.replaceFirst('-', ''),
        _sign = val[0] == '-'
            ? -1
            : val == '0'
                ? 0
                : 1;

  /// Equivalen to `IntStr('0');`
  IntStr.zero() : this('0');

  /// Equivalen to `IntStr('1');`
  IntStr.one() : this('1');

  /// Equivalen to `IntStr('2');`
  IntStr.two() : this('2');

  /// Creates `IntStr` from `int` value
  IntStr.fromInt(int val)
      : _val = '$val'.replaceFirst('-', ''),
        _sign = val.sign;

  /// Get length of digits
  int get length => _val.length;
  int get sign => _sign;

  static bool isValid(String value) {
    if (value[0] == '-') value = value.replaceFirst('-', '');
    for (int i = 0; i < value.length; i++) {
      if (int.tryParse(value[i]) == null) return false;
    }
    return true;
  }

  static IntStr max(IntStr a, IntStr b) {
    return a > b ? a : b;
  }

  static IntStr min(IntStr a, IntStr b) {
    return a < b ? a : b;
  }

  int _maxInt(int a, int b) => a > b ? a : b;

  bool operator >(IntStr other) {
    return _greatherThan(other, false);
  }

  bool operator <(IntStr other) {
    return _lessThan(other, false);
  }

  bool operator <=(IntStr other) {
    return _lessThan(other, true);
  }

  bool operator >=(IntStr other) {
    return _greatherThan(other, true);
  }

  bool operator ==(Object other) => other is IntStr && _val == other._val;

  bool _lessThan(IntStr other, bool acceptEqual) {
    if (_sign < other._sign) return true;
    if (_sign > other._sign) return false;
    if (_sign == 0) return true;

    if (length < other.length) return _sign == 1;
    if (length > other.length) return _sign == -1;

    for (int i = 0; i < length; i++) {
      if (digit(i) > other.digit(i)) {
        return _sign == -1;
      } else if (digit(i) < other.digit(i)) {
        return _sign == 1;
      }
    }

    // Equal
    return acceptEqual;
  }

  bool _greatherThan(IntStr other, bool acceptEqual) {
    if (_sign > other._sign) return true;
    if (_sign < other._sign) return false;
    if (_sign == 0) return true;

    if (length > other.length) return _sign == 1;
    if (length < other.length) return _sign == -1;

    for (int i = 0; i < length; i++) {
      if (digit(i) < other.digit(i)) {
        return _sign == -1;
      } else if (digit(i) > other.digit(i)) {
        return _sign == 1;
      }
    }
    // Equal
    return acceptEqual;
  }

  void clamp(IntStr lowerLimit, IntStr upperLimit) {
    if (lowerLimit >= upperLimit) {
      throw new Exception('[lowerLimit] must be '
          'less than [upperLimit]');
    }

    if (this < lowerLimit) {
      _val = lowerLimit._val;
      _sign = lowerLimit._sign;
    } else if (this > upperLimit) {
      _val = upperLimit._val;
      _sign = upperLimit._sign;
    }
  }

  /// Return ([idx] + 1)th digit
  int digit(int idx) {
    if (idx > _val.length - 1 || idx < 0) {
      throw new Exception(
        'out of bounds for index $idx, 0..${_val.length - 1}',
      );
    }
    return int.parse(_val[idx]);
  }

  /// Return IntStr(this `plus` other);
  IntStr operator +(IntStr other) {
    if (_sign == 0) return other;
    if (other._sign == 0) return this;

    if (_sign == 1 && other._sign == 1) {
      return IntStr(_add(_val, other._val));
    }

    if (_sign == 1 && other._sign == -1) {
      return IntStr(_subtract(_val, other._val));
    }

    if (_sign == -1 && other._sign == 1) {
      return IntStr(_subtract(other._val, _val));
    }

    if (_sign == -1 && other._sign == -1) {
      return IntStr(_add(_val, other._val))..reverseSign();
    }

    // if the sign get invalid somehow
    throw new Exception(
        'either or both of two sign is invalid for sign $_sign and '
        '${other._sign}. signs accepted are -1, 0, and 1');
  }

  IntStr operator -() {
    return this..reverseSign();
  }

  /// Return IntStr(this `minus` other);
  IntStr operator -(IntStr other) {
    if (_sign == 0) return other;
    if (other._sign == 0) return this;

    if (_sign == 1 && other._sign == 1) {
      return IntStr(_subtract(_val, other._val));
    }

    if (_sign == 1 && other._sign == -1) {
      return IntStr(_add(_val, other._val));
    }

    if (_sign == -1 && other._sign == 1) {
      return IntStr(_add(_val, other._val))..reverseSign();
    }

    if (_sign == -1 && other._sign == -1) {
      return IntStr(_subtract(other._val, _val));
    }

    // if the sign get invalid somehow
    throw new Exception(
        'either or both of two sign is invalid for sign $_sign and '
        '${other._sign}. signs accepted are -1, 0, and 1');
  }

  /// Return IntStr(this `multiply` other);
  IntStr operator *(IntStr other) {
    if (other._val == '0') return other;
    if (_val == '0') return this;

    List<String> nums = [];
    int carry = 0;
    int curr = 0;

    for (int i = other.length - 1; i >= 0; i--) {
      int opposite_i = other.length - 1 - i;
      nums.add('0' * opposite_i);
      for (int j = _val.length - 1; j >= 0; j--) {
        curr = digit(j) * other.digit(i);
        curr += carry;

        String _curr = '$curr';
        if (_curr.length == 2) {
          curr = int.parse(_curr[1]);
          carry = int.parse(_curr[0]);
        } else {
          carry = 0;
        }

        nums[opposite_i] = '$curr${nums[opposite_i]}';
      }

      if (carry >= 1) {
        nums[opposite_i] = '$carry${nums[opposite_i]}';
        carry = 0;
      }
    }

    IntStr res = IntStr();

    for (String str in nums) {
      res._val = _add(res._val, str);
    }

    if ((_sign == 1 && other._sign == -1) ||
        (_sign == -1 && other._sign == 1)) {
      res._sign = -1;
    }

    return res;
  }

  // TODO: Implement this
  DoubleStr operator /(IntStr other) {
    return DoubleStr();
  }

  void reverseSign() {
    if (_sign == 0) return;
    _sign = _sign == 1 ? -1 : 1;
  }

  /// Join two `IntStr` into one IntStr.
  ///
  /// If the signs are -1 and 1 or 1 and -1, the final sign
  /// will be -1.
  /// If either of signs are 0, the final sign will be equal
  /// to other's sign.
  /// And if the signs is -1 and -1, the final sign will be 1.
  ///
  /// ```dart
  /// IntStr.join(IntStr('1234'), IntStr('-5678')); // -12345678
  /// ```
  static IntStr join(IntStr a, IntStr b) {
    int __sign = 0;
    if (a.sign == 0) __sign = b.sign;
    if (b.sign == 0) __sign = a.sign;
    if (a.sign == 1 && b.sign == -1) __sign = -1;
    if (a.sign == -1 && b.sign == 1) __sign = -1;
    if (a.sign == b.sign && (a.sign == 1 || a.sign == -1)) __sign = 1;
    return IntStr('${a._val}${b._val}').._sign = __sign;
  }

  String _subtract(String a, String b) {
    bool swap = IntStr(a) < IntStr(b);
    String res = '';

    int debt = 0;
    int curr = 0;

    String top = swap ? b : a;
    String bottom = swap ? a : b;

    for (int i = 0; i < top.length; i++) {
      int j = top.length - 1 - i;
      int k = bottom.length - 1 - i;
      curr = int.parse(top[j]) - debt;

      if (curr == -1) {
        res = '9$res';
        continue;
      }

      int bt = k >= 0 ? int.parse(bottom[k]) : 0;
      if (curr >= bt) {
        curr -= bt;
        debt = 0;
      } else {
        debt = 1;
        curr = curr + 10 - bt;
      }
      res = '$curr$res';
    }

    res = _trimLeadingZeros(res);
    return swap ? '-$res' : res;
  }

  static String _trimLeadingZeros(String val) {
    String _sign = '';
    if (val[0] == ('-')) {
      _sign = '-';
      val = val.replaceFirst('-', '');
    }

    int i = 0;
    if (val == '0') return val;
    while (val[i] == '0') {
      i++;
      // All digits are zero
      if (i == val.length) {
        return '0';
      }
    }

    return '$_sign${val.replaceRange(0, i, '')}';
  }

  String _add(String a, String b) {
    int carry = 0;
    int len = _maxInt(a.length, b.length);
    int curr = 0;
    String res = '';
    for (int i = 0; i < len; i++) {
      curr = carry;
      int j = a.length - 1 - i;
      int k = b.length - 1 - i;

      if (j >= 0) curr += int.parse(a[j]);
      if (k >= 0) curr += int.parse(b[k]);

      if (curr >= 10) {
        curr -= 10;
        carry = 1;
      } else {
        carry = 0;
      }
      res = '$curr$res';
    }
    if (carry == 1) {
      res = '1$res';
    }

    return res;
  }

  @override
  String toString() => '${_sign == -1 ? '-' : ''}$_val';

  @override
  int compareTo(other) {
    if (_sign != other._sign) {
      return _sign - other._sign;
    }
    //? maybe we can improve this
    return (this - other)._sign;
  }
}
