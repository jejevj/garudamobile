import 'dart:async';
import 'package:flutter/material.dart';
import 'package:garudajayasakti/bukti_kirim.dart';
import 'package:garudajayasakti/colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class DeliveryMap extends StatefulWidget {
  @override
  _DeliveryMapState createState() => _DeliveryMapState();
}

class _DeliveryMapState extends State<DeliveryMap> {
  late GoogleMapController mapController;
  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
  static const LatLng destination = LatLng(37.33429383, -122.06600055);
  final LatLng _center = const LatLng(45.521563, -122.677433);

  List<LatLng> polylineCoordinates = [];

  @override
  void initState() {
    getPolyPoints();
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyAqjK9pohRLvcZZe745qh2KmpHS_DYsrts",
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );

    if (result.points.isNotEmpty) {
      polylineCoordinates = result.points
          .map((PointLatLng point) => LatLng(point.latitude, point.longitude))
          .toList();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Delivery',style: TextStyle(color: AppColors.whitePrimary),),
          backgroundColor: AppColors.purplePrimary,
        ),
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: sourceLocation,
                zoom: 13.5,
              ),
              markers: {
                Marker(
                  markerId: MarkerId("source"),
                  position: sourceLocation,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueOrange), // Ikon truk
                ),
                Marker(
                  markerId: MarkerId("destination"),
                  position: destination,
                  infoWindow: InfoWindow(
                    title: 'Tujuan',
                    snippet: 'Petunjuk arahan untuk driver di sini...',
                  ),
                ),
              },
              onMapCreated: (mapController) {
                _controller.complete(mapController);
              },
              polylines: {
                Polyline(
                  polylineId: PolylineId("route"),
                  points: polylineCoordinates,
                  color: const Color(0xFF7B61FF),
                  width: 6,
                ),
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
                      MaterialPageRoute(
                        builder: (context) => UploadBuktiPage(),
                      ),
                    );
                  },
                  child: Text('Selesaikan Pesanan'),
                ),

              ),
            ), Positioned(
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
            ),Positioned(
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
                    Text("Hint: Tap Icon Merah")

                  ],
                ),

              ),
            ),
          ],
        ),
      ),
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
}
