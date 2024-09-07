import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:neps_posting_app/src/models/models.dart';
import 'package:http/http.dart' as http;

class FetchApi {
  Future<PostApiResponse> fetchPosts(int page) async {
    final response = await http.get(Uri.parse(
        'https://minifeed.neps.academy/posts/?page=$page&reversed=false'));

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body);

      final postApiResponse = PostApiResponse.fromJson(jsonResponse);

      return postApiResponse;
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<void> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      throw Exception('Please enter username and password');
    }

    final response = await http.post(
      Uri.parse('https://minifeed.neps.academy/auth/login'),
      body: json.encode({'username': username, 'password': password}),
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json'
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      const storage = FlutterSecureStorage();
      await storage.write(key: 'token', value: jsonResponse['access_token']);
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<void> logout() async {
    const storage = FlutterSecureStorage();
    var token = await storage.read(key: 'token') ?? '';
    if (token.isEmpty) {
      throw Exception('Please login first!');
    }

    final response = await http.post(
      Uri.parse('https://minifeed.neps.academy/auth/logout'),
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      await storage.delete(key: 'token');
    } else {
      throw Exception('Failed to logout');
    }
  }

  Future<String> signup(User user) async {
    if (user.username.isEmpty || user.email.isEmpty || user.password!.isEmpty) {
      throw Exception('Please fill all the fields');
    }

    final response = await http.post(
      Uri.parse('https://minifeed.neps.academy/users/'),
      body: json.encode(user.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['msg'];
    } else {
      throw Exception('Failed to signup');
    }
  }

  Future<User> getAccountInfo() async {
    const storage = FlutterSecureStorage();
    var token = await storage.read(key: 'token') ?? '';
    if (token.isEmpty) {
      throw Exception('You are not logged In!');
    }

    final response = await http.get(
      Uri.parse('https://minifeed.neps.academy/users/me'),
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      User user = User.fromJson(jsonResponse);
      return user;
    } else {
      throw Exception('Failed to get account info');
    }
  }

  Future<void> createPost(String content) async {
    const storage = FlutterSecureStorage();
    String token = await storage.read(key: 'token') ?? '';
    if (token.isEmpty) {
      throw Exception('Please login first!');
    }

    final response = await http.post(
      Uri.parse('https://minifeed.neps.academy/posts/'),
      body: json.encode({'text': content}),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 201) {
      final jsonResponse = json.decode(response.body);
      print(jsonResponse['msg']);
    } else {
      throw Exception('Failed to create post');
    }
  }
}
