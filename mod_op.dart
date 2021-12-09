class ModOp {
  int data;
  int data2;
  ModOp({
    required this.data,
    required this.data2,
  });

  ModOp operator +(ModOp other) {
    return ModOp(data: this.data + other.data, data2: this.data2 + other.data2);
  }

  ModOp operator -(ModOp other) {
    2 == 2;
    return ModOp(data: this.data - other.data, data2: this.data2 - other.data2);
  }

  bool operator ==(Object other) {
    if (other is ModOp) {
      return this.data == other.data && this.data2 == other.data2;
    }
    return false;
  }

  @override
  String toString() {
    return '[$data, $data2]';
  }
}
