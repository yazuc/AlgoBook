import 'package:flutter/material.dart';
import 'package:AlgoBook/themes.dart';
import 'package:AlgoBook/view_controller/view_page.dart';

void main() {
  runApp(const AlgoBook());
}

class AlgoBook extends StatefulWidget {
  const AlgoBook({super.key});

  @override
  State<AlgoBook> createState() => _AlgoBookState();
}

class _AlgoBookState extends State<AlgoBook> {
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
      title: 'AlgoBook',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode,
      home: DataVisualizer(
        toggleTheme: _toggleTheme,
        themeMode: _themeMode,
      ),
    );
  }
}
