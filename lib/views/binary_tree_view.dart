import 'package:flutter/material.dart';
import '../data_structures/binary_tree.dart';
import '../widgets/common/data_structure_view.dart';

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
  double _treeHeight = 500;
  
  @override
  void initState() {
    super.initState();
    // Registra um listener para atualizar a UI quando a árvore mudar
    widget.tree.addListener(_onTreeChanged);
  }

  @override
  void dispose() {
    // Remove o listener ao descartar o widget
    widget.tree.removeListener(_onTreeChanged);
    super.dispose();
  }

  /// Callback chamado quando a árvore é modificada
  ///
  /// Atualiza o estado do widget para refletir as mudanças na árvore
  void _onTreeChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.tree.root != null)
          Stack(
            children: [
              // Tree container
              Container(
                height: _treeHeight,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: InteractiveViewer(
                  boundaryMargin: EdgeInsets.all(20),
                  minScale: 0.3,
                  maxScale: 2.5,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: _treeHeight,
                    child: Transform.scale(
                      scale: _zoomLevel,
                      child: _buildTreeWithConnections(widget.tree.root!, 0),
                    ),
                  ),
                ),
              ),
              
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.zoom_out, size: 20),
                        padding: EdgeInsets.all(4),
                        constraints: BoxConstraints(),
                        onPressed: () {
                          setState(() {
                            _zoomLevel = (_zoomLevel - 0.1).clamp(0.5, 2.0);
                            _treeHeight = 300 * (1 / _zoomLevel);
                          });
                        },
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${(_zoomLevel * 100).toInt()}%',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 4),
                      IconButton(
                        icon: Icon(Icons.zoom_in, size: 20),
                        padding: EdgeInsets.all(4),
                        constraints: BoxConstraints(),
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
                  widget.onLog("Árvore inserida com valor $value");
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
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, _treeHeight),
          painter: TreePainter(root),
          child: _buildTreeNodes(root, constraints.maxWidth / 2, 50, constraints.maxWidth / 4),
        );
      },
    );
  }

  /// Constrói recursivamente os widgets dos nós da árvore.
  ///
  /// Este método posiciona cada nó no local correto e
  /// constrói recursivamente os nós filhos.
  ///
  /// [node] O nó atual sendo processado
  /// [x] A posição horizontal do nó
  /// [y] A posição vertical do nó
  /// [horizontalSpacing] O espaçamento horizontal entre os níveis
  ///
  /// @return Um widget Stack contendo todos os nós posicionados corretamente
  Widget _buildTreeNodes(TreeNode<int> node, double x, double y, double horizontalSpacing) {
    return Stack(
      children: [
        // Current node
        Positioned(
          left: x - 25,
          top: y - 25,
          child: Container(
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
        ),
        
        // Left child
        if (node.left != null)
          _buildTreeNodes(
            node.left!, 
            x - horizontalSpacing, 
            y + 80, 
            horizontalSpacing / 2
          ),
        
        // Right child
        if (node.right != null)
          _buildTreeNodes(
            node.right!, 
            x + horizontalSpacing, 
            y + 80, 
            horizontalSpacing / 2
          ),
      ],
    );
  }
}

/// Pintor personalizado para desenhar as conexões entre os nós da árvore.
///
/// Esta classe é responsável por desenhar as linhas que conectam
/// um nó pai aos seus filhos, usando o Canvas do Flutter.
class TreePainter extends CustomPainter {
  /// O nó raiz da árvore a ser desenhada
  final TreeNode<int> root;
  
  TreePainter(this.root);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    _drawConnections(canvas, root, size.width / 2, 50, size.width / 4, paint);
  }
  
  /// Desenha recursivamente as conexões entre os nós da árvore.
  ///
  /// Este método desenha linhas do nó atual para seus filhos e
  /// continua recursivamente para os filhos.
  ///
  /// [canvas] O canvas onde desenhar
  /// [node] O nó atual sendo processado
  /// [x] A posição horizontal do nó
  /// [y] A posição vertical do nó
  /// [horizontalSpacing] O espaçamento horizontal entre os níveis
  /// [paint] O objeto Paint com as configurações de estilo da linha
  void _drawConnections(Canvas canvas, TreeNode<int> node, double x, double y, 
                         double horizontalSpacing, Paint paint) {
    if (node.left != null) {
      canvas.drawLine(
        Offset(x, y),
        Offset(x - horizontalSpacing, y + 80),
        paint,
      );
      _drawConnections(canvas, node.left!, x - horizontalSpacing, y + 80, horizontalSpacing / 2, paint);
    }
    
    if (node.right != null) {
      canvas.drawLine(
        Offset(x, y),
        Offset(x + horizontalSpacing, y + 80),
        paint,
      );
      _drawConnections(canvas, node.right!, x + horizontalSpacing, y + 80, horizontalSpacing / 2, paint);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
} 