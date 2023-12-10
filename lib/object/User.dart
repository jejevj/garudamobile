import 'dart:convert';
import 'package:http/http.dart' as http;

class User {
  final int id;
  final String username;
  final String email;
  final String password;
  final String? photo;
  final double lat;
  final double lon;
  final String level;
  final String createdAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.photo,
    required this.lat,
    required this.lon,
    required this.level,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      photo: json['photo'],
      lat: double.parse(json['lat']),
      lon: double.parse(json['lon']),
      level: json['level'],
      createdAt: json['created_at'],
    );
  }
}

Future<List<User>> fetchData() async {
  final response = await http.get(
    Uri.parse('https://garudadriver.azurewebsites.net/api/driver/?format=json'),
  );

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    List<User> users = data.map((json) => User.fromJson(json)).toList();
    return users;
  } else {
    throw Exception('Failed to load data');
  }
}

Future<User> fetchUserById(int userId) async {
  final response = await http.get(
    Uri.parse('https://garudadriver.azurewebsites.net/api/driver/$userId/?format=json'),
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> data = jsonDecode(response.body);
    return User.fromJson(data);
  } else {
    throw Exception('Failed to load user');
  }
}
