import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse('https://integrada.minhabiblioteca.com.br/reader/books/9788595159914/');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

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
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: _launchUrl,
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  children: [
                    TextSpan(
                      text: structureTitles[currentStructure] ?? 'Data Structure Visualization',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(showTerminal ? Icons.expand_more : Icons.expand_less),
            color: Colors.black,
            onPressed: onToggleTerminal,
          ),
        ],
      ),
    );
  }
}
