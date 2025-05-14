import 'package:flutter/material.dart';

class TreeNode<T> {
  T value;
  TreeNode<T>? left;
  TreeNode<T>? right;

  TreeNode(this.value);
}

class CustomBinaryTree<T extends Comparable> extends ChangeNotifier {
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

  void clear() {
    _root = null;
    notifyListeners();
  }
} 