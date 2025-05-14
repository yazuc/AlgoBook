import 'package:flutter/material.dart';

class TreeNode<T> {
  T value;
  TreeNode<T>? left;
  TreeNode<T>? right;

  TreeNode(this.value);
}

/// Implementação de uma árvore binária simples.
/// 
/// Diferente da implementação da Stack, esta versão da árvore
/// não mantém uma lista de memória dos nós, pois a visualização
/// é feita pela navegação recursiva da estrutura da árvore a
/// partir do nó raiz.
class CustomBinaryTree<T> extends ChangeNotifier {
  TreeNode<T>? _root;

  TreeNode<T>? get root => _root;

  void insert(T value) {
    if (_root == null) {
      _root = TreeNode(value);
    } else {
      _insertRecursive(_root!, value);
    }
    notifyListeners();
  }

  void _insertRecursive(TreeNode<T> node, T value) {
    if (node.left == null) {
      node.left = TreeNode(value);
    } else if (node.right == null) {
      node.right = TreeNode(value);
    } else {
      // Se ambos os filhos existem, tenta inserir no filho esquerdo primeiro
      if (_isComplete(node.left!)) {
        _insertRecursive(node.right!, value);
      } else {
        _insertRecursive(node.left!, value);
      }
    }
  }

  bool _isComplete(TreeNode<T> node) {
    if (node.left == null) return false;
    if (node.right == null) return false;
    return _isComplete(node.left!) && _isComplete(node.right!);
  }

  void clear() {
    _root = null;
    notifyListeners();
  }
} 