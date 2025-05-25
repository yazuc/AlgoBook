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

  const Sidebar({
    super.key,
    required this.isExpanded,
    required this.onToggleExpand,
    required this.currentStructure,
    required this.onStructureChanged,
    required this.codeSwitcherKey,
    required this.terminalKey,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: isExpanded ? 300 : 80,
      color: Colors.grey[900],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.code, color: Colors.white),
                onPressed: onToggleExpand,
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
              style: const TextStyle(color: Colors.white),
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
