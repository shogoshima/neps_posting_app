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
                seedColor: const Color.fromARGB(255, 0, 0, 0),
                primary: const Color.fromARGB(255, 10, 9, 56),
                secondary: const Color.fromARGB(255, 255, 255, 255)),
            textTheme: const TextTheme(
              titleMedium: TextStyle(fontSize: 10.0, color: Colors.white),
              bodyMedium: TextStyle(fontSize: 15.0, color: Colors.white),
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
  void login(String username, String password) async {
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

  void signup(User user) async {
    try {
      await api.signup(user);
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  void logout() async {
    try {
      await api.logout();
      loggedIn = false;
    } catch (e) {
      rethrow;
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

  void loadPosts(int page) async {
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
      appBar: AppBar(
        title: const Text('Mini Feed'),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 30,
          fontWeight: FontWeight.normal,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        toolbarHeight: 100,
      ),
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
          NavigationDestination(
            selectedIcon: Icon(Icons.account_circle_outlined),
            icon: Icon(Icons.account_circle),
            label: 'Account',
          )
        ],
      ),
      body: <Widget>[
        FutureBuilder(
          future: appState.api.fetchPosts(appState.currentPostPage),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              appState.posts = snapshot.data?.posts ?? [];
              appState.totalPostPages = snapshot.data?.pages ?? 0;

              return const ListPostPage();
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        const CreatePostPage(),
        const AccountPage(),
      ][currentPageIndex],
    );
  }
}
