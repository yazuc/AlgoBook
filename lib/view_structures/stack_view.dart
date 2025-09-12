import 'package:flutter/material.dart';
import '../widgets/common/data_structure_view.dart';
import '../data_structures/stack.dart';

class StackView extends StatefulWidget implements DataStructureView {
  final CustomStack<int> stack;
  final int maxSize;
  final TextEditingController pushController;
  final Function(String) onLog;
  final Function(String) onHighlightCode;

  const StackView({
    super.key,
    required this.stack,
    required this.maxSize,
    required this.pushController,
    required this.onLog,
    required this.onHighlightCode,
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
    return LayoutBuilder(
      builder: (context, constraints) {
        List<int?> displayStack = List.filled(widget.maxSize, null);
        for (int i = 0;
            i < widget.stack.memory.length && i < widget.maxSize;
            i++) {
          displayStack[i] = widget.stack.memory[i];
        }

        return Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.maxSize,
                  (index) {
                    final value = displayStack[index];
                    final isActive = index < widget.stack.elements.length;
                    return StackCell(
                      value: value,
                      index: index + 1,
                      length: widget.maxSize,
                      isTop: index == widget.stack.elements.length - 1,
                      isTrash: !isActive && value != null,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                SizedBox(
                  width: 80,
                  child: TextField(
                    controller: widget.pushController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Valor',
                      filled: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final text = widget.pushController.text.trim();
                    if (text.isNotEmpty && int.tryParse(text) != null) {
                      int value = int.parse(text);
                      if (widget.stack.elements.length < widget.maxSize) {
                        widget.onLog("A pilha S após a chamada Push(S, $value)");
                        await widget.onHighlightCode("Push(S, x)");
                        widget.stack.push(value);
                      } else {
                        widget.onLog("error \"overflow\"");
                      }
                      widget.pushController.clear();
                    } else {
                      widget.onLog("error Invalid input");
                    }
                  },
                  child: const Text('Push(S, x)'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (widget.stack.elements.isEmpty) {
                      widget.onLog("error \"underflow\"");
                    } else {
                      widget.onLog("A pilha S após a chamada Pop(S)");
                      await widget.onHighlightCode("Pop(S)");
                      widget.stack.pop();
                    }
                  },
                  child: const Text('Pop(S)'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    widget.onLog(widget.stack.elements.isEmpty
                        ? "A pilha está vazia"
                        : "A pilha não está vazia");
                    await widget.onHighlightCode("Pilha-Vazia(S)");
                  },
                  child: const Text('Pilha-Vazia(S)'),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}


class StackCell extends StatelessWidget {
  final int? value;
  final int index;
  final bool isTop;
  final bool isTrash;
  final int length;

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
    final theme = Theme.of(context);
    Color backgroundColor;
    if (value == null) {
      backgroundColor = theme.disabledColor;
    } else if (isTrash) {
      backgroundColor = theme.disabledColor;
    } else {
      backgroundColor = theme.cardColor;
    }

    return SizedBox(
      height: 120,
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          if (index == 1)
            const Positioned(
              left: -25,
              top: 15,
              child: Text(
                'S',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Callibri"),
              ),
            ),
          Positioned(
            top: -30,
            child: Text(
              index.toString(),
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Callibri"),
            ),
          ),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(
                  color: theme.textTheme.bodyLarge?.color ?? Colors.black),
              color: backgroundColor,
            ),
            alignment: Alignment.center,
            child: Text(
              value?.toString() ?? '',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          if (isTop)
            Positioned(
              top: 55,
              child: Text('      ↑\nS.top = $index',
                  style: const TextStyle(fontSize: 20)),
            ),
        ],
      ),
    );
  }
}
