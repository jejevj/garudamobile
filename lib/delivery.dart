import 'package:flutter/material.dart';
import 'package:garudajayasakti/colors.dart';
import 'package:garudajayasakti/object/User.dart';
import 'package:garudajayasakti/object/delivery.dart'; // Sesuaikan path sesuai dengan struktur proyek Anda
import 'delivery_detail_page.dart';

class DeliveryPage extends StatefulWidget {
  final int userId;

  // Konstruktor menerima ID pengguna
  DeliveryPage({required this.userId});
  @override
  _DeliveryPageState createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {
  late Future<List<Delivery>> futureDelivery;
  late String driverUsername = "";

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    futureDelivery = fetchDataDelivery();
  }

  Future<void> _fetchUserData() async {
    try {
      final User user = await fetchUserById(widget.userId);
      setState(() {
        driverUsername = user.username;
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

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
    return FutureBuilder<List<Delivery>>(
      future: futureDelivery,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text('No delivery data available.'),
          );
        }

        // Filter data berdasarkan driverName
        final filteredDeliveries =
        snapshot.data!.where((delivery) => delivery.driverName == driverUsername).toList();

        return ListView.builder(
          itemCount: filteredDeliveries.length,
          itemBuilder: (context, index) {
            return _buildDeliveryCard(context, filteredDeliveries[index]);
          },
        );
      },
    );
  }

  Widget _buildDeliveryCard(BuildContext context, Delivery delivery) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5.0,
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: AppColors.purplePrimary, // Ganti dengan warna sesuai keinginan
      child: ListTile(
        title: Text(
          'Delivery #${delivery.noDelivery}',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          'Alamat pengiriman: ${delivery.address}',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        onTap: () {
          // Arahkan ke halaman DeliveryDetail saat item diklik
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DeliveryDetailPage(deliveryNumber: delivery.noDelivery),
            ),
          );
        },
      ),
    );
  }
}
