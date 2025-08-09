import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final Widget sidebar;
  final Widget titleBar;
  final Widget visualization;
  final Widget terminal;

  const AppScaffold({
    super.key,
    required this.sidebar,
    required this.titleBar,
    required this.visualization,
    required this.terminal,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          sidebar,
          Expanded(
            child: Column(
              children: [
                titleBar,
                visualization,
                terminal,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
