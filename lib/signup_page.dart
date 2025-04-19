import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DoctorSignupPage extends StatefulWidget {
  const DoctorSignupPage({super.key});

  @override
  State<DoctorSignupPage> createState() => _DoctorSignupPageState();
}

class _DoctorSignupPageState extends State<DoctorSignupPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final specializationController = TextEditingController();

  List<dynamic> phcList = [];
  String? selectedPhcId; // Holds selected PHC _id

  @override
  void initState() {
    super.initState();
    fetchPHCs(); // Fetch list of PHCs on load
  }

  Future<void> fetchPHCs() async {
    final url = Uri.parse("http://192.168.38.142:3000/api/list-phc");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        phcList = data;
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to load PHCs")));
    }
  }

  Future<void> registerDoctor() async {
    final url = Uri.parse("http://192.168.38.142:3000/api/add-doctor");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "doctor_name": nameController.text.trim(),
        "doctor_email": emailController.text.trim(),
        "password": passwordController.text.trim(),
        "phone": phoneController.text.trim(),
        "specialization": specializationController.text.trim(),
        "phc": selectedPhcId, // Send selected PHC _id
      }),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Dr. ${data['doctor_detail']['doctor_name']} registered",
          ),
        ),
      );
      Navigator.pushNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(data['error'] ?? 'Signup failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  "Doctor Sign Up",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: specializationController,
                  decoration: const InputDecoration(
                    labelText: 'Specialization',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),

                /// 🔽 Dropdown to Select PHC
                DropdownButtonFormField<String>(
                  value: selectedPhcId,
                  decoration: const InputDecoration(
                    labelText: "Select PHC",
                    border: OutlineInputBorder(),
                  ),
                  items:
                      phcList.map<DropdownMenuItem<String>>((phc) {
                        return DropdownMenuItem<String>(
                          value: phc["_id"],
                          child: Text(phc["name"]),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPhcId = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: registerDoctor,
                  child: const Text("Register"),
                ),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  child: const Text("Already have an account? Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
