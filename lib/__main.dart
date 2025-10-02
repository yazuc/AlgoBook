import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: BinaryTreeDemo(),
  ));
}

class BinaryTreeDemo extends StatelessWidget {
  const BinaryTreeDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final graph = Graph()..isTree = true;

    final builder = BuchheimWalkerConfiguration()
      ..orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM
      ..siblingSeparation = 80
      ..levelSeparation = 80
      ..subtreeSeparation = 80;

    // Create nodes
    var n10 = Node.Id('10');
    var n4 = Node.Id('4');
    var n17 = Node.Id('17');
    var n1 = Node.Id('1');
    var n5 = Node.Id('5');
    var n16 = Node.Id('16');
    var n21 = Node.Id('21');

    // Add edges (Cormen style = direct connections, not orthogonal)
    graph.addEdge(n10, n4,
        paint: Paint()
          ..color = theme.textTheme.bodyLarge?.color ?? Colors.black
          ..strokeWidth = 1.0);
    graph.addEdge(n10, n17,
        paint: Paint()
          ..color = theme.textTheme.bodyLarge?.color ?? Colors.black
          ..strokeWidth = 1.0);
    graph.addEdge(n4, n1,
        paint: Paint()
          ..color = theme.textTheme.bodyLarge?.color ?? Colors.black
          ..strokeWidth = 1.0);
    graph.addEdge(n4, n5,
        paint: Paint()
          ..color = theme.textTheme.bodyLarge?.color ?? Colors.black
          ..strokeWidth = 1.0);
    graph.addEdge(n17, n16,
        paint: Paint()
          ..color = theme.textTheme.bodyLarge?.color ?? Colors.black
          ..strokeWidth = 1.0);
    graph.addEdge(n17, n21,
        paint: Paint()
          ..color = theme.textTheme.bodyLarge?.color ?? Colors.black
          ..strokeWidth = 1.0);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Cormen-Style Binary Tree'),
        backgroundColor: theme.primaryColor,
      ),
      body: Center(
        child: InteractiveViewer(
          constrained: false,
          boundaryMargin: const EdgeInsets.all(100),
          minScale: 0.1,
          maxScale: 5.0,
          child: GraphView(
            graph: graph,
            algorithm:
                BuchheimWalkerAlgorithm(builder, TreeEdgeRenderer(builder)),
            builder: (Node node) {
              return Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.cardColor,
                  border: Border.all(
                      color:
                          theme.textTheme.bodyLarge?.color ?? Colors.black,
                      width: 1),
                ),
                alignment: Alignment.center,
                child: Text(
                  node.key!.value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontFamily: 'Times New Roman',
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}