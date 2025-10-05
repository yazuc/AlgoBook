import 'package:shelf/shelf.dart';
import '../utils/jwt.dart';
import '../db/connection.dart';
import '../models/user.dart';

/// Middleware para autenticação JWT
class AuthMiddleware {
  /// Middleware que verifica se o usuário está autenticado
  static Middleware requireAuth() {
    return (Handler innerHandler) {
      return (Request request) async {
        // Obtém o token do header Authorization
        final authHeader = request.headers['authorization'];
        
        if (authHeader == null || !authHeader.startsWith('Bearer ')) {
          return Response.unauthorized('Token de acesso requerido');
        }

        final token = authHeader.substring(7); // Remove 'Bearer '
        
        // Verifica o token JWT
        final payload = JwtUtils.verify(token);
        if (payload == null) {
          return Response.unauthorized('Token inválido ou expirado');
        }

        // Busca o usuário no banco de dados
        final userId = payload['id'] as int;
        final result = await Database.connection.execute(
          'SELECT * FROM users WHERE id = @id',
          parameters: {'id': userId},
        );

        if (result.isEmpty) {
          return Response.unauthorized('Usuário não encontrado');
        }

        // Cria objeto User e adiciona ao contexto da requisição
        final userMap = {
          'id': result.first[0],
          'google_id': result.first[1],
          'email': result.first[2],
          'name': result.first[3],
          'created_at': result.first[4].toString(),
          'updated_at': result.first[5].toString(),
        };
        
        final user = User.fromMap(userMap);
        
        // Adiciona o usuário ao contexto da requisição
        final newRequest = request.change(context: {
          ...request.context,
          'user': user,
        });

        return await innerHandler(newRequest);
      };
    };
  }

  /// Middleware opcional - não falha se não houver token
  static Middleware optionalAuth() {
    return (Handler innerHandler) {
      return (Request request) async {
        final authHeader = request.headers['authorization'];
        
        if (authHeader != null && authHeader.startsWith('Bearer ')) {
          final token = authHeader.substring(7);
          final payload = JwtUtils.verify(token);
          
          if (payload != null) {
            final userId = payload['id'] as int;
            final result = await Database.connection.execute(
              'SELECT * FROM users WHERE id = @id',
              parameters: {'id': userId},
            );

            if (result.isNotEmpty) {
              final userMap = {
                'id': result.first[0],
                'google_id': result.first[1],
                'email': result.first[2],
                'name': result.first[3],
                'created_at': result.first[4].toString(),
                'updated_at': result.first[5].toString(),
              };
              
              final user = User.fromMap(userMap);
              
              final newRequest = request.change(context: {
                ...request.context,
                'user': user,
              });

              return await innerHandler(newRequest);
            }
          }
        }

        // Continua sem usuário autenticado
        return await innerHandler(request);
      };
    };
  }

  /// Obtém o usuário autenticado do contexto da requisição
  static User? getCurrentUser(Request request) {
    return request.context['user'] as User?;
  }

  /// Verifica se há um usuário autenticado
  static bool isAuthenticated(Request request) {
    return getCurrentUser(request) != null;
  }
}
