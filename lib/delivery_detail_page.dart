// delivery_detail_page.dart
import 'package:flutter/material.dart';
import 'package:garudajayasakti/colors.dart';

class DeliveryDetailPage extends StatelessWidget {
  final int deliveryNumber;

  const DeliveryDetailPage({required this.deliveryNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delivery Detail #$deliveryNumber',style: TextStyle(color: Colors.white),),
        backgroundColor: AppColors.purplePrimary, // Latar belakang warna primary
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: _buildDeliveryDetail(context),
    );
  }

  Widget _buildDeliveryDetail(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nama Customer: John Doe',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            'Alamat: Jl. Contoh No. 123, Kota Contoh',
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 10.0),
          Text(
            'Narahubung: Jane Doe',
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 10.0),
          Text(
            'Nomor HP: 08123456789',
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 20.0),
          // Gambar dummy menggunakan network image
          Image.network(
            'https://placekitten.com/200/200', // Ganti dengan URL gambar dummy sesuai keinginan
            width: MediaQuery.of(context).size.width, // Lebar gambar mengikuti lebar layar
            height: 200.0,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 20.0),
          SizedBox(
            width: double.infinity, // Membuat tombol mengisi lebar maksimum
            child: ElevatedButton(
              onPressed: () {
                // Tambahkan logika untuk memulai pengiriman
                print('Pengiriman dimulai untuk Delivery #$deliveryNumber');
              },
              child: Text('Start'),

            ),
          ),
        ],
      ),
    );
  }
}
