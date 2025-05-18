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
  final String dataStructure;
  
  const CodeSwitcher({
    super.key,
    required this.dataStructure,
  });

  @override
  State<CodeSwitcher> createState() => CodeSwitcherState();
}

class CodeSwitcherState extends State<CodeSwitcher> {
  String selected = 'Cormen';
  late String currentDataStructure;

  @override
  void initState() {
    super.initState();
    currentDataStructure = widget.dataStructure;
  }
  
  // Method to update the data structure from outside
  void updateDataStructure(String dataStructure) {
    setState(() {
      currentDataStructure = dataStructure;
    });
  }

  // Code examples for Stack data structure
  final Map<String, List<Map<String, dynamic>>> pilhaCodeVariants = {
    'Cormen': [
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
  
  // Code examples for Binary Tree data structure
  final Map<String, List<Map<String, dynamic>>> arvoreBinariaCodeVariants = {
    'Cormen': [
    ],
    'Java': [      
    ]
  };

   final Map<String, List<Map<String, dynamic>>> filaCodeVariants = {
    'Cormen': [
      {
        'title': 'ENQUEUE(Q,x)',
        'lines': [
          '1   Q[Q.fim] = x',
          '2   if Q.fim = Q.comprimento',
          '3      Q.fim = 1',
          '4   else Q.fim = Q.fim + 1',
         ],
      },
      {
        'title': 'DEQUEUE(Q)',
        'lines': [
          '1   x = Q[Q.início]',
          '2   if Q.início == Q.comprimento',
          '3      Q.início = 1',
          '4   else Q.início = Q.início + 1',
          '5   return x',
         ],
      },
    ],
  };

  Map<String, List<Map<String, dynamic>>> getCodeVariants() {
    switch (currentDataStructure) {
      case 'Árvore Binária':
        return arvoreBinariaCodeVariants;
      case 'Fila':
        return filaCodeVariants;
      case 'Pilha':
      default:
        return pilhaCodeVariants;
    }
  }

  @override
  Widget build(BuildContext context) {
    final codeVariants = getCodeVariants();
    final currentCode = codeVariants[selected] ?? [];
    
    // If the selected language is not available for the current data structure,
    // default to 'Padrão'
    if (!codeVariants.containsKey(selected)) {
      selected = 'Cormen';
    }

    return Expanded(
      child: Column(
        children: [
          Text(
            currentDataStructure,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          DropdownButton<String>(
            value: selected,
            dropdownColor: Colors.grey[800],
            style: TextStyle(color: Colors.white),
            items: codeVariants.keys
                .map((k) => DropdownMenuItem(value: k, child: Text(k)))
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

