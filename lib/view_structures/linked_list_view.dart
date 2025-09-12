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
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.list.values.length,
            itemBuilder: (context, index) {
              var node = widget.list.head;
              for (int i = 0; i < index; i++) {
                node = node?.next;
              }
              return NodeView(
                node: node,
                isHead: node == widget.list.head,
              );
            },
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
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          if (!isHead)
            const Icon(Icons.arrow_back),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(color: theme.textTheme.bodyLarge?.color ?? Colors.black),
              color: theme.cardColor,
            ),
            child: Center(
              child: Text(
                node?.value.toString() ?? '',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          if (node?.next != null)
            const Icon(Icons.arrow_forward),
        ],
      ),
    );
  }
}
