import 'package:flutter/material.dart';
import 'stack.dart';
import '/widgets/terminal_panel.dart';

void main() {
  runApp(DataStructureApp());
}

final terminalKey = GlobalKey<TerminalPanelState>();

class DataStructureApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stack Simulator',
      theme: ThemeData.light(), // Estilo VSCode
      home: StackVisualizer(),
    );
  }
}

class StackVisualizer extends StatefulWidget {
  @override
  _StackVisualizerState createState() => _StackVisualizerState();
}

class _StackVisualizerState extends State<StackVisualizer> {
  final CustomStack<int> _stack = CustomStack<int>();
  final int _maxSize = 7;
  int _counter = 1;
  bool _showTerminal = true;
  bool _isSidebarExpanded = false;

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
            crossAxisAlignment: _isSidebarExpanded ? CrossAxisAlignment.center : CrossAxisAlignment.center,
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
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Stack-Empty(S)",
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text("1   if S.topo == 0", style: TextStyle(color: Colors.white)),
                        Text("2     return true", style: TextStyle(color: Colors.white)),
                        Text("3   else return false", style: TextStyle(color: Colors.white)),
                        SizedBox(height: 16),
                        Text(
                          "Push(S, x)",
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text("1   S.topo = S.topo + 1", style: TextStyle(color: Colors.white)),
                        Text("2   S[S.topo] = x", style: TextStyle(color: Colors.white)),
                        SizedBox(height: 16),
                        Text(
                          "Pop(S)",
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text("1   if Stack-Empty(S)", style: TextStyle(color: Colors.white)),
                        Text('2     error "underflow"', style: TextStyle(color: Colors.white)),
                        Text("3   else S.topo = S.topo - 1", style: TextStyle(color: Colors.white)),
                        Text("4   return S[S.topo + 1]", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
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
                      StackView(stack: _stack, maxSize: _maxSize),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (_stack.elements.length < _maxSize) {
                                  terminalKey.currentState?.addLog("Stack was pushed with P(S, $_counter)");
                                  _stack.push(_counter++);
                                } else {
                                  terminalKey.currentState?.addLog("Error: 'Overflow'");
                                }
                              });
                            },
                            child: Text('Push'),
                          ),
                          SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (_stack.elements.isEmpty) {
                                  terminalKey.currentState?.addLog("Error: 'Underflow'");
                                } else {
                                  terminalKey.currentState?.addLog("Stack was popped with P(S)");
                                  _stack.pop();
                                  _counter--;
                                }
                              });
                            },
                            child: Text('Pop'),
                          ),
                          SizedBox(width: 16),
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
                    child: Container(
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
