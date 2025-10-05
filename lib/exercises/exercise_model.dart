class Exercise {
  final String id;
  final String title;
  final String description;
  final String dataStructure;
  final List<Map<String, dynamic>> steps;
  final List<dynamic> expectedFinalState;

  Exercise({
    required this.id,
    required this.title,
    required this.description,
    required this.dataStructure,
    required this.steps,
    required this.expectedFinalState,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dataStructure: json['data_structure'],
      steps: List<Map<String, dynamic>>.from(json['steps']),
      expectedFinalState: List<dynamic>.from(json['expected_final_state']),
    );
  }
}
