import 'dart:convert';

/// Modelo para representar uma sessão de estudo de estruturas de dados
class StudySession {
  final int id;
  final int userId;
  final String dataStructureType; // 'stack', 'queue', 'binary_tree', 'linked_list'
  final Map<String, dynamic> state; // Estado da estrutura de dados
  final List<String> operations; // Histórico de operações realizadas
  final int duration; // Duração em segundos
  final DateTime createdAt;
  final DateTime updatedAt;

  StudySession({
    required this.id,
    required this.userId,
    required this.dataStructureType,
    required this.state,
    required this.operations,
    required this.duration,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Cria uma StudySession a partir de um Map (banco de dados)
  factory StudySession.fromMap(Map<String, dynamic> map) {
    return StudySession(
      id: map['id'] as int,
      userId: map['user_id'] as int,
      dataStructureType: map['data_structure_type'] as String,
      state: jsonDecode(map['state'] as String) as Map<String, dynamic>,
      operations: List<String>.from(jsonDecode(map['operations'] as String)),
      duration: map['duration'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  /// Converte para Map (para salvar no banco)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'data_structure_type': dataStructureType,
      'state': jsonEncode(state),
      'operations': jsonEncode(operations),
      'duration': duration,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Converte para JSON (para resposta da API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'data_structure_type': dataStructureType,
      'state': state,
      'operations': operations,
      'duration': duration,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// Modelo para criar uma nova sessão de estudo
class CreateStudySessionRequest {
  final String dataStructureType;
  final Map<String, dynamic> state;
  final List<String> operations;
  final int duration;

  CreateStudySessionRequest({
    required this.dataStructureType,
    required this.state,
    required this.operations,
    required this.duration,
  });

  factory CreateStudySessionRequest.fromJson(Map<String, dynamic> json) {
    return CreateStudySessionRequest(
      dataStructureType: json['data_structure_type'] as String,
      state: json['state'] as Map<String, dynamic>,
      operations: List<String>.from(json['operations']),
      duration: json['duration'] as int,
    );
  }
}
