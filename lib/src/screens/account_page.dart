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
  // State variables
  bool _isSignUp = false;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late TextEditingController _emailController;
  late TextEditingController _dobController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _initializeControllers() {
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _emailController = TextEditingController();
    _dobController = TextEditingController();
  }

  void _disposeControllers() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailController.dispose();
    _dobController.dispose();
  }

  // Toggle between login and sign-up states
  void _toggleSignUp() {
    setState(() {
      _isSignUp = !_isSignUp;
    });
  }

  // Date picker for sign-up
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _dobController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  // Build the UI for login/sign-up
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildUsernameField(context),
            const SizedBox(height: 15),
            _buildPasswordField(context),
            if (_isSignUp) _buildSignUpFields(context),
            const SizedBox(height: 15),
            _buildToggleSignUpText(),
            const SizedBox(height: 20),
            _buildActionButton(appState),
          ],
        ),
      ),
    );
  }

  // Username field
  TextField _buildUsernameField(BuildContext context) {
    return TextField(
      controller: _usernameController,
      decoration: _buildInputDecoration(context, 'Username'),
    );
  }

  // Password field
  TextField _buildPasswordField(BuildContext context) {
    return TextField(
      controller: _passwordController,
      obscureText: true,
      decoration: _buildInputDecoration(context, 'Password'),
    );
  }

  // Input decoration helper
  InputDecoration _buildInputDecoration(BuildContext context, String label) {
    return InputDecoration(
      border: const UnderlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      labelText: label,
      labelStyle: Theme.of(context).textTheme.bodyMedium,
      filled: true,
      fillColor: Theme.of(context).colorScheme.tertiary,
    );
  }

  // Additional sign-up fields
  Column _buildSignUpFields(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15),
        _buildConfirmPasswordField(context),
        const SizedBox(height: 15),
        _buildEmailField(context),
        const SizedBox(height: 15),
        _buildDOBField(context),
      ],
    );
  }

  // Confirm password field for sign-up
  TextField _buildConfirmPasswordField(BuildContext context) {
    return TextField(
      controller: _confirmPasswordController,
      obscureText: true,
      decoration: _buildInputDecoration(context, 'Confirm Password'),
    );
  }

  // Email field for sign-up
  TextField _buildEmailField(BuildContext context) {
    return TextField(
      controller: _emailController,
      decoration: _buildInputDecoration(context, 'Email'),
    );
  }

  // Date of birth field with a tap event to open the date picker
  TextFormField _buildDOBField(BuildContext context) {
    return TextFormField(
      controller: _dobController,
      decoration: _buildInputDecoration(context, 'Date of Birth'),
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        await _selectDate(context);
      },
    );
  }

  // Toggle between sign-up and login text
  Row _buildToggleSignUpText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _isSignUp ? "Already have an account? " : "Don't have an account? ",
          style: const TextStyle(color: Colors.white),
        ),
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
    );
  }

  // Button for login or sign-up
  CustomElevatedButton _buildActionButton(MyAppState appState) {
    return CustomElevatedButton(
      onPressed: () async {
        _isSignUp
            ? await _handleSignUp(appState)
            : await _handleLogin(appState);
      },
      text: _isSignUp ? 'Sign Up' : 'Login',
    );
  }

  // Handle sign-up action
  Future<void> _handleSignUp(MyAppState appState) async {
    try {
      User newUser = User(
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        birthdate: DateTime.parse(_dobController.text),
        password: _passwordController.text,
        createdAt: DateTime.now(),
      );
      await appState.signup(newUser);
      _toggleSignUp();
    } catch (e) {
      _showErrorSnackBar(context, '$e');
    }
  }

  // Handle login action
  Future<void> _handleLogin(MyAppState appState) async {
    try {
      await appState.login(
        _usernameController.text.trim(),
        _passwordController.text,
      );
    } catch (e) {
      _showErrorSnackBar(context, '$e');
    }
  }

  // Display error message in SnackBar
  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _AccountInfo extends StatelessWidget {
  const _AccountInfo();

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var user = appState.loggedInUser;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildUserInfo(user),
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

  // User information display
  Column _buildUserInfo(User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${user.username} (ID: ${user.id})',
          style: const TextStyle(fontSize: 30),
        ),
        const SizedBox(height: 30),
        _buildUserDetails(user),
      ],
    );
  }

  // Display detailed user information
  RichText _buildUserDetails(User user) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 20),
        children: [
          _buildUserDetail('Email: ', user.email),
          _buildUserDetail('Date of Birth: ',
              DateFormat('dd/MM/yyyy').format(user.birthdate)),
          _buildUserDetail('Created At: ',
              DateFormat('dd/MM/yyyy – kk:mm').format(user.createdAt)),
          _buildUserDetail('Role: ', user.role?.name ?? ''),
        ],
      ),
    );
  }

  // Helper to format user details
  TextSpan _buildUserDetail(String label, String? value) {
    return TextSpan(
      children: [
        TextSpan(
            text: label, style: const TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: '$value\n'),
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
      backgroundColor: Colors.transparent,
      body: appState.loggedIn ? const _AccountInfo() : const _LoginSection(),
    );
  }
}
