import 'package:flutter/material.dart';
import '../data_structures/linked_list.dart';
import '../widgets/common/data_structure_view.dart';

class LinkedListView extends StatefulWidget implements DataStructureView {
  final DoublyLinkedList<int> list;
  final TextEditingController valueController;
  final Function(String) onLog;

  const LinkedListView({
    super.key,
    required this.list,
    required this.valueController,
    required this.onLog,
  });

  @override
  State<LinkedListView> createState() => _LinkedListViewState();
}

class _LinkedListViewState extends State<LinkedListView> {
  @override
  void initState() {
    super.initState();
    widget.list.addListener(_onListChanged);
  }

  @override
  void dispose() {
    widget.list.removeListener(_onListChanged);
    super.dispose();
  }

  void _onListChanged() {
    setState(() {});
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
                if (widget.list.head != null)
                  const Row(
                    children: [
                      Text('Início'),
                      Icon(Icons.arrow_forward),
                      SizedBox(width: 10),
                    ],
                  ),
                for (var node in widget.list.nodes)
                  NodeView(
                    node: node,
                    isHead: node == widget.list.head,
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
              width: 80,
              child: TextField(
                controller: widget.valueController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Valor',
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final text = widget.valueController.text.trim();
                if (text.isNotEmpty && int.tryParse(text) != null) {
                  int value = int.parse(text);
                  widget.list.insert(value);
                  widget.onLog("Inserido o valor $value na lista.");
                  widget.valueController.clear();
                } else {
                  widget.onLog("Erro: Entrada inválida.");
                }
              },
              child: const Text('Inserir'),
            ),
            ElevatedButton(
              onPressed: () {
                final text = widget.valueController.text.trim();
                if (text.isNotEmpty && int.tryParse(text) != null) {
                  int value = int.parse(text);
                  var node = widget.list.search(value);
                  if (node != null) {
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
              child: const Text('Remover'),
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

  const NodeView({super.key, this.node, this.isHead = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          if (!isHead)
            const Row(children: [
              Icon(Icons.arrow_back, size: 16),
              Icon(Icons.arrow_forward, size: 16)
            ]),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.textTheme.bodyLarge?.color ?? Colors.black,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(4),
              color: theme.cardColor,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Campo Anterior
                Container(
                  width: 25,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                          color:
                              theme.textTheme.bodyLarge?.color ?? Colors.black,
                          width: 1),
                    ),
                  ),
                  child: Text(
                    node?.prev != null ? "●" : "/",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                // Campo Valor
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                          color:
                              theme.textTheme.bodyLarge?.color ?? Colors.black,
                          width: 1),
                    ),
                  ),
                  child: Text(
                    node?.value.toString() ?? '',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                // Campo Próximo
                Container(
                  width: 25,
                  height: 40,
                  alignment: Alignment.center,
                  child: Text(
                    node?.next != null ? "●" : "/",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

