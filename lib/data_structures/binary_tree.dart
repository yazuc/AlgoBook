import 'package:flutter/material.dart';

/// Representação de um nó em uma árvore binária.
/// 
/// Cada nó contém um valor do tipo genérico T e referências
/// opcionais para os nós filhos à esquerda e à direita.
class TreeNode<T> {
  /// O valor armazenado no nó
  T value;
  
  /// Referência para o nó filho à esquerda (valores menores)
  TreeNode<T>? left;
  
  /// Referência para o nó filho à direita (valores maiores ou iguais)
  TreeNode<T>? right;

  /// Cria um novo nó com o valor especificado.
  /// 
  /// Inicialmente, os filhos esquerdo e direito são nulos.
  TreeNode(this.value);
}

/// Implementação de uma árvore binária de busca.
/// 
/// Esta árvore organiza os valores de forma ordenada, onde:
/// - Valores menores que o nó pai são inseridos à esquerda
/// - Valores maiores ou iguais ao nó pai são inseridos à direita
/// 
/// A árvore utiliza a interface Comparable para comparar valores
/// e decidir onde inserir novos elementos.
class CustomBinaryTree<T extends Comparable> extends ChangeNotifier {
  /// Referência para o nó raiz da árvore
  TreeNode<T>? _root;

  /// Obtém o nó raiz da árvore (apenas leitura)
  TreeNode<T>? get root => _root;

  /// Insere um novo valor na árvore.
  /// 
  /// Se a árvore estiver vazia, cria um novo nó raiz com o valor.
  /// Caso contrário, insere o valor no local apropriado seguindo
  /// as regras de uma árvore binária de busca.
  /// 
  /// Após a inserção, notifica os ouvintes sobre a mudança.
  /// 
  /// [value] O valor a ser inserido na árvore.
  void insert(T value) {
    if (_root == null) {
      _root = TreeNode(value);
    } else {
      _insertRecursive(_root!, value);
    }
    notifyListeners();
  }

  /// Método auxiliar recursivo para inserir um valor na posição correta.
  /// 
  /// Compara o valor a ser inserido com o valor do nó atual:
  /// - Se for menor, insere na subárvore esquerda
  /// - Se for maior ou igual, insere na subárvore direita
  /// 
  /// [node] O nó atual onde estamos tentando inserir
  /// [value] O valor a ser inserido
  void _insertRecursive(TreeNode<T> node, T value) {
    if (value.compareTo(node.value) < 0) {
      if (node.left == null) {
        node.left = TreeNode(value);
      } else {
        _insertRecursive(node.left!, value);
      }
    } else {
      if (node.right == null) {
        node.right = TreeNode(value);
      } else {
        _insertRecursive(node.right!, value);
      }
    }
  }

  /// Limpa a árvore, removendo todos os nós.
  /// 
  /// Após a limpeza, a árvore estará vazia (raiz nula).
  /// Notifica os ouvintes sobre a mudança.
  void clear() {
    _root = null;
    notifyListeners();
  }

  /// Procura por um valor na árvore.
  ///
  /// Retorna true se o valor for encontrado, false caso contrário.
  bool search(T value) {
    return _searchRecursive(_root, value);
  }

  bool _searchRecursive(TreeNode<T>? node, T value) {
    if (node == null) {
      return false;
    }
    if (value.compareTo(node.value) == 0) {
      return true;
    }
    if (value.compareTo(node.value) < 0) {
      return _searchRecursive(node.left, value);
    } else {
      return _searchRecursive(node.right, value);
    }
  }

  /// Remove um valor da árvore.
  ///
  /// Notifica os ouvintes sobre a mudança.
  void remove(T value) {
    _root = _removeRecursive(_root, value);
    notifyListeners();
  }

  TreeNode<T>? _removeRecursive(TreeNode<T>? node, T value) {
    if (node == null) {
      return null;
    }
    if (value.compareTo(node.value) < 0) {
      node.left = _removeRecursive(node.left, value);
    } else if (value.compareTo(node.value) > 0) {
      node.right = _removeRecursive(node.right, value);
    } else {
      if (node.left == null) {
        return node.right;
      } else if (node.right == null) {
        return node.left;
      }
      node.value = _minValue(node.right!);
      node.right = _removeRecursive(node.right, node.value);
    }
    return node;
  }

  T _minValue(TreeNode<T> node) {
    T minValue = node.value;
    while (node.left != null) {
      minValue = node.left!.value;
      node = node.left!;
    }
    return minValue;
  }
} 