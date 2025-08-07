import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class ApiService {
  final String baseUrl = 'http://localhost:8000';

  Future<String> _getToken() async {
    final user = FirebaseAuth.instance.currentUser;
    return user != null ? user.getIdToken() : '';
  }

  Future<dynamic> get(String path) async {
    final token = await _getToken();
    final response = await http.get(Uri.parse('$baseUrl$path'), headers: {
      'Authorization': 'Bearer $token',
    });
    return jsonDecode(response.body);
  }

  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    final token = await _getToken();
    final response = await http.post(Uri.parse('$baseUrl$path'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body));
    return jsonDecode(response.body);
  }
}
