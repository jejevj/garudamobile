// history_page.dart
import 'package:flutter/material.dart';
import 'package:garudajayasakti/colors.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: _buildHistoryList(context),
    );
  }

  Widget _buildHistoryList(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return _buildHistoryCard(context, index + 1);
      },
    );
  }

  Widget _buildHistoryCard(BuildContext context, int cardNumber) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5.0,
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: cardNumber.isOdd ? AppColors.purplePrimary : AppColors.whitePrimary,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Gambar di sebelah kiri kartu
            Container(
              width: 70.0,
              height: 70.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/history_image_$cardNumber.png'), // Ganti dengan path gambar sesuai keinginan
                ),
              ),
            ),
            SizedBox(width: 16.0), // Beri jarak antara gambar dan keterangan

            // Keterangan di sebelah kanan kartu
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'History #$cardNumber',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: cardNumber.isOdd ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Detail keterangan history #$cardNumber',
                    style: TextStyle(
                      color: cardNumber.isOdd ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
