import 'package:flutter/material.dart';
import '../data_structures/binary_tree.dart';
import '../widgets/common/data_structure_view.dart';

/// Controller para gerenciar a árvore binária e suas operações
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

  void insertNode() {
    final text = inputController.text.trim();
    if (text.isNotEmpty && int.tryParse(text) != null) {
      int value = int.parse(text);
      onLog("Árvore inserida com valor $value");
      tree.insert(value);
      inputController.clear();
    } else {
      onLog("Error: Invalid input");
    }
  }

  void clearTree() {
    onLog("Tree was cleared");
    tree.clear();
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


/// Widget para visualização de uma árvore binária.
///
/// Este widget implementa a interface DataStructureView e permite
/// a visualização interativa de uma árvore binária com funções para:
/// - Inserir valores
/// - Limpar a árvore
/// - Zoom in/out na visualização
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

List<PositionedNode<int>> _calculateNodePositions(TreeNode<int> node, double x, double y, double spacing) {
  List<PositionedNode<int>> result = [];
  void dfs(TreeNode<int> current, double cx, double cy, double space) {
    result.add(PositionedNode(current, cx, cy));
    if (current.left != null) {
      dfs(current.left!, cx - space, cy + 80, space / 2);
    }
    if (current.right != null) {
      dfs(current.right!, cx + space, cy + 80, space / 2);
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.controller.tree.root != null)
          Stack(
            children: [
              Container(
                height: widget.controller.treeHeight,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  border: Border.all(color: theme.dividerColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: InteractiveViewer(
                  boundaryMargin: const EdgeInsets.all(20),
                  minScale: 0.3,
                  maxScale: 2.5,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: widget.controller.treeHeight,
                    child: Transform.scale(
                      scale: widget.controller.zoomLevel,
                      child: _buildTreeWithConnections(widget.controller.tree.root!, 0),
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
          )
        else
          const Text('Árvore vazia'),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 80,
              child: TextField(
                controller: widget.controller.inputController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Valor',
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  widget.controller.insertNode();
                });
              },
              child: const Text('Insert'),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  widget.controller.clearTree();
                });
              },
              child: const Text('Clear'),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ],
    );
  }

  /// Cria a representação visual da árvore com conexões entre os nós.
  ///
  /// Este método usa CustomPaint para desenhar as linhas de conexão
  /// entre os nós da árvore e posiciona os nós adequadamente.
  ///
  /// [root] O nó raiz da árvore a ser exibido
  /// [level] O nível atual da recursão (inicia em 0)
  ///
  /// @return Um widget contendo a visualização da árvore
  Widget _buildTreeWithConnections(TreeNode<int> root, int level) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final centerX = constraints.maxWidth / 2;
        final positions = _calculateNodePositions(root, centerX, 50, centerX / 2);
        return Stack(
          children: [
            CustomPaint(
              size: Size(constraints.maxWidth, widget.controller.treeHeight),
              painter: TreePainter(positions, theme.textTheme.bodyLarge?.color ?? Colors.black),
            ),
            ...positions.map((p) => Positioned(
              left: p.x - 25,
              top: p.y - 25,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.cardColor,
                  border: Border.all(color: theme.textTheme.bodyLarge?.color ?? Colors.black, width: 2),
                ),
                child: Center(child: Text(
                  p.node.value.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                )),
              ),
            )),
          ],
        );
      },
    );
  }

}

/// Pintor personalizado para desenhar as conexões entre os nós da árvore.
///
/// Esta classe é responsável por desenhar as linhas que conectam
/// um nó pai aos seus filhos, usando o Canvas do Flutter.
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
