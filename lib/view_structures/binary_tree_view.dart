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

class _BinaryTreeViewState extends State<BinaryTreeView> with TickerProviderStateMixin {
  Map<int, AnimationController> _animationControllers = {};
  Set<int> _currentNodeValues = {};

  @override
  void initState() {
    super.initState();
    _updateNodes(isInitial: true);
    widget.controller.tree.addListener(_onTreeChanged);
  }

  @override
  void dispose() {
    widget.controller.tree.removeListener(_onTreeChanged);
    _animationControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _onTreeChanged() {
    setState(() {
      _updateNodes();
    });
  }

  void _updateNodes({bool isInitial = false}) {
    final newNodes = _getAllNodes(widget.controller.tree.root);
    final newNodeValues = newNodes.map((n) => n.value).toSet();

    final removedValues = _currentNodeValues.difference(newNodeValues);
    for (var value in removedValues) {
      _animationControllers[value]?.dispose();
      _animationControllers.remove(value);
    }

    for (var node in newNodes) {
      if (!_animationControllers.containsKey(node.value)) {
        final controller = AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 800),
        );
        _animationControllers[node.value] = controller;
        if (!isInitial) {
          controller.forward();
        } else {
          controller.value = 1.0;
        }
      }
    }
    _currentNodeValues = newNodeValues;
  }

  List<TreeNode<int>> _getAllNodes(TreeNode<int>? node) {
    if (node == null) return [];
    return [node, ..._getAllNodes(node.left), ..._getAllNodes(node.right)];
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
                            widget.controller.tree.root!,
                            0,
                          ),
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
                positions,
                theme.textTheme.bodyLarge?.color ?? Colors.black,
                animationProgress: {
                  for (var e in _animationControllers.entries) e.key: e.value.value,
                },
              ),
            ),
            ...positions.map((p) {
              final controller = _animationControllers[p.node.value]!;
              return Positioned(
                left: p.x - 20,
                top: p.y - 20,
                child: AnimatedBuilder(
                  animation: controller,
                  builder: (context, child) {
                    final animValue = controller.value;
                    final nodeOpacity =
                        (animValue <= 0.5) ? 0.0 : (animValue - 0.5) * 2;
                    final nodeScale =
                        (animValue <= 0.5) ? 0.5 : 0.5 + (animValue - 0.5);
                    return Opacity(
                      opacity: nodeOpacity,
                      child: Transform.scale(
                        scale: nodeScale,
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.cardColor,
                      border: Border.all(
                          color: theme.textTheme.bodyLarge?.color ??
                              Colors.black,
                          width: 2),
                    ),
                    child: Center(
                      child: Text(
                        p.node.value.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}

class TreePainter extends CustomPainter {
  final List<PositionedNode<int>> positionedNodes;
  final Color lineColor;
  final Map<int, double>? animationProgress;

  TreePainter(this.positionedNodes, this.lineColor, {this.animationProgress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 2;

    final nodeOffsets = {
      for (var p in positionedNodes) p.node: Offset(p.x, p.y)
    };

    for (var p in positionedNodes) {
      final start = nodeOffsets[p.node]!;

      void drawPartialLine(TreeNode<int>? child) {
        if (child == null) return;
        final end = nodeOffsets[child]!;
        final value = animationProgress?[child.value] ?? 1.0;
        final lineProgress = (value * 2).clamp(0.0, 1.0);
        final currentEnd = Offset.lerp(start, end, lineProgress)!;
        canvas.drawLine(start, currentEnd, paint);
      }

      drawPartialLine(p.node.left);
      drawPartialLine(p.node.right);
    }
  }

  @override
  bool shouldRepaint(covariant TreePainter oldDelegate) => true;
}
