// welcome_page.dart
import 'package:flutter/material.dart';
import 'package:garudajayasakti/object/User.dart';

class Home extends StatelessWidget {
  final int userId;

  // Konstruktor menerima ID pengguna
  Home({required this.userId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: fetchUserById(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          User user = snapshot.data!;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Garuda Jayasakti Monitoring',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
                Image.network(
                  'https://demos.pixinvent.com/vuexy-html-admin-template/assets/img/illustrations/auth-login-illustration-light.png',
                  width: 150.0,
                  height: 150.0,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 20.0),
                Text(
                  'Selamat Datang',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  '${user.username.toUpperCase()}', // Menampilkan username dan ID pengguna
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    // Pindah ke halaman profil dengan membawa ID pengguna
                    Navigator.pushNamed(context, '/profile', arguments: {'userId': userId});
                  },
                  child: Text('Lihat Profil'),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
