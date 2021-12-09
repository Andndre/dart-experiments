import 'linked_list.dart';

class HistoryString {
  late LinkedList<String> _linkedList;
  int _currentIndex = 0;

  HistoryString(String init) {
    this._linkedList = LinkedList(headValue: init);
  }

  void setText(String txt) {
    _linkedList.cutAfter(_currentIndex);
    LinkedList tmp1 = _linkedList.elementAt(_currentIndex);
    tmp1.next = LinkedList(headValue: txt);
    _currentIndex++;
  }

  bool get hasUndo {
    return _currentIndex != 0;
  }

  bool get hasRedo {
    return _currentIndex < _linkedList.length - 1;
  }

  String get text {
    return _linkedList.elementAt(_currentIndex).headValue;
  }

  int get length {
    return _linkedList.length;
  }

  bool undo() {
    if (hasUndo) {
      _currentIndex--;
      return true;
    } else {
      print('cannot undo');
      return false;
    }
  }

  bool redo() {
    if (hasRedo) {
      _currentIndex++;
      return true;
    } else {
      print('cannot redo');
      return false;
    }
  }

  void printAll() {
    _linkedList.forEach((e) {
      print(e);
    });
  }
}
