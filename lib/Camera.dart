// import 'dart:io';
// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(title: 'Face Detection', home: FacePage());
//   }
// }

// class FacePage extends StatefulWidget {
//   @override
//   _FacePageState createState() => _FacePageState();
// }

// class _FacePageState extends State<FacePage> {
//   File? _imageFile;
//   List<dynamic> _faces = [];
//   ui.Image? _image;
//   bool isLoading = false;

//   Future<void> _getImageAndDetectFaces() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile == null) return;

//     final file = File(pickedFile.path);
//     setState(() => isLoading = true);

//     final request = http.MultipartRequest(
//       'POST',
//       Uri.parse('http://YOUR_SERVER_IP:3000/detect'),
//     );
//     request.files.add(await http.MultipartFile.fromPath('image', file.path));
//     final response = await request.send();

//     if (response.statusCode == 200) {
//       final responseBody = await response.stream.bytesToString();
//       final faces = jsonDecode(responseBody);
//       final data = await file.readAsBytes();
//       final image = await decodeImageFromList(data);
//       setState(() {
//         _imageFile = file;
//         _faces = faces;
//         _image = image;
//         isLoading = false;
//       });
//     } else {
//       setState(() => isLoading = false);
//       print('Error: ${response.statusCode}');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:
//           isLoading
//               ? Center(child: CircularProgressIndicator())
//               : (_imageFile == null)
//               ? Center(child: Text('No image selected'))
//               : Center(
//                 child: FittedBox(
//                   child: SizedBox(
//                     width: _image!.width.toDouble(),
//                     height: _image!.height.toDouble(),
//                     child: CustomPaint(painter: FacePainter(_image!, _faces)),
//                   ),
//                 ),
//               ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _getImageAndDetectFaces,
//         child: Icon(Icons.add_a_photo),
//       ),
//     );
//   }
// }

// class FacePainter extends CustomPainter {
//   final ui.Image image;
//   final List<dynamic> faces;

//   FacePainter(this.image, this.faces);

//   @override
//   void paint(ui.Canvas canvas, ui.Size size) {
//     final paint =
//         Paint()
//           ..style = PaintingStyle.stroke
//           ..strokeWidth = 3.0
//           ..color = Colors.red;

//     canvas.drawImage(image, Offset.zero, Paint());

//     for (var face in faces) {
//       final rect = Rect.fromLTWH(
//         face['x'].toDouble(),
//         face['y'].toDouble(),
//         face['width'].toDouble(),
//         face['height'].toDouble(),
//       );
//       canvas.drawRect(rect, paint);
//     }
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => true;
// }
