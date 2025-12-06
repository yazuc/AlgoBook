# Guia de Contribuição para AlgoBook

Obrigado por considerar contribuir com o AlgoBook! Este documento fornece diretrizes para contribuir com o projeto.

## Índice

- [Código de Conduta](#código-de-conduta)
- [Como Contribuir](#como-contribuir)
- [Processo de Desenvolvimento](#processo-de-desenvolvimento)
- [Padrões de Código](#padrões-de-código)
- [Testes](#testes)
- [Documentação](#documentação)
- [Submissão de Pull Requests](#submissão-de-pull-requests)

## Código de Conduta

Este projeto segue um código de conduta. Ao participar, você concorda em manter um ambiente respeitoso e acolhedor para todos.

## Como Contribuir

### Reportando Bugs

Se você encontrou um bug:

1. Verifique se o bug já não foi reportado nas [Issues](https://github.com/yazuc/AlgoBook/issues)
2. Se não foi reportado, crie uma nova issue com:
   - Título descritivo
   - Descrição clara do problema
   - Passos para reproduzir
   - Comportamento esperado vs. comportamento atual
   - Screenshots (se aplicável)
   - Informações do ambiente (SO, versão do Flutter, etc.)

### Sugerindo Melhorias

Para sugerir novas funcionalidades ou melhorias:

1. Verifique se a sugestão já não existe nas Issues
2. Crie uma issue com o label "enhancement"
3. Descreva claramente:
   - O problema que a melhoria resolveria
   - Como você imagina que funcionaria
   - Possíveis alternativas consideradas

### Contribuindo com Código

1. **Fork o repositório**
2. **Crie uma branch para sua feature/fix**
   ```bash
   git checkout -b feature/nome-da-sua-feature
   # ou
   git checkout -b fix/nome-do-bug
   ```

3. **Faça suas alterações**
   - Siga os padrões de código do projeto
   - Adicione testes quando apropriado
   - Atualize a documentação se necessário

4. **Commit suas mudanças**
   ```bash
   git commit -m "feat: adiciona nova funcionalidade X"
   # ou
   git commit -m "fix: corrige bug Y"
   ```

   Use mensagens de commit descritivas seguindo o padrão [Conventional Commits](https://www.conventionalcommits.org/):
   - `feat:` para novas funcionalidades
   - `fix:` para correções de bugs
   - `docs:` para mudanças na documentação
   - `style:` para formatação, ponto e vírgula faltando, etc.
   - `refactor:` para refatoração de código
   - `test:` para adicionar ou corrigir testes
   - `chore:` para mudanças em build, dependências, etc.

5. **Push para sua branch**
   ```bash
   git push origin feature/nome-da-sua-feature
   ```

6. **Abra um Pull Request**
   - Descreva claramente o que foi alterado e por quê
   - Referencie issues relacionadas
   - Adicione screenshots se for uma mudança visual

## Processo de Desenvolvimento

### Configuração do Ambiente

1. Instale o Flutter SDK (versão 3.7.2 ou superior)
2. Clone o repositório
3. Execute `flutter pub get` para instalar dependências
4. Execute `flutter analyze` para verificar problemas de código
5. Execute `flutter test` para rodar os testes

### Estrutura de Branches

- `master` - Branch principal, código estável
- `develop` - Branch de desenvolvimento (se existir)
- `feature/*` - Novas funcionalidades
- `fix/*` - Correções de bugs
- `docs/*` - Melhorias na documentação

## Padrões de Código

### Dart/Flutter Style Guide

Seguimos o [Effective Dart](https://dart.dev/guides/language/effective-dart) e o [Flutter Style Guide](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo).

### Convenções Importantes

1. **Nomenclatura**:
   - Classes: `PascalCase`
   - Variáveis e funções: `camelCase`
   - Constantes: `lowerCamelCase` ou `UPPER_CASE_WITH_UNDERSCORES`
   - Arquivos: `snake_case.dart`

2. **Documentação**:
   - Use comentários doc (`///`) para classes públicas e métodos importantes
   - Explique o "porquê", não o "o quê"
   - Mantenha comentários atualizados

3. **Formatação**:
   - Execute `dart format .` antes de commitar
   - Use 2 espaços para indentação
   - Máximo de 80 caracteres por linha (quando possível)

4. **Imports**:
   - Ordene imports: `dart:`, `package:`, `relative:`
   - Use imports específicos quando possível

### Exemplo de Código

```dart
/// Implementação de uma estrutura de dados genérica.
///
/// Esta classe fornece funcionalidades básicas para
/// estruturas de dados lineares.
class CustomDataStructure<T> extends ChangeNotifier {
  /// Lista interna de elementos
  final List<T> _elements = [];

  /// Adiciona um elemento à estrutura.
  ///
  /// [value] O valor a ser adicionado.
  /// Retorna true se a operação foi bem-sucedida.
  bool add(T value) {
    _elements.add(value);
    notifyListeners();
    return true;
  }

  /// Retorna uma lista não-modificável dos elementos.
  List<T> get elements => List.unmodifiable(_elements);
}
```

## Testes

### Escrevendo Testes

- Adicione testes para novas funcionalidades
- Mantenha a cobertura de testes alta
- Teste casos de sucesso e falha
- Use nomes descritivos para os testes

### Exemplo de Teste

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:AlgoBook/data_structures/stack.dart';

void main() {
  group('CustomStack', () {
    late CustomStack<int> stack;

    setUp(() {
      stack = CustomStack<int>();
    });

    test('deve estar vazia inicialmente', () {
      expect(stack.isEmpty, isTrue);
    });

    test('deve adicionar elemento corretamente', () {
      stack.push(42);
      expect(stack.isEmpty, isFalse);
      expect(stack.peek, equals(42));
    });
  });
}
```

### Executando Testes

```bash
# Todos os testes
flutter test

# Testes específicos
flutter test test/data_structures/stack_test.dart

# Com cobertura
flutter test --coverage
```

## Documentação

### Documentação de Código

- Documente classes públicas e métodos importantes
- Use exemplos quando apropriado
- Mantenha a documentação atualizada

### Documentação do Projeto

- Atualize o README.md para mudanças significativas
- Adicione exemplos de uso quando apropriado
- Mantenha a documentação clara e concisa

## 🔍 Submissão de Pull Requests

### Checklist Antes de Submeter

- [ ] Código segue os padrões do projeto
- [ ] Testes foram adicionados/atualizados
- [ ] Todos os testes passam (`flutter test`)
- [ ] Análise estática passou (`flutter analyze`)
- [ ] Documentação foi atualizada
- [ ] Commits seguem o padrão Conventional Commits
- [ ] Branch está atualizada com `master`

### Template de Pull Request

```markdown
## Descrição
Breve descrição das mudanças.

## Tipo de Mudança
- [ ] Bug fix
- [ ] Nova funcionalidade
- [ ] Breaking change
- [ ] Documentação

## Como foi testado?
Descreva os testes realizados.

## Checklist
- [ ] Meu código segue os padrões do projeto
- [ ] Realizei uma auto-revisão do código
- [ ] Comentei código complexo
- [ ] Minhas mudanças não geram warnings
- [ ] Adicionei testes que provam que minha correção é efetiva
- [ ] Testes novos e existentes passam localmente
- [ ] Atualizei a documentação conforme necessário
```

## Dúvidas?

Se você tiver dúvidas sobre como contribuir:

1. Verifique as [Issues](https://github.com/yazuc/AlgoBook/issues) existentes
2. Abra uma nova issue com a tag "question"
3. Entre em contato com os mantenedores
