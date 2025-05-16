import 'package:flutter/material.dart';

class CodeBlock extends StatelessWidget {
  final String title;
  final List<String> lines;

  const CodeBlock({super.key, required this.title, required this.lines});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        ...lines.map(
          (line) => Text(
            line,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class CodeSwitcher extends StatefulWidget {
  const CodeSwitcher({super.key});

  @override
  State<CodeSwitcher> createState() => _CodeSwitcherState();
}

class _CodeSwitcherState extends State<CodeSwitcher> {
  String selected = 'Padrão';

  final Map<String, List<Map<String, dynamic>>> codeVariants = {
    'Padrão': [
      {
        'title': 'Stack-Empty(S)',
        'lines': [
          '1   if S.topo == 0',
          '2     return true',
          '3   else return false',
        ],
      },
      {
        'title': 'Push(S, x)',
        'lines': [
          '1   S.topo = S.topo + 1',
          '2   S[S.topo] = x',
        ],
      },
      {
        'title': 'Pop(S)',
        'lines': [
          '1   if Stack-Empty(S)',
          '2     error "underflow"',
          '3   else S.topo = S.topo - 1',
          '4   return S[S.topo + 1]',
        ],
      },
    ],
    // Adicione outras variantes aqui
    'Java': [
      {
        'title': 'Stack.isEmpty()',
        'lines': ['return elements.size() == 0;'],
      },
      {
        'title': 'Stack.push(x)',
        'lines': ['elements.add(x);'],
      },
      {
        'title': 'Stack.pop()',
        'lines': ['if (isEmpty()) throw Exception();', 'return elements.removeLast();'],
      },
    ]
  };

  @override
  Widget build(BuildContext context) {
    final currentCode = codeVariants[selected] ?? [];

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DropdownButton<String>(
            value: selected,
            dropdownColor: Colors.grey[800],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            items: codeVariants.keys
                .map((k) => DropdownMenuItem(
                    value: k,
                    child: Text(k, style: const TextStyle(color: Colors.white))))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => selected = value);
              }
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: currentCode
                    .map((block) => CodeBlock(
                          title: block['title'],
                          lines: List<String>.from(block['lines']),
                        ))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

