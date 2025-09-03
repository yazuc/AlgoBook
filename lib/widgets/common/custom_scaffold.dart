import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  final Widget sidebar;
  final Widget titleBar;
  final Widget visualization;
  final Widget terminal;

  const CustomScaffold({
    super.key,
    required this.sidebar,
    required this.titleBar,
    required this.visualization,
    required this.terminal,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                      Expanded(
                        child: visualization,
                      ),
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
              backgroundColor: theme.primaryColor,
            ),
            drawer: Drawer(
              child: sidebar,
            ),
            body: Column(
              children: [
                titleBar,
                Expanded(
                  child: visualization,
                ),
                terminal,
              ],
            ),
          );
        }
      },
    );
  }
}
