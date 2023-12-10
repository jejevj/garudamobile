import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
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
    _checkPermissionAndNavigate();
  }

  Future<void> _checkPermissionAndNavigate() async {
    // Memeriksa izin lokasi
    PermissionStatus status = await Permission.location.status;

    if (status == PermissionStatus.granted) {
      // Izin sudah diberikan, langsung pindah ke halaman login
      _navigateToLogin();
    } else {
      // Meminta izin lokasi
      PermissionStatus permissionStatus = await Permission.location.request();

      // Pindah ke halaman login setelah mendapatkan atau menolak izin
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
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
