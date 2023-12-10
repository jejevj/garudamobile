import 'package:flutter/material.dart';
import 'package:garudajayasakti/object/User.dart';
import 'colors.dart'; // Sesuaikan dengan jalur file User.dart
import 'package:collection/collection.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: AppColors.purplePrimary,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  'https://demos.pixinvent.com/vuexy-html-admin-template/assets/img/illustrations/auth-login-illustration-light.png',
                  height: 120.0,
                ),
                SizedBox(height: 20),
                Text(
                  'Login Screen',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                  ),
                ),
                SizedBox(height: 20),
                _buildUsernameField(),
                SizedBox(height: 10),
                _buildPasswordField(),
                SizedBox(height: 20),
                _buildLoginButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUsernameField() {
    return TextFormField(
      controller: _usernameController,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[300],
        labelText: 'Username',
        labelStyle: TextStyle(color: Colors.black),
        enabledBorder: _buildInputBorder(),
        focusedBorder: _buildInputBorder(),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[300],
        labelText: 'Password',
        labelStyle: TextStyle(color: Colors.black),
        enabledBorder: _buildInputBorder(),
        focusedBorder: _buildInputBorder(),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        List<User> users = await fetchData();
        String enteredUsername = _usernameController.text;
        String enteredPassword = _passwordController.text;

        User? authenticatedUser = users.firstWhereOrNull((user) =>
        user.username == enteredUsername && user.password == enteredPassword);

        if (authenticatedUser != null) {
          // Save user.id for future use
          int userId = authenticatedUser.id;

          // Navigate to the next page and pass the user id
          Navigator.pushReplacementNamed(
            context,
            '/home',
            arguments: {'userId': userId},
          );
        } else {
          // Show an error message or handle the login failure accordingly
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Login Failed'),
                content: Text('Invalid username or password.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      },
      child: Text('Login'),
      style: ElevatedButton.styleFrom(
        primary: Colors.grey[300],
        onPrimary: Colors.black,
        elevation: 5,
      ),
    );
  }

  InputBorder _buildInputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
      borderRadius: BorderRadius.circular(10),
    );
  }
}
