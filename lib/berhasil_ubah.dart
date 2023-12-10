import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'colors.dart';
class UbahPasswordSuksesPage extends StatefulWidget {
  @override
  _UbahPasswordSuksesPageState createState() => _UbahPasswordSuksesPageState();
}

class _UbahPasswordSuksesPageState extends State<UbahPasswordSuksesPage> {
  late ConfettiController _controllerCenter;

  @override
  void initState() {
    super.initState();
    _controllerCenter = ConfettiController(duration: const Duration(seconds: 10));
    _controllerCenter.play();
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }

  Path drawStar(Size size) {
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: ConfettiWidget(
                confettiController: _controllerCenter,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: true,
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple,
                ],
                createParticlePath: drawStar,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 100.0,
                    color: AppColors.purplePrimary, // Sesuaikan dengan warna proyek Anda
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Ubah Password Berhasil',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.purplePrimary, // Sesuaikan dengan warna proyek Anda
                    ),
                  ),
                ],
              ),
            ),
            // ubah_password_sukses.dart
            // ubah_password_sukses.dart
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(bottom: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Mendapatkan argumen yang dikirimkan
                    final Map<String, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

                    if (args != null && args.containsKey('userId')) {
                      // Menggunakan Navigator untuk kembali ke halaman home dan mengirimkan ID pengguna
                      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false, arguments: {'userId': args['userId']});
                    } else {
                      // Handle jika ID pengguna tidak ditemukan
                      print('User ID not found.');
                    }
                  },
                  child: Text('Kembali ke Home', style: TextStyle(color: AppColors.whitePrimary)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.purplePrimary,
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
