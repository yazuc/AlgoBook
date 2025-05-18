import 'package:flutter/material.dart';
import '../data_structures/binary_tree.dart';
import '../widgets/common/data_structure_view.dart';
import 'package:graphview/GraphView.dart';

/// Widget para visualização de uma árvore binária.
///
/// Este widget implementa a interface DataStructureView e permite
/// a visualização interativa de uma árvore binária com funções para:
/// - Inserir valores
/// - Limpar a árvore
/// - Zoom in/out na visualização
class BinaryTreeView extends StatefulWidget implements DataStructureView {
  /// A árvore binária a ser visualizada
  final CustomBinaryTree<int> tree;
  
  /// Controlador para o campo de texto de inserção
  final TextEditingController pushController;
  
  /// Função de callback para enviar logs ao terminal
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
  /// Nível de zoom atual da visualização
  double _zoomLevel = 1.0;
  
  /// Altura atual do componente da árvore
  double _treeHeight = 300;
  
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

  Graph buildGraphFromBinaryTree(TreeNode<int>? root) {
    final graph = Graph();
    final nodeMap = <TreeNode<int>, Node>{};

    if (root == null) return graph;

    // Primeiro, crie todos os Nodes
    void createNodes(TreeNode<int> current) {
      nodeMap[current] = Node(_buildGraphNode(current.value));
      if (current.left != null) createNodes(current.left!);
      if (current.right != null) createNodes(current.right!);
    }

    // Depois, adicione as arestas
    void addEdges(TreeNode<int> current) {
      final currentNode = nodeMap[current]!;
      graph.addNode(currentNode);

      if (current.left != null) {
        final leftNode = nodeMap[current.left!]!;
        graph.addEdge(currentNode, leftNode);
        addEdges(current.left!);
      }
      if (current.right != null) {
        final rightNode = nodeMap[current.right!]!;
        graph.addEdge(currentNode, rightNode);
        addEdges(current.right!);
      }
    }

    createNodes(root);
    addEdges(root);

    return graph;
  }

  Widget _buildGraphNode(int value) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black, width: 2),
        color: Colors.white,
      ),
      child: Text(
        value.toString(),
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildGraphView() {
    final graph = buildGraphFromBinaryTree(widget.tree.root);

    final builder = SugiyamaConfiguration()
      ..nodeSeparation = 100
      ..levelSeparation = 100
      ..orientation = SugiyamaConfiguration.ORIENTATION_TOP_BOTTOM;

    return GraphView(
      graph: graph,
      algorithm: SugiyamaAlgorithm(builder),
      paint: Paint()
        ..color = Colors.black
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
      builder: (Node node) {
        return node.key!.value as Widget;
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.tree.root != null)
          Stack(
            children: [
              Container(
                height: _treeHeight,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: InteractiveViewer(
                  boundaryMargin: const EdgeInsets.all(200),
                  minScale: 0.1,
                  maxScale: 2.5,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 3,
                    height: _treeHeight * 3,
                    child: Transform.scale(
                      scale: _zoomLevel,
                      child: Center(
                        child: _buildGraphView(),
                      ),
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
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey[300]!),
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
                            _zoomLevel = (_zoomLevel - 0.1).clamp(0.5, 2.0);
                            _treeHeight = 300 * (1 / _zoomLevel);
                          });
                        },
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${(_zoomLevel * 100).toInt()}%',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        icon: const Icon(Icons.zoom_in, size: 20),
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          setState(() {
                            _zoomLevel = (_zoomLevel + 0.1).clamp(0.5, 2.0);
                            _treeHeight = 300 * (1 / _zoomLevel);
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
                controller: widget.pushController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Valor',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                final text = widget.pushController.text.trim();
                if (text.isNotEmpty && int.tryParse(text) != null) {
                  int value = int.parse(text);
                  widget.onLog("Árvore inserida com valor $value");
                  widget.tree.insert(value);
                  widget.pushController.clear();
                } else {
                  widget.onLog("Error: Invalid input");
                }
              },
              child: const Text('Insert'),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                widget.onLog("Tree was cleared");
                widget.tree.clear();
              },
              child: const Text('Clear'),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ],
    );
  }
}
