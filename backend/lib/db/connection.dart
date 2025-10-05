import 'package:postgres/postgres.dart';
import 'package:dotenv/dotenv.dart';

class Database {
  static late Connection connection;

  static Future<void> init() async {
    final env = DotEnv()..load();

    final endpoint = Endpoint(
      host: env['DB_HOST']!,
      port: int.parse(env['DB_PORT']!),
      database: env['DB_NAME']!,
      username: env['DB_USER']!,
      password: env['DB_PASS']!,
    );

    connection = await Connection.open(endpoint);
    print('Conectado ao PostgreSQL');
  }
}
