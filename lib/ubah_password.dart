// ubah_password.dart
import 'package:flutter/material.dart';

class UbahPasswordPage extends StatefulWidget {
  @override
  _UbahPasswordPageState createState() => _UbahPasswordPageState();
}

class _UbahPasswordPageState extends State<UbahPasswordPage> {
  final TextEditingController _passwordLamaController = TextEditingController();
  final TextEditingController _passwordBaruController = TextEditingController();
  final TextEditingController _ulangPasswordBaruController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ubah Password'),
      ),
      body: _buildUbahPassword(context),
    );
  }

  Widget _buildUbahPassword(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Field Password Lama
          TextField(
            controller: _passwordLamaController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password Lama',
            ),
          ),
          SizedBox(height: 10.0),

          // Field Password Baru
          TextField(
            controller: _passwordBaruController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password Baru',
            ),
          ),
          SizedBox(height: 10.0),

          // Field Ulang Password Baru
          TextField(
            controller: _ulangPasswordBaruController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Ulang Password Baru',
            ),
          ),
          SizedBox(height: 20.0),

          // Tombol "Ubah Password"
          ElevatedButton(
            onPressed: () {
              // Validasi bahwa password baru dan ulang password baru sama
              if (_passwordBaruController.text == _ulangPasswordBaruController.text) {
                // Lakukan logika ubah password di sini
                Navigator.pushNamed(context, '/ubah_password_sukses');
                print('Password berhasil diubah');
              } else {
                // Tampilkan pesan kesalahan jika password baru dan ulang password baru tidak sama
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Password baru dan ulang password baru harus sama.'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text('Ubah Password'),
          ),
        ],
      ),
    );
  }
}
