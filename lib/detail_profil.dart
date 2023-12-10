// detail_profil.dart
import 'package:flutter/material.dart';
import 'package:garudajayasakti/object/User.dart';

class DetailProfilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Mendapatkan argument dari ModalRoute
    final Map<String, dynamic>? args =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    // Mengambil ID pengguna dari argument
    final int userId = args?['userId'] ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Profil'),
      ),
      body: _buildDetailProfil(context, userId),
    );
  }

  Widget _buildDetailProfil(BuildContext context, int userId) {
    return FutureBuilder<User>(
      future: fetchUserById(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child:CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          User user = snapshot.data!;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Foto Profil
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    user.photo ?? 'https://example.com/default-photo.jpg',
                  ),
                  radius: 50.0,
                ),
                SizedBox(height: 20.0),

                // Tombol "Change Password"
                ElevatedButton(
                  onPressed: () {
                    // Tambahkan logika untuk pindah ke halaman ubah password di sini
                    // Misalnya, menggunakan Navigator
                    Navigator.pushNamed(context, '/ubah_password', arguments: {'userId': userId});
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
      },
    );
  }
}
