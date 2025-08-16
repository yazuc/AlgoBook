import 'package:flutter/material.dart';
import 'package:Bookrithm/widgets/registry/visualization_registry.dart';

class TerminalPanel extends StatefulWidget {
  final VoidCallback onToggleTerminal;
  final bool showTerminal;

  const TerminalPanel({
    super.key,
    required this.onToggleTerminal,
    required this.showTerminal
    });

  @override
  TerminalPanelState createState() => TerminalPanelState();
}

class TerminalPanelState extends State<TerminalPanel>
    with TickerProviderStateMixin {
  final List<List<String>> _logsPerTab = [
    [], // Aba 1
    [], // Aba 2
  ];

  final List<String> _tabNames = [
    'Terminal',
    'Capítulo do livro',
  ];

  final bool showTerminal = true;

  late TabController _tabController;
  bool terminal = false;

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
                        color: Colors.black,
                        fontFamily: 'monospace',
                        fontSize: 14),
                  ))
              .toList(),
        ),
      );
    } else {
      return Center(child: Text('Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TabBar(
                  controller: _tabController,
                  tabs: List.generate(
                    _tabNames.length,
                    (index) => Tab(
                      text: _tabNames[index],
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                    terminal ? Icons.expand_more : Icons.expand_less,
                ),
                onPressed: widget.onToggleTerminal,
              ),   
                         
            ],
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

  final VoidCallback onToggleTerminal;
  final bool showTerminal;
  const ResizableTerminalPanel({
    super.key,
    required this.visible,
    required this.onToggleTerminal,
    required this.showTerminal,
  });

  @override
  State<ResizableTerminalPanel> createState() => _ResizableTerminalPanelState();
  
}


class _ResizableTerminalPanelState extends State<ResizableTerminalPanel> {
  double _terminalHeight = 200;
  final double _minTerminalHeight = 100;
  final double _maxTerminalHeight = 500;
  bool terminal = false;

  //final GlobalKey<TerminalPanelState> _terminalKey = GlobalKey();
  final GlobalKey<TerminalPanelState> _terminalKey = TerminalController.terminalKey;

  @override
  Widget build(BuildContext context) {
    if (!widget.visible) _terminalHeight = 48;
    if(widget.visible) _terminalHeight = 200;

    terminal = widget.visible;

    return Column(
      children: [
        // GestureDetector(
        //   onVerticalDragUpdate: (details) {
        //     setState(() {
        //       _terminalHeight = (_terminalHeight - details.delta.dy)
        //           .clamp(_minTerminalHeight, _maxTerminalHeight);
        //     });
        //   },
        //   child: Container(
        //     height: 10,
        //     width: double.infinity,
        //     color: Colors.grey[300],
        //     child: Center(
        //       child: Container(
        //         width: 30,
        //         height: 1,
        //         decoration: BoxDecoration(
        //           color: Colors.grey[600],
        //           borderRadius: BorderRadius.circular(10),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        Container(
          height: _terminalHeight,
          width: double.infinity,
          child: TerminalPanel(key: _terminalKey,  showTerminal: widget.showTerminal, onToggleTerminal: widget.onToggleTerminal,),
        ),
      ],
    );
  }
}
