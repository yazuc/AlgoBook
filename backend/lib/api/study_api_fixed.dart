import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../db/connection.dart';

class StudyApiFixed {
  Router get router {
    final router = Router();

    // GET /study/sessions - Lista sessões de estudo
    router.get('/sessions', (Request request) async {
      try {
        final result = await Database.connection.execute(
          '''SELECT id, user_id, data_structure_type, state, operations, 
             duration, created_at, updated_at 
             FROM study_sessions 
             ORDER BY created_at DESC 
             LIMIT 50''',
        );

        final sessions = result.map((row) {
          return {
            'id': row[0],
            'user_id': row[1],
            'data_structure_type': row[2],
            'state': row[3],
            'operations': row[4],
            'duration': row[5],
            'created_at': row[6].toString(),
            'updated_at': row[7].toString(),
          };
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
      try {
        final body = jsonDecode(await request.readAsString());
        final dataStructureType = body['data_structure_type'] as String;
        final state = jsonEncode(body['state']);
        final operations = jsonEncode(body['operations']);
        final duration = body['duration'] as int;

        // Valida tipo de estrutura de dados
        final validTypes = ['stack', 'queue', 'binary_tree', 'linked_list'];
        if (!validTypes.contains(dataStructureType)) {
          return Response.badRequest(
            body: jsonEncode({'error': 'Tipo de estrutura inválido'}),
          );
        }

        // Insere nova sessão usando parâmetros posicionais simples
        final result = await Database.connection.execute(
          r'''INSERT INTO study_sessions 
          (user_id, data_structure_type, state, operations, duration, created_at, updated_at)
          VALUES (1, $1, $2, $3, $4, NOW(), NOW())
          RETURNING id, created_at, updated_at''',
          parameters: [dataStructureType, state, operations, duration],
        );

        final sessionId = result.first[0] as int;
        final createdAt = DateTime.parse(result.first[1].toString());
        final updatedAt = DateTime.parse(result.first[2].toString());

        final session = {
          'id': sessionId,
          'user_id': 1,
          'data_structure_type': dataStructureType,
          'state': body['state'],
          'operations': body['operations'],
          'duration': duration,
          'created_at': createdAt.toIso8601String(),
          'updated_at': updatedAt.toIso8601String(),
        };

        return Response.ok(
          jsonEncode({'session': session}),
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
      try {
        final result = await Database.connection.execute(
          '''SELECT id, user_id, data_structure_type, total_sessions, 
             total_duration, total_operations, operation_counts, 
             last_study_at, created_at, updated_at
             FROM user_progress 
             WHERE user_id = 1''',
        );

        final progressByStructure = <String, dynamic>{};
        var totalSessions = 0;
        var totalDuration = 0;
        var totalOperations = 0;
        DateTime? lastStudyAt;

        for (final row in result) {
          final structureType = row[2] as String;
          final sessions = row[3] as int;
          final duration = row[4] as int;
          final operations = row[5] as int;
          final lastStudy = DateTime.parse(row[7].toString());

          progressByStructure[structureType] = {
            'total_sessions': sessions,
            'total_duration': duration,
            'total_operations': operations,
            'last_study_at': lastStudy.toIso8601String(),
          };

          totalSessions += sessions;
          totalDuration += duration;
          totalOperations += operations;

          if (lastStudyAt == null || lastStudy.isAfter(lastStudyAt)) {
            lastStudyAt = lastStudy;
          }
        }

        final stats = {
          'total_sessions': totalSessions,
          'total_duration': totalDuration,
          'total_operations': totalOperations,
          'progress_by_structure': progressByStructure,
          'last_study_at': lastStudyAt?.toIso8601String(),
        };

        return Response.ok(
          jsonEncode({'progress': stats}),
          headers: {'Content-Type': 'application/json'},
        );
      } catch (e) {
        return Response.internalServerError(
          body: jsonEncode({'error': 'Erro ao buscar progresso: $e'}),
        );
      }
    });

    return router;
  }
}
