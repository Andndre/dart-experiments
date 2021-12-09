// TODO: Complete this
import 'int_string.dart';

class DoubleStr {
  String _val;
  String _decimal;
  int _sign;

  DoubleStr([String value = '0.0'])
      : _val = value.replaceFirst('-', '').split('.')[0],
        _decimal = value.replaceFirst('-', '').split('.')[1],
        _sign = value[0] == '-'
            ? -1
            : value == '0.0'
                ? 0
                : 1;

  DoubleStr.fromIntStr(IntStr value)
      : _val = value.toString().replaceFirst('-', ''),
        _decimal = '0',
        _sign = value.sign;

  DoubleStr operator +(DoubleStr other) {
    return DoubleStr();
  }

  int get valLength => _val.length;
  int get decimalLength => _decimal.length;

  static int _maxInt(int a, int b) => a > b ? a : b;

  static String add(String a, String b) {
    int carry = 0;

    String decimalResult = '';
    String valResult = '';

    List<String> aList = a.split('.');
    List<String> bList = b.split('.');

    if (aList.length != 2 || bList.length != 2) {
      throw new Exception('invalid number!: $a or/and $b');
    }

    int len = _maxInt(aList[1].length, bList[1].length);
    int curr = 0;

    // decimal
    for (int i = len - 1; i >= 0; i--) {
      curr = carry;

      if (i < aList[1].length) curr += int.parse(aList[1][i]);
      if (i < bList[1].length) curr += int.parse(bList[1][i]);

      if (curr >= 10) {
        curr -= 10;
        carry = 1;
      } else {
        carry = 0;
      }

      decimalResult = '$curr$decimalResult';
      if (decimalResult == '0') decimalResult = '';
    }

    if (decimalResult == '') decimalResult = '';

    len = _maxInt(aList[0].length, bList[0].length);

    // value
    for (int i = 0; i < len; i++) {
      curr = carry;
      int j = aList[0].length - 1 - i;
      int k = bList[0].length - 1 - i;

      if (j >= 0) curr += int.parse(aList[0][j]);
      if (k >= 0) curr += int.parse(bList[0][k]);

      if (curr >= 10) {
        curr -= 10;
        carry = 1;
      } else {
        carry = 0;
      }

      valResult = '$curr$valResult';
    }
    if (carry == 1) {
      valResult = '1$valResult';
    }

    return '$valResult.$decimalResult';
  }

  @override
  String toString() {
    String sign = _sign == -1 ? '-' : '';
    return '$sign$_val.$_decimal';
  }
}
