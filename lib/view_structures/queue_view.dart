import 'package:flutter/material.dart';
import '../widgets/common/data_structure_view.dart';
import '../data_structures/queue.dart';

class QueueView extends StatefulWidget implements DataStructureView {
  final CustomQueue<int> queue;
  final int maxSize;
  final TextEditingController enqueueController;
  final Function(String) onLog;
  final Function(String) onHighlightCode;

  const QueueView({
    super.key,
    required this.queue,
    required this.maxSize,
    required this.enqueueController,
    required this.onLog,
    required this.onHighlightCode,
  });

  @override
  State<QueueView> createState() => _QueueViewState();
}

class _QueueViewState extends State<QueueView> {
  @override
  void initState() {
    super.initState();
    widget.queue.addListener(_onQueueChanged);
  }

  @override
  void dispose() {
    widget.queue.removeListener(_onQueueChanged);
    super.dispose();
  }

  void _onQueueChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        List<int?> displayQueue = widget.queue.elements;
        final headIndex = widget.queue.frontIndex;
        final tailIndex = widget.queue.rearIndex;

        return Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.maxSize,
                  (index) {
                    final value = displayQueue[index];
                    final isHead = index == headIndex;
                    final isTail = index == tailIndex;

                    return QueueCell(
                      value: value,
                      index: index + 1,
                      length: widget.maxSize,
                      isHead: isHead,
                      isTail: isTail,
                      isTrash: false,
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
                  width: 150,
                  child: TextField(
                    controller: widget.enqueueController,
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
                    final text = widget.enqueueController.text.trim();
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
                        if (!widget.queue.isFull) {
                          widget.onLog(
                              "A fila Q após a chamada Enqueue(Q, $value)");
                          await widget.onHighlightCode("ENQUEUE(Q,x)");
                          widget.queue.enqueue(value);
                          await Future.delayed(
                              const Duration(milliseconds: 500));
                        } else {
                          widget.onLog('error "overflow"');
                          break;
                        }
                      } else {
                        widget.onLog(
                            "Entrada inválida para o valor '$valueStr'");
                      }
                    }
                    widget.enqueueController.clear();
                  },
                  child: const Text('Enqueue(Q, x)'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (widget.queue.elements.isEmpty) {
                      widget.onLog('error "underflow"');
                    } else {
                      widget.onLog("A fila Q após a chamada Dequeue(Q)");
                      await widget.onHighlightCode("DEQUEUE(Q)");
                      widget.queue.dequeue();
                    }
                  },
                  child: const Text('Dequeue(Q)'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class QueueCell extends StatelessWidget {
  final int? value;
  final int index;
  final bool isHead;
  final bool isTail;
  final bool isTrash;
  final int length;

  const QueueCell({
    super.key,
    this.value,
    required this.index,
    required this.length,
    this.isHead = false,
    this.isTail = false,
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
      height: 150, // increased height to fit both
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          if (index == 1)
            const Positioned(
              left: -25,
              top: 15,
              child: Text(
                'Q',
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
          if (isHead)
            Positioned(
              top: 43,
              child: Column(
                children: [
                  const Text('↑', style: TextStyle(fontSize: 20)),
                  Text('Q.head = $index', style: const TextStyle(fontSize: 20)),
                ],
              ),
            ),
          if (isTail)
            Positioned(
              top: (isHead && isTail)
                  ? 85
                  : 43, // empurra para baixo se for o mesmo índice
              right: -25,
              child: Column(
                children: [
                  const Text('↑', style: TextStyle(fontSize: 20)),
                  Text('Q.tail = $index'),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
