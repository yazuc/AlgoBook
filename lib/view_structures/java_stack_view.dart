import 'package:flutter/material.dart';
import '../widgets/common/data_structure_view.dart';
import '../data_structures/stack.dart';

class JavaStackView extends StatefulWidget implements DataStructureView {
  final CustomStack<int> stack;
  final int maxSize;
  final TextEditingController pushController;
  final Function(String) onLog;
  final Function(String) onHighlightCode;

  const JavaStackView({
    super.key,
    required this.stack,
    required this.maxSize,
    required this.pushController,
    required this.onLog,
    required this.onHighlightCode,
  });

  @override
  State<JavaStackView> createState() => _JavaStackViewState();
}

class _JavaStackViewState extends State<JavaStackView> {
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
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 40), // Alligns with top pointer
                      const SizedBox(
                        width: 30,
                        child: Text(
                          'N',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: 80,
                        height: 10,
                        child: CustomPaint(
                          painter: DottedLinePainter(),
                        ),
                      ),
                    ],
                  ),
                  ...List.generate(
                    widget.maxSize,
                    (i) {
                      final index = widget.maxSize - 1 - i;
                    final value = displayStack[index];
                    final isActive = index < widget.stack.elements.length;
                    return StackCell(
                      value: value,
                      index: index,
                      length: widget.maxSize,
                      isTop: index == widget.stack.elements.length - 1,
                      isTrash: !isActive && value != null,
                    );
                  },
                ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                SizedBox(
                  width: 150,
                  child: TextField(
                    controller: widget.pushController,
                    decoration: const InputDecoration(
                      hintText: 'Valores (e.g. 1,2,3)',
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
                    if (text.isEmpty) {
                      widget.onLog("Entrada inválida.");
                      return;
                    }

                    final values = text
                        .split(',')
                        .map((e) => e.trim())
                        .where((e) => e.isNotEmpty)
                        .toList();

                    for (var valueStr in values) {
                      final value = int.tryParse(valueStr);
                      if (value != null) {
                        if (widget.stack.elements.length < widget.maxSize) {
                          widget.onLog(
                              "A pilha S após a chamada Push(S, $value)");
                          await widget.onHighlightCode("Stack.push(x)");
                          widget.stack.push(value);
                          await Future.delayed(
                              const Duration(milliseconds: 500));
                        } else {
                          widget.onLog("error \"overflow\"");
                          break;
                        }
                      } else {
                        widget.onLog(
                            "Entrada inválida para o valor '$valueStr'");
                      }
                    }
                    widget.pushController.clear();
                  },
                  child: const Text('Push(S, x)'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (widget.stack.elements.isEmpty) {
                      widget.onLog("error \"underflow\"");
                    } else {
                      widget.onLog("A pilha S após a chamada Pop(S)");
                      await widget.onHighlightCode("Stack.pop()");
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
                    await widget.onHighlightCode("Stack.isEmpty()");
                  },
                  child: const Text('Stack.isEmpty()'),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1;
    const dashWidth = 4.0;
    const dashSpace = 4.0;
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, size.height / 2),
          Offset(startX + dashWidth, size.height / 2), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
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
    final hasValue = value != null && !isTrash;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 40,
            child: isTop
                ? const Text(
                    'top →',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 14),
                  )
                : null,
          ),
          SizedBox(
            width: 30,
            child: Text(
              '$index',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Container(
            width: 80,
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(
                color: hasValue
                    ? theme.textTheme.bodyLarge?.color ?? Colors.black
                    : theme.disabledColor,
              ),
              color: hasValue ? theme.cardColor : null,
            ),
            alignment: Alignment.center,
            child: hasValue
                ? Text(
                    value.toString(),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}