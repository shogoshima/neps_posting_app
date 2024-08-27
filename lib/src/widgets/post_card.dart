import 'package:flutter/material.dart';
import 'package:neps_posting_app/src/models/models.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text.rich(TextSpan(children: <TextSpan>[
              TextSpan(
                text: post.author.username,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(
                  text: ' posted:', style: TextStyle(fontSize: 13.0)),
            ])),
            subtitle: Text(style: const TextStyle(fontSize: 20.0), post.text),
          ),
          ListTile(
            title: Text(post.created.toString()),
          ),
        ],
      ),
    );
  }
}
