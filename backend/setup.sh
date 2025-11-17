#!/bin/bash

echo "🚀 Configurando AlgoBook Backend..."

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Função para imprimir mensagens coloridas
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar se o Dart está instalado
if ! command -v dart &> /dev/null; then
    print_error "Dart não está instalado. Por favor, instale o Dart SDK primeiro."
    echo "Visite: https://dart.dev/get-dart"
    exit 1
fi

print_status "Dart SDK encontrado: $(dart --version)"

# Verificar se o PostgreSQL está disponível
if ! command -v psql &> /dev/null; then
    print_warning "PostgreSQL client não encontrado. Certifique-se de que o PostgreSQL está instalado."
fi

# Instalar dependências
print_status "Instalando dependências..."
dart pub get

if [ $? -ne 0 ]; then
    print_error "Falha ao instalar dependências"
    exit 1
fi

# Verificar se existe arquivo .env
if [ ! -f ".env" ]; then
    print_status "Criando arquivo .env a partir do exemplo..."
    cp .env.example .env
    print_warning "Por favor, edite o arquivo .env com suas configurações antes de continuar."
    echo "Principais configurações necessárias:"
    echo "  - DB_HOST, DB_PORT, DB_NAME, DB_USER, DB_PASS"
    echo "  - JWT_SECRET (use uma chave forte)"
    echo ""
    echo "Execute novamente este script após configurar o .env"
    exit 0
fi

# Carregar variáveis do .env
if [ -f ".env" ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

# Verificar configurações essenciais
if [ -z "$DB_HOST" ] || [ -z "$DB_NAME" ] || [ -z "$JWT_SECRET" ]; then
    print_error "Configurações essenciais não encontradas no .env"
    print_error "Verifique: DB_HOST, DB_NAME, JWT_SECRET"
    exit 1
fi

# Testar conexão com banco de dados (se psql estiver disponível)
if command -v psql &> /dev/null; then
    print_status "Testando conexão com banco de dados..."
    
    # Verificar se o banco existe
    DB_EXISTS=$(PGPASSWORD=$DB_PASS psql -h $DB_HOST -p $DB_PORT -U $DB_USER -lqt | cut -d \| -f 1 | grep -qw $DB_NAME; echo $?)
    
    if [ $DB_EXISTS -ne 0 ]; then
        print_warning "Banco de dados '$DB_NAME' não encontrado."
        read -p "Deseja criar o banco de dados? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            print_status "Criando banco de dados..."
            PGPASSWORD=$DB_PASS createdb -h $DB_HOST -p $DB_PORT -U $DB_USER $DB_NAME
            if [ $? -eq 0 ]; then
                print_status "Banco de dados criado com sucesso!"
            else
                print_error "Falha ao criar banco de dados"
                exit 1
            fi
        else
            print_error "Banco de dados é necessário para continuar"
            exit 1
        fi
    fi
    
    # Executar script de inicialização
    print_status "Executando script de inicialização do banco..."
    PGPASSWORD=$DB_PASS psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f sql/init.sql
    
    if [ $? -eq 0 ]; then
        print_status "Banco de dados inicializado com sucesso!"
    else
        print_error "Falha ao inicializar banco de dados"
        exit 1
    fi
else
    print_warning "PostgreSQL client não disponível. Execute manualmente:"
    print_warning "psql -d $DB_NAME -f sql/init.sql"
fi

# Verificar se o servidor pode ser iniciado
print_status "Testando compilação do servidor..."
dart analyze

if [ $? -ne 0 ]; then
    print_error "Problemas encontrados na análise do código"
    exit 1
fi

print_status "Setup concluído com sucesso!"
echo ""
echo "Para iniciar o servidor:"
echo "  dart run bin/server.dart"
echo ""
echo "Ou para desenvolvimento com hot reload:"
echo "  dart run --enable-vm-service bin/server.dart"
echo ""
echo "Servidor estará disponível em: http://localhost:${PORT:-8080}"

# Mostrar endpoints disponíveis
echo ""
echo "Endpoints disponíveis:"
echo "  GET  /              - Documentação da API"
echo "  GET  /health        - Health check"
echo "  POST /auth/google   - Autenticação Google"
echo "  GET  /api/user/*    - APIs do usuário (requer auth)"
echo "  GET  /api/study/*   - APIs de estudo (requer auth)"
