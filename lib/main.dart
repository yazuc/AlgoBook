import 'package:flutter/material.dart';
import 'stack.dart';
import '/widgets/terminal_panel.dart';
import 'package:Bookrithm/widgets/code_block.dart';
import 'package:Bookrithm/widgets/visualization_registry.dart';
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
  final int _maxSize = 7;
  bool _showTerminal = true;
  bool _isSidebarExpanded = false;
  String _currentStructure = 'Stack';
  double _terminalHeight = 150.0;
  static const double _minTerminalHeight = 50.0;
  static const double _maxTerminalHeight = 500.0;

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
                        terminalKey.currentState?.addLog("Demonstrando pilha da página tal, exemplo tal, do cara tal");
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
                      Tooltip(
                        message: 'Pilha Thomas H. Cormen... [et al.]  [tradução Arlete Simille Marques]. - Rio de Janeiro : Elsevier, 2012. il',
                        decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        textStyle: const TextStyle(color: Colors.white),
                        preferBelow: false,
                        verticalOffset: 20,
                        child: Text(
                          'Pilha - Cormen et al.',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      IconButton(
                        icon: Icon(_showTerminal ? Icons.expand_more : Icons.expand_less),
                        color: Colors.white,
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
                      StackView(stack: _stack, maxSize: _maxSize),
                      // VisualizationRegistry.getView(_currentStructure),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Input field
                          SizedBox(
                            width: 80,
                            child: TextField(
                              controller: _pushController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'x',
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),

                          // Push Button
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (_stack.elements.length < _maxSize) {
                                  final text = _pushController.text.trim();
                                  if (text.isNotEmpty && int.tryParse(text) != null) {
                                    int value = int.parse(text);
                                    terminalKey.currentState?.addLog("Stack was pushed with P(S, $value)");
                                    _stack.push(value);
                                    _pushController.clear();
                                  } else {
                                    terminalKey.currentState?.addLog("Error: Invalid input");
                                  }
                                } else {
                                  terminalKey.currentState?.addLog("Error: 'Overflow'");
                                }
                              });
                            },
                            child: Text('Push(S, x)'),
                          ),
                          SizedBox(width: 16),

                          // Pop Button
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (_stack.elements.isEmpty) {
                                  terminalKey.currentState?.addLog("Error: 'underflow'");
                                } else {
                                  terminalKey.currentState?.addLog("Stack was popped with P(S)");
                                  _stack.pop();
                                }
                              });
                            },
                            child: Text('Pop (S)'),
                          ),
                          SizedBox(width: 16),
                          // Empty Button
                          ElevatedButton(
                            onPressed: () {
                              terminalKey.currentState?.addLog(
                                _stack.elements.isEmpty
                                    ? "Stack is empty"
                                    : "Stack is not empty"
                              );
                            },
                            child: Text('Stack-Empty(S)'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Terminal fixo na parte inferior
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
