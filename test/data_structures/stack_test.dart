import 'package:flutter_test/flutter_test.dart';
import 'package:Bookrithm/data_structures/stack.dart';

void main() {
  group('CustomStack', () {
    late CustomStack<int> stack;

    setUp(() {
      stack = CustomStack<int>();
    });

    test('isEmpty returns true for an empty stack', () {
      expect(stack.isEmpty, isTrue);
    });

    test('isEmpty returns false for a non-empty stack', () {
      stack.push(1);
      expect(stack.isEmpty, isFalse);
    });

    test('push adds an element to the stack', () {
      stack.push(1);
      expect(stack.elements, [1]);
      stack.push(2);
      expect(stack.elements, [1, 2]);
    });

    test('pop removes and returns the top element', () {
      stack.push(1);
      stack.push(2);
      final popped = stack.pop();
      expect(popped, 2);
      expect(stack.elements, [1]);
    });

    test('pop returns null for an empty stack', () {
      final popped = stack.pop();
      expect(popped, isNull);
    });

    test('peek returns the top element without removing it', () {
      stack.push(1);
      stack.push(2);
      final peeked = stack.peek;
      expect(peeked, 2);
      expect(stack.elements, [1, 2]);
    });

    test('peek returns null for an empty stack', () {
      final peeked = stack.peek;
      expect(peeked, isNull);
    });

    test('exec clears the stack', () {
      stack.push(1);
      stack.push(2);
      stack.exec();
      expect(stack.isEmpty, isTrue);
    });
  });
}
