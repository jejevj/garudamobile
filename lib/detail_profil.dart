// detail_profil.dart
import 'package:flutter/material.dart';

class DetailProfilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Profil'),
      ),
      body: _buildDetailProfil(context),
    );
  }

  Widget _buildDetailProfil(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Foto Profil
          CircleAvatar(
            backgroundImage: NetworkImage(
              'https://example.com/path/to/photo.jpg', // Ganti dengan URL foto profil Anda
            ),
            radius: 50.0,
          ),
          SizedBox(height: 20.0),

          // Tombol "Change Password"
          ElevatedButton(
            onPressed: () {
              // Tambahkan logika untuk pindah ke halaman ubah password di sini
              // Misalnya, menggunakan Navigator
              Navigator.pushNamed(context, '/ubah_password');
            },
            child: Text('Change Password'),
          ),
          SizedBox(height: 10.0),

          // Tombol "Logout"
          ElevatedButton(
            onPressed: () {
              // Tambahkan logika untuk logout di sini
              // Misalnya, kembalikan ke halaman login
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
