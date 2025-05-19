import 'package:flutter/material.dart';
import 'package:Bookrithm/widgets/common/terminal_panel.dart';
import 'package:Bookrithm/widgets/common/code_block.dart';
import 'package:Bookrithm/widgets/registry/visualization_registry.dart';
import 'package:Bookrithm/widgets/common/sidebar.dart';
import 'package:Bookrithm/widgets/common/structure_title_bar.dart';
import './view_Objects.dart';
import 'package:Bookrithm/widgets/registry/visualization_area.dart';

final codeSwitcherKey = GlobalKey<CodeSwitcherState>();

class DataVisualizer extends StatefulWidget {
  const DataVisualizer({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DataVisualizerState createState() => _DataVisualizerState();
}

class _DataVisualizerState extends State<DataVisualizer> {
  bool _showTerminal = true;
  bool _isSidebarExpanded = true;
  String _currentStructure = 'Pilha';

  final Map<String, String> _structureTitles = {
    'Pilha': 'Thomas H. Cormen... [et al.] - Rio de Janeiro : Elsevier, 2012. il',
    'Árvore Binária': 'Thomas H. Cormen... [et al.] - Rio de Janeiro : Elsevier, 2012. il',
    'Fila': 'Thomas H. Cormen... [et al.] - Rio de Janeiro : Elsevier, 2012. il',
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
    );
  }

  @override
  void dispose() {
    _pushController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      sidebar: Sidebar(
        isExpanded: _isSidebarExpanded,
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
            );

            TerminalController.logToTerminal("Demonstrando ${value.toLowerCase()} da página tal, exemplo tal, do cara tal");

            if (codeSwitcherKey.currentState != null) {
              codeSwitcherKey.currentState!.updateDataStructure(value);
            }
          });
        },
        codeSwitcherKey: codeSwitcherKey,
        terminalKey: TerminalController.terminalKey,
      ),
      titleBar: StructureTitleBar(
        currentStructure: _currentStructure,
        structureTitles: _structureTitles,
        showTerminal: _showTerminal,
        onToggleTerminal: () {
          setState(() {
            _showTerminal = !_showTerminal;
          });
        },
      ),
      visualization: VisualizationArea(
        child: _currentVisualizationView,
      ),
      terminal: ResizableTerminalPanel(visible: _showTerminal),
    );
  }
}
