import 'package:flutter/material.dart';
import 'package:Bookrithm/themes.dart';
import 'package:Bookrithm/view_controller/view_page.dart';

void main() {
  runApp(const Bookrithm());
}

class Bookrithm extends StatefulWidget {
  const Bookrithm({super.key});

  @override
  State<Bookrithm> createState() => _BookrithmState();
}

class _BookrithmState extends State<Bookrithm> {
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
