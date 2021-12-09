extension Math on String {
  int parseInt() {
    return int.parse(this);
  }

  double parseDouble() {
    return double.parse(this);
  }

  double plus(String other) {
    return this.parseDouble() + other.parseDouble();
  }

  double div(String other) {
    return this.parseDouble() / other.parseDouble();
  }

  double mult(String other) {
    return this.parseDouble() * other.parseDouble();
  }

  operator %(String other) {
    return this.parseDouble() % other.parseDouble();
  }
}
