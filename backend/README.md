# Bookrithm Backend

Backend da aplicação Bookrithm - Simulador de algoritmos e estruturas de dados com autenticação Google e armazenamento de progresso do usuário.

## Funcionalidades

- 🔐 **Autenticação Google OAuth**: Login seguro usando conta Google
- 📊 **Gerenciamento de Sessões**: Armazenamento de sessões de estudo das estruturas de dados
- 📈 **Progresso do Usuário**: Acompanhamento do progresso por estrutura de dados
- 🏗️ **Estruturas Suportadas**: Pilha, Fila, Árvore Binária, Lista Ligada
- 🔒 **APIs Protegidas**: Middleware de autenticação JWT
- 💾 **PostgreSQL**: Armazenamento persistente de dados

## Estrutura do Projeto

```
backend/
├── lib/
│   ├── api/              # APIs REST
│   │   ├── auth_api.dart    # Autenticação Google
│   │   ├── study_api.dart   # Sessões de estudo
│   │   └── user_api.dart    # Perfil do usuário
│   ├── db/
│   │   └── connection.dart  # Conexão PostgreSQL
│   ├── middleware/
│   │   └── auth_middleware.dart # Middleware JWT
│   ├── models/           # Modelos de dados
│   │   ├── user.dart
│   │   ├── study_session.dart
│   │   └── user_progress.dart
│   └── utils/
│       └── jwt.dart         # Utilitários JWT
├── sql/
│   └── init.sql            # Script de inicialização do banco
├── bin/
│   └── server.dart         # Servidor principal
└── .env.example           # Exemplo de configuração
```

## Configuração

### 1. Pré-requisitos

- Dart SDK 3.8.1+
- PostgreSQL 12+
- Conta Google Cloud (para OAuth)

### 2. Instalação

```bash
# Clonar o repositório
cd backend

# Instalar dependências
dart pub get

# Configurar variáveis de ambiente
cp .env.example .env
# Editar .env com suas configurações
```

### 3. Configuração do Banco de Dados

```bash
# Criar banco de dados
createdb bookrithm

# Executar script de inicialização
psql -d bookrithm -f sql/init.sql
```

### 4. Configuração Google OAuth

1. Acesse [Google Cloud Console](https://console.cloud.google.com/)
2. Crie um novo projeto ou selecione um existente
3. Habilite a Google+ API
4. Crie credenciais OAuth 2.0
5. Configure as URLs de callback
6. Adicione o Client ID no arquivo .env

### 5. Executar Servidor

```bash
# Desenvolvimento
dart run bin/server.dart

# Ou usando o comando dart
dart bin/server.dart
```

O servidor estará disponível em `http://localhost:8080`

## APIs Disponíveis

### Autenticação

- `POST /auth/google` - Login com Google OAuth

### Usuário (Requer Autenticação)

- `GET /api/user/profile` - Perfil do usuário
- `PUT /api/user/profile` - Atualizar perfil
- `DELETE /api/user/account` - Deletar conta
- `GET /api/user/stats` - Estatísticas do usuário

### Estudos (Requer Autenticação)

- `GET /api/study/sessions` - Listar sessões de estudo
- `POST /api/study/sessions` - Criar nova sessão
- `GET /api/study/sessions/:id` - Obter sessão específica
- `GET /api/study/progress` - Progresso do usuário

### Utilitários

- `GET /health` - Health check
- `GET /` - Documentação da API

## Exemplo de Uso

### 1. Autenticação

```bash
curl -X POST http://localhost:8080/auth/google \
  -H "Content-Type: application/json" \
  -d '{"token": "seu_google_id_token"}'
```

### 2. Criar Sessão de Estudo

```bash
curl -X POST http://localhost:8080/api/study/sessions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer seu_jwt_token" \
  -d '{
    "data_structure_type": "stack",
    "state": {"elements": [1, 2, 3]},
    "operations": ["push(1)", "push(2)", "push(3)"],
    "duration": 120
  }'
```

### 3. Obter Progresso

```bash
curl -X GET http://localhost:8080/api/study/progress \
  -H "Authorization: Bearer seu_jwt_token"
```

## Modelos de Dados

### User
```dart
{
  "id": 1,
  "email": "user@example.com",
  "name": "João Silva",
  "created_at": "2024-01-01T00:00:00Z"
}
```

### StudySession
```dart
{
  "id": 1,
  "user_id": 1,
  "data_structure_type": "stack",
  "state": {"elements": [1, 2, 3]},
  "operations": ["push(1)", "push(2)", "push(3)"],
  "duration": 120,
  "created_at": "2024-01-01T00:00:00Z"
}
```

### UserProgress
```dart
{
  "total_sessions": 10,
  "total_duration": 1200,
  "total_operations": 50,
  "progress_by_structure": {
    "stack": {
      "total_sessions": 5,
      "total_duration": 600,
      "total_operations": 25
    }
  }
}
```

## Desenvolvimento

### Executar Testes

```bash
dart test
```

### Lint

```bash
dart analyze
```

### Format

```bash
dart format .
```

## Deploy

### Docker (Recomendado)

```dockerfile
FROM dart:stable AS build

WORKDIR /app
COPY pubspec.* ./
RUN dart pub get

COPY . .
RUN dart compile exe bin/server.dart -o bin/server

FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/

EXPOSE 8080
ENTRYPOINT ["/app/bin/server"]
```

### Variáveis de Ambiente de Produção

```bash
DB_HOST=seu_postgres_host
DB_PORT=5432
DB_NAME=bookrithm_prod
DB_USER=bookrithm_user
DB_PASS=senha_forte
JWT_SECRET=chave_jwt_muito_forte_producao
ENVIRONMENT=production
```

## Contribuição

1. Fork o projeto
2. Crie uma branch para sua feature
3. Commit suas mudanças
4. Push para a branch
5. Abra um Pull Request

## Licença

Este projeto está sob a licença MIT. Veja o arquivo LICENSE para mais detalhes.
