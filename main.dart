import 'dart:developer';

enum color { RED, GREEN, BLUE, YELLOW, ORANGE, PINK, PURPLE }

typedef ListMapper<T> = Map<T, List<T>>;

void main() {
  int startTime = Timeline.now;

  print([1, -1, 1, 1, 1, -1, -1, 1].scan());
  print([6215, 879432, 317, 13, 41, 41, 41, 313, 113, 313, 313].mean());

  int endTime = Timeline.now;
  print('${(endTime - startTime) / 1000} ms');
}

void pascalTriangle(int n) {
  if (n <= 0) return;
  if (n == 1) {
    print('1');
    return;
  }
  if (n == 2) {
    print(' 1');
    print('1 1');
    return;
  }

  List<List<int>> pT = [
    [1],
    [1, 1]
  ];

  for (int i = 2; i < n; i++) {
    pT.add([1]);
    for (int j = 1; j < i; j++) {
      pT[i].add(pT[i - 1][j - 1] + pT[i - 1][j]);
    }
    pT[i].add(1);
  }

  int spaces = pT[pT.length - 1].length - 1;
  for (int i = 0; i < pT.length; i++) {
    print(' ' * spaces + pT[i].join(' '));
    spaces--;
  }
}

void clearConsole() {
  print("\x1B[2J\x1B[0;0H");
}

bool canConstruct(String target, List<String> wordBank) {
  if (target == '') return true;
  for (String str in wordBank) {
    if (target.startsWith(str)) {
      if (canConstruct(target.replaceFirst(str, ''), wordBank)) return true;
    }
  }
  return false;
}

bool canSum(int target, List<int> array, Map memo) {
  if (memo.containsKey(target)) return memo[target] as bool;
  if (target < 0) return false;
  if (target == 0) return true;
  for (int numb in array) {
    int remainder = target - numb;
    if (canSum(remainder, array, memo)) {
      memo.addAll({target: true});
      return true;
    }
  }
  memo.addAll({target: false});
  return false;
}

void displayImg(List<List> img) {
  img.forEach((element) {
    print(element);
  });
}

/// ```
/// f(0) = 0,
/// f(1) = 1,
/// f(n) = f(n-1) + f(n-2).
/// ```
/// returns [n]th fibonacci number
///
/// returns zero if [n] is less than or equal to zero
BigInt fibonacci(int n) {
  List<BigInt> dp = [BigInt.zero, BigInt.one, BigInt.one];

  if (n <= 2) {
    if (n < 0) return dp[0];
    return dp[n];
  }

  for (int i = 1; i < n; i++) {
    dp[2] = dp[0] + dp[1];
    dp[0] = dp[1];
    dp[1] = dp[2];
  }

  return dp[2];
}

Object? firstDuplicate(List<Object> arr) {
  List<Object> history = [];
  for (int i = 0; i < arr.length; i++) {
    Object current = arr[i];
    if (history.contains(current)) return current;
    history.add(current);
  }
  print('not found');
  return null;
}

String? firstNotRepeatingCharacter(String str) {
  if (str.length <= 1) return 'not found';
  String willRepeat = str[0];
  for (int i = 1; i < str.length; i++) {
    if (str[i] != willRepeat) {
      return str[i];
    }
  }
  print('not found');
  return null;
}

List<List<int>> generateEmptyImg(int width, int height) {
  return List.generate(height, (__) => List.generate(width, (_) => 0));
}

BigInt gridTlaveler(int m, int n) {
  return _gridTlaveler(m, n, {});
}

BigInt _gridTlaveler(int m, int n, Map<String, BigInt> memo) {
  String key = '$m,$n';
  // because gridTlaveler(m, n) == gridTlaveler(n, m), we can check '$n,$m' too
  String keyReverse = '$n,$m';
  if (memo.containsKey(key)) return memo[key]!;
  if (memo.containsKey(keyReverse)) return memo[keyReverse]!;
  if (n == 1 && m == 1) return BigInt.from(1);
  if (n == 0 || m == 0) return BigInt.from(0);
  memo[key] = _gridTlaveler(m - 1, n, memo) + _gridTlaveler(m, n - 1, memo);
  return memo[key]!;
}

double mean(List<int> numbers) {
  int sum = 0;

  for (int number in numbers) {
    sum += number;
  }

  return sum / numbers.length;
}

List<List<int>> rotateImageRight(List<List<int>> img) {
  int length = img.length;
  List<List<int>> result = generateEmptyImg(length, length);

  for (int i = 0; i < length; i++) {
    for (int j = 0; j < length; j++) {
      result[i][j] = img[2 - j][i];
    }
  }

  return result;
}

List<List<int>> rotateImage(List<List<int>> img, int rotation) {
  bool right = rotation.sign == 1;
  int rotate = rotation.abs() % 4;
  if (rotate == 0) return img;

  int max = right ? rotate : 4 - rotate;
  for (int i = 1; i <= max; i++) {
    img = rotateImageRight(img);
  }

  return img;
}

String spreadRepeatingCharacters(Map<String, int> map) {
  String result = '';
  map.forEach((key, value) {
    result += key * value;
  });
  return result;
}

List<int> sumOfTwo(List<int> first, List<int> second, int target,
    [int offset = 0]) {
  List<int> closest = [];
  first.sort((a, b) => a.compareTo(b));
  second.sort((a, b) => a.compareTo(b));

  int cAIndex = 0;
  int cBIndex = second.length - 1;

  while (cAIndex != first.length) {
    int res = first[cAIndex] + second[cBIndex];

    if (res == target) {
      print('${first[cAIndex]} + ${second[cBIndex]} = $res');
      return [res];
    } else if (res < target) {
      if ((res - target).abs() <= offset) {
        closest.add(res);
      }
      cAIndex++;
    } else if (res > target) {
      if ((res - target).abs() <= offset) {
        closest.add(res);
      }
      cBIndex--;
    }
  }

  return closest;
}

Future<void> calculatePi() async {
  double pi = 1;
  double i = 0;

  for (;; i++) {
    double den = i * 2 + 3;
    double frac = 1 / den;
    if (i % 2 == 0) {
      pi = pi - frac;
    } else {
      pi = pi + frac;
    }
    await Future.delayed(Duration(milliseconds: 10));
    clearConsole();
    print('1/$den = $frac');
    print(pi * 4);
    if (den == double.maxFinite) {
      break;
    }
    // i += 1;
  }
}

extension DoubleMath on List<double> {
  double mean() {
    if (length == 0) {
      return double.nan;
    }
    double sum = 0;
    forEach((element) {
      sum += element;
    });
    return sum / length;
  }

  double sum() {
    double result = 0;
    forEach((element) {
      result += element;
    });
    return result;
  }
}

extension ListExtension on List<num> {
  num mean() {
    if (length == 0) return 0;

    if (length == 0) {
      return double.nan;
    }

    num sum = 0;
    forEach((element) {
      sum += num.parse(element.toString());
    });
    return sum / length;
  }

  List<num> scan() {
    num current = 0;
    List<num> result = [];

    for (int i = 0; i < length; i++) {
      current += elementAt(i);
      result.add(current);
    }

    return result;
  }

  num sum() {
    num result = 0;
    forEach((element) {
      result += element;
    });
    return result;
  }
}
