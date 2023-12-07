// welcome_page.dart
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Teks di atas gambar
          Text(
            'Garuda Jayasakti Monitoring',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.0), // Beri jarak antara teks dan gambar

          // Gambar menggunakan URL yang telah Anda berikan
          Image.network(
            'https://demos.pixinvent.com/vuexy-html-admin-template/assets/img/illustrations/auth-login-illustration-light.png',
            width: 150.0,
            height: 150.0,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 20.0),

          // Teks selamat datang
          Text(
            'Selamat Datang',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.0),

          // Teks nama
          Text(
            'John Doe',
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
          SizedBox(height: 20.0),

          // Tombol "Lihat Profil"
          ElevatedButton(
            onPressed: () {
              // Tambahkan logika untuk pindah ke halaman profil di sini
              // Misalnya, menggunakan Navigator
              Navigator.pushNamed(context, '/profile');
            },
            child: Text('Lihat Profil'),
          ),
        ],
      ),
    );
  }
}
