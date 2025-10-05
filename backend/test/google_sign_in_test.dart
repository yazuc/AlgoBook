import 'dart:convert';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;

void main() {
  group('Google Sign-In API', () {
    test('POST /google com idToken válido', () async {
      // Substitua pelo idToken real obtido via Google Sign-In no Flutter
      const idToken = 'COLE_AQUI_UM_ID_TOKEN_VALIDO';

      final response = await http.post(
        Uri.parse('http://localhost:8080/google'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': idToken}),
      );

      print('Resposta: ${response.body}');
      expect(response.statusCode, 200);

      final data = jsonDecode(response.body);
      expect(data, contains('jwt'));
    });

    test('POST /google com idToken inválido', () async {
      final response = await http.post(
        Uri.parse('http://localhost:8080/google'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': 'token_invalido'}),
      );

      expect(response.statusCode, isNot(200));
    });
  });
}