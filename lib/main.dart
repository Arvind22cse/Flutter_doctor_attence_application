import 'package:flutter/material.dart';

import 'login_page.dart';
import 'signup_page.dart';
import 'homepage.dart';
import 'camera.dart';

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
      home: const DoctorLoginPage(), // Start with the Login Page
      routes: {
        '/login': (context) => const DoctorLoginPage(),
        '/signup': (context) => const DoctorSignupPage(),
        '/home': (context) => const Home(),
        '/camera':
            (context) =>
                const CameraScreen(doctorId: '6802586c36b8f3684d8fec18'),
      },
    );
  }
}
