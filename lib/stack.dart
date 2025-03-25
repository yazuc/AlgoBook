import 'package:flutter/material.dart';

class CustomStack<T> extends ChangeNotifier {
  final List<T> _elements = [];

  void push(T value) {
    _elements.add(value);
    notifyListeners();
  }

  T? pop() {
    if (_elements.isNotEmpty) {
      T value = _elements.removeLast();
      notifyListeners();
      return value;
    }
    return null;
  }

  void exec() {
    while (_elements.isNotEmpty) {
      pop();  // Keep popping until the stack is empty
    }
  }


  List<T> get elements => List.unmodifiable(_elements);
}

class StackView extends StatelessWidget {
  final CustomStack<int> stack;
  final int maxSize;

  StackView({required this.stack, required this.maxSize});

  @override
  Widget build(BuildContext context) {
    List<int?> displayStack = List.filled(maxSize, null);
    for (int i = 0; i < stack.elements.length; i++) {
      displayStack[i] = stack.elements[i];
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            maxSize,
            (index) => StackCell(
              value: displayStack[index],
              index: index + 1,
              isTop: index == stack.elements.length - 1,
            ),
          ),
        ),
      ],
    );
  }
}

class StackCell extends StatelessWidget {
  final int? value;
  final int index;
  final bool isTop;

  StackCell({this.value, required this.index, required this.isTop});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
            color: value != null ? Colors.white : Colors.grey[300],
          ),
          alignment: Alignment.center,
          child: Text(value?.toString() ?? '',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        if (isTop) Text('↑', style: TextStyle(fontSize: 20))
      ],
    );
  }
}

