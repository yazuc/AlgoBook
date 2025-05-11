import 'package:flutter/material.dart';
import 'widgets/data_structures_view.dart';
class CustomStack<T> extends ChangeNotifier {
  final List<T> _elements = [];
  final List<T?> _memory = [];

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
      pop();
    }
  }

  List<T> get elements => List.unmodifiable(_elements);
  List<T?> get memory => List.unmodifiable(_memory);
}



class StackView extends StatefulWidget implements DataStructureView {
  final CustomStack<int> stack;
  final int maxSize;
  final TextEditingController pushController;
  final Function(String) onLog;

  const StackView({
    super.key, 
    required this.stack, 
    required this.maxSize,
    required this.pushController,
    required this.onLog,
  });

  @override
  State<StackView> createState() => _StackViewState();
}

class _StackViewState extends State<StackView> {
  @override
  void initState() {
    super.initState();
    widget.stack.addListener(_onStackChanged);
  }

  @override
  void dispose() {
    widget.stack.removeListener(_onStackChanged);
    super.dispose();
  }

  void _onStackChanged() {
    setState(() {});
  }
  
  @override
  Widget build(BuildContext context) {
    List<int?> displayStack = List.filled(widget.maxSize, null);
    for (int i = 0; i < widget.stack.memory.length && i < widget.maxSize; i++) {
      displayStack[i] = widget.stack.memory[i];
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.maxSize,
            (index) {
              final value = displayStack[index];
              final isActive = index < widget.stack.elements.length;
              return StackCell(
                value: value,
                index: index + 1,
                isTop: index == widget.stack.elements.length - 1,
                isTrash: !isActive && value != null,
              );
            },
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Input field
            SizedBox(
              width: 80,
              child: TextField(
                controller: widget.pushController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Valor',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(width: 16),

            // Push Button
            ElevatedButton(
              onPressed: () {
                final text = widget.pushController.text.trim();
                if (text.isNotEmpty && int.tryParse(text) != null) {
                  int value = int.parse(text);
                  if (widget.stack.elements.length < widget.maxSize) {
                    widget.onLog("Stack was pushed with P(S, $value)");
                    widget.stack.push(value);
                  } else {
                    widget.onLog("Error: 'Overflow'");
                  }
                  widget.pushController.clear();
                } else {
                  widget.onLog("Error: Invalid input");
                }
              },
              child: Text('Push'),
            ),
            SizedBox(width: 16),

            // Pop Button
            ElevatedButton(
              onPressed: () {
                if (widget.stack.elements.isEmpty) {
                  widget.onLog("Error: 'Underflow'");
                } else {
                  widget.onLog("Stack was popped with P(S)");
                  widget.stack.pop();
                }
              },
              child: Text('Pop'),
            ),
            SizedBox(width: 16),

            // Empty Button
            ElevatedButton(
              onPressed: () {
                widget.onLog(
                  widget.stack.elements.isEmpty
                      ? "Stack is empty"
                      : "Stack is not empty"
                );
              },
              child: Text('Empty'),
            ),
          ],
        ),
      ],
    );
  }
}

class StackCell extends StatelessWidget {
  final int? value;
  final int index;
  final bool isTop;
  final bool isTrash;

  const StackCell({
    super.key,
    this.value,
    required this.index,
    required this.isTop,
    this.isTrash = false,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    if (value == null) {
      backgroundColor = Colors.grey[300]!;
    } else if (isTrash) {
      backgroundColor = Colors.grey[300]!; // or another "trash" color
    } else {
      backgroundColor = Colors.white;
    }

    return SizedBox(
      height: 80,
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          if (index == 1)
            Positioned(
              left: -20,
              top: 15,
              child: Text(
                'S',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
           Positioned(
            top: -20,
            child: Text(
              index.toString(),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),
              color: backgroundColor,
            ),
            alignment: Alignment.center,
            child: Text(
              value?.toString() ?? '',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          if (isTop)
            Positioned(
              top: 55,
              child: Text('↑', style: TextStyle(fontSize: 20)),
            ),
        ],
      ),
    );
  }
}



