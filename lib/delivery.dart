// delivery_page.dart
import 'package:flutter/material.dart';
import 'package:garudajayasakti/colors.dart';
import 'delivery_detail_page.dart';

class DeliveryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delivery'),
      ),
      body: _buildDeliveryList(context),
    );
  }

  Widget _buildDeliveryList(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return _buildDeliveryCard(context, index + 1);
      },
    );
  }

  Widget _buildDeliveryCard(BuildContext context, int cardNumber) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5.0,
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: AppColors.purplePrimary, // Ganti dengan warna sesuai keinginan
      child: ListTile(
        title: Text(
          'Delivery #$cardNumber',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          'Alamat pengiriman #$cardNumber',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        onTap: () {
          // Arahkan ke halaman DeliveryDetail saat item diklik
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DeliveryDetailPage(deliveryNumber: cardNumber),
            ),
          );
        },
      ),
    );
  }
}
