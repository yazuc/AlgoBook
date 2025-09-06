import 'package:flutter_test/flutter_test.dart';
import 'package:Bookrithm/data_structures/binary_tree.dart';

void main() {
  group('CustomBinaryTree', () {
    late CustomBinaryTree<int> tree;

    setUp(() {
      tree = CustomBinaryTree<int>();
    });

    test('insert creates a root node in an empty tree', () {
      tree.insert(10);
      expect(tree.root, isNotNull);
      expect(tree.root!.value, 10);
    });

    test('insert adds smaller values to the left', () {
      tree.insert(10);
      tree.insert(5);
      expect(tree.root!.left, isNotNull);
      expect(tree.root!.left!.value, 5);
    });

    test('insert adds larger values to the right', () {
      tree.insert(10);
      tree.insert(15);
      expect(tree.root!.right, isNotNull);
      expect(tree.root!.right!.value, 15);
    });

    test('search finds an existing value', () {
      tree.insert(10);
      tree.insert(5);
      tree.insert(15);
      expect(tree.search(15), isTrue);
    });

    test('search does not find a non-existing value', () {
      tree.insert(10);
      tree.insert(5);
      tree.insert(15);
      expect(tree.search(20), isFalse);
    });

    test('remove deletes a leaf node', () {
      tree.insert(10);
      tree.insert(5);
      tree.insert(15);
      tree.remove(15);
      expect(tree.search(15), isFalse);
    });

    test('remove deletes a node with one child', () {
      tree.insert(10);
      tree.insert(5);
      tree.insert(15);
      tree.insert(12);
      tree.remove(15);
      expect(tree.search(15), isFalse);
      expect(tree.root!.right!.value, 12);
    });

    test('remove deletes a node with two children', () {
      tree.insert(10);
      tree.insert(5);
      tree.insert(20);
      tree.insert(15);
      tree.insert(25);
      tree.insert(12);
      tree.insert(18);

      tree.remove(20);

      expect(tree.search(20), isFalse);
      expect(tree.root!.value, 10);
      expect(tree.root!.right!.value, 25);
      expect(tree.root!.right!.left!.value, 15);
      expect(tree.root!.right!.left!.left!.value, 12);
      expect(tree.root!.right!.left!.right!.value, 18);
    });

    test('clear removes all nodes from the tree', () {
      tree.insert(10);
      tree.insert(5);
      tree.insert(15);
      tree.clear();
      expect(tree.root, isNull);
    });
  });
}
