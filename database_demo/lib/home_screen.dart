import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contact Screen')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter Name:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(),
            ),
            SizedBox(height: 5),

            Text(
              'Enter Mobile No:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: mobileController,
              decoration: InputDecoration(),
            ),

            SizedBox(height: 50),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: 100,
                    vertical: 10,
                  ),
                ),
                child: Text(
                  'Save',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
