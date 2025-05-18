import 'package:flutter/material.dart';
import 'package:Bookrithm/view_controller/view_page.dart';

void main() {
  runApp(const DataStructureApp());
}

class DataStructureApp extends StatelessWidget {
  const DataStructureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bookrithm',
      theme: ThemeData.light(),
      home: const DataVisualizer(),
    );
  }
}
