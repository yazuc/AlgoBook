import 'package:test/test.dart';
import 'package:backend/db/connection.dart';

void main() {
  setUpAll(() async {
    await Database.init();
  });

  test('Consulta simples', () async {
    final result = await Database.connection.execute('SELECT 1;');
    expect(result.first[0], equals(1));
  });
}


