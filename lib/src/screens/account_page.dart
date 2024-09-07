import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neps_posting_app/src/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:neps_posting_app/main.dart';

import '../models/models.dart';

class _LoginSection extends StatefulWidget {
  const _LoginSection();

  @override
  _LoginSectionState createState() => _LoginSectionState();
}

class _LoginSectionState extends State<_LoginSection> {
  bool _isSignUp = false; // State to track if the user wants to sign up
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late TextEditingController _emailController;
  late TextEditingController _dobController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _emailController = TextEditingController();
    _dobController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  void _toggleSignUp() {
    setState(() {
      _isSignUp = !_isSignUp;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Username',
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Password',
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                if (_isSignUp) ...[
                  const SizedBox(height: 15),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Confirm Password',
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Email',
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _dobController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Date of Birth',
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.secondary,
                    ),
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      await _selectDate(context);
                    },
                  ),
                ],
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          style: const TextStyle(color: Colors.white),
                          _isSignUp
                              ? "Already have an account? "
                              : "Don't have an account? "),
                      GestureDetector(
                        onTap: _toggleSignUp,
                        child: Text(
                          _isSignUp ? "Login here!" : "Sign up here!",
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          CustomElevatedButton(
            onPressed: () async {
              if (_isSignUp) {
                try {
                  User user = User(
                    username: _usernameController.text.trim(),
                    email: _emailController.text.trim(),
                    birthdate: DateTime.parse(_dobController.text),
                    password: _passwordController.text,
                  );
                  await appState.signup(user); // Add sign-up logic here
                  _toggleSignUp();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$e'),
                    ),
                  );
                }
              } else {
                try {
                  await appState.login(
                    _usernameController.text.trim(),
                    _passwordController.text,
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$e'),
                    ),
                  );
                }
              }
            },
            text: _isSignUp ? 'Sign Up' : 'Login',
          ),
        ],
      ),
    );
  }
}

class _AccountInfo extends StatelessWidget {
  const _AccountInfo();

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var user = appState.loggedInUser;

    var username = user.username;
    var userId = user.id;
    var email = user.email;
    var dob = user.birthdate;
    var created = user.createdAt;
    var role = user.role?.name;

    String formatDate(DateTime? date) {
      if (date == null) return '';
      return DateFormat('dd/MM/yyyy – kk:mm').format(date);
    }

    String formatDateNoHour(DateTime? date) {
      if (date == null) return '';
      return DateFormat('dd/MM/yyyy').format(date);
    }

    const TextStyle bold = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // Center horizontally
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  style: const TextStyle(fontSize: 30),
                  '$username (ID: $userId)',
                ),
                const SizedBox(height: 30),
                Text.rich(
                  style: const TextStyle(fontSize: 20),
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Email: ',
                        style: bold,
                      ),
                      TextSpan(text: '$email\n'),
                      const TextSpan(
                        text: 'Date of Birth: ',
                        style: bold,
                      ),
                      TextSpan(text: '${formatDateNoHour(dob)}\n'),
                      const TextSpan(
                        text: 'Created At: ',
                        style: bold,
                      ),
                      TextSpan(text: '${formatDate(created)}\n'),
                      const TextSpan(
                        text: 'Role: ',
                        style: bold,
                      ),
                      TextSpan(text: '$role\n'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                CustomElevatedButton(
                  text: 'Logout',
                  onPressed: appState.logout,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: appState.loggedIn ? const _AccountInfo() : const _LoginSection(),
    );
  }
}
