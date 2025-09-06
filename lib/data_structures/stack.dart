import 'package:flutter/material.dart';

/// Implementação de uma pilha (stack) genérica.
///
/// Esta pilha mantém duas listas internas:
/// - Uma lista de elementos ativos (que estão na pilha)
/// - Uma lista de memória que mantém o histórico de elementos
///   para fins de visualização
class CustomStack<T> extends ChangeNotifier {
  /// Lista de elementos atualmente na pilha
  final List<T> _elements = [];
  
  /// Lista de memória para visualização, mantém histórico dos elementos
  final List<T?> _memory = [];

  /// Adiciona um elemento ao topo da pilha.
  ///
  /// Este método insere o valor no topo da pilha e também o registra
  /// na lista de memória para visualização. A memória pode conter 
  /// posições vazias (null) se elementos forem removidos.
  ///
  /// Após a inserção, notifica os ouvintes sobre a mudança.
  ///
  /// [value] O valor a ser inserido no topo da pilha.
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

  /// Remove e retorna o elemento do topo da pilha.
  ///
  /// Se a pilha estiver vazia, retorna null.
  /// Este método não altera a lista de memória, mantendo
  /// o histórico intacto para visualização.
  ///
  /// Após a remoção, notifica os ouvintes sobre a mudança.
  ///
  /// @return O elemento removido do topo da pilha, ou null se a pilha estiver vazia.
  T? pop() {
    if (_elements.isNotEmpty) {
      T value = _elements.removeLast();
      notifyListeners();
      return value;
    }
    return null;
  }

  /// Remove todos os elementos da pilha.
  ///
  /// Este método esvazia a pilha chamando o método pop()
  /// repetidamente até que a pilha esteja vazia.
  /// Cada chamada a pop() notifica os ouvintes.
  void exec() {
    while (_elements.isNotEmpty) {
      pop();
    }
  }

  /// Obtém uma lista não-modificável dos elementos ativos na pilha.
  ///
  /// Esta lista representa os elementos que estão atualmente na pilha,
  /// na ordem de inserção (o último elemento é o topo da pilha).
  List<T> get elements => List.unmodifiable(_elements);
  
  /// Obtém uma lista não-modificável do histórico de memória.
  ///
  /// Esta lista contém todos os valores que foram inseridos na pilha,
  /// com posições vazias (null) quando os elementos são removidos.
  /// É usada para visualização da pilha, mostrando o estado atual e histórico.
  List<T?> get memory => List.unmodifiable(_memory);

  /// Verifica se a pilha está vazia.
  bool get isEmpty => _elements.isEmpty;

  /// Retorna o elemento do topo da pilha sem removê-lo.
  ///
  /// Se a pilha estiver vazia, retorna null.
  T? get peek => _elements.isNotEmpty ? _elements.last : null;
} 