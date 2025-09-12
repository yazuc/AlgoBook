import 'package:flutter/material.dart';

class Node<T> {
  T value;
  Node<T>? next;
  Node<T>? prev;

  Node({required this.value, this.next, this.prev});
}

class DoublyLinkedList<T> extends ChangeNotifier {
  Node<T>? head;

  void insert(T value) {
    final newNode = Node(value: value);
    if (head == null) {
      head = newNode;
    } else {
      newNode.next = head;
      head!.prev = newNode;
      head = newNode;
    }
    notifyListeners();
  }

  void delete(Node<T> node) {
    if (node.prev != null) {
      node.prev!.next = node.next;
    } else {
      head = node.next;
    }
    if (node.next != null) {
      node.next!.prev = node.prev;
    }
    notifyListeners();
  }

  Node<T>? search(T value) {
    var current = head;
    while (current != null) {
      if (current.value == value) {
        return current;
      }
      current = current.next;
    }
    return null;
  }

  List<T> get values {
    final List<T> list = [];
    var current = head;
    while (current != null) {
      list.add(current.value);
      current = current.next;
    }
    return list;
  }
}
