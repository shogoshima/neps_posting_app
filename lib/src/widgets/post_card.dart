import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
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
      color: Theme.of(context).colorScheme.tertiary,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text.rich(
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
            const SizedBox(height: 10),

            // Let Markdown expand to fit its content
            MarkdownBody(
              data: post.text,
              selectable: true,
              styleSheet: MarkdownStyleSheet(
                code: const TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(height: 10),
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
