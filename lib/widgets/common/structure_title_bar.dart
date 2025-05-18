import 'package:flutter/material.dart';

class StructureTitleBar extends StatelessWidget {
  final String currentStructure;
  final Map<String, String> structureTitles;
  final bool showTerminal;
  final VoidCallback onToggleTerminal;

  const StructureTitleBar({
    super.key,
    required this.currentStructure,
    required this.structureTitles,
    required this.showTerminal,
    required this.onToggleTerminal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.grey[850],
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            structureTitles[currentStructure] ?? 'Data Structure Visualization',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          IconButton(
            icon: Icon(showTerminal ? Icons.expand_more : Icons.expand_less),
            color: Colors.white,
            onPressed: onToggleTerminal,
          ),
        ],
      ),
    );
  }
}
