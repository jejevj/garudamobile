import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:garudajayasakti/homepage.dart';
import 'colors.dart';

class BerhasilKirimBukti extends StatefulWidget {
  @override
  _BerhasilKirimBuktiState createState() => _BerhasilKirimBuktiState();
}

class _BerhasilKirimBuktiState extends State<BerhasilKirimBukti> {
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
    final Map<String, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;


    final int userId = args?['userId'];

    return SafeArea(
      child: Scaffold(
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
                    color: AppColors.purplePrimary,
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Berhasil Mengirim Bukti',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.purplePrimary,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(bottom: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Ganti route dan argumen sesuai kebutuhan
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                        settings: RouteSettings(
                          arguments: {'userId': userId},
                        ),
                      ),
                    );


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
