import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../db/connection.dart';
import '../models/user.dart';
import '../middleware/auth_middleware.dart';

class UserApi {
  Router get router {
    final router = Router();

    // GET /user/profile - Obtém perfil do usuário autenticado
    router.get('/profile', (Request request) async {
      final user = AuthMiddleware.getCurrentUser(request);
      if (user == null) {
        return Response.unauthorized('Usuário não autenticado');
      }

      return Response.ok(
        jsonEncode({'user': user.toJson()}),
        headers: {'Content-Type': 'application/json'},
      );
    });

    // PUT /user/profile - Atualiza perfil do usuário
    router.put('/profile', (Request request) async {
      final user = AuthMiddleware.getCurrentUser(request);
      if (user == null) {
        return Response.unauthorized('Usuário não autenticado');
      }

      try {
        final body = jsonDecode(await request.readAsString());
        final name = body['name'] as String?;

        if (name == null || name.trim().isEmpty) {
          return Response.badRequest(
            body: jsonEncode({'error': 'Nome é obrigatório'}),
          );
        }

        // Atualiza o nome do usuário
        await Database.connection.execute(
          r'UPDATE users SET name = $1, updated_at = NOW() WHERE id = $2',
          parameters: [name.trim(), user.id],
        );

        // Busca o usuário atualizado
        final result = await Database.connection.execute(
          r'SELECT * FROM users WHERE id = $1',
          parameters: [user.id],
        );

        if (result.isNotEmpty) {
          final row = result.first;
          final updatedUserMap = {
            'id': row[0],
            'google_id': row[1],
            'email': row[2],
            'name': row[3],
            'created_at': row[4].toString(),
            'updated_at': row[5].toString(),
          };

          final updatedUser = User.fromMap(updatedUserMap);

          return Response.ok(
            jsonEncode({'user': updatedUser.toJson()}),
            headers: {'Content-Type': 'application/json'},
          );
        }

        return Response.internalServerError(
          body: jsonEncode({'error': 'Erro ao buscar usuário atualizado'}),
        );
      } catch (e) {
        return Response.internalServerError(
          body: jsonEncode({'error': 'Erro ao atualizar perfil: $e'}),
        );
      }
    });

    // DELETE /user/account - Deleta conta do usuário
    router.delete('/account', (Request request) async {
      final user = AuthMiddleware.getCurrentUser(request);
      if (user == null) {
        return Response.unauthorized('Usuário não autenticado');
      }

      try {
        // Inicia transação para deletar todos os dados relacionados
        await Database.connection.execute('BEGIN');

        // Deleta sessões de estudo
        await Database.connection.execute(
          r'DELETE FROM study_sessions WHERE user_id = $1',
          parameters: [user.id],
        );

        // Deleta progresso do usuário
        await Database.connection.execute(
          r'DELETE FROM user_progress WHERE user_id = $1',
          parameters: [user.id],
        );

        // Deleta o usuário
        await Database.connection.execute(
          r'DELETE FROM users WHERE id = $1',
          parameters: [user.id],
        );

        await Database.connection.execute('COMMIT');

        return Response.ok(
          jsonEncode({'message': 'Conta deletada com sucesso'}),
          headers: {'Content-Type': 'application/json'},
        );
      } catch (e) {
        await Database.connection.execute('ROLLBACK');
        return Response.internalServerError(
          body: jsonEncode({'error': 'Erro ao deletar conta: $e'}),
        );
      }
    });

    // GET /user/stats - Estatísticas gerais do usuário
    router.get('/stats', (Request request) async {
      final user = AuthMiddleware.getCurrentUser(request);
      if (user == null) {
        return Response.unauthorized('Usuário não autenticado');
      }

      try {
        // Busca estatísticas das sessões
        final sessionStats = await Database.connection.execute(
          r'''SELECT 
              COUNT(*) as total_sessions,
              SUM(duration) as total_duration,
              SUM(jsonb_array_length(operations::jsonb)) as total_operations,
              MAX(created_at) as last_session
            FROM study_sessions 
            WHERE user_id = $1''',
          parameters: [user.id],
        );

        // Busca estatísticas por estrutura de dados
        final structureStats = await Database.connection.execute(
          r'''SELECT 
              data_structure_type,
              COUNT(*) as sessions,
              SUM(duration) as duration,
              SUM(jsonb_array_length(operations::jsonb)) as operations
            FROM study_sessions 
            WHERE user_id = $1
            GROUP BY data_structure_type''',
          parameters: [user.id],
        );

        final stats = <String, dynamic>{
          'total_sessions': sessionStats.first[0] ?? 0,
          'total_duration': sessionStats.first[1] ?? 0,
          'total_operations': sessionStats.first[2] ?? 0,
          'last_session': sessionStats.first[3]?.toString(),
          'by_structure': {},
        };

        for (final row in structureStats) {
          final structureType = row[0] as String;
          stats['by_structure'][structureType] = {
            'sessions': row[1],
            'duration': row[2],
            'operations': row[3],
          };
        }

        return Response.ok(
          jsonEncode({'stats': stats}),
          headers: {'Content-Type': 'application/json'},
        );
      } catch (e) {
        return Response.internalServerError(
          body: jsonEncode({'error': 'Erro ao buscar estatísticas: $e'}),
        );
      }
    });

    return router;
  }
}
