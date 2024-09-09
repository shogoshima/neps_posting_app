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
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 12, 39, 63),
              surface: const Color.fromARGB(255, 10, 10, 10),
              onSurface: const Color.fromARGB(255, 10, 10, 10),
              primary: const Color.fromARGB(255, 12, 39, 63),
              secondary: const Color.fromARGB(255, 255, 46, 52),
              tertiary: const Color.fromARGB(255, 235, 235, 235),
            ),
            textTheme: const TextTheme(
              titleMedium: TextStyle(
                  fontSize: 15.0, color: Color.fromARGB(255, 0, 0, 0)),
              bodyLarge: TextStyle(fontSize: 20.0, color: Colors.black),
              bodyMedium: TextStyle(fontSize: 17.0, color: Colors.black),
              bodySmall: TextStyle(
                  fontSize: 15.0, color: Color.fromARGB(255, 0, 0, 0)),
            )),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  // Define your state variables and methods here
  FetchApi api = FetchApi();

  bool loggedIn = false;
  User loggedInUser = User(
    username: '',
    email: '',
    birthdate: DateTime.now(),
  );

  Future<void> login(String username, String password) async {
    try {
      await api.login(username, password);
      User user = await api.getAccountInfo();
      loggedInUser = user;
      loggedIn = true;
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> signup(User user) async {
    try {
      await api.signup(user);
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> logout() async {
    try {
      loggedIn = false;
      await api.logout();
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  int currentPostPage = 1;
  int totalPostPages = 0;
  List<Post> posts = [];

  void addPosts(List<Post> newPosts) {
    posts = newPosts;
    notifyListeners();
  }

  Future<void> loadPosts(int page) async {
    currentPostPage = page;
    PostApiResponse response = await api.fetchPosts(page);
    addPosts(response.posts);
    notifyListeners();
  }
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
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
                icon: Image.asset(
                  'assets/logo_simplified.png',
                  width: 50.0,
                  height: 50.0,
                ),
                iconSize: 10.0,
                onPressed: () {}),
            const Text('Mini Feed'),
          ],
        ),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 30,
          fontWeight: FontWeight.normal,
        ),
        backgroundColor: Theme.of(context).colorScheme.onSurface,
        toolbarHeight: 100,
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Theme.of(context).colorScheme.secondary,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.book_outlined, color: Colors.white),
            icon: Icon(Icons.book),
            label: 'Feed',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.post_add_outlined, color: Colors.white),
            icon: Icon(Icons.post_add),
            label: 'Create Post',
          ),
          NavigationDestination(
            selectedIcon:
                Icon(Icons.account_circle_outlined, color: Colors.white),
            icon: Icon(Icons.account_circle),
            label: 'Account',
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.onSurface,
            Theme.of(context).colorScheme.primary,
          ],
        )),
        child: <Widget>[
          FutureBuilder(
            future: appState.api.fetchPosts(appState.currentPostPage),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                appState.posts = snapshot.data?.posts ?? [];
                appState.totalPostPages = snapshot.data?.pages ?? 0;

                return const ListPostPage();
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              }
            },
          ),
          const CreatePostPage(),
          const AccountPage(),
        ][currentPageIndex],
      ),
    );
  }
}
