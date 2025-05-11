import 'package:flutter/material.dart';
import 'stack.dart';
import '/widgets/terminal_panel.dart';
import 'package:Bookrithm/widgets/code_block.dart';
import 'package:Bookrithm/widgets/visualization_registry.dart';
import 'binary_tree.dart';
import '/widgets/binary_tree_view.dart';

void main() {
  runApp(DataStructureApp());
}

final terminalKey = GlobalKey<TerminalPanelState>();

class DataStructureApp extends StatelessWidget {
  const DataStructureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stack Simulator',
      theme: ThemeData.light(),
      home: StackVisualizer(),
    );
  }
}

class StackVisualizer extends StatefulWidget {
  const StackVisualizer({super.key});

  @override
  _StackVisualizerState createState() => _StackVisualizerState();
}

class _StackVisualizerState extends State<StackVisualizer> {
  final CustomStack<int> _stack = CustomStack<int>();
  final CustomBinaryTree<int> _tree = CustomBinaryTree<int>();
  final int _maxSize = 7;
  bool _showTerminal = true;
  bool _isSidebarExpanded = false;
  String _currentStructure = 'Stack';

  final TextEditingController _pushController = TextEditingController();

  @override
  void dispose() {
    _pushController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Menu lateral estilo VSCode
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: _isSidebarExpanded ? 300 : 80,
            color: Colors.grey[900],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),

                // Ícones lado a lado
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.settings, color: Colors.white),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.code, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          _isSidebarExpanded = !_isSidebarExpanded;
                        });
                      },
                    ),
                  ],
                ),

                if (_isSidebarExpanded)
                  const CodeSwitcher(),
                  DropdownButton<String>(
                    value: _currentStructure,
                    dropdownColor: Colors.grey[800],
                    style: TextStyle(color: Colors.white),
                    items: VisualizationRegistry.available
                        .map((name) => DropdownMenuItem(value: name, child: Text(name)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _currentStructure = value!;
                        terminalKey.currentState?.addLog("Demonstrando ${value.toLowerCase()} da página tal, exemplo tal, do cara tal");
                      });
                    },
                  )
              ],
            ),
          ),
          // Área principal
          Expanded(
            child: Column(
              children: [
                // Barra de título
                Container(
                  height: 50,
                  color: Colors.grey[850],
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pilha Thomas H. Cormen... [et al.]  [tradução Arlete Simille Marques]. - Rio de Janeiro : Elsevier, 2012. il',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      IconButton(
                        icon: Icon(_showTerminal ? Icons.expand_more : Icons.expand_less),
                        onPressed: () {
                          setState(() {
                            _showTerminal = !_showTerminal;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                // Parte central (Stack + botões)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_currentStructure == 'Stack')
                        VisualizationRegistry.getView(
                          'Stack',
                          pushController: _pushController,
                          onLog: (message) => terminalKey.currentState?.addLog(message),
                        )
                      else if (_currentStructure == 'Binary Tree')
                        VisualizationRegistry.getView('Binary Tree'),
                    ],
                  ),
                ),

                // Terminal fixo na parte inferior
                AnimatedSize(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: ConstrainedBox(
                    constraints: _showTerminal
                        ? BoxConstraints(maxHeight: 150)
                        : BoxConstraints(maxHeight: 0),
                    child: SizedBox(
                      width: double.infinity,
                      child: TerminalPanel(key: terminalKey),
                    ),
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
