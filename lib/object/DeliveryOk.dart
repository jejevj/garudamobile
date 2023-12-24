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

  Future<void> updateDelivery(String imagePath, String status) async {
    try {
      var request = http.MultipartRequest(
          'PUT',
          Uri.parse(
              'https://garudadriver.azurewebsites.net/api/delivery-by-id/$noDelivery?format=json'));

      // Menambahkan data teks
      request.fields['status'] = status;

      // Menambahkan data yang diperlukan (sesuaikan dengan kebutuhan)
      request.fields['no_delivery'] = noDelivery;
      request.fields['date'] = date;
      request.fields['address'] = address;
      request.fields['cp'] = cp;
      request.fields['hp'] = hp;
      request.fields['driver_name'] = driverName;

      var file = await http.MultipartFile.fromPath('photo', imagePath);
      request.files.add(file);

      var response = await request.send();

      if (response.statusCode == 200) {
        print('Upload bukti pengiriman berhasil');
      } else {
        print(
            'Gagal upload bukti pengiriman. Status code: ${response.statusCode}');
        print('Response: ${await response.stream.bytesToString()}');
      }
    } catch (error) {
      print('Error: $error');
      throw Exception('Gagal upload bukti pengiriman');
    }
  }

}

Future<Delivery> fetchDataDeliveryById(String id) async {
  try {
    final response = await http.get(
      Uri.parse(
          'https://garudadriver.azurewebsites.net/api/delivery-by-id/$id?format=json'),
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