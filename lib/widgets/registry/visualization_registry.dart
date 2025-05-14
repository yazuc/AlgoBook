import '../../views/stack_view.dart';
import '../../widgets/common/data_structure_view.dart';
import '../../views/binary_tree_view.dart';
import '../../data_structures/binary_tree.dart';
import '../../data_structures/stack.dart';
import 'package:flutter/material.dart';

typedef DataStructureBuilder = DataStructureView Function({
  TextEditingController? pushController,
  Function(String)? onLog,
});

class VisualizationRegistry {
  static final Map<String, DataStructureBuilder> _registry = {
    'Stack': ({pushController, onLog}) => StackView(
      stack: CustomStack<int>(), 
      maxSize: 7,
      pushController: pushController ?? TextEditingController(),
      onLog: onLog ?? (String _) {},
    ),
    // futuro: 'Queue': () => QueueView(queue: CustomQueue<int>(), maxSize: 7),
    'Binary Tree': ({pushController, onLog}) => BinaryTreeView(
      tree: CustomBinaryTree<int>(),
      pushController: pushController ?? TextEditingController(),
      onLog: onLog ?? (String _) {},
    ),
  };

  // Mapeamento de chaves internas para nomes de exibição
  static final Map<String, String> _displayNames = {
    'Stack': 'Pilha',
    'Binary Tree': 'Árvore Binária',
  };
  
  // Mapeamento inverso para converter de nome de exibição para chave interna
  static String getInternalKey(String displayName) {
    return _displayNames.entries
        .firstWhere(
          (entry) => entry.value == displayName,
          orElse: () => const MapEntry('', ''),
        )
        .key;
  }

  // Retorna as chaves disponíveis com seus nomes de exibição
  static List<String> get available => _registry.keys.map((key) => _displayNames[key] ?? key).toList();
  
  // Obtém a visualização usando o nome de exibição (converte para chave interna)
  static DataStructureView getView(String displayName, {
    TextEditingController? pushController,
    Function(String)? onLog,
  }) {
    final internalKey = getInternalKey(displayName);
    // Se não encontrou uma chave válida, tenta usar o displayName diretamente 
    // (para compatibilidade com código existente)
    final key = internalKey.isNotEmpty ? internalKey : displayName;
    
    return _registry[key]!(
      pushController: pushController, 
      onLog: onLog
    );
  }
}
