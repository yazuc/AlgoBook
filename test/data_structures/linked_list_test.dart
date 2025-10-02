import 'package:flutter_test/flutter_test.dart';
import 'package:Bookrithm/data_structures/linked_list.dart';

void main() {
  group('DoublyLinkedList', () {
    late DoublyLinkedList<int> list;

    setUp(() {
      list = DoublyLinkedList<int>();
    });

    test('insert adds an element to an empty list', () {
      list.insert(1);
      expect(list.values, [1]);
      expect(list.head?.value, 1);
    });

    test('insert adds elements to the beginning of the list', () {
      list.insert(1);
      list.insert(2);
      list.insert(3);
      expect(list.values, [3, 2, 1]);
      expect(list.head?.value, 3);
    });

    test('search finds an existing element', () {
      list.insert(1);
      list.insert(2);
      final node = list.search(1);
      expect(node, isNotNull);
      expect(node?.value, 1);
    });

    test('search returns null for a non-existing element', () {
      list.insert(1);
      final node = list.search(2);
      expect(node, isNull);
    });

    test('delete removes an element from the list', () {
      list.insert(1);
      list.insert(2);
      list.insert(3);
      final nodeToDelete = list.search(2);
      expect(nodeToDelete, isNotNull);
      if (nodeToDelete != null) {
        list.delete(nodeToDelete);
      }
      expect(list.values, [3, 1]);
    });

    test('delete removes the head of the list', () {
      list.insert(1);
      list.insert(2);
      final nodeToDelete = list.search(2);
       expect(nodeToDelete, isNotNull);
      if (nodeToDelete != null) {
        list.delete(nodeToDelete);
      }
      expect(list.values, [1]);
      expect(list.head?.value, 1);
    });

    test('delete removes the only element in the list', () {
      list.insert(1);
      final nodeToDelete = list.search(1);
       expect(nodeToDelete, isNotNull);
      if (nodeToDelete != null) {
        list.delete(nodeToDelete);
      }
      expect(list.values, []);
      expect(list.head, isNull);
    });
  });
}
