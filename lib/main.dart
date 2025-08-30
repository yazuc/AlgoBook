import 'package:flutter/material.dart';
import 'package:Bookrithm/view_controller/view_page.dart';

void main() {
  runApp(const DataStructureApp());
}

class DataStructureApp extends StatefulWidget {
  const DataStructureApp({super.key});

  @override
  State<DataStructureApp> createState() => _DataStructureAppState();
}

class _DataStructureAppState extends State<DataStructureApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bookrithm',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark().copyWith(
        canvasColor: const Color.fromARGB(255, 48, 48, 48),
      ),
      themeMode: _themeMode,
      home: DataVisualizer(
        toggleTheme: _toggleTheme,
        themeMode: _themeMode,
      ),
    );
  }
}
