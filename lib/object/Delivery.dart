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
  final String? photo;
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
  // Fungsi untuk melakukan pembaruan pada foto dan status pengiriman
  Future<void> updateDelivery(String newPhotoUrl, String newStatus) async {
    // Endpoint untuk update
    String updateEndpoint = "https://garudadriver.azurewebsites.net/api/delivery-by-id/$noDelivery?format=api";

    // Data yang akan diupdate
    Map<String, String> data = {
      "photo": newPhotoUrl,
      "status": newStatus,
    };

    try {
      // Membuat permintaan PATCH untuk melakukan update
      var response = await http.patch(
        Uri.parse(updateEndpoint),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      // Cek apakah permintaan berhasil (HTTP 200 OK)
      if (response.statusCode == 200) {
        print("Update berhasil");
        // Jika Anda ingin memperbarui objek Delivery setelah pembaruan, Anda dapat menambahkan logika di sini
        // contoh: this.photo = newPhotoUrl; this.status = newStatus;
      } else {
        print("Update gagal. Status code: ${response.statusCode}");
        print("Response: ${response.body}");
      }
    } catch (error) {
      print("Error: $error");
      throw Exception("Failed to update delivery");
    }
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

Future<Delivery> fetchDataDeliveryById(String id) async {
  try {
    final response = await http.get(
      Uri.parse('https://garudadriver.azurewebsites.net/api/delivery-by-id/$id?format=json'),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return Delivery.fromJson(data);
    } else {
      print('Error response: ${response.statusCode}');
      print('Error body: ${response.body}');
      throw Exception('Failed to load delivery by ID: $id');
    }
  } catch (error) {
    print('Error: $error');
    throw Exception('Failed to load delivery by ID: $id');
  }
}
