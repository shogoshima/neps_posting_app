import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neps_posting_app/src/models/models.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  String _formatDate(DateTime? date) {
    if (date == null) {
      return '';
    }
    return DateFormat('dd-MM-yyyy – kk:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text.rich(
          TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: post.author.username,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(
                text: ' posted:',
                style: TextStyle(fontSize: 13.0),
              ),
            ],
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                post.text,
                style: const TextStyle(fontSize: 20.0),
              ),
            ),
            Text(
              _formatDate(post.created),
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
