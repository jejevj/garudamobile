import 'dart:convert';
import 'package:http/http.dart' as http;

class Delivery {
  final String noDelivery;
  final String date;
  final String customerName;
  final String address;
  final double custLat;
  final double custLon;
  final String cp;
  final String hp;
  final String driverName;
  final double driverLat;
  final double driverLon;
  final String photo;
  final String status;

  Delivery({
    required this.noDelivery,
    required this.date,
    required this.customerName,
    required this.address,
    required this.custLat,
    required this.custLon,
    required this.cp,
    required this.hp,
    required this.driverName,
    required this.driverLat,
    required this.driverLon,
    required this.photo,
    required this.status,
  });

  factory Delivery.fromJson(Map<String, dynamic> json) {
    return Delivery(
      noDelivery: json['no_delivery'],
      date: json['date'],
      customerName: json['customer_name'],
      address: json['address'],
      custLat: double.parse(json['cust_lat']),
      custLon: double.parse(json['cust_lon']),
      cp: json['cp'],
      hp: json['hp'],
      driverName: json['driver_name'],
      driverLat: double.parse(json['driver_lat']),
      driverLon: double.parse(json['driver_lon']),
      photo: json['photo'],
      status: json['status'],
    );
  }
}

Future<List<Delivery>> fetchDataDelivery() async {
  final response = await http.get(
    Uri.parse('https://garudadriver.azurewebsites.net/api/delivery/?format=json'),
  );

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    List<Delivery> deliveries = data.map((json) => Delivery.fromJson(json)).toList();
    return deliveries;
  } else {
    throw Exception('Failed to load delivery data');
  }
}
