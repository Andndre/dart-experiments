import 'dart:math';

import 'main.dart';

num snap(num number, num step) {
  return (((number + 1) / step).ceil() - 1) * step;
}

// https://stackoverflow.com/questions/12967896/converting-integers-to-roman-numerals-java
// String intToRoman(int number) {
//   if (number == 5000) return 'V';
//   int minValue = 1;
//   int maxValue = 4999;
//   List<String> romanM = ["", "M", "MM", "MMM", "MMMM"];
//   List<String> romanC = ["", "C", "CC", "CCC", "CD", "D", "DC", "DCC", "DCCC", "CM"];
//   List<String> romanX = ["", "X", "XX", "XXX", "XL", "L", "LX", "LXX", "LXXX", "XC"];
//   List<String> romanI = ["", "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX"];
//   if (number < minValue || number > maxValue) {
//     throw ('The number must be in the range $minValue..$maxValue');
//   }

//   return romanM[(number / 1000).floor()] + romanC[(number % 1000 / 100).floor()] + romanX[(number % 100 / 10).floor()] + romanI[number % 10];
// }

const List<int> arabianRomanNumbers = [
  1000,
  900,
  500,
  400,
  100,
  90,
  50,
  40,
  10,
  9,
  5,
  4,
  1
];

const List<String> romanNumbers = [
  "M",
  "CM",
  "D",
  "CD",
  "C",
  "XC",
  "L",
  "XL",
  "X",
  "IX",
  "V",
  "IV",
  "I"
];

// https://stackoverflow.com/questions/60332689/how-do-i-make-an-integer-to-roman-algorithm-in-dart
String intToRoman(int input) {
  if (input <= 0) {
    return "";
  }

  StringBuffer builder = StringBuffer();

  for (int a = 0; a < arabianRomanNumbers.length; a++) {
    int times = (input / arabianRomanNumbers[a])
        .truncate(); // equals 1 only when arabianRomanNumbers[a] = num
    // executes n times where n is the number of times you have to add
    // the current roman number value to reach current num.
    builder.write(romanNumbers[a] * times);
    input -= times *
        arabianRomanNumbers[a]; // subtract previous roman number value from num
  }

  return builder.toString();
}

double exp(int x) {
  return <double>[
    for (int i = 0; i <= 100; i++) ...[
      pow(x, i) / factorial(i),
    ]
  ].sum();
}

double factorial(int i) {
  double result = i.toDouble();
  if (result < 0) return 0;
  if (result <= 1) return 1;
  for (double i = result - 1; i >= 1; i--) result *= i;
  return result;
}
