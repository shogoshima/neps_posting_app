import 'package:neps_posting_app/src/models/author.dart';

class Post {
  final Author author;
  final int id;
  final String text;
  DateTime? created;

  Post({
    required this.id,
    required this.author,
    required this.text,
    this.created,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      author: Author.fromJson(json['author']),
      text: json['text'],
      created: json['created'] != null
          ? DateTime.parse(json['created'])
          : DateTime.now(),
    );
  }
}
