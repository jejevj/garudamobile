// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:garudajayasakti/berhasil_ubah.dart';
import 'package:garudajayasakti/data.dart';
import 'package:garudajayasakti/delivery_detail_page.dart';
import 'package:garudajayasakti/detail_profil.dart';
import 'package:garudajayasakti/object/LocationUtil.dart';
import 'package:garudajayasakti/ubah_password.dart';
import 'homepage.dart';
import 'login.dart';
import 'splash_screen.dart';
import 'colors.dart';
import 'dart:async';
import 'package:background_location/background_location.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> with WidgetsBindingObserver{
  String latitude = 'waiting...';
  String longitude = 'waiting...';
  String altitude = 'waiting...';
  String accuracy = 'waiting...';
  String bearing = 'waiting...';
  String speed = 'waiting...';
  String time = 'waiting...';
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);

  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Aplikasi kembali aktif
      LocationUtil.startBackgroundLocationUpdates(LocationUtil.userid);
    } else if (state == AppLifecycleState.paused) {
      // Aplikasi masuk latar belakang
      LocationUtil.startBackgroundLocationUpdates(LocationUtil.userid);
    }
  }
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Garuda Monitoring',

      debugShowCheckedModeBanner: false, // Tambahkan baris ini
      theme: ThemeData(
        primaryColor: AppColors.purplePrimary,
      ),
      initialRoute: '/splash', // Atur rute awal ke splash screen


      routes: {
        '/splash': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => MainScreen(), // Gunakan MainScreen sebagai halaman utama
        '/profile': (context) => DetailProfilPage(),
        '/ubah_password': (context) => UbahPasswordPage(),
        '/ubah_password_sukses': (context) => UbahPasswordSuksesPage(),
        '/data_tes': (context) => DataTes(),
        '/delivery_detail_page': (context) => DeliveryDetailPage(),
      },

    );
  }
  Widget locationData(String data) {
    return Text(
      data,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      textAlign: TextAlign.center,
    );
  }

//   FUNGSI UNTUK MENGAMBIL LOKASI SECARA LANGSUNG
  void getCurrentLocation() {
    BackgroundLocation().getCurrentLocation().then((location) {
      print('Latitude: ${location.latitude}');
      print('Longitude: ${location.longitude}');
      print('Altitude: ${location.altitude}');
      print('Accuracy: ${location.accuracy}');
      print('Bearing: ${location.bearing}');
      print('Speed: ${location.speed}');
      print('Time: ${location.time}');

      // Assign values to the state variables
      setState(() {
        latitude = location.latitude.toString();
        longitude = location.longitude.toString();
        altitude = location.altitude.toString();
        accuracy = location.accuracy.toString();
        bearing = location.bearing.toString();
        speed = location.speed.toString();
        time = location.time.toString();
      });
    });
  }
}

class MainScreen extends StatefulWidget {

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
  }
  int _currentIndex = 0;


  final List<Widget> _pages = [
    HomePage(),
    Container(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: _buildMiddleButton(),
          label: 'Add',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.other_houses),
          label: 'Other',
        ),
      ],
    );
  }

  Widget _buildMiddleButton() {
    return Container(
      width: 56.0,
      height: 56.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.purplePrimary,
      ),
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }
}
