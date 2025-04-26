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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bookrithm')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Text('Stack Representation',
          //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          StackView(stack: _stack, maxSize: _maxSize),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (_stack.elements.length < _maxSize) {
                      terminalKey.currentState?.addLog("Stack was pushed with P(S, $_counter)");
                      _stack.push(_counter++);
                    }
                  });
                },
                child: Text('Push'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (_stack.elements.length <= _maxSize) {
                       if(_stack.elements.isEmpty){
                          terminalKey.currentState?.addLog("Error: 'Underflow'");
                       }else{
                        terminalKey.currentState?.addLog("Stack was popped with P(S)");
                        _stack.pop();
                        _counter--;
                       }
                    }
                  });
                },
                child: Text('Pop'),
              ),
              //  ElevatedButton(
              //   onPressed: _isExecuting
              //       ? null // Disable button while executing
              //       : _executeAnimated,
              //   child: Text('Execute'),
              // ),
              // ElevatedButton(
              //   onPressed: _isExecuting
              //       ? () {
              //           setState(() {
              //             _stopExecution = true; // Stop execution mid-way
              //           });
              //         }
              //       : null,
              //   child: Text('Stop'),
              // ),
            ],
          ),
          SizedBox(height: 20),
          TerminalPanel(key: terminalKey),
        ],
      ),
    );
  }
}

