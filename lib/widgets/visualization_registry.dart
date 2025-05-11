import '/stack.dart'; // para StackView
import '/widgets/data_structures_view.dart';
//import '/widgets/binary_tree_view.dart';
import '/widgets/binary_tree_view.dart';
import '/binary_tree.dart';
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

  static List<String> get available => _registry.keys.toList();

  static DataStructureView getView(String key, {
    TextEditingController? pushController,
    Function(String)? onLog,
  }) => _registry[key]!(pushController: pushController, onLog: onLog);
}
