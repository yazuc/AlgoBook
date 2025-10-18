import 'package:flutter/material.dart';
import '../data_structures/binary_tree.dart';
import '../widgets/common/data_structure_view.dart';

class BinaryTreeController {
  final CustomBinaryTree<int> tree;
  final TextEditingController inputController;
  final Function(String) onLog;
  double zoomLevel = 1.0;
  double treeHeight = 400;

  BinaryTreeController({
    required this.tree,
    required this.inputController,
    required this.onLog,
  });

  Future<void> insertNode() async {
    final text = inputController.text.trim();
    if (text.isEmpty) {
      onLog("Error: Invalid input");
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
        onLog("Árvore inserida com valor $value");
        tree.insert(value);
        await Future.delayed(const Duration(milliseconds: 500));
      } else {
        onLog("Error: Valor inválido '$valueStr'");
      }
    }
    inputController.clear();
  }

  void clearTree() {
    onLog("A árvore foi limpa");
    tree.clear();
  }
  
  Future<void> removeNode() async {
    final text = inputController.text.trim();
    if (text.isEmpty) {
      onLog("Error: Valor inválido");
      return;
    }

    final value = int.tryParse(text);
    if (value != null) {
      onLog("Removendo nodo de valor $value");
      tree.remove(value);
      await Future.delayed(const Duration(milliseconds: 500));
    } else {
      onLog("Error: Valor inválido '$text'");
    }
    inputController.clear();
  }

  void zoomIn() {
    zoomLevel = (zoomLevel + 0.1).clamp(0.5, 2.0);
    treeHeight = 300 * (1 / zoomLevel);
  }

  void zoomOut() {
    zoomLevel = (zoomLevel - 0.1).clamp(0.5, 2.0);
    treeHeight = 300 * (1 / zoomLevel);
  }
}

class BinaryTreeView extends StatefulWidget implements DataStructureView {
  final BinaryTreeController controller;

  const BinaryTreeView({
    super.key,
    required this.controller,
  });

  @override
  State<BinaryTreeView> createState() => _BinaryTreeViewState();
}

class PositionedNode<T> {
  final TreeNode<T> node;
  final double x;
  final double y;

  PositionedNode(this.node, this.x, this.y);
}

List<PositionedNode<int>> _calculateNodePositions(
    TreeNode<int> node, double x, double y, double spacing) {
  List<PositionedNode<int>> result = [];
  void dfs(TreeNode<int> current, double cx, double cy, double space) {
    result.add(PositionedNode(current, cx, cy));
    if (current.left != null) {
      dfs(current.left!, cx - space, cy + 60, space / 2);
    }
    if (current.right != null) {
      dfs(current.right!, cx + space, cy + 60, space / 2);
    }
  }

  dfs(node, x, y, spacing);
  return result;
}

class _BinaryTreeViewState extends State<BinaryTreeView> {
  @override
  void initState() {
    super.initState();
    widget.controller.tree.addListener(_onTreeChanged);
  }

  @override
  void dispose() {
    widget.controller.tree.removeListener(_onTreeChanged);
    super.dispose();
  }

  void _onTreeChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.controller.tree.root != null)
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.dividerColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: InteractiveViewer(
                      boundaryMargin: const EdgeInsets.all(20),
                      minScale: 0.3,
                      maxScale: 2.5,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Transform.scale(
                          scale: widget.controller.zoomLevel,
                          child: _buildTreeWithConnections(
                              widget.controller.tree.root!, 0),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.cardColor.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: theme.dividerColor),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.zoom_out, size: 20),
                            padding: const EdgeInsets.all(4),
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              setState(() {
                                widget.controller.zoomOut();
                              });
                            },
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${(widget.controller.zoomLevel * 100).toInt()}%',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 4),
                          IconButton(
                            icon: const Icon(Icons.zoom_in, size: 20),
                            padding: const EdgeInsets.all(4),
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              setState(() {
                                widget.controller.zoomIn();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            const Expanded(
              child: Center(child: Text('Árvore vazia')),
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
                  controller: widget.controller.inputController,
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
                  await widget.controller.insertNode();
                  setState(() {});
                },
                child: const Text('Insere-Árvore(T, z)'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await widget.controller.removeNode();
                  setState(() {});
                },
                child: const Text('Remove-Árvore(T, z)'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    widget.controller.clearTree();
                  });
                },
                child: const Text('Limpar'),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTreeWithConnections(TreeNode<int> root, int level) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final centerX = constraints.maxWidth / 2;
        final positions =
            _calculateNodePositions(root, centerX, 50, centerX / 2);
        return Stack(
          children: [
            CustomPaint(
              size: Size(constraints.maxWidth, constraints.maxHeight),
              painter: TreePainter(
                  positions, theme.textTheme.bodyLarge?.color ?? Colors.black),
            ),
            ...positions.map((p) => Positioned(
                  left: p.x - 20,
                  top: p.y - 20,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.cardColor,
                      border: Border.all(
                          color:
                              theme.textTheme.bodyLarge?.color ?? Colors.black,
                          width: 2),
                    ),
                    child: Center(
                        child: Text(
                      p.node.value.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    )),
                  ),
                )),
          ],
        );
      },
    );
  }
}

class TreePainter extends CustomPainter {
  final List<PositionedNode<int>> positionedNodes;
  final Color lineColor;

  TreePainter(this.positionedNodes, this.lineColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 2;

    final Map<TreeNode<int>, Offset> nodeOffsets = {
      for (var p in positionedNodes) p.node: Offset(p.x, p.y)
    };

    for (var p in positionedNodes) {
      final start = nodeOffsets[p.node]!;
      if (p.node.left != null) {
        final end = nodeOffsets[p.node.left]!;
        canvas.drawLine(start, end, paint);
      }
      if (p.node.right != null) {
        final end = nodeOffsets[p.node.right]!;
        canvas.drawLine(start, end, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
