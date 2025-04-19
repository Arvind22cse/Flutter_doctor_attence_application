import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class CameraScreen extends StatefulWidget {
  final String doctorId;

  const CameraScreen({super.key, required this.doctorId});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late List<CameraDescription> cameras;
  bool isCameraReady = false;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    await Permission.camera.request();
    if (await Permission.camera.isGranted) {
      try {
        cameras = await availableCameras();
        if (cameras.isEmpty) {
          // Handle the case where no cameras are available
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No camera found on this device')),
          );
          return;
        }

        _controller = CameraController(cameras[0], ResolutionPreset.medium);
        await _controller.initialize();

        if (!mounted) return;
        setState(() {
          isCameraReady = true;
        });
      } catch (e) {
        print("Error initializing camera: $e");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error initializing camera')));
      }
    } else {
      // Handle permission denied case
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Camera permission is required')));
    }
  }

  Future<void> takePictureAndUpload() async {
    final XFile image = await _controller.takePicture();
    File imageFile = File(image.path);

    // Upload to backend
    var uri = Uri.parse('http://localhost:3000/uploads/upload-image');
    var request =
        http.MultipartRequest('POST', uri)
          ..fields['doctorId'] = widget.doctorId
          ..files.add(
            await http.MultipartFile.fromPath('image', imageFile.path),
          );

    var response = await request.send();

    if (response.statusCode == 200) {
      print("Image uploaded successfully");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Attendance marked!')));
    } else {
      print("Image upload failed");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Upload failed. Try again!')));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isCameraReady) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: Text('Mark Attendance')),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: CameraPreview(_controller),
          ),
          ElevatedButton(
            onPressed:
                () => takePictureAndUpload(), // No need to pass context here
            child: Text("Capture & Mark Attendance"),
          ),
        ],
      ),
    );
  }
}
