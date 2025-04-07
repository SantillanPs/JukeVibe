import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

Future<Map<String, dynamic>?> readJsonFromFile() async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/form_data.json');

    if (await file.exists()) {
      final jsonString = await file.readAsString();
      final data = jsonDecode(jsonString);
      return data;
    } else {
      print('File does not exist.');
      return null;
    }
  } catch (e) {
    print('Error reading JSON file: $e');
    return null;
  }
}

class UserDataScreen extends StatelessWidget {
  const UserDataScreen({Key? key}) : super(key: key);

  Future<Map<String, dynamic>?> readJsonFromFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/form_data.json');

      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final data = jsonDecode(jsonString);
        return data;
      } else {
        print('File does not exist.');
        return null;
      }
    } catch (e) {
      print('Error reading JSON file: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Saved User Data")),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: readJsonFromFile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data != null) {
            final data = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                color: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'User Details',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "👤 Name: ${data['name']}",
                        style: TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "📧 Email: ${data['email']}",
                        style: TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "🔒 Password: ${data['password']}",
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Center(child: Text("No saved data found."));
          }
        },
      ),
    );
  }
}
