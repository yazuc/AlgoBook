import 'package:flutter/material.dart';
import 'package:Bookrithm/widgets/common/terminal_panel.dart';
import 'package:Bookrithm/widgets/common/code_block.dart';
import 'package:Bookrithm/widgets/registry/visualization_registry.dart';
import 'package:Bookrithm/widgets/common/sidebar.dart';
import 'package:Bookrithm/widgets/common/structure_title_bar.dart';
import './view_objects.dart';
import 'package:Bookrithm/widgets/registry/visualization_area.dart';

final codeSwitcherKey = GlobalKey<CodeSwitcherState>();

class DataVisualizer extends StatefulWidget {
  final VoidCallback toggleTheme;
  final ThemeMode themeMode;

  const DataVisualizer({
    super.key,
    required this.toggleTheme,
    required this.themeMode,
  });

  @override
  // ignore: library_private_types_in_public_api
  _DataVisualizerState createState() => _DataVisualizerState();
}

class _DataVisualizerState extends State<DataVisualizer> {
  bool _showTerminal = true;
  bool _isSidebarExpanded = true;
  String _currentStructure = 'Pilha';

  final Map<String, String> _structureTitles = {
    'Pilha':
        'CORMEN, Thomas H.; LEISERSON, Charles E.; Ronald L. Rivest; et al. Algoritmos. 4. ed.',
    'Árvore Binária':
        'CORMEN, Thomas H.; LEISERSON, Charles E.; Ronald L. Rivest; et al. Algoritmos. 4. ed.',
    'Fila':
        'CORMEN, Thomas H.; LEISERSON, Charles E.; Ronald L. Rivest; et al. Algoritmos. 4. ed.',
  };

  final TextEditingController _pushController = TextEditingController();
  Widget? _currentVisualizationView;

  @override
  void initState() {
    super.initState();
    _currentVisualizationView = VisualizationRegistry.getView(
      _currentStructure,
      pushController: _pushController,
      onLog: (message) => TerminalController.logToTerminal(message),
      onHighlightCode: (title) => CodeBlocker.highLightCode(title),
    );
  }

  @override
  void dispose() {
    _pushController.dispose();
    super.dispose();
  }

  void _toggleTerminal() {
    setState(() {
      _showTerminal = !_showTerminal;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width <= 600;

    return AppScaffold(
      sidebar: Sidebar(
        isMobile: isMobile,
        isExpanded: isMobile || _isSidebarExpanded,
        onToggleExpand: () {
          setState(() {
            _isSidebarExpanded = !_isSidebarExpanded;
          });
        },
        currentStructure: _currentStructure,
        onStructureChanged: (value) {
          setState(() {
            _currentStructure = value;

            _currentVisualizationView = VisualizationRegistry.getView(
              _currentStructure,
              pushController: _pushController,
              onLog: (message) => TerminalController.logToTerminal(message),
              onHighlightCode: (title) => CodeBlocker.highLightCode(title),
            );

            //TerminalController.logToTerminal("Demonstrando ${value.toLowerCase()} da página tal, exemplo tal, do cara tal");

            if (CodeBlocker.codeSwitcherKey.currentState != null) {
              CodeBlocker.codeSwitcherKey.currentState!
                  .updateDataStructure(value);
            }
          });
        },
        codeSwitcherKey: CodeBlocker.codeSwitcherKey,
        terminalKey: TerminalController.terminalKey,
        toggleTheme: widget.toggleTheme,
        themeMode: widget.themeMode,
      ),
      titleBar: StructureTitleBar(
        currentStructure: _currentStructure,
        structureTitles: _structureTitles,
      ),
      visualization: VisualizationArea(
        child: _currentVisualizationView,
      ),
      terminal: ResizableTerminalPanel(
          visible: _showTerminal,
          showTerminal: true,
          onToggleTerminal: _toggleTerminal),
    );
  }
}
