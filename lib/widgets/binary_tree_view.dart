import 'package:flutter/material.dart';
import '../binary_tree.dart';
import 'data_structures_view.dart';

class BinaryTreeView extends StatefulWidget implements DataStructureView {
  final CustomBinaryTree<int> tree;
  final TextEditingController pushController;
  final Function(String) onLog;

  const BinaryTreeView({
    super.key, 
    required this.tree,
    required this.pushController,
    required this.onLog,
  });

  @override
  State<BinaryTreeView> createState() => _BinaryTreeViewState();
}

class _BinaryTreeViewState extends State<BinaryTreeView> {
  @override
  void initState() {
    super.initState();
    widget.tree.addListener(_onTreeChanged);
  }

  @override
  void dispose() {
    widget.tree.removeListener(_onTreeChanged);
    super.dispose();
  }

  void _onTreeChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.tree.root != null)
          _buildTree(widget.tree.root!, 0)
        else
          const Text('Árvore vazia'),
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

            // Insert Button
            ElevatedButton(
              onPressed: () {
                final text = widget.pushController.text.trim();
                if (text.isNotEmpty && int.tryParse(text) != null) {
                  int value = int.parse(text);
                  widget.onLog("Tree was inserted with value $value");
                  widget.tree.insert(value);
                  widget.pushController.clear();
                } else {
                  widget.onLog("Error: Invalid input");
                }
              },
              child: Text('Insert'),
            ),
            SizedBox(width: 16),

            // Clear Button
            ElevatedButton(
              onPressed: () {
                widget.onLog("Tree was cleared");
                widget.tree.clear();
              },
              child: Text('Clear'),
            ),
            SizedBox(width: 16),

            // Empty Button
            ElevatedButton(
              onPressed: () {
                widget.onLog(
                  widget.tree.root == null
                      ? "Tree is empty"
                      : "Tree is not empty"
                );
              },
              child: Text('Empty'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTree(TreeNode<int> node, int level) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              node.value.toString(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        if (node.left != null || node.right != null)
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (node.left != null)
                  Column(
                    children: [
                      Container(
                        width: 30,
                        height: 2,
                        color: Colors.black,
                      ),
                      _buildTree(node.left!, level + 1),
                    ],
                  ),
                if (node.left != null && node.right != null)
                  const SizedBox(width: 40),
                if (node.right != null)
                  Column(
                    children: [
                      Container(
                        width: 30,
                        height: 2,
                        color: Colors.black,
                      ),
                      _buildTree(node.right!, level + 1),
                    ],
                  ),
              ],
            ),
          ),
      ],
    );
  }
} 