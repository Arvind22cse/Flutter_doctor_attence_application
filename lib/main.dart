// main.dart

import 'package:flutter/material.dart';
import 'login_page.dart';
import 'signup_page.dart';
import 'homepage.dart';
import 'camera.dart';
import 'location.dart';
import 'doctorattendenceview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const DoctorLoginPage(),
        '/signup': (context) => const DoctorSignupPage(),
        '/home': (context) => const Home(),
        '/location': (context) => const LocationTracker(),
        '/attendence': (context) {
          final Map<String, dynamic> data =
              ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>? ??
              {};
          final String doctorId =
              data['doctorId'] ??
              ''; // Retrieve doctorId from the arguments passed
          return DoctorAttendanceScreen(
            doctorId: doctorId,
          ); // Pass doctorId here
        },
      },
    );
  }
}
