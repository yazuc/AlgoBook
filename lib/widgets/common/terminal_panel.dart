import 'package:flutter/material.dart';

class TerminalPanel extends StatefulWidget {
  const TerminalPanel({super.key});

  @override
  TerminalPanelState createState() => TerminalPanelState();
}

class TerminalPanelState extends State<TerminalPanel>
    with TickerProviderStateMixin {
  final List<List<String>> _logsPerTab = [
    [], // Aba 1
    [], // Aba 2
    [], // Aba 3
    [], // Aba 4
    [], // Aba 5
  ];

  final List<String> _tabNames = [
    'Terminal',
    'Capítulo do livro',
    'Outro conteúdo',
    'Outro conteúdo',
    'Outro conteúdo',
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _logsPerTab.length, vsync: this);
  }

  void addLog(String message) {
    setState(() {
      _logsPerTab[_tabController.index].add(message);
    });
  }

  // Example of how you can return different content for each tab
  Widget getTabContent(int index) {
    if (index == 0) {
      return SingleChildScrollView(
        reverse: true,
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _logsPerTab[index]
              .map((log) => Text(
                    log,
                    style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'monospace',
                        fontSize: 14),
                  ))
              .toList(),
        ),
      );
    } else {
      return Center(child: Text('Other content for Tab $index'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      color: Colors.black,
      child: Column(
        children: [
          Container(
            color: Colors.grey[900],
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              tabs: List.generate(
                _tabNames.length,
                (index) => Tab(
                  text: _tabNames[index],
                ),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List.generate(
                _logsPerTab.length,
                (index) => getTabContent(index),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ResizableTerminalPanel extends StatefulWidget {
  final bool visible;

  const ResizableTerminalPanel({
    super.key,
    required this.visible,
  });

  @override
  State<ResizableTerminalPanel> createState() => _ResizableTerminalPanelState();
}

class _ResizableTerminalPanelState extends State<ResizableTerminalPanel> {
  double _terminalHeight = 200;
  final double _minTerminalHeight = 100;
  final double _maxTerminalHeight = 500;

  final GlobalKey<TerminalPanelState> _terminalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    if (!widget.visible) return const SizedBox.shrink();

    return Column(
      children: [
        GestureDetector(
          onVerticalDragUpdate: (details) {
            setState(() {
              _terminalHeight = (_terminalHeight - details.delta.dy)
                  .clamp(_minTerminalHeight, _maxTerminalHeight);
            });
          },
          child: Container(
            height: 10,
            width: double.infinity,
            color: Colors.grey[300],
            child: Center(
              child: Container(
                width: 30,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
        Container(
          height: _terminalHeight,
          width: double.infinity,
          child: TerminalPanel(key: _terminalKey),
        ),
      ],
    );
  }
}
