class LinkedList<T> {
  LinkedList? next;
  T headValue;

  LinkedList({
    required this.headValue,
    this.next = null,
  });

  /**
   * get [length] of this linked list
  */
  int get length {
    int length = 1;

    LinkedList tmp = this;

    while (tmp.next != null) {
      tmp = tmp.next!;
      length++;
    }

    return length;
  }

  /**
   * func [forEach]
  */
  void forEach(void func(T e)) {
    LinkedList tmp = this;
    while (true) {
      func(tmp.headValue);
      if (tmp.next == null) break;
      tmp = tmp.next!;
    }
  }

  /**
   * Adds [end] at the end
  */
  void append(T end) {
    LinkedList tmp = LinkedList(headValue: end);
    _last.next = tmp;
  }

  /**
   * get [_last] element
  */
  LinkedList get _last {
    LinkedList tmp = this;
    while (true) {
      if (tmp.next == null) break;
      tmp = tmp.next!;
    }

    return tmp;
  }

  void cutAfter(int index) {
    LinkedList tmp = elementAt(index);
    tmp.next = null;
  }

  /**
   * Adds [first] to the list with index zero
  */
  void insert(T first) {
    LinkedList tmp = new LinkedList(headValue: headValue);

    tmp.next = next;
    tmp.headValue = headValue;
    next = tmp;
    headValue = first;
  }

  LinkedList elementAt(int index) {
    int i = 0;
    LinkedList tmp = this;

    while (i < index) {
      tmp = tmp.next!;
      i++;
    }

    return tmp;
  }

  /**
   * [String] representation of this object
  */
  @override
  String toString() {
    return toList().toString();
  }

  /**
   * Converts to [List]
   * 
   * ```dart
   * Node<String> linkedList = Node(value: 'hello');
   * List<String> someList = linkedList.toList(); // ['hello']
   *```
  */
  List<T> toList() {
    List<T> a = [];
    forEach((e) {
      a.add(e);
    });
    return a;
  }
}
