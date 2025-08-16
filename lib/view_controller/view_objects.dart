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
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          // Desktop layout
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
        } else {
          // Mobile layout
          return Scaffold(
            appBar: AppBar(
              title: const Text('Bookrithm'),
              backgroundColor: const Color.fromARGB(255, 196, 192, 192),
            ),
            drawer: Drawer(
              child: sidebar,
            ),
            body: Column(
              children: [
                titleBar,
                visualization,
                terminal,
              ],
            ),
          );
        }
      },
    );
  }
}
