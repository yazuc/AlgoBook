-- Criação das tabelas para o sistema Bookrithm

-- Extensão para UUID (opcional)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Tabela de usuários
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    google_id VARCHAR(255) UNIQUE NOT NULL,
    email VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Índices para a tabela users
CREATE INDEX IF NOT EXISTS idx_users_google_id ON users(google_id);
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

-- Tabela de sessões de estudo
CREATE TABLE IF NOT EXISTS study_sessions (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    data_structure_type VARCHAR(50) NOT NULL, -- 'stack', 'queue', 'binary_tree', 'linked_list'
    state JSONB NOT NULL, -- Estado da estrutura de dados
    operations JSONB NOT NULL, -- Array de operações realizadas
    duration INTEGER NOT NULL DEFAULT 0, -- Duração em segundos
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Índices para a tabela study_sessions
CREATE INDEX IF NOT EXISTS idx_study_sessions_user_id ON study_sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_study_sessions_type ON study_sessions(data_structure_type);
CREATE INDEX IF NOT EXISTS idx_study_sessions_created_at ON study_sessions(created_at);

-- Tabela de progresso do usuário por estrutura de dados
CREATE TABLE IF NOT EXISTS user_progress (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    data_structure_type VARCHAR(50) NOT NULL,
    total_sessions INTEGER DEFAULT 0,
    total_duration INTEGER DEFAULT 0, -- em segundos
    total_operations INTEGER DEFAULT 0,
    operation_counts JSONB DEFAULT '{}', -- contagem por tipo de operação
    last_study_at TIMESTAMP DEFAULT NOW(),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(user_id, data_structure_type)
);

-- Índices para a tabela user_progress
CREATE INDEX IF NOT EXISTS idx_user_progress_user_id ON user_progress(user_id);
CREATE INDEX IF NOT EXISTS idx_user_progress_type ON user_progress(data_structure_type);
CREATE INDEX IF NOT EXISTS idx_user_progress_last_study ON user_progress(last_study_at);

-- Função para atualizar updated_at automaticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers para atualizar updated_at
DROP TRIGGER IF EXISTS update_users_updated_at ON users;
CREATE TRIGGER update_users_updated_at 
    BEFORE UPDATE ON users 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_study_sessions_updated_at ON study_sessions;
CREATE TRIGGER update_study_sessions_updated_at 
    BEFORE UPDATE ON study_sessions 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_user_progress_updated_at ON user_progress;
CREATE TRIGGER update_user_progress_updated_at 
    BEFORE UPDATE ON user_progress 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Inserir dados de exemplo (opcional)
-- INSERT INTO users (google_id, email, name) VALUES 
-- ('123456789', 'user@example.com', 'Usuário Teste')
-- ON CONFLICT (google_id) DO NOTHING;

-- Comentários para documentação
COMMENT ON TABLE users IS 'Tabela de usuários autenticados via Google';
COMMENT ON TABLE study_sessions IS 'Sessões de estudo das estruturas de dados';
COMMENT ON TABLE user_progress IS 'Progresso acumulado do usuário por estrutura de dados';

COMMENT ON COLUMN study_sessions.data_structure_type IS 'Tipo da estrutura: stack, queue, binary_tree, linked_list';
COMMENT ON COLUMN study_sessions.state IS 'Estado JSON da estrutura no final da sessão';
COMMENT ON COLUMN study_sessions.operations IS 'Array JSON das operações realizadas na sessão';
COMMENT ON COLUMN study_sessions.duration IS 'Duração da sessão em segundos';

COMMENT ON COLUMN user_progress.operation_counts IS 'Contagem de operações por tipo (push, pop, enqueue, etc.)';
