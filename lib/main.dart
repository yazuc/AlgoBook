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
  String _currentBook = 'Cormen';

  final Map<String, String> bookReferences = {
    'Cormen': 'Pilha Thomas H. Cormen... [et al.]  [tradução Arlete Simille Marques]. - Rio de Janeiro : Elsevier, 2012. il',
    'Ellis': 'Data Structures and Their Algorithms - Larry Ellis, 1992',
    'Goodrich': 'Data Structures and Algorithms in Java - Michael T. Goodrich, 2014',
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
            width: _isSidebarExpanded ? 300 : 48,
            color: const Color(0xFF1E1E1E),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                // Bibliography buttons
                ...bookReferences.keys.map((book) => InkWell(
                  onTap: () {
                    setState(() {
                      _currentBook = book;
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: _currentBook == book ? Colors.white : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      color: _currentBook == book ? Color(0xFF2D2D2D) : Colors.transparent,
                    ),
                    child: Center(
                      child: Text(
                        book[0],
                        style: TextStyle(
                          color: _currentBook == book ? Colors.white : Colors.grey[600],
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                )).toList(),
                
                const SizedBox(height: 8),
                
                // Code section with label
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _isSidebarExpanded = !_isSidebarExpanded;
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              color: _isSidebarExpanded ? Colors.white : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          color: _isSidebarExpanded ? Color(0xFF2D2D2D) : Colors.transparent,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.code,
                            color: _isSidebarExpanded ? Colors.white : Colors.grey[600],
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Center(
                        child: Text(
                          'Stack',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                if (_isSidebarExpanded)
                  const CodeSwitcher(),
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
                        message: bookReferences[_currentBook],
                        decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        textStyle: const TextStyle(color: Colors.white),
                        preferBelow: false,
                        verticalOffset: 20,
                        child: Text(
                          'Pilha - ${_currentBook.toUpperCase()}',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
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
                            child: Text('Push'),
                          ),
                          SizedBox(width: 16),

                          // Pop Button
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (_stack.elements.isEmpty) {
                                  terminalKey.currentState?.addLog("Error: 'Underflow'");
                                } else {
                                  terminalKey.currentState?.addLog("Stack was popped with P(S)");
                                  _stack.pop();
                                }
                              });
                            },
                            child: Text('Pop'),
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
                            child: Text('Empty'),
                          ),
                        ],
                      ),
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
