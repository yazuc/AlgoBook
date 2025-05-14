import 'package:flutter/material.dart';
import 'views/terminal_panel.dart';
import 'widgets/common/code_block.dart';
import 'widgets/registry/visualization_registry.dart';


void main() {
  runApp(DataStructureApp());
}

final terminalKey = GlobalKey<TerminalPanelState>();
final codeSwitcherKey = GlobalKey<CodeSwitcherState>();

class DataStructureApp extends StatelessWidget {
  const DataStructureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bookrithm',
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
  bool _showTerminal = true;
  bool _isSidebarExpanded = false;
  String _currentStructure = 'Pilha';
  double _terminalHeight = 150.0;
  static const double _minTerminalHeight = 50.0;
  static const double _maxTerminalHeight = 500.0;

  final Map<String, String> _structureTitles = {
    'Pilha': 'Thomas H. Cormen... [et al.] - Rio de Janeiro : Elsevier, 2012. il',
    'Árvore Binária': 'Thomas H. Cormen... [et al.] - Rio de Janeiro : Elsevier, 2012. il',
  };

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

                if (_isSidebarExpanded) ...[
                  CodeSwitcher(
                    key: codeSwitcherKey,
                    dataStructure: _currentStructure,
                  ),
                  DropdownButton<String>(
                    value: _currentStructure,
                    dropdownColor: Colors.grey[800],
                    style: TextStyle(color: Colors.white),
                    items: VisualizationRegistry.available
                        .map((name) => DropdownMenuItem(value: name, child: Text(name)))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _currentStructure = value;
                          terminalKey.currentState?.addLog("Demonstrando ${value.toLowerCase()} da página tal, exemplo tal, do cara tal");
                          if (codeSwitcherKey.currentState != null) {
                            codeSwitcherKey.currentState!.updateDataStructure(value);
                          }
                        });
                      }
                    },
                  ),
                ],
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
                        _structureTitles[_currentStructure] ?? 'Data Structure Visualization',
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
                      VisualizationRegistry.getView(
                        _currentStructure,
                        pushController: _pushController,
                        onLog: (message) => terminalKey.currentState?.addLog(message),
                      ),
                    ],
                  ),
                ),

                // Terminal resizable
                if (_showTerminal) 
                  Column(
                    children: [
                      // Resize handle
                      GestureDetector(
                        onVerticalDragUpdate: (details) {
                          setState(() {
                            _terminalHeight = (_terminalHeight - details.delta.dy)
                                .clamp(_minTerminalHeight, _maxTerminalHeight);
                          });
                        },
                        child: Container(
                          height: 10,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: Center(
                            child: Container(
                              width: 30,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.grey[600],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Terminal painel
                      Container(
                        height: _terminalHeight,
                        width: double.infinity,
                        child: TerminalPanel(key: terminalKey),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
