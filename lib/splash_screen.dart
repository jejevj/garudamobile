import 'dart:async';
import 'package:flutter/material.dart';
import 'login.dart';
import 'colors.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Tambahkan delay, contoh: Duration(seconds: 2)
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: AppColors.purplePrimary,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Tambahkan widget Image untuk menampilkan gambar dari URL
              Image.network(
                'https://demos.pixinvent.com/vuexy-html-admin-template/assets/img/illustrations/auth-login-illustration-light.png',
                height: 200, // Sesuaikan tinggi gambar sesuai kebutuhan
              ),
              SizedBox(height: 16), // Beri sedikit jarak antara gambar dan teks
              Text(
                'Garuda Jayasakti\n Monitoring Driver',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
