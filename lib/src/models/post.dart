import 'package:neps_posting_app/src/models/author.dart';

class Post {
  final Author author;
  final DateTime created = DateTime.now();
  final int id;
  final String text;

  Post(
      {required this.id,
      required this.author,
      required this.text,
      DateTime? created});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      author: Author.fromJson(json['author']),
      text: json['text'],
      created: json['created'] != null
          ? DateTime.parse(json['created'])
          : null, // Parse date or use null,
    );
  }
}
