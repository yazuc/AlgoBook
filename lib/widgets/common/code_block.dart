import 'package:flutter/material.dart';

class CodeBlock extends StatelessWidget {
  final String title;
  final List<String> lines;
  final int? highlightedLine;
  final bool highlightedTitle;
  final bool theme;

  const CodeBlock({
    super.key,
    required this.title,
    required this.lines,
    this.highlightedLine,
    this.highlightedTitle = false,
    this.theme = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final highlightColor = theme.highlightColor;
    final defaultTextColor = theme.textTheme.bodyLarge?.color;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: highlightedTitle
              ? highlightColor
              : Colors.transparent,
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 14,
              color: defaultTextColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 4),
        ...lines.asMap().entries.map((entry) {
          int index = entry.key;
          String line = entry.value;
          bool isHighlighted = highlightedLine == index;
          return Container(
            color: isHighlighted
                ? highlightColor
                : Colors.transparent,
            child: Text(
              line,
              style: TextStyle(color: defaultTextColor, fontSize: 12),
            ),
          );
        }),
        const SizedBox(height: 16),
      ],
    );
  }
}

class CodeSwitcher extends StatefulWidget {
  final String dataStructure;
  final Function(String)? onBookChanged;

  const CodeSwitcher({
    super.key,
    required this.dataStructure,
    this.onBookChanged,
  });

  @override
  State<CodeSwitcher> createState() => CodeSwitcherState();
}

class CodeSwitcherState extends State<CodeSwitcher> {
  String selected = 'Cormen';
  late String currentDataStructure;

  int? currentHighlightIndex;
  int? currentBlockIndex;
  bool highlightTitle = false; // NOVO


  @override
  void initState() {
    super.initState();
    currentDataStructure = widget.dataStructure;
  }

  void updateDataStructure(String dataStructure) {
    setState(() {
      currentDataStructure = dataStructure;
      currentHighlightIndex = null;
      currentBlockIndex = null;
      highlightTitle = false; // reset
    });
  }

  Future<void> highlightByTitle(String title) async {
    final codeVariants = getCodeVariants();
    final currentCode = codeVariants[selected] ?? [];

    final blockIndex =
        currentCode.indexWhere((block) => block['title'] == title);

    if (blockIndex == -1) return; // Não encontrou

    final block = currentCode[blockIndex];
    final lines = List<String>.from(block['lines']);

    // 1. Highlight o título
    setState(() {
      currentBlockIndex = blockIndex;
      highlightTitle = true;
      currentHighlightIndex = null;
    });
    await Future.delayed(const Duration(seconds: 1));

    // 2. Highlight cada linha
    for (int i = 0; i < lines.length; i++) {
      setState(() {
        currentBlockIndex = blockIndex;
        currentHighlightIndex = i;
        highlightTitle = false;
      });
      await Future.delayed(const Duration(seconds: 1));
    }

    // Limpa
    setState(() {
      currentHighlightIndex = null;
      currentBlockIndex = null;
      highlightTitle = false;
    });
  }

  final Map<String, List<Map<String, dynamic>>> pilhaCodeVariants = {
    'Cormen': [
      {
        'title': 'Pilha-Vazia(S)',
        'lines': [
          '1   if S.top == 0',
          '2     return VERDADE',
          '3   else return FALSO',
        ],
      },
      {
        'title': 'Pilha-Cheia(S)',
        'lines': [
          '1   if S.top == S.tamanho',
          '2     return VERDADE',
          '3   else return FALSO',
        ],
      },
      {
        'title': 'Push(S, x)',
        'lines': [
          '1   if Pilha-Cheia(S)',
          '2     error "overflow"',
          '3   else S.topo = S.topo + 1',
          '4     S[S.topo] = x', // S[S.top] = x é o mesmo que S.top = x
        ],
      },
      {
        'title': 'Pop(S)',
        'lines': [
          '1   if Pilha-Vazia(S)',
          '2     error "underflow"',
          '3   else S.topo = S.topo - 1',
          '4     return S[S.topo + 1]',
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
        'lines': [
          'if (isEmpty()) throw Exception();',
          'return elements.removeLast();'
        ],
      },
    ]
  };

  final Map<String, List<Map<String, dynamic>>> arvoreBinariaCodeVariants = {
    'Cormen': [
      {
        'title': 'BUSCA-ÁRVORE(x, k)',
        'lines': [
          '1   if x == NIL or k == x.chave',
          '2     return x',
          '3   if k < x.chave',
          '4     return BUSCA-ÁRVORE(x.esquerda, k)',
          '5   else',
          '6     return BUSCA-ÁRVORE(x.direita, k)',
        ],
      },
      {
        'title': 'INSERE-ÁRVORE(T, z)',
        'lines': [
          '1   x = T.raiz',
          '2   y = NIL',
          '3   while x != NIL',
          '4     y = x',
          '5     if z.chave < x.chave',
          '6       x = x.esquerda',
          '7     else',
          '8       x = x.direita',
          '9   z.p = y',
          '10  if y == NIL',
          '11    T.raiz = z',
          '12  else if z.chave < y.chave',
          '13    y.esquerda = z',
          '14  else',
          '15    y.direita = z',
        ],
      },
      {
        'title': 'REMOVE-ÁRVORE(T, z)',
        'lines': [
          '1   if z.esquerda == NIL',
          '2     TRANSPLANTE(T, z, z.direita)',
          '3   else if z.direita == NIL',
          '4     TRANSPLANTE(T, z, z.esquerda)',
          '5   else',
          '6     y = MÍNIMO-ÁRVORE(z.direita)',
          '7     if y != z.direita',
          '8       TRANSPLANTE(T, y, y.direita)',
          '9       y.direita = z.direita',
          '10      y.direita.p = y',
          '11    TRANSPLANTE(T, z, y)',
          '12    y.esquerda = z.esquerda',
          '13    y.esquerda.p = y',
        ],
      },
      {
        'title': 'TRANSPLANTE(T, u, v)',
        'lines': [
          '1   if u.p == NIL',
          '2     T.raiz = v',
          '3   else if u == u.p.esquerda',
          '4     u.p.esquerda = v',
          '5   else',
          '6     u.p.direita = v',
          '7   if v != NIL',
          '8     v.p = u.p',
        ],
      },
    ]
  };

  final Map<String, List<Map<String, dynamic>>> filaCodeVariants = {
    'Cormen': [
      {
        'title': 'ENQUEUE(Q,x)',
        'lines': [
          '1   if QUEUE-FULL(Q)',
          '2     error "overflow"',
          '3   Q[Q.fim] = x',
          '4   if Q.fim == Q.tamanho',
          '5      Q.fim = 1',
          '6   else ',
          '7      Q.fim = Q.fim + 1',
        ],
      },
      {
        'title': 'DEQUEUE(Q)',
        'lines': [
          '1   if Q.início == Q.fim',
          '2     error "underflow"',
          '3   x = Q[Q.início]',
          '4   if Q.início == Q.tamanho',
          '5      Q.início = 1',
          '6   else',
          '7     Q.início = Q.início + 1',
          '8   return x',
        ],
      },
      {
        'title': 'QUEUE-EMPTY(Q)',
        'lines': [
          '1   if Q.inicio == Q.fim',
          '2     return VERDADEIRO',
          '3   else',
          '4     return FALSO',
        ],
      },
      {
        'title': 'QUEUE-FULL(Q)',
        'lines': [
          '1   if Q.inicio == Q.fim + 1',
          'or (Q.inicio == 1 and Q.fim == Q.tamanho)',
          '2     return VERDADE',
          '3   else',
          '4     return FALSO',
        ],
      },
    ],
  };
 final Map<String, List<Map<String, dynamic>>> linkedCode = {
  'Cormen': [
    {
      'title': 'BUSCA-LISTA(L, k)',
      'lines': [
        '1   x = L.início',
        '2   while x ≠ NIL and x.chave ≠ k do',
        '3       x = x.próximo',
        '4   end while',
        '5   return x',
      ],
    },
    {
      'title': 'INSERE-INÍCIO-LISTA(L, x)',
      'lines': [
        '1   x.próximo = L.início',
        '2   x.anterior = NIL',
        '3   if L.início ≠ NIL then',
        '4       L.início.anterior = x',
        '5   end if',
        '6   L.início = x',
      ],
    },
    {
      'title': 'REMOVE-LISTA(L, x)',
      'lines': [
        '1   if x.anterior ≠ NIL then',
        '2       x.anterior.próximo = x.próximo',
        '3   else',
        '4       L.início = x.próximo',
        '5   end if',
        '6   if x.próximo ≠ NIL then',
        '7       x.próximo.anterior = x.anterior',
        '8   end if',
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
      case 'Lista Ligada':        
        return linkedCode;
      case 'Pilha':
      default:
        return pilhaCodeVariants;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final codeVariants = getCodeVariants();
    final currentCode = codeVariants[selected] ?? [];

    if (!codeVariants.containsKey(selected)) {
      selected = 'Cormen';
    }

    return Expanded(
      child: Column(
        children: [
          // Text(
          //   currentDataStructure,
          //   style: TextStyle(
          //     color: theme.textTheme.bodyLarge?.color,
          //     fontWeight: FontWeight.bold,
          //     fontSize: 16,
          //   ),
          // ),
          // const SizedBox(height: 8),
          DropdownButton<String>(
            value: selected,
            dropdownColor: theme.colorScheme.surface,
            style: TextStyle(color: theme.textTheme.bodyLarge?.color),
            items: codeVariants.keys
                .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => selected = value);
                widget.onBookChanged?.call(value);
              }
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: currentCode.asMap().entries.map((entry) {
                  int index = entry.key;
                  var block = entry.value;
                  bool isCurrentBlock = index == currentBlockIndex;

                  return CodeBlock(
                    title: block['title'],
                    lines: List<String>.from(block['lines']),
                    highlightedTitle: isCurrentBlock && highlightTitle,
                    highlightedLine: isCurrentBlock && !highlightTitle
                        ? currentHighlightIndex
                        : null,
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
