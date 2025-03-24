import 'package:flutter/material.dart';
import 'stack.dart'; // Import the modified file

void main() {
  runApp(DataStructureApp());
}

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
  int _counter = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stack Visualizer')),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _stack.elements.reversed
                    .map((e) => Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          width: 100,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '$e',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _stack.push(_counter++);
                  });
                },
                child: Text('Push'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _stack.pop();
                  });
                },
                child: Text('Pop'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _stack.exec();
                  });
                },
                child: Text('Execute'),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
