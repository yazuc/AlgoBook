import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:backend/db/connection.dart';
import 'package:backend/api/auth_api.dart';
import 'package:backend/api/study_api_fixed.dart';
import 'package:backend/api/user_api_test.dart';

void main() async {
  try {
    // Inicializa conexão com banco de dados
    print('Iniciando conexão com banco de dados...');
    await Database.init();
    print('Banco de dados conectado com sucesso!');

    // Configura roteador principal
    final router = Router();

    // Rotas públicas (não requerem autenticação)
    router.mount('/auth/', AuthApi().router.call);
    
    // Rotas sem autenticação porque não funciona
    router.mount('/api/user/', UserApiTest().router.call);
    router.mount('/api/study/', StudyApiFixed().router.call);

    // Rota de health check
    router.get('/health', (Request request) {
      return Response.ok('OK');
    });

    // Rota de informações da API
    router.get('/', (Request request) {
      final info = {
        'name': 'AlgoBook API',
        'version': '1.0.0',
        'description': 'API para o simulador de algoritmos e estruturas de dados',
        'note': 'Endpoints de usuário e estudo estão SEM autenticação',
        'endpoints': {
          'auth': {
            'POST /auth/google': 'Autenticação via Google OAuth',
          },
          'user': {
            'GET /api/user/profile': 'Perfil do usuário (SEM AUTH)',
            'PUT /api/user/profile': 'Atualizar perfil (SEM AUTH)',
            'GET /api/user/stats': 'Estatísticas do usuário (SEM AUTH)',
          },
          'study': {
            'GET /api/study/sessions': 'Listar sessões de estudo (SEM AUTH)',
            'POST /api/study/sessions': 'Criar sessão de estudo (SEM AUTH)',
            'GET /api/study/progress': 'Progresso do usuário (SEM AUTH)',
          },
        },
      };

      return Response.ok(
        jsonEncode(info),
        headers: {'Content-Type': 'application/json'},
      );
    });

    // Pipeline de middleware
    final handler = Pipeline()
        .addMiddleware(logRequests())
        .addMiddleware(corsHeaders(headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
          'Access-Control-Allow-Headers': 'Origin, Content-Type, Authorization',
        }))
        .addMiddleware(_errorHandler())
        .addHandler(router.call);

    // Inicia servidor
    final server = await io.serve(handler, '0.0.0.0', 8080);
    print('Servidor AlgoBook rodando em http://${server.address.host}:${server.port}');
    print('Documentação da API disponível em http://${server.address.host}:${server.port}/');
    print(' MODO TESTE: Endpoints sem autenticação para facilitar testes');
  } catch (e, stackTrace) {
    print('Erro ao iniciar servidor: $e');
    print('Stack trace: $stackTrace');
    exit(1);
  }
}

/// Middleware para tratamento de erros
Middleware _errorHandler() {
  return (Handler innerHandler) {
    return (Request request) async {
      try {
        return await innerHandler(request);
      } catch (error, stackTrace) {
        print('Erro na requisição ${request.method} ${request.url}: $error');
        print('Stack trace: $stackTrace');
        
        return Response.internalServerError(
          body: jsonEncode({
            'error': 'Erro interno do servidor',
            'message': error.toString(),
          }),
          headers: {'Content-Type': 'application/json'},
        );
      }
    };
  };
}
