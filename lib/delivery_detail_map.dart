import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:garudajayasakti/bukti_kirim.dart';
import 'package:garudajayasakti/colors.dart';
import 'package:garudajayasakti/object/Delivery.dart';
import 'package:garudajayasakti/object/Jarak.dart';
import 'package:garudajayasakti/object/LocationUtil.dart';
import 'package:garudajayasakti/object/User.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DeliveryMap extends StatefulWidget {
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

  Set<Polyline> _polylines = {};
  late GoogleMapController mapController;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  String googleAPiKey = "AIzaSyAqjK9pohRLvcZZe745qh2KmpHS_DYsrts";
  double _actualDistance = 0.0;
  late RouteInfo routeInfo; // Singleton instance

  @override
  void initState() {
    super.initState();

    var initializationSettingsAndroid =
    AndroidInitializationSettings(
        'logo'); // This line is removed for Android-only
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid

    );

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,

    );
    routeInfo = RouteInfo();
    // Fetch and draw the route when the widget is created
    _fetchRoute();


  }

  Future<void> _showNotification(String title, String body) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',

      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: widget.sourceLocation,
            zoom: 13.5,

          ),
          tiltGesturesEnabled: true,
          compassEnabled: true,
          scrollGesturesEnabled: true,
          zoomGesturesEnabled: true,
          markers: {
            Marker(
              markerId: MarkerId("source"),
              position: widget.sourceLocation,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueOrange),
              infoWindow: InfoWindow(
                title: 'Lokasi Kamu, userID:${LocationUtil.userid}',
              ),
            ),
            Marker(
              markerId: MarkerId("destination"),
              position: widget.destinationLocation,
              infoWindow: InfoWindow(
                title: 'Tujuan',
                snippet: 'Klik Panah Dibawah Kanan ...',
              ),
            ),

          },

          polylines: _polylines,
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
                // _showNotification(
                //     'Lokasi Tujuan', 'Lat: ${widget.destinationLocation
                //     .latitude}, Long: ${widget.destinationLocation
                //     .longitude}');
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
  Future<void> _fetchRoute() async {
    String apiUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=${widget.sourceLocation.latitude},${widget.sourceLocation.longitude}&destination=${widget.destinationLocation.latitude},${widget.destinationLocation.longitude}&key=${googleAPiKey}";

    final response = await http.get(Uri.parse(apiUrl));
    // Extract distance from the first route

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<LatLng> points = _decodePolyline(data['routes'][0]['overview_polyline']['points']);

      double distance = data['routes'][0]['legs'][0]['distance']['value'] / 1000.0; // Distance in kilometers
      // Update the actual distance
      setState(() {
        // Update the actual distance in the singleton instance
        routeInfo.jarakDalamKM = distance;
        _actualDistance = distance;
        LocationUtil.kodePengiriman = widget.noDelivery;
      });
      print("Jarak: $_actualDistance KM");
      Polyline polyline = Polyline(
        polylineId: PolylineId('route'),
        color: Colors.blue,
        width: 5,
        points: points,
      );

      setState(() {
        _polylines.add(polyline);
      });
    } else {
      // Handle error
      print("Error fetching route: ${response.reasonPhrase}");
    }
  }

  List<LatLng> _decodePolyline(String polyline) {
    List<LatLng> polyLinePoints = [];
    int index = 0;
    int len = polyline.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      double latitude = lat / 1e5;
      double longitude = lng / 1e5;

      LatLng position = LatLng(latitude, longitude);
      polyLinePoints.add(position);
    }

    return polyLinePoints;
  }
}
