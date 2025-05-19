import 'package:flutter/material.dart';

/// Implementação de uma fila (queue) genérica.
///
/// Esta fila mantém uma lista circular de elementos,
/// onde novos elementos são adicionados ao final e
/// removidos do início (FIFO - First In, First Out).
class CustomQueue<T> extends ChangeNotifier {
  /// Lista de elementos na fila
  final List<T?> _elements;
  
  /// Índice do primeiro elemento na fila
  int _front = 0;
  
  /// Índice do próximo elemento a ser inserido
  int _rear = 0;
  
  /// Número de elementos na fila
  int _size = 0;

  CustomQueue(int capacity) : _elements = List.filled(capacity, null);

  /// Adiciona um elemento ao final da fila.
  ///
  /// [value] O valor a ser inserido no final da fila.
  /// Retorna true se a inserção foi bem sucedida, false se a fila estiver cheia.
  bool enqueue(T value) {
    if (_size == _elements.length) {
      return false; // Fila cheia
    }
    
    _elements[_rear] = value;
    _rear = (_rear + 1) % _elements.length;
    _size++;
    
    notifyListeners();
    return true;
  }

  /// Remove e retorna o elemento do início da fila.
  ///
  /// Retorna null se a fila estiver vazia.
  T? dequeue() {
    if (_size == 0) {
      return null;
    }
    
    T? value = _elements[_front];
    _elements[_front] = null;
    _front = (_front + 1) % _elements.length;
    _size--;
    
    notifyListeners();
    return value;
  }

  /// Remove todos os elementos da fila.
  void clear() {
    _elements.fillRange(0, _elements.length, null);
    _front = 0;
    _rear = 0;
    _size = 0;
    notifyListeners();
  }

  /// Obtém a lista de elementos para visualização.
  List<T?> get elements {
    List<T?> result = List.filled(_elements.length, null);
    int current = _front;
    for (int i = 0; i < _size; i++) {
      result[current] = _elements[current];
      current = (current + 1) % _elements.length;
    }
    return result;
  }

  /// Retorna o primeiro elemento da fila sem removê-lo.
  T? get head => _size > 0 ? _elements[_front] : null;

  /// Retorna o último elemento da fila sem removê-lo.
  T? get tail => _size > 0 ? _elements[(_rear - 1 + _elements.length) % _elements.length] : null;

  /// Retorna a quantidade de elementos atualmente na fila.
  int get length => _size;

  /// Retorna true se a fila estiver vazia.
  bool get isEmpty => _size == 0;

  /// Retorna true se a fila estiver cheia.
  bool get isFull => _size == _elements.length;

  /// Retorna o índice do primeiro elemento na fila.
  int get frontIndex => _front;

  /// Retorna o índice do último elemento na fila.
  int get rearIndex => (_rear - 1 + _elements.length) % _elements.length;
}


