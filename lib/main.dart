import 'package:flutter/material.dart';
import 'package:neps_posting_app/src/models/models.dart';
import 'package:provider/provider.dart';
import 'package:neps_posting_app/src/screens/screens.dart';
import 'package:neps_posting_app/src/services/services.dart';

enum PopupItem { account, settings }

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Neps App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  // Define your state variables and methods here
  bool loggedIn = false;
  void login() {
    loggedIn = true;
    notifyListeners();
  }

  FetchApi api = FetchApi();
  var posts = <Post>[];
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 0;
  PopupItem? selectedPopupItem;

  final FocusNode _buttonFocusNode = FocusNode(debugLabel: 'Menu Button');
  @override
  void dispose() {
    _buttonFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    FetchApi api = FetchApi();
    return Scaffold(
      appBar: AppBar(
          title: const Text('Neps Posting App'),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.normal,
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          toolbarHeight: 80,
          actions: <Widget>[
            MenuAnchor(
              childFocusNode: _buttonFocusNode,
              menuChildren: <Widget>[
                MenuItemButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AccountPage()),
                    );
                  },
                  child: const Text('Account'),
                ),
                MenuItemButton(
                  onPressed: () {},
                  child: const Text('Settings'),
                ),
                MenuItemButton(
                  onPressed: () {},
                  child: const Text('Send Feedback'),
                ),
              ],
              builder: (_, MenuController controller, Widget? child) {
                return IconButton(
                  color: Theme.of(context).colorScheme.onPrimary,
                  iconSize: 30,
                  focusNode: _buttonFocusNode,
                  onPressed: () {
                    if (controller.isOpen) {
                      controller.close();
                    } else {
                      controller.open();
                    }
                  },
                  icon: const Icon(Icons.more_vert),
                );
              },
            ),
          ]),
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.book_outlined),
            icon: Icon(Icons.book),
            label: 'Feed',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.post_add_outlined),
            icon: Icon(Icons.post_add),
            label: 'Create Post',
          ),
        ],
      ),
      body: <Widget>[
        FutureBuilder(
          future: api.fetchPosts(2),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              appState.posts = snapshot.data?.posts ?? [];

              return const ListPostPage();
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        const CreatePostPage(),
      ][currentPageIndex],
    );
  }
}
