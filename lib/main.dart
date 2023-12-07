// main.dart
import 'package:flutter/material.dart';
import 'homepage.dart';
import 'login.dart';
import 'splash_screen.dart';
import 'colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Flutter App',
      theme: ThemeData(
        primaryColor: AppColors.purplePrimary,
      ),
      initialRoute: '/splash', // Atur rute awal ke splash screen
      routes: {
        '/splash': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => MainScreen(), // Gunakan MainScreen sebagai halaman utama
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
