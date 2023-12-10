// ubah_password.dart
import 'package:flutter/material.dart';
import 'package:garudajayasakti/object/User.dart'; // Sesuaikan dengan path file User.dart

class UbahPasswordPage extends StatefulWidget {
  @override
  _UbahPasswordPageState createState() => _UbahPasswordPageState();
}

class _UbahPasswordPageState extends State<UbahPasswordPage> {
  final TextEditingController _passwordLamaController = TextEditingController();
  final TextEditingController _passwordBaruController = TextEditingController();
  final TextEditingController _ulangPasswordBaruController = TextEditingController();

  late User _user; // Variabel untuk menyimpan data pengguna

  @override
  Widget build(BuildContext context) {
    // Dapatkan nilai userId dari argumen yang dikirimkan
    final Map<String, dynamic>? args = ModalRoute
        .of(context)
        ?.settings
        .arguments as Map<String, dynamic>?;

    if (args == null || !args.containsKey('userId')) {
      // Handle jika userId tidak ditemukan dalam argumen
      return Scaffold(
        body: Center(
          child: Text('UserId not found.'),
        ),
      );
    }

    final int userId = args['userId'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Ubah Password'),
      ),
      body: FutureBuilder<User>(
        future: fetchUserById(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return
              Center(
                child: CircularProgressIndicator(),
              );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: Text('User not found.'),
            );
          }

          _user = snapshot.data!;

          return _buildUbahPassword(context, userId);
        },
      ),
    );
  }

  Widget _buildUbahPassword(BuildContext context, int userId) {
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
              // Validasi dan logika ubah password
              _cekPasswordLamaDanUbah(context, userId);
            },
            child: Text('Ubah Password'),
          ),
        ],
      ),
    );
  }

  void _cekPasswordLamaDanUbah(BuildContext context, int userId) async {
    // Memeriksa apakah password lama sesuai
    if (_user.password == _passwordLamaController.text) {
      // Validasi bahwa password baru dan ulang password baru sama
      if (_passwordBaruController.text == _ulangPasswordBaruController.text) {
        try {
          // Lakukan pembaruan password di sini
          await User.updatePassword(userId, _passwordBaruController.text);
          Navigator.pushNamed(
              context, '/ubah_password_sukses', arguments: {'userId': userId});
          print('Password berhasil diubah');
        } catch (error) {
          print('Error updating password: $error');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal mengubah password. Silakan coba lagi.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        // Tampilkan pesan kesalahan jika password baru dan ulang password baru tidak sama
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password baru dan ulang password baru harus sama.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      // Tampilkan pesan kesalahan jika password lama tidak sesuai
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password lama tidak sesuai.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
