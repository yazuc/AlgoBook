import '/stack.dart'; // para StackView
import '/widgets/data_structures_view.dart';

typedef DataStructureBuilder = DataStructureView Function();

class VisualizationRegistry {
  static final Map<String, DataStructureBuilder> _registry = {
    'Stack': () => StackView(stack: CustomStack<int>(), maxSize: 7),
    // futuro: 'Queue': () => QueueView(queue: CustomQueue<int>(), maxSize: 7),
  };

  static List<String> get available => _registry.keys.toList();

  static DataStructureView getView(String key) => _registry[key]!();
}
