import 'package:flutter/material.dart';

class CustomStack<T> extends ChangeNotifier {
  final List<T> _elements = [];

  void push(T value) {
    _elements.add(value);
    notifyListeners();
  }

  T? pop() {
    if (_elements.isNotEmpty) {
      T value = _elements.removeLast();
      notifyListeners();
      return value;
    }
    return null;
  }

  void exec() {
    while (_elements.isNotEmpty) {
      pop();  // Keep popping until the stack is empty
    }
  }


  List<T> get elements => List.unmodifiable(_elements);
}
