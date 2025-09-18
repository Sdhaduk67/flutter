import 'package:flutter/material.dart';
import 'screens/onboarding1.dart';

void main() {
  runApp(const TaskifyApp());
}

class TaskifyApp extends StatelessWidget {
  const TaskifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Taskify",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Onboarding1(),
    );
  }
}
