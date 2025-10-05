import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dotenv/dotenv.dart';

class JwtUtils {
  static String generate(Map<String, dynamic> payload) {
    final env = DotEnv()..load();
    final secret = env['JWT_SECRET']!;
    final jwt = JWT(payload);
    return jwt.sign(SecretKey(secret), expiresIn: const Duration(hours: 2));
  }

  static Map<String, dynamic>? verify(String token) {
    final env = DotEnv()..load();
    final secret = env['JWT_SECRET']!;
    try {
      final jwt = JWT.verify(token, SecretKey(secret));
      return jwt.payload;
    } catch (e) {
      return null;
    }
  }
}
