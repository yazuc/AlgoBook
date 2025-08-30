import 'package:flutter/material.dart';
import '../registry/visualization_registry.dart'; // Ajuste o caminho conforme necessário
import 'package:Bookrithm/widgets/common/code_block.dart'; // Ajuste o caminho conforme necessário

class Sidebar extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onToggleExpand;
  final String currentStructure;
  final void Function(String) onStructureChanged;
  final GlobalKey<CodeSwitcherState> codeSwitcherKey;
  final GlobalKey terminalKey;
  final VoidCallback toggleTheme;
  final ThemeMode themeMode;

  final bool isMobile;

  const Sidebar({
    super.key,
    required this.isExpanded,
    required this.onToggleExpand,
    required this.currentStructure,
    required this.onStructureChanged,
    required this.codeSwitcherKey,
    required this.terminalKey,
    required this.toggleTheme,
    required this.themeMode,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isExpanded ? 300 : 80,
      color: Theme.of(context).canvasColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          if (!isMobile)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.code),
                  onPressed: onToggleExpand,
                ),
                IconButton(
                  icon: Icon(
                    themeMode == ThemeMode.light
                        ? Icons.dark_mode
                        : Icons.light_mode,
                  ),
                  onPressed: toggleTheme,
                ),
              ],
            ),
          if (isExpanded) ...[
            CodeSwitcher(
              key: codeSwitcherKey,
              dataStructure: currentStructure,
            ),
            DropdownButton<String>(
              value: currentStructure,
              dropdownColor: Colors.grey[800],
              style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
              items: VisualizationRegistry.available
                  .map((name) => DropdownMenuItem(value: name, child: Text(name)))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  onStructureChanged(value);
                }
              },
            ),
          ],
        ],
      ),
    );
  }
}
