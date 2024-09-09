import 'package:flutter/material.dart';
import 'package:neps_posting_app/main.dart';
import 'package:neps_posting_app/src/widgets/widgets.dart';
import 'package:provider/provider.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handlePostCreation(MyAppState appState) async {
    try {
      await appState.api.createPost(_controller.text);
      if (!context.mounted) return;
      _showDialog('Thanks!', 'You posted "${_controller.text}"!');
    } catch (e) {
      if (!context.mounted) return;
      _showDialog('Error', 'Failed to post: \n$e');
    }
  }

  Future<void> _showDialog(String title, String content) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentTextStyle: Theme.of(context).textTheme.bodyLarge,
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPostInput() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: TextField(
        maxLines: 6,
        controller: _controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          hintText: 'Enter your post here',
          hintStyle: Theme.of(context).textTheme.bodyMedium,
          filled: true,
          fillColor: Theme.of(context).colorScheme.tertiary,
        ),
      ),
    );
  }

  Widget _buildPostButton(MyAppState appState) {
    return CustomElevatedButton(
      onPressed: () => _handlePostCreation(appState),
      text: 'Post',
    );
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildPostInput(),
            _buildPostButton(appState),
          ],
        ),
      ),
    );
  }
}
