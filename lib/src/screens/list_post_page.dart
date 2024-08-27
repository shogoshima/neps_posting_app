import 'package:flutter/material.dart';
import 'package:neps_posting_app/main.dart';
import 'package:neps_posting_app/src/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ListPostPage extends StatelessWidget {
  const ListPostPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var posts = appState.posts;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Feed'),
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return PostCard(post: posts[index]);
        },
      ),
    );
  }
}
