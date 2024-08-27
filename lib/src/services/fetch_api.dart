import 'dart:convert';

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
}
