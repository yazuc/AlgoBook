import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:Bookrithm/exercises/exercise_model.dart';
import 'package:flutter/material.dart';
import 'package:Bookrithm/widgets/registry/visualization_registry.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class TerminalPanel extends StatefulWidget {
  final VoidCallback onToggleTerminal;
  final bool showTerminal;

  const TerminalPanel(
      {super.key, required this.onToggleTerminal, required this.showTerminal});

  @override
  TerminalPanelState createState() => TerminalPanelState();
}

class TerminalPanelState extends State<TerminalPanel>
    with TickerProviderStateMixin {
      List<Exercise> exercises = [];
  final List<List<String>> _logsPerTab = [
    [], // Aba 1
    [], // Aba 2
    [], // Aba 3
  ];

  final List<String> _tabNames = [
    'Terminal',
    'Capítulo do livro',
    'Exercícios',
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _logsPerTab.length, vsync: this);
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    final String response =
    await rootBundle.loadString('assets/exercises/stack.json');
    final data = jsonDecode(response) as List;
    setState(() {
      exercises = data.map((e) => Exercise.fromJson(e)).toList();
    });
  }

  Future<String> _loadChapter(String fileName) async {
  return await rootBundle.loadString('assets/chapters/$fileName');
  }
  
  void addLog(String message) {
    setState(() {
      _logsPerTab[0].add(message);
    });
  }

Widget getTabContent(int index) {
  final theme = Theme.of(context);

  if (index == 0) {
    // Aba Terminal
    return SingleChildScrollView(
      reverse: true,
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _logsPerTab[index]
            .map((log) => Text(
                  log,
                  style: TextStyle(
                      color: theme.textTheme.bodyLarge?.color,
                      fontFamily: 'monospace',
                      fontSize: 14),
                ))
            .toList(),
      ),
    );
  } else if (index == 1) {
    // Aba Capítulo do livro
    return _buildChapterView();
  } else if (index == 2) {
    // Aba Exercícios
    if (exercises.isEmpty) {
      return const Center(child: Text("Nenhum exercício disponível."));
    }
    return ListView.builder(
      itemCount: exercises.length,
      itemBuilder: (context, index) {
        final exercise = exercises[index];
        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            title: Text(exercise.title),
            subtitle: Text(exercise.description),
            trailing: const Icon(Icons.play_arrow),
            onTap: () {
              // Aqui você pode abrir uma nova tela ou iniciar a execução do exercício
              addLog("Iniciando exercício: ${exercise.title}");
            },
          ),
        );
      },
    );
  } else {
    return const Center(child: Text("Aba inválida."));
  }
}

Widget _buildChapterView() {
  return FutureBuilder<String>(
    future: _loadChapter('stack.md'), // trocar dinamicamente depois
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return Center(child: Text("Erro ao carregar capítulo: ${snapshot.error}"));
      }
      return Markdown(
        data: snapshot.data ?? '',
        styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
          p: TextStyle(fontSize: 14),
          h1: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.cardColor,
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
                  widget.showTerminal
                      ? Icons.expand_more
                      : Icons.expand_less,
                ),
                onPressed: widget.onToggleTerminal,
              ),
            ],
          ),
          if (widget.showTerminal)
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

  final GlobalKey<TerminalPanelState> _terminalKey =
      TerminalController.terminalKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onVerticalDragUpdate: (details) {
            if (widget.visible) {
              setState(() {
                _terminalHeight = (_terminalHeight - details.delta.dy)
                    .clamp(_minTerminalHeight, _maxTerminalHeight);
              });
            }
          },
          child: Container(
            height: 10,
            width: double.infinity,
            color: Colors.grey[300],
            child: Center(
              child: Container(
                width: 30,
                height: 1,
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: widget.visible ? _terminalHeight : 48,
          width: double.infinity,
          child: TerminalPanel(
            key: _terminalKey,
            showTerminal: widget.showTerminal,
            onToggleTerminal: widget.onToggleTerminal,
          ),
        ),
      ],
    );
  }
}
