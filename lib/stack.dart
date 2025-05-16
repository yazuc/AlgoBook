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



class StackView extends StatelessWidget implements DataStructureView{
  final CustomStack<int> stack;
  final int maxSize;


  const StackView({super.key, required this.stack, required this.maxSize});
  
  @override
  Widget build(BuildContext context) {
    List<int?> displayStack = List.filled(maxSize, null);
    for (int i = 0; i < stack.memory.length && i < maxSize; i++) {
      displayStack[i] = stack.memory[i];
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            maxSize,
            (index) {
              final value = displayStack[index];
              final isActive = index < stack.elements.length;
              return StackCell(
                value: value,
                index: index + 1,
                isTop: index == stack.elements.length - 1,
                length: maxSize,
                isTrash: !isActive && value != null,
              );
            },
          ),
        ),
      ],
    );
  }

}

class StackCell extends StatelessWidget {
  final int? value;
  final int index;
  final int length;
  final bool isTop;
  final bool isTrash;
  final double widthBorder = 1.2;

  const StackCell({
    super.key,
    this.value,
    required this.index,
    required this.isTop,
    required this.length,
    this.isTrash = false,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    if (value == null) {
      backgroundColor = const Color.fromARGB(192,188,188, 188); 
    } else if (isTrash) {
      backgroundColor = const Color.fromARGB(192,188,188, 188); 
    } else {
      backgroundColor = Colors.white;
    }

    return SizedBox(
      height: 120,
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          if (index == 1)
            Positioned(
              left: -25,
              top: 15,
              child: Text(
                'S',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: "Calibri"),
              ),
            ),
           Positioned(
            top: -30,
            child: Text(
              index.toString(),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: "Calibri"),
            ),
          ),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(color: Colors.black, width: widthBorder),
                  left: BorderSide(color: Colors.black, width: widthBorder),
                  bottom: BorderSide(color: Colors.black, width: widthBorder),
                  right: BorderSide(color: Colors.black, width: index == length ? widthBorder : 0.2,),
              ),
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
              child: Text('      ↑\nS.top = $index', style: TextStyle(fontSize: 20)),
            ),
        ],
      ),
    );
  }
}



