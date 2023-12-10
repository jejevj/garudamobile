import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class UploadBuktiPage extends StatefulWidget {
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

    // Ambil gambar
    final XFile image = await _controller.takePicture();

    // Simpan path gambar
    setState(() {
      _imagePath = image.path;
    });
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
              onPressed: () {
                // Upload bukti pengiriman logic here
                print('Upload bukti pengiriman...');
              },
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
        // Jika ada gambar yang diambil, tampilkan gambar
        return Image.file(
          File(_imagePath!),
          height: 200.0,
        );
      } else {
        // Jika belum ada gambar yang diambil, tampilkan frame kamera
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
