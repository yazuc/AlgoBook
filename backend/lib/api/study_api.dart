import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../db/connection.dart';
import '../models/study_session.dart';
import '../models/user_progress.dart';
import '../middleware/auth_middleware.dart';

class StudyApi {
  Router get router {
    final router = Router();

    // GET /study/sessions - Lista sessões de estudo do usuário
    router.get('/sessions', (Request request) async {
      final user = AuthMiddleware.getCurrentUser(request);
      if (user == null) {
        return Response.unauthorized('Usuário não autenticado');
      }

      try {
        final result = await Database.connection.execute(
          '''SELECT id, user_id, data_structure_type, state, operations, 
             duration, created_at, updated_at 
             FROM study_sessions 
             WHERE user_id = @userId 
             ORDER BY created_at DESC 
             LIMIT 50''',
          parameters: {'userId': user.id},
        );

        final sessions = result.map((row) {
          final sessionMap = {
            'id': row[0],
            'user_id': row[1],
            'data_structure_type': row[2],
            'state': row[3],
            'operations': row[4],
            'duration': row[5],
            'created_at': row[6].toString(),
            'updated_at': row[7].toString(),
          };
          return StudySession.fromMap(sessionMap).toJson();
        }).toList();

        return Response.ok(
          jsonEncode({'sessions': sessions}),
          headers: {'Content-Type': 'application/json'},
        );
      } catch (e) {
        return Response.internalServerError(
          body: jsonEncode({'error': 'Erro ao buscar sessões: $e'}),
        );
      }
    });

    // POST /study/sessions - Cria nova sessão de estudo
    router.post('/sessions', (Request request) async {
      final user = AuthMiddleware.getCurrentUser(request);
      if (user == null) {
        return Response.unauthorized('Usuário não autenticado');
      }

      try {
        final body = jsonDecode(await request.readAsString());
        final sessionRequest = CreateStudySessionRequest.fromJson(body);

        // Valida tipo de estrutura de dados
        final validTypes = ['stack', 'queue', 'binary_tree', 'linked_list'];
        if (!validTypes.contains(sessionRequest.dataStructureType)) {
          return Response.badRequest(
            body: jsonEncode({'error': 'Tipo de estrutura inválido'}),
          );
        }

        // Insere nova sessão
        final result = await Database.connection.execute(
          r'''INSERT INTO study_sessions 
            (user_id, data_structure_type, state, operations, duration, created_at, updated_at)
            VALUES ($1, $2, $3, $4, $5, NOW(), NOW())
            RETURNING id, created_at, updated_at''',
          parameters: [
            user.id,
            sessionRequest.dataStructureType,
            jsonEncode(sessionRequest.state),
            jsonEncode(sessionRequest.operations),
            sessionRequest.duration,
          ],
        );

        final sessionId = result.first[0] as int;
        final createdAt = DateTime.parse(result.first[1].toString());
        final updatedAt = DateTime.parse(result.first[2].toString());

        // Atualiza progresso do usuário
        await _updateUserProgress(
          user.id, 
          sessionRequest.dataStructureType, 
          sessionRequest.operations.length,
          sessionRequest.duration,
        );

        final session = StudySession(
          id: sessionId,
          userId: user.id,
          dataStructureType: sessionRequest.dataStructureType,
          state: sessionRequest.state,
          operations: sessionRequest.operations,
          duration: sessionRequest.duration,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

        return Response.ok(
          jsonEncode({'session': session.toJson()}),
          headers: {'Content-Type': 'application/json'},
        );
      } catch (e) {
        return Response.internalServerError(
          body: jsonEncode({'error': 'Erro ao criar sessão: $e'}),
        );
      }
    });

    // GET /study/progress - Obtém progresso do usuário
    router.get('/progress', (Request request) async {
      final user = AuthMiddleware.getCurrentUser(request);
      if (user == null) {
        return Response.unauthorized('Usuário não autenticado');
      }

      try {
        final result = await Database.connection.execute(
          '''SELECT id, user_id, data_structure_type, total_sessions, 
             total_duration, total_operations, operation_counts, 
             last_study_at, created_at, updated_at
             FROM user_progress 
             WHERE user_id = @userId''',
          parameters: {'userId': user.id},
        );

        final progressByStructure = <String, UserProgress>{};
        var totalSessions = 0;
        var totalDuration = 0;
        var totalOperations = 0;
        DateTime? lastStudyAt;

        for (final row in result) {
          final progressMap = {
            'id': row[0],
            'user_id': row[1],
            'data_structure_type': row[2],
            'total_sessions': row[3],
            'total_duration': row[4],
            'total_operations': row[5],
            'operation_counts': jsonDecode(row[6] as String),
            'last_study_at': row[7].toString(),
            'created_at': row[8].toString(),
            'updated_at': row[9].toString(),
          };

          final progress = UserProgress.fromMap(progressMap);
          progressByStructure[progress.dataStructureType] = progress;

          totalSessions += progress.totalSessions;
          totalDuration += progress.totalDuration;
          totalOperations += progress.totalOperations;

          if (lastStudyAt == null || progress.lastStudyAt.isAfter(lastStudyAt)) {
            lastStudyAt = progress.lastStudyAt;
          }
        }

        final stats = UserStats(
          totalSessions: totalSessions,
          totalDuration: totalDuration,
          totalOperations: totalOperations,
          progressByStructure: progressByStructure,
          lastStudyAt: lastStudyAt,
        );

        return Response.ok(
          jsonEncode({'progress': stats.toJson()}),
          headers: {'Content-Type': 'application/json'},
        );
      } catch (e) {
        return Response.internalServerError(
          body: jsonEncode({'error': 'Erro ao buscar progresso: $e'}),
        );
      }
    });

    // GET /study/sessions/:id - Obtém sessão específica
    router.get('/sessions/<id>', (Request request) async {
      final user = AuthMiddleware.getCurrentUser(request);
      if (user == null) {
        return Response.unauthorized('Usuário não autenticado');
      }

      final sessionId = int.tryParse(request.params['id']!);
      if (sessionId == null) {
        return Response.badRequest(
          body: jsonEncode({'error': 'ID da sessão inválido'}),
        );
      }

      try {
        final result = await Database.connection.execute(
          '''SELECT id, user_id, data_structure_type, state, operations, 
             duration, created_at, updated_at 
             FROM study_sessions 
             WHERE id = @sessionId AND user_id = @userId''',
          parameters: {'sessionId': sessionId, 'userId': user.id},
        );

        if (result.isEmpty) {
          return Response.notFound(
            jsonEncode({'error': 'Sessão não encontrada'}),
          );
        }

        final row = result.first;
        final sessionMap = {
          'id': row[0],
          'user_id': row[1],
          'data_structure_type': row[2],
          'state': row[3],
          'operations': row[4],
          'duration': row[5],
          'created_at': row[6].toString(),
          'updated_at': row[7].toString(),
        };

        final session = StudySession.fromMap(sessionMap);

        return Response.ok(
          jsonEncode({'session': session.toJson()}),
          headers: {'Content-Type': 'application/json'},
        );
      } catch (e) {
        return Response.internalServerError(
          body: jsonEncode({'error': 'Erro ao buscar sessão: $e'}),
        );
      }
    });

    return router;
  }

  /// Atualiza o progresso do usuário para uma estrutura de dados
  Future<void> _updateUserProgress(
    int userId,
    String dataStructureType,
    int operationCount,
    int duration,
  ) async {
    // Verifica se já existe registro de progresso
    final existingResult = await Database.connection.execute(
      '''SELECT id, total_sessions, total_duration, total_operations, operation_counts
         FROM user_progress 
         WHERE user_id = @userId AND data_structure_type = @type''',
      parameters: {'userId': userId, 'type': dataStructureType},
    );

    if (existingResult.isEmpty) {
      // Cria novo registro de progresso
      await Database.connection.execute(
        r'''INSERT INTO user_progress 
          (user_id, data_structure_type, total_sessions, total_duration, 
            total_operations, operation_counts, last_study_at, created_at, updated_at)
          VALUES ($1, $2, 1, $3, $4, '{}', NOW(), NOW(), NOW())''',
        parameters: [
          userId,
          dataStructureType,
          duration,
          operationCount,
        ],
      );
    } else {
      // Atualiza registro existente
      final row = existingResult.first;
      final currentSessions = row[1] as int;
      final currentDuration = row[2] as int;
      final currentOperations = row[3] as int;

      await Database.connection.execute(
        r'''UPDATE user_progress 
          SET total_sessions = $1,
              total_duration = $2,
              total_operations = $3,
              last_study_at = NOW(),
              updated_at = NOW()
          WHERE user_id = $4 AND data_structure_type = $5''',
        parameters: [
          currentSessions + 1,
          currentDuration + duration,
          currentOperations + operationCount,
          userId,
          dataStructureType,
        ],
      );
    }
  }
}
