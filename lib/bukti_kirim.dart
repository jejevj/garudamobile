import 'dart:io';
import 'package:garudajayasakti/berhasil_kirim.dart';
import 'package:garudajayasakti/object/DeliveryOk.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:garudajayasakti/object/User.dart';
import 'package:permission_handler/permission_handler.dart';


class UploadBuktiPage extends StatefulWidget {
  final String noDelivery;

  UploadBuktiPage({required this.noDelivery});
  @override
  _UploadBuktiPageState createState() => _UploadBuktiPageState();
}

class _UploadBuktiPageState extends State<UploadBuktiPage> {
  late CameraController _controller;
  late CameraDescription _camera;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      setState(() {
        _camera = cameras.first;
        _controller = CameraController(
          _camera,
          ResolutionPreset.medium,
        );
        _controller.initialize().then((_) {
          if (!mounted) {
            return;
          }
          setState(() {});
        });
      });
    }
  }

  Future<void> _requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      await Permission.camera.request();
    }
  }

  Future<void> _takePicture() async {
    if (!_controller.value.isInitialized) {
      return;
    }

    final XFile image = await _controller.takePicture();

    setState(() {
      _imagePath = image.path;
    });
  }

  Future<void> _uploadProofOfDelivery() async {
    try {
      if (_imagePath != null) {
        File imageFile = File(_imagePath!);
        Delivery delivery = await fetchDataDeliveryById(widget.noDelivery);
        await delivery.updateDelivery(imageFile.path, "Delivered");
        print("Bukti pengiriman berhasil diupload");
        User user = await fetchUserByUsername(delivery.driverName);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BerhasilKirimBukti(),
            settings: RouteSettings(
              arguments: {'userId': user.id}, // Sesuaikan dengan data yang ingin Anda kirim
            ),
          ),
        );
      } else {
        print("Ambil foto terlebih dahulu");
      }
    } catch (error) {
      print("Error: $error");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Bukti Pengiriman'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCameraPreview(),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await _requestCameraPermission();
                if (await Permission.camera.isGranted) {
                  await _takePicture();
                } else {
                  print('Camera permission is required');
                }
              },
              child: Text('Ambil Foto'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _uploadProofOfDelivery,
              child: Text('Upload Bukti Pengiriman'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraPreview() {
    if (_controller.value.isInitialized) {
      if (_imagePath != null) {
        return Image.file(
          File(_imagePath!),
          height: 200.0,
        );
      } else {
        return Container(
          height: 200.0,
          child: CameraPreview(_controller),
        );
      }
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}