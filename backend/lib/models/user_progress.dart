/// Modelo para representar o progresso geral do usuário
class UserProgress {
  final int id;
  final int userId;
  final String dataStructureType;
  final int totalSessions;
  final int totalDuration; // em segundos
  final int totalOperations;
  final Map<String, int> operationCounts; // contagem por tipo de operação
  final DateTime lastStudyAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProgress({
    required this.id,
    required this.userId,
    required this.dataStructureType,
    required this.totalSessions,
    required this.totalDuration,
    required this.totalOperations,
    required this.operationCounts,
    required this.lastStudyAt,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Cria um UserProgress a partir de um Map (banco de dados)
  factory UserProgress.fromMap(Map<String, dynamic> map) {
    return UserProgress(
      id: map['id'] as int,
      userId: map['user_id'] as int,
      dataStructureType: map['data_structure_type'] as String,
      totalSessions: map['total_sessions'] as int,
      totalDuration: map['total_duration'] as int,
      totalOperations: map['total_operations'] as int,
      operationCounts: Map<String, int>.from(map['operation_counts'] ?? {}),
      lastStudyAt: DateTime.parse(map['last_study_at'] as String),
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  /// Converte para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'data_structure_type': dataStructureType,
      'total_sessions': totalSessions,
      'total_duration': totalDuration,
      'total_operations': totalOperations,
      'operation_counts': operationCounts,
      'last_study_at': lastStudyAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// Estatísticas gerais do usuário
class UserStats {
  final int totalSessions;
  final int totalDuration;
  final int totalOperations;
  final Map<String, UserProgress> progressByStructure;
  final DateTime? lastStudyAt;

  UserStats({
    required this.totalSessions,
    required this.totalDuration,
    required this.totalOperations,
    required this.progressByStructure,
    this.lastStudyAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'total_sessions': totalSessions,
      'total_duration': totalDuration,
      'total_operations': totalOperations,
      'progress_by_structure': progressByStructure.map(
        (key, value) => MapEntry(key, value.toJson()),
      ),
      'last_study_at': lastStudyAt?.toIso8601String(),
    };
  }
}
