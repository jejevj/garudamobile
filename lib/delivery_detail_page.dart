import 'package:flutter/material.dart';
import 'package:garudajayasakti/colors.dart';
import 'package:garudajayasakti/delivery_detail_map.dart';
import 'package:garudajayasakti/object/Delivery.dart';

class DeliveryDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Mengambil nilai dari arguments
    final Map<String, dynamic> args =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    // Menyimpan data dummy
    final String deliveryNumber = args['deliveryNumber'] ?? 'No. Delivery';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Delivery Detail #$deliveryNumber',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.purplePrimary,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildDeliveryDetail(context, deliveryNumber),
      ),
    );
  }

  Widget _buildDeliveryDetail(BuildContext context, String deliveryNumber) {
    return FutureBuilder<Delivery>(
      future: fetchDataDeliveryById(deliveryNumber),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData) {
          return Center(
            child: Text('No data available.'),
          );
        }

        // Data telah diambil, kita dapat mengaksesnya dari snapshot.data
        final Delivery delivery = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('No. Delivery', delivery.noDelivery),
            _buildDetailRow('Nama Customer', delivery.customerName),
            _buildDetailRow('Narahubung', delivery.cp),
            _buildDetailRow('Alamat', delivery.address),
            SizedBox(height: 20.0),
            // Lanjutkan menampilkan data lainnya sesuai kebutuhan

            // Gambar dummy menggunakan network image
            Image.network(
              delivery.photo ?? 'https://placekitten.com/200/200',
              width: double.infinity,
              height: 200.0,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20.0),
            if (delivery.status != 'Delivered') // Tambahkan kondisi untuk menampilkan tombol hanya jika status bukan "Delivered"
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    print('Pengiriman dimulai untuk Delivery #${delivery.noDelivery}');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DeliveryMap(),
                        settings: RouteSettings(
                          arguments: {'noDelivery': delivery.noDelivery},
                        ),
                      ),
                    );
                  },
                  child: Text('Start'),
                ),
              ),
            if (delivery.status == 'Delivered') // Tampilkan tulisan jika status "Delivered"
              Center(
                child:Text(
                  'Pengiriman sudah selesai',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              )
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 14.0),
          ),
        ],
      ),
    );
  }
}
