import 'package:flutter/material.dart';
import '../widgets/common/data_structure_view.dart';
import '../data_structures/stack.dart';

/// Widget para visualização de uma pilha (stack).
///
/// Este widget implementa a interface DataStructureView e permite
/// a visualização interativa de uma pilha com funções para:
/// - Push: adicionar elementos ao topo da pilha
/// - Pop: remover o elemento do topo da pilha
/// - Verificar se a pilha está vazia
class StackView extends StatefulWidget implements DataStructureView {
  /// A pilha a ser visualizada
  final CustomStack<int> stack;
  
  /// Tamanho máximo da pilha que pode ser visualizada
  final int maxSize;
  
  /// Controlador para o campo de texto de entrada
  final TextEditingController pushController;
  
  /// Função de callback para enviar logs ao terminal
  final Function(String) onLog;
  final Function(String) onHighlightCode;

  const StackView({
    super.key, 
    required this.stack, 
    required this.maxSize,
    required this.pushController,
    required this.onLog,
    required this.onHighlightCode
  });

  @override
  State<StackView> createState() => _StackViewState();
}

class _StackViewState extends State<StackView> {
  @override
  void initState() {
    super.initState();
    // Registra um listener para atualizar a UI quando a pilha mudar
    widget.stack.addListener(_onStackChanged);
  }

  @override
  void dispose() {
    // Remove o listener ao descartar o widget
    widget.stack.removeListener(_onStackChanged);
    super.dispose();
  }

  /// Callback chamado quando a pilha é modificada
  ///
  /// Atualiza o estado do widget para refletir as mudanças na pilha
  void _onStackChanged() {
    setState(() {});
  }
  
  @override
  Widget build(BuildContext context) {
    // Cria uma lista de tamanho fixo para mostrar os elementos da pilha
    List<int?> displayStack = List.filled(widget.maxSize, null);
    
    // Preenche a lista de exibição com os valores da memória da pilha
    for (int i = 0; i < widget.stack.memory.length && i < widget.maxSize; i++) {
      displayStack[i] = widget.stack.memory[i];
    }

    return Column(
      children: [
        // Visualização das células da pilha
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.maxSize,
            (index) {
              final value = displayStack[index];
              final isActive = index < widget.stack.elements.length;
              return StackCell(
                value: value,
                index: index + 1,
                length: widget.maxSize,
                isTop: index == widget.stack.elements.length - 1,
                isTrash: !isActive && value != null,
              );
            },
          ),
        ),
        SizedBox(height: 20),
        // Controles da pilha (Push, Pop, Empty)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Input field
            SizedBox(
              width: 80,
              child: TextField(
                controller: widget.pushController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Valor',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(width: 16),

            // Push Button
            ElevatedButton(
              onPressed: () async {
                final text = widget.pushController.text.trim();                
                if (text.isNotEmpty && int.tryParse(text) != null) {
                  int value = int.parse(text);
                  if (widget.stack.elements.length < widget.maxSize) {
                    widget.onLog("A pilha S após a chamada Push(S, $value)");
                    await widget.onHighlightCode("Push(S, x)");
                    widget.stack.push(value);
                  } else {
                    widget.onLog("error \"overflow\"");
                  }
                  widget.pushController.clear();
                } else {
                  widget.onLog("error Invalid input");
                }
              },
              child: Text('Push(S, x)'),
            ),
            SizedBox(width: 16),

            // Pop Button
            ElevatedButton(
              onPressed: () async {
                if (widget.stack.elements.isEmpty) {
                  widget.onLog("error \"underflow\"");
                } else {
                  widget.onLog("A pilha S após a chamada Pop(S)");
                  await widget.onHighlightCode("Pop(S)");
                  widget.stack.pop();
                }
              },
              child: Text('Pop(S)'),
            ),
            SizedBox(width: 16),

            // Empty Button
            ElevatedButton(
              onPressed: () async {
                widget.onLog(
                  widget.stack.elements.isEmpty
                      ? "A pilha está vazia"
                      : "A pilha não está vazia"
                );
                await widget.onHighlightCode("Pilha-Vazia(S)");
              },
              child: Text('Pilha-Vazia(S)'),
            ),
          ],
        ),
      ],
    );
  }
}

/// Widget que representa uma célula individual na visualização da pilha.
///
/// Cada célula mostra um valor da pilha, com indicação visual
/// especial para o elemento do topo e células que contêm
/// valores antigos (lixo).
class StackCell extends StatelessWidget {
  final int? value;
  final int index;  
  final bool isTop;  
  final bool isTrash;
  final int length;
  final double widthBorder = 1.2;

  const StackCell({
    super.key,
    this.value,
    required this.index,
    required this.isTop,
    required this.length,
    this.isTrash = false,
  });

  @override
  Widget build(BuildContext context) {
    // Determina a cor de fundo da célula com base em seu estado
    Color backgroundColor;
    if (value == null) {
      backgroundColor = const Color.fromARGB(192,188,188, 188); 
    } else if (isTrash) {
      backgroundColor =const Color.fromARGB(192,188,188, 188);  // or another "trash" color
    } else {
      backgroundColor = Colors.white;
    }

    return SizedBox(
      height: 120,
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          // Indicador 'S' para a primeira célula
          if (index == 1)
            Positioned(
              left: -25,
              top: 15,
              child: Text(
                'S',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: "Callibri"),
              ),
            ),
           // Índice da célula
           Positioned(
            top: -30,
            child: Text(
              index.toString(),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: "Callibri"),
            ),
          ),
          // Célula principal
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(color: Colors.black, width: widthBorder),
                  left: BorderSide(color: Colors.black, width: widthBorder),
                  bottom: BorderSide(color: Colors.black, width: widthBorder),
                  right: BorderSide(color: Colors.black, width: index == length ? widthBorder : 0.2,),
              ),
              color: backgroundColor,
            ),
            alignment: Alignment.center,
            child: Text(
              value?.toString() ?? '',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          // Indicador de topo da pilha
          if (isTop)
            Positioned(
              top: 55,
              child: Text('      ↑\nS.top = $index', style: TextStyle(fontSize: 20)),
            ),
        ],
      ),
    );
  }
} 