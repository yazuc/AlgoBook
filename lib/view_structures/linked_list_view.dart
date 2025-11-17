import 'package:flutter/material.dart';
import '../data_structures/linked_list.dart';
import '../widgets/common/data_structure_view.dart';

class LinkedListView extends StatefulWidget implements DataStructureView {
  final DoublyLinkedList<int> list;
  final TextEditingController valueController;
  final Function(String) onLog;
  final Function(String) onHighlightCode;

  const LinkedListView({
    super.key,
    required this.list,
    required this.valueController,
    required this.onLog,
    required this.onHighlightCode,
  });

  @override
  State<LinkedListView> createState() => _LinkedListViewState();
}

class _LinkedListViewState extends State<LinkedListView>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    widget.list.addListener(_onListChanged);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    widget.list.removeListener(_onListChanged);
    _animationController.dispose();
    super.dispose();
  }

  void _onListChanged() {
    setState(() {
      _animationController.forward(from: 0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var node in widget.list.nodes)
                  FadeTransition(
                    opacity: _animation,
                    child: ScaleTransition(
                      scale: _animation,
                      child: NodeView(
                        node: node,
                        isHead: node == widget.list.head,
                      ),
                    ),
                  ),
              ],
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
                controller: widget.valueController,
                decoration: const InputDecoration(
                  hintText: 'Valores (e.g. 1,2,3)',
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final text = widget.valueController.text.trim();
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
                    await widget.onHighlightCode("INSERE-INÍCIO-LISTA(L, x)");
                    widget.list.insert(value);
                    widget.onLog("Inserido o valor $value na lista.");
                  } else {
                    widget.onLog("Entrada inválida para o valor '$valueStr'");
                  }
                }
                widget.valueController.clear();
              },
              child: const Text('INSERE-INÍCIO-LISTA(L, x)'),
            ),
            ElevatedButton(
              onPressed: () async{
                final text = widget.valueController.text.trim();
                if (text.isNotEmpty && int.tryParse(text) != null) {
                  int value = int.parse(text);
                  var node = widget.list.search(value);
                  if (node != null) {
                    await widget.onHighlightCode("REMOVE-LISTA(L, x)");
                    widget.list.delete(node);
                    widget.onLog("Removido o valor $value da lista.");
                  } else {
                    widget.onLog("Erro: Valor $value não encontrado.");
                  }
                  widget.valueController.clear();
                } else {
                  widget.onLog("Erro: Entrada inválida.");
                }
              },
              child: const Text('REMOVE-LISTA(L, x)'),
            ),
          ],
        )
      ],
    );
  }
}

class NodeView extends StatelessWidget {
  final Node<int>? node;
  final bool isHead;

  final double boxHeight = 30;
  final double prevNextWidth = 30;
  final double valueWidth = 30;

  const NodeView({super.key, this.node, this.isHead = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        // Show "L.início →" before the head node
        if (isHead) ...[
          const Text("L.início"),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_forward, size: 20),
          const SizedBox(width: 8),
        ],

        // Draw the node (three compartments)
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.textTheme.bodyLarge?.color ?? Colors.black,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Campo Anterior
              Container(
                width: prevNextWidth,
                height: boxHeight,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: theme.textTheme.bodyLarge?.color ?? Colors.black,
                      width: 1,
                    ),
                  ),
                ),
                child: Text(
                  node?.prev != null ? "" : "/",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              // Campo Valor (Chave)
              Container(
                width: valueWidth,
                height: boxHeight,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: theme.textTheme.bodyLarge?.color ?? Colors.black,
                      width: 1,
                    ),
                  ),
                ),
                child: Text(
                  node?.value.toString() ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Campo Próximo (sempre vazio no desenho)
              Container(
                width: prevNextWidth,
                height: boxHeight,
                alignment: Alignment.center,
                child: const Text(""),
              ),
            ],
          ),
        ),

        // External arrows
        if (node?.next != null) ...[
          const Icon(Icons.arrow_forward, size: 24), // → after this node
          const Icon(Icons.arrow_back, size: 24),    // ← before next node
        ],
      ],
    );
  }
}


