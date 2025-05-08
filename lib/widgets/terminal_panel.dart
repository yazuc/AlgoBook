import 'package:flutter/material.dart';

class TerminalPanel extends StatefulWidget {
  const TerminalPanel({super.key});

  @override
  TerminalPanelState createState() => TerminalPanelState();
}

class TerminalPanelState extends State<TerminalPanel> {
  final List<String> _logs = [];

  void addLog(String message) {
    setState(() {
      _logs.add(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: Colors.black,
      padding: const EdgeInsets.all(8),
      child: SingleChildScrollView(
        reverse: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _logs
              .map((log) => Text(
                    log,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'monospace',
                        fontSize: 14),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
