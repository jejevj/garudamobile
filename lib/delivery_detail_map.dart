import 'dart:async';
import 'package:flutter/material.dart';
import 'package:garudajayasakti/bukti_kirim.dart';
import 'package:garudajayasakti/colors.dart';
import 'package:garudajayasakti/object/Delivery.dart';
import 'package:garudajayasakti/object/User.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DeliveryMap extends StatefulWidget {

  final List<LatLng> polylineCoordinates = [];

  @override
  _DeliveryMapState createState() => _DeliveryMapState();
}

class _DeliveryMapState extends State<DeliveryMap> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final String deliveryNumber = args['noDelivery'] ?? 'No. Delivery';

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Delivery',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.purplePrimary,
        ),
        body: FutureBuilder<Delivery>(
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

            final Delivery delivery = snapshot.data!;
            print(delivery.driverName);
            final drivernama = delivery.driverName.toString();


            // const source = LatLng(delivery.driverLat.toDouble(), delivery.driverLon.toDouble());
            return FutureBuilder<User>(
              future: fetchUserByUsername(drivernama),
              builder: (context, snapshot2) {
                if (snapshot2.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot2.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot2.error}'),
                  );
                } else if (!snapshot2.hasData) {
                  return Center(
                    child: Text('No data available.'),
                  );
                }

                final User user = snapshot2.data!;
                print(user.id);

                // const source = LatLng(delivery.driverLat.toDouble(), delivery.driverLon.toDouble());

                return DeliveryMapView(
                  sourceLocation: LatLng(user.lat, user.lon),
                  destinationLocation:
                  LatLng(delivery.custLat, delivery.custLon),
                  noDelivery: deliveryNumber,
                );
              },

            );
          },
        ),
      ),
    );
  }
}


class DeliveryMapView extends StatefulWidget {
  final LatLng sourceLocation;
  final LatLng destinationLocation;
  final String noDelivery;

  DeliveryMapView({
    required this.sourceLocation,
    required this.destinationLocation,
    required this.noDelivery,
  });

  @override
  _DeliveryMapViewState createState() => _DeliveryMapViewState();
}

class _DeliveryMapViewState extends State<DeliveryMapView> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Polyline> _polylines = {};

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: widget.destinationLocation,
            zoom: 13.5,
          ),
          markers: {
            Marker(
              markerId: MarkerId("source"),
              position: widget.sourceLocation,
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
              infoWindow: InfoWindow(
                title: 'Lokasi Kamu',
              ),
            ),
            Marker(
              markerId: MarkerId("destination"),
              position: widget.destinationLocation,
              infoWindow: InfoWindow(
                title: 'Tujuan',
                snippet: 'Klik Panah Dibawah Kanan...',
              ),
            ),
          },
          polylines: _polylines,
          onMapCreated: (mapController) {
            _controller.complete(mapController);
            _getDirections();
          },
        ),
        Positioned(
          bottom: 20,
          left: 20,
          child: Container(
            padding: EdgeInsets.all(8),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UploadBuktiPage(noDelivery: widget.noDelivery)),
                );
              },
              child: Text('Selesaikan Pesanan'),
            ),

          ),
        ),
        Positioned(
          bottom: 80,
          left: 20,
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                _buildLegendItem(
                  color: Colors.orange,
                  label: 'Posisi Pengirim',
                ),
                const SizedBox(width: 10),
                _buildLegendItem(
                  color: Colors.red,
                  label: 'Lokasi Tujuan',
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 130,
          left: 20,
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Text("Hint: Tap Icon Merah"),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem({required Color color, required String label}) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          color: color,
        ),
        const SizedBox(width: 5),
        Text(label),
      ],
    );
  }

  Future<void> _getDirections() async {
    // You can use a library like http to make a request to the Google Maps Directions API
    // and parse the response to get the polyline coordinates.

    // Example using a fake response:
    final String apiKey = 'AIzaSyAqjK9pohRLvcZZe745qh2KmpHS_DYsrts';
    final String apiUrl =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${widget.sourceLocation.latitude},${widget.sourceLocation.longitude}&destination=${widget.destinationLocation.latitude},${widget.destinationLocation.longitude}&key=$apiKey';

    final http.Response response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      final List<LatLng> points =
      _convertToLatLng(_decodePoly(encodedString: decodedResponse['routes'][0]['overview_polyline']['points']));

      setState(() {
        _polylines.add(Polyline(
          polylineId: PolylineId('route'),
          color: Colors.blue,
          width: 6,
          points: points,
        ));
      });
    } else {
      throw Exception('Failed to load directions');
    }
  }

  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  List _decodePoly({required String encodedString}) {
    var len = encodedString.length;
    int index = 0;
    List<int> decoded = [];
    int b, shift = 0, result = 0;
    do {
      b = encodedString.codeUnitAt(index++) - 63;
      result |= (b & 0x1F) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    decoded.add(dlat);
    result = 0;
    shift = 0;
    do {
      b = encodedString.codeUnitAt(index++) - 63;
      result |= (b & 0x1F) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    decoded.add(dlng);
    for (int i = 2; i < len; i++) {
      int value = 0;
      int shift = 0;
      int result = 0;
      do {
        b = encodedString.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      value += dlat;
      result = 0;
      shift = 0;
      do {
        b = encodedString.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      value += dlng;
      decoded.add(value);
    }
    return decoded;
  }
}
