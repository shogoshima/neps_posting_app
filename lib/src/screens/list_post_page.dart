import 'package:flutter/material.dart';
import 'package:neps_posting_app/main.dart';
import 'package:neps_posting_app/src/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ListPostPage extends StatelessWidget {
  const ListPostPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: ListView.builder(
          itemCount: appState.posts.length + 1,
          itemBuilder: (context, index) {
            if (index == appState.posts.length) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < appState.totalPostPages; i++)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: i + 1 == appState.currentPostPage
                                ? Colors.blue
                                : null,
                          ),
                          onPressed: i + 1 != appState.currentPostPage
                              ? () => appState.loadPosts(i + 1)
                              : null,
                          child: Text((i + 1).toString()),
                        ),
                      ),
                    )
                ],
              );
            }
            return PostCard(post: appState.posts[index]);
          },
        ),
      ),
    );
  }
}
