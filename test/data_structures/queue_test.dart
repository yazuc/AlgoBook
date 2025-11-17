import 'package:flutter_test/flutter_test.dart';
import 'package:AlgoBook/data_structures/queue.dart';

void main() {
  group('CustomQueue', () {
    late CustomQueue<int> queue;

    setUp(() {
      queue = CustomQueue<int>(5);
    });

    test('isEmpty returns true for an empty queue', () {
      expect(queue.isEmpty, isTrue);
    });

    test('isEmpty returns false for a non-empty queue', () {
      queue.enqueue(1);
      expect(queue.isEmpty, isFalse);
    });

    test('enqueue adds an element to the queue', () {
      queue.enqueue(1);
      expect(queue.elements.where((e) => e != null).toList(), [1]);
      queue.enqueue(2);
      expect(queue.elements.where((e) => e != null).toList(), [1, 2]);
    });

    test('dequeue removes and returns the front element', () {
      queue.enqueue(1);
      queue.enqueue(2);
      final dequeued = queue.dequeue();
      expect(dequeued, 1);
      expect(queue.elements.where((e) => e != null).toList(), [2]);
    });

    test('dequeue returns null for an empty queue', () {
      final dequeued = queue.dequeue();
      expect(dequeued, isNull);
    });

    test('head returns the front element without removing it', () {
      queue.enqueue(1);
      queue.enqueue(2);
      final peeked = queue.head;
      expect(peeked, 1);
      expect(queue.elements.where((e) => e != null).toList(), [1, 2]);
    });

    test('head returns null for an empty queue', () {
      final peeked = queue.head;
      expect(peeked, isNull);
    });

    test('clear removes all elements from the queue', () {
      queue.enqueue(1);
      queue.enqueue(2);
      queue.clear();
      expect(queue.isEmpty, isTrue);
    });

    test('isFull returns true for a full queue', () {
      queue.enqueue(1);
      queue.enqueue(2);
      queue.enqueue(3);
      queue.enqueue(4);
      queue.enqueue(5);
      expect(queue.isFull, isTrue);
    });

    test('isFull returns false for a non-full queue', () {
      queue.enqueue(1);
      expect(queue.isFull, isFalse);
    });
  });
}
