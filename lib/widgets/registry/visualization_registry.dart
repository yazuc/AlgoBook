
import '../../views/stack_view.dart';
import '../../widgets/common/data_structure_view.dart';
import '../../views/binary_tree_view.dart';
import '../../data_structures/binary_tree.dart';
import '../../data_structures/stack.dart';
import 'package:flutter/material.dart';

/// Tipo de função para criar uma visualização de estrutura de dados.
///
/// Esta função de factory recebe os parâmetros necessários para criar
/// uma instância de uma visualização específica.
typedef DataStructureBuilder = DataStructureView Function({
  TextEditingController? pushController,
  Function(String)? onLog,
});

/// Registro centralizado de visualizações de estruturas de dados.
///
/// Esta classe gerencia as diferentes visualizações disponíveis
/// no aplicativo e facilita a alternância entre elas. Ela também
/// traduz os nomes internos para nomes de exibição em português.
class VisualizationRegistry {
  /// Mapeamento entre chaves internas e builders das visualizações
  static final Map<String, DataStructureBuilder> _registry = {
    'Stack': ({pushController, onLog}) => StackView(
      stack: CustomStack<int>(), 
      maxSize: 7,
      pushController: pushController ?? TextEditingController(),
      onLog: onLog ?? (String _) {},
    ),
    // futuro: 'Queue': () => QueueView(queue: CustomQueue<int>(), maxSize: 7),
    'Binary Tree': ({pushController, onLog}) {
      final controller = BinaryTreeController(
        tree: CustomBinaryTree<int>(),
        inputController: pushController ?? TextEditingController(),
        onLog: onLog ?? (String _) {},
      );
      return BinaryTreeView(controller: controller);
    },
  };

  /// Mapeamento de chaves internas para nomes de exibição em português
  static final Map<String, String> _displayNames = {
    'Stack': 'Pilha',
    'Binary Tree': 'Árvore Binária',
  };
  
  /// Converte um nome de exibição para a chave interna correspondente.
  ///
  /// Este método faz a tradução inversa para encontrar a chave interna
  /// a partir do nome de exibição em português.
  ///
  /// [displayName] O nome de exibição a ser convertido
  ///
  /// @return A chave interna correspondente ou uma string vazia se não encontrada
  static String getInternalKey(String displayName) {
    return _displayNames.entries
        .firstWhere(
          (entry) => entry.value == displayName,
          orElse: () => const MapEntry('', ''),
        )
        .key;
  }

  /// Obtém a lista de nomes de visualizações disponíveis para exibição.
  ///
  /// Retorna uma lista de nomes traduzidos para português, que podem
  /// ser usados na interface do usuário.
  ///
  /// @return Lista de nomes de visualizações em português
  static List<String> get available => _registry.keys.map((key) => _displayNames[key] ?? key).toList();
  
  /// Obtém uma visualização para uma estrutura de dados pelo seu nome de exibição.
  ///
  /// Este método cria uma nova instância da visualização solicitada,
  /// convertendo o nome de exibição para a chave interna correspondente.
  ///
  /// [displayName] O nome de exibição da visualização (em português)
  /// [pushController] O controlador para o campo de texto de inserção
  /// [onLog] A função de callback para enviar logs ao terminal
  ///
  /// @return Uma instância da visualização solicitada
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