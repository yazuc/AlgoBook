/// Modelo para representar um usuário do sistema
class User {
  final int id;
  final String googleId;
  final String email;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.googleId,
    required this.email,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Cria um User a partir de um Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int,
      googleId: map['google_id'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  /// Converte o User para um Map (para serialização JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'google_id': googleId,
      'email': email,
      'name': name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Converte para JSON (sem dados sensíveis)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
