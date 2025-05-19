import 'package:Bookrithm/view_structures/stack_view.dart';
import '../common/data_structure_view.dart';
import 'package:Bookrithm/view_structures/binary_tree_view.dart';
import '../../data_structures/binary_tree.dart';
import '../../data_structures/stack.dart';
import 'package:flutter/material.dart';
import 'package:Bookrithm/data_structures/queue.dart';
import 'package:Bookrithm/view_structures/queue_view.dart';
import 'package:Bookrithm/widgets/common/terminal_panel.dart';

/// Tipo de função para criar uma visualização de estrutura de dados.
///
/// Esta função de factory recebe os parâmetros necessários para criar
/// uma instância de uma visualização específica.
typedef DataStructureBuilder = DataStructureView Function({
  TextEditingController? pushController,
  Function(String)? onLog,
});

class VisualizationEntry {
  final String internalKey;
  final String displayName;
  final DataStructureBuilder builder;

  VisualizationEntry({
    required this.internalKey,
    required this.displayName,
    required this.builder,
  });
}

class TerminalController {
  static final GlobalKey<TerminalPanelState> terminalKey = GlobalKey();

    static void logToTerminal(String message) {
      final state = TerminalController.terminalKey.currentState;
      if (state != null && state.mounted) {
        state.addLog(message);
      }
    }
}


/// Registro centralizado de visualizações de estruturas de dados.
///
/// Esta classe gerencia as diferentes visualizações disponíveis
/// no aplicativo e facilita a alternância entre elas. Ela também
/// traduz os nomes internos para nomes de exibição em português.

class VisualizationRegistry {
  static final List<VisualizationEntry> _entries = [
    VisualizationEntry(
      internalKey: 'Stack',
      displayName: 'Pilha',
      builder: ({pushController, onLog}) => StackView(
        stack: CustomStack<int>(),
        maxSize: 7,
        pushController: pushController ?? TextEditingController(),
        onLog: onLog ?? TerminalController.logToTerminal,
      ),
    ),
    VisualizationEntry(
      internalKey: 'Queue',
      displayName: 'Fila',
      builder: ({pushController, onLog}) {
        return QueueView(
          queue: CustomQueue<int>(10),
          maxSize: 10,
          enqueueController: pushController ?? TextEditingController(),
          onLog: onLog ?? TerminalController.logToTerminal,
        );
      },
    ),
    VisualizationEntry(
      internalKey: 'Binary Tree',
      displayName: 'Árvore Binária',
      builder: ({pushController, onLog}) {
        final controller = BinaryTreeController(
          tree: CustomBinaryTree<int>(),
          inputController: pushController ?? TextEditingController(),
          onLog: onLog ?? TerminalController.logToTerminal,
        );
        return BinaryTreeView(controller: controller);
      },
    ),
  ];

  static final Map<String, DataStructureBuilder> _registry = {
    for (var entry in _entries) entry.internalKey: entry.builder,
  };

  static final Map<String, String> _displayNames = {
    for (var entry in _entries) entry.internalKey: entry.displayName,
  };

  static String getInternalKey(String displayName) {
    return _displayNames.entries
        .firstWhere(
          (entry) => entry.value == displayName,
          orElse: () => const MapEntry('', ''),
        )
        .key;
  }

  static List<String> get available =>
      _entries.map((entry) => entry.displayName).toList();

  static DataStructureView getView(String displayName, {
    TextEditingController? pushController,
    Function(String)? onLog,
  }) {
    final internalKey = getInternalKey(displayName);
    final key = internalKey.isNotEmpty ? internalKey : displayName;

    return _registry[key]!(
      pushController: pushController,
      onLog: onLog,
    );
  }
}
