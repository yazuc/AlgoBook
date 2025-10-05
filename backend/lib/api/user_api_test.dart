import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../db/connection.dart';

class UserApiTest {
  Router get router {
    final router = Router();

    // GET /user/profile - Obtém perfil do usuário (MODO TESTE - sem auth)
    router.get('/profile', (Request request) async {
      try {
        // Para teste, vamos retornar um usuário fictício
        final mockUser = {
          'id': 1,
          'email': 'teste@example.com',
          'name': 'Usuário Teste',
          'created_at': DateTime.now().toIso8601String(),
        };

        return Response.ok(
          jsonEncode({'user': mockUser}),
          headers: {'Content-Type': 'application/json'},
        );
      } catch (e) {
        return Response.internalServerError(
          body: jsonEncode({'error': 'Erro ao buscar perfil: $e'}),
        );
      }
    });

    // PUT /user/profile - Atualiza perfil do usuário (MODO TESTE - sem auth)
    router.put('/profile', (Request request) async {
      try {
        final body = jsonDecode(await request.readAsString());
        final name = body['name'] as String?;

        if (name == null || name.trim().isEmpty) {
          return Response.badRequest(
            body: jsonEncode({'error': 'Nome é obrigatório'}),
          );
        }

        // Atualiza o nome do usuário no banco (exemplo para user_id = 1)
        await Database.connection.execute(
          r'''UPDATE users SET name = $1, updated_at = NOW() WHERE id = $2''',
          parameters: [name.trim(), 1],
        );

        // Busca usuário atualizado
        final result = await Database.connection.execute(
          r'''SELECT id, email, name, created_at FROM users WHERE id = $1''',
          parameters: [1],
        );
        final row = result.first;

        final updatedUser = {
          'id': row[0],
          'email': row[1],
          'name': row[2],
          'created_at': row[3].toString(),
        };

        return Response.ok(
          jsonEncode({'user': updatedUser}),
          headers: {'Content-Type': 'application/json'},
        );
      } catch (e) {
        return Response.internalServerError(
          body: jsonEncode({'error': 'Erro ao atualizar perfil: $e'}),
        );
      }
    });

    // GET /user/stats - Estatísticas gerais do usuário (MODO TESTE - sem auth)
    router.get('/stats', (Request request) async {
      try {
        // Busca estatísticas das sessões (se existirem)
        final sessionStats = await Database.connection.execute(
          '''SELECT 
               COUNT(*) as total_sessions,
               SUM(duration) as total_duration,
               SUM(jsonb_array_length(operations::jsonb)) as total_operations,
               MAX(created_at) as last_session
             FROM study_sessions''',
        );

        // Busca estatísticas por estrutura de dados
        final structureStats = await Database.connection.execute(
          '''SELECT 
               data_structure_type,
               COUNT(*) as sessions,
               SUM(duration) as duration,
               SUM(jsonb_array_length(operations::jsonb)) as operations
             FROM study_sessions
             GROUP BY data_structure_type''',
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
