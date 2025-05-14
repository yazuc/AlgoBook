import 'package:flutter/material.dart';

class CustomStack<T> extends ChangeNotifier {
  final List<T> _elements = [];
  final List<T?> _memory = [];

  void push(T value) {
    _elements.add(value);
    final index = _elements.length - 1;

    if (index < _memory.length) {
      _memory[index] = value; // sobrescreve posição existente
    } else {
      _memory.add(value); // expande memória
    }

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
      pop();
    }
  }

  List<T> get elements => List.unmodifiable(_elements);
  List<T?> get memory => List.unmodifiable(_memory);
} 