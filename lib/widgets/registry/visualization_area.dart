import 'package:flutter/material.dart';

class VisualizationArea extends StatelessWidget {
  final Widget? child;

  const VisualizationArea({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (child != null) child!,
        ],
      ),
    );
  }
}
