// lib/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchUserProfile(int userId) async {
  final response = await http.get(Uri.parse('http://10.0.2.2:8000/user/1'));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load user profile');
  }
}

Future<List<dynamic>> fetchUserTasks(int userId) async {
  final response = await http.get(Uri.parse('http://10.0.2.2:8000/tasks/1'));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load user tasks');
  }
}
