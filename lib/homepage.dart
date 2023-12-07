// homepage.dart
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:garudajayasakti/colors.dart';
import 'package:garudajayasakti/delivery.dart';
import 'package:garudajayasakti/history.dart';
import 'package:garudajayasakti/home.dart';
import 'nextpage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Garuda Monitor',style: TextStyle(color: Colors.white),),
        backgroundColor: AppColors.purplePrimary, // Warna background AppBar
        actions: [
          // Tombol logout di sebelah kanan AppBar
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              // Tambahkan logika logout di sini
              // Misalnya, kembali ke halaman login
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        height: 60.0,
        items: <Widget>[
          Icon(Icons.home, size: 35, color: Colors.white),
          Icon(Icons.local_shipping, size: 35, color: Colors.white),
          Icon(Icons.history_edu, size: 35, color: Colors.white),
        ],
        color: AppColors.purplePrimary,
        buttonBackgroundColor: AppColors.purplePrimary,
        backgroundColor: Colors.white,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),

    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return
            Home();
      case 1:
      // Tambahkan widget untuk tampilan index 1 di sini
        return DeliveryPage();
      case 2:
      // Tambahkan widget untuk tampilan index 2 di sini
        return HistoryPage();
      default:
        return Home();
    }
  }
}
