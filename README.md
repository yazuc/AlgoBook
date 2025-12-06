# AlgoBook

Simulador interativo de algoritmos e estruturas de dados, desenvolvido em Flutter com foco educacional. Uma ferramenta multiplataforma para visualizar e aprender sobre estruturas de dados fundamentais.

## Características

- **Visualização Interativa**: Experimente estruturas de dados em tempo real
- **Múltiplas Estruturas**: Pilha, Fila, Árvore Binária e Lista Ligada
- **Código de Referência**: Visualize algoritmos do livro "Algoritmos" de Cormen et al.
- **Interface Moderna**: Suporte a tema claro e escuro
- **Multiplataforma**: Funciona em Windows, Linux, macOS, Web, Android e iOS
- **Terminal Integrado**: Acompanhe operações em tempo real
- **Exercícios Práticos**: Pratique com exercícios interativos

## Estruturas de Dados Implementadas

- **Pilha (Stack)** - LIFO (Last In, First Out)
- **Fila (Queue)** - FIFO (First In, First Out)
- **Árvore Binária de Busca** - Estrutura hierárquica ordenada
- **Lista Ligada Dupla** - Lista encadeada bidirecional

## Instalação

### Pré-requisitos

- Flutter SDK 3.7.2 ou superior
- Dart SDK 3.7.2 ou superior

### Passos de Instalação

1. **Clone o repositório**
   ```bash
   git clone https://github.com/yazuc/AlgoBook.git
   cd AlgoBook
   ```

2. **Instale as dependências**
   ```bash
   flutter pub get
   ```

3. **Execute o aplicativo**
   ```bash
   flutter run
   ```

## Build

### Build para Desktop (Linux/Windows/macOS)
```bash
flutter build
```

Isso gera binários executáveis para o sistema operacional atual.

### Build para Web
```bash
flutter build web
```

### Build para Android
```bash
flutter build apk
# ou
flutter build appbundle
```

**Nota**: Para builds Android, é necessário ter o Android Studio instalado e configurado.

### Build para iOS
```bash
flutter build ios
```

**Nota**: Para builds iOS, é necessário ter um Mac com Xcode instalado.

## Acesso

- **Web**: Acesse via [https://yazuc.github.io/](https://yazuc.github.io/)
- **Downloads**: Binários pré-compilados disponíveis em [Releases](https://github.com/yazuc/AlgoBook/releases)

## Estrutura do Projeto

```
AlgoBook/
├── lib/
│   ├── data_structures/      # Implementações das estruturas de dados
│   │   ├── stack.dart
│   │   ├── queue.dart
│   │   ├── binary_tree.dart
│   │   └── linked_list.dart
│   ├── view_structures/       # Visualizações das estruturas
│   ├── widgets/               # Componentes reutilizáveis
│   │   ├── common/
│   │   └── registry/
│   ├── view_controller/       # Controladores de visualização
│   ├── exercises/             # Modelos de exercícios
│   ├── themes.dart            # Temas claro/escuro
│   └── main.dart              # Ponto de entrada
├── assets/
│   ├── chapters/              # Capítulos do livro em Markdown
│   └── exercises/             # Exercícios em JSON
├── test/                      # Testes unitários
└── backend/                   # Backend (opcional)

```

## Testes

Execute os testes com:
```bash
flutter test
```

## Contribuindo

Contribuições são bem-vindas! Por favor, leia o [CONTRIBUTING.md](CONTRIBUTING.md) para detalhes sobre nosso código de conduta e processo de submissão de pull requests.

## Licença

Este projeto está licenciado sob a licença especificada no arquivo [LICENSE](LICENSE).

## Autores

- **yazuc** - Desenvolvimento inicial

## Agradecimentos

- Livro "Algoritmos: Teoria e Prática" de Thomas H. Cormen et al.
- Comunidade Flutter
- Todos os contribuidores do projeto

## Recursos Adicionais

- [Documentação Flutter](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
