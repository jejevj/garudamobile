// login.dart
import 'package:flutter/material.dart';
import 'colors.dart';

class LoginScreen extends StatelessWidget {
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
      onPressed: () {
        Navigator.pushReplacementNamed(context, '/home');
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
