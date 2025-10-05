import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:http/http.dart' as http;
import '../db/connection.dart';
import '../utils/jwt.dart';

class AuthApi {
  Router get router {
    final router = Router();

    // Endpoint: /auth/google
    router.post('/google', (Request req) async {
      final body = jsonDecode(await req.readAsString());
      final idToken = body['idToken'];

      // Valida token no endpoint oficial do Google
      final googleResp = await http.get(Uri.parse(
        'https://oauth2.googleapis.com/tokeninfo?id_token=$idToken',
      ));

      if (googleResp.statusCode != 200) {
        return Response.forbidden('Token inválido');
      }

      final data = jsonDecode(googleResp.body);
      final googleId = data['sub'];
      final email = data['email'];
      final name = data['name'];

      // Verifica se o usuário já existe no Postgres
      final result = await Database.connection.execute(
        r'SELECT id FROM users WHERE google_id=$1',
        parameters: [googleId],
      );

      int userId;
      if (result.isEmpty) {
        final inserted = await Database.connection.execute(
          r'INSERT INTO users (google_id, email, name) VALUES ($1, $2, $3) RETURNING id',
          parameters: [googleId, email, name],
        );
        userId = inserted.first[0] as int;
      } else {
        userId = result.first[0] as int;
      }

      // Gera JWT local
      final jwt = JwtUtils.generate({'id': userId, 'email': email});
      return Response.ok(jsonEncode({'jwt': jwt}));
    });

    return router;
  }
}
