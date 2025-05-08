import 'package:flutter/material.dart';

class TerminalPanel extends StatefulWidget {
  const TerminalPanel({super.key});

  @override
  TerminalPanelState createState() => TerminalPanelState();
}

class TerminalPanelState extends State<TerminalPanel> {
  final List<String> _logs = [];
  final ScrollController _scrollController = ScrollController();

  void addLog(String message) {
    setState(() {
      _logs.add(message);
    });

    // Aguarda o próximo frame para rolar até o fim
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: Colors.black,
      padding: const EdgeInsets.all(8),
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _logs
              .map((log) => Text(
                    log,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'monospace',
                      fontSize: 14,
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
