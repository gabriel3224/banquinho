/* Tabela do usuario */
CREATE TABLE USUARIO (
    USERNAME VARCHAR(15) NOT NULL,
    NOME VARCHAR(50) NOT NULL,
    CARGO CHAR(13) NOT NULL,
    CONSTRAINT PK_USERNAME PRIMARY KEY (USERNAME),
    CONSTRAINT CK_CARGO CHECK (UPPER(CARGO) IN ('ADMINISTRADOR','MOCHILEIRO','ESPECIALISTA', 'ORGANIZADOR'))
);

CREATE TABLE ADMINISTRADOR (
    USERNAME VARCHAR(15) NOT NULL,
    CONSTRAINT FK_ADMINISTRADOR FOREIGN KEY (USERNAME) 
        REFERENCES USUARIO(USERNAME)                     
        ON DELETE CASCADE,
    CONSTRAINT PK_ADMINISTRADOR PRIMARY KEY (USERNAME)
);

CREATE TABLE MOCHILEIRO (
    USERNAME VARCHAR(15) NOT NULL,
    CONSTRAINT FK_MOCHILEIRO FOREIGN KEY (USERNAME) 
        REFERENCES USUARIO(USERNAME)                     
        ON DELETE CASCADE,
    CONSTRAINT PK_MOCHILEIRO PRIMARY KEY (USERNAME) 
);

CREATE TABLE ESPECIALISTA (
    USERNAME VARCHAR(15) NOT NULL,
    CONSTRAINT FK_ESPECIALISTA FOREIGN KEY (USERNAME) 
        REFERENCES USUARIO(USERNAME)                     
        ON DELETE CASCADE,
    CONSTRAINT PK_ESPECIALISTA PRIMARY KEY (USERNAME) 
);

CREATE TABLE ORGANIZADOR (
    USERNAME VARCHAR(15) NOT NULL,
    CONSTRAINT FK_ORGANIZADOR FOREIGN KEY (USERNAME) 
        REFERENCES USUARIO(USERNAME)                     
        ON DELETE CASCADE,
    CONSTRAINT PK_ORGANIZADOR PRIMARY KEY (USERNAME) 
);

CREATE TABLE CONTATO (
    USERNAME VARCHAR(15) NOT NULL,
    CONTATO VARCHAR(30) NOT NULL,
    CONSTRAINT FK_CONTATO FOREIGN KEY (USERNAME) 
        REFERENCES USUARIO(USERNAME)                     
        ON DELETE CASCADE,
    CONSTRAINT PK_CONTATO PRIMARY KEY (USERNAME, CONTATO)
);

CREATE TABLE CONDICOES_MEDICAS (
    USERNAME VARCHAR(15) NOT NULL,
    CONDICAO VARCHAR(50) NOT NULL,
    CONSTRAINT FK_CONDICAO FOREIGN KEY (USERNAME) 
        REFERENCES USUARIO(USERNAME)                     
        ON DELETE CASCADE,
    CONSTRAINT PK_CONDICAO PRIMARY KEY (USERNAME, CONDICAO)
);

CREATE TABLE QUALIFICACOES (
    USERNAME VARCHAR(15) NOT NULL,
    QUALIFICACAO VARCHAR(25) NOT NULL,
    CONSTRAINT FK_QUALIFICACAO FOREIGN KEY (USERNAME) 
        REFERENCES USUARIO(USERNAME)                     
        ON DELETE CASCADE,
    CONSTRAINT PK_QUALIFICACAO PRIMARY KEY (USERNAME, QUALIFICACAO)
);

CREATE TABLE AUTORIZACOES_LEGAIS (
    ORGANIZADOR VARCHAR(15) NOT NULL,
    AUTORIZACAO VARCHAR(30) NOT NULL,
    CONSTRAINT FK_AUTORIZACAO FOREIGN KEY (ORGANIZADOR) 
        REFERENCES ORGANIZADOR(USERNAME)                      
        ON DELETE CASCADE,
    CONSTRAINT PK_AUTORIZACAO PRIMARY KEY (ORGANIZADOR, AUTORIZACAO)
);

/* Entidade caravana */ 
CREATE TABLE CARAVANA (
    ORGANIZADOR VARCHAR(15) NOT NULL,
    CODIGO_INTERNO CHAR(10) NOT NULL,
    NOME VARCHAR(30) NOT NULL,
    PARTIDA TIMESTAMP NOT NULL,
    CHEGADA TIMESTAMP NOT NULL,
    DESCRICAO TEXT,
    CONSTRAINT FK_CARAVANA FOREIGN KEY (ORGANIZADOR) 
        REFERENCES ORGANIZADOR(USERNAME)                      
        ON DELETE CASCADE,
    CONSTRAINT PK_CARAVANA PRIMARY KEY (ORGANIZADOR, CODIGO_INTERNO)
);

/* Entidade ponto turistico */
CREATE TABLE PONTO_TURISTICO (
    ID SERIAL NOT NULL,
    NOME VARCHAR(30),
    LATITUDE REAL NOT NULL,
    LONGITUDE REAL NOT NULL,    
    ALTITUDE REAL NOT NULL,
    PAIS CHAR(20) NOT NULL,
    DESCRICAO TEXT,

    CONSTRAINT PK_PONTO_TURISTICO PRIMARY KEY (ID),
    CONSTRAINT SK_PONTO_TURISTICO UNIQUE(NOME, LATITUDE, LONGITUDE, ALTITUDE)
);

CREATE TABLE REQUISITOS (
    PONTO_TURISTICO INTEGER NOT NULL,
    REQUISITO VARCHAR(40) NOT NULL,
    CONSTRAINT FK_PONTO_TURISTICO FOREIGN KEY (PONTO_TURISTICO) 
        REFERENCES PONTO_TURISTICO(ID)                      
        ON DELETE CASCADE,
    CONSTRAINT PK_REQUISITO PRIMARY KEY (PONTO_TURISTICO, REQUISITO)
);

/* Entidade itinerario */
CREATE TABLE ITINERARIO (
    ID SERIAL NOT NULL,
    ORGANIZADOR VARCHAR(15) NOT NULL,
    CODIGO_INTERNO CHAR(10) NOT NULL,
    INICIO TIMESTAMP NOT NULL,
    FIM TIMESTAMP NOT NULL,
    PONTO_TURISTICO INTEGER NOT NULL,
    CONSTRAINT FK_ITINERARIO_PONTO_TURISTICO FOREIGN KEY (PONTO_TURISTICO) 
        REFERENCES PONTO_TURISTICO(ID)                      
        ON DELETE CASCADE,
    CONSTRAINT FK_ITINERARIO_CARAVANA FOREIGN KEY (ORGANIZADOR, CODIGO_INTERNO) 
        REFERENCES CARAVANA(ORGANIZADOR, CODIGO_INTERNO)                      
        ON DELETE CASCADE,
    CONSTRAINT PK_ITINERARIO PRIMARY KEY (ID),
    CONSTRAINT SK_ITINERARIO UNIQUE(ORGANIZADOR, CODIGO_INTERNO, INICIO)
);

/* Tabela da entidade atividade */
CREATE TABLE ATIVIDADE (
    ID SERIAL NOT NULL,
    ITINERARIO INTEGER NOT NULL,
    NOME VARCHAR(40) NOT NULL,
    INICIO TIMESTAMP NOT NULL,
    FIM TIMESTAMP NOT NULL,
    DESCRICAO TEXT,
    PAIS CHAR(20) NOT NULL,
    LATITUDE REAL NOT NULL,
    LONGITUDE REAL NOT NULL,
    ALTITUDE REAL NOT NULL,
    CONSTRAINT FK_ATIVIDADE FOREIGN KEY (ITINERARIO) 
        REFERENCES ITINERARIO(ID)                      
        ON DELETE CASCADE,
    CONSTRAINT PK_ATIVIDADE PRIMARY KEY (ID),
    CONSTRAINT SK_ATIVIDADE UNIQUE(ITINERARIO, NOME, INICIO)
);

CREATE TABLE RESTRICOES (
    ATIVIDADE INTEGER NOT NULL,
    RESTRICAO VARCHAR(50) NOT NULL,
    CONSTRAINT FK_RESTRICAO FOREIGN KEY (ATIVIDADE) 
        REFERENCES ATIVIDADE(ID)                      
        ON DELETE CASCADE,
    CONSTRAINT PK_RESTRICAO PRIMARY KEY (ATIVIDADE, RESTRICAO)
);

/* Entidade grupo de participantes */
CREATE TABLE GRUPO_DE_PARTICIPANTES (
    ATIVIDADE INTEGER NOT NULL,
    CATEGORIA VARCHAR(30) NOT NULL,
    GASTOS_GANHOS REAL,
    CONSTRAINT FK_GRUPO_DE_PARTICIPANTES FOREIGN KEY (ATIVIDADE) 
        REFERENCES ATIVIDADE(ID)                      
        ON DELETE CASCADE,
    CONSTRAINT PK_GRUPO_DE_PARTICIPANTES PRIMARY KEY (ATIVIDADE, CATEGORIA)
);

CREATE TABLE QUALIFICACOES_NECESSARIAS (
    ATIVIDADE INTEGER NOT NULL,
    CATEGORIA VARCHAR(30) NOT NULL,
    QUALIFICACAO_NECESSARIA VARCHAR(20),
    CONSTRAINT FK_QUALIFICACOES_NECESSARIAS FOREIGN KEY (ATIVIDADE, CATEGORIA) 
        REFERENCES GRUPO_DE_PARTICIPANTES(ATIVIDADE, CATEGORIA)                      
        ON DELETE CASCADE,
    CONSTRAINT PK_QUALIFICACOES_NECESSARIAS PRIMARY KEY (ATIVIDADE, CATEGORIA, QUALIFICACAO_NECESSARIA)
);

CREATE TABLE INSTRUMENTOS_NECESSARIOS (
    ATIVIDADE INTEGER NOT NULL,
    CATEGORIA VARCHAR(30) NOT NULL,
    INSTRUMENTO_NECESSARIO VARCHAR(40),
    CONSTRAINT FK_INSTRUMENTOS_NECESSARIOS FOREIGN KEY (ATIVIDADE, CATEGORIA) 
        REFERENCES GRUPO_DE_PARTICIPANTES(ATIVIDADE, CATEGORIA)                      
        ON DELETE CASCADE,
    CONSTRAINT PK_INSTRUMENTOS_NECESSARIOS PRIMARY KEY (ATIVIDADE, CATEGORIA, INSTRUMENTO_NECESSARIO)
);

CREATE TABLE INSTRUMENTOS_PROVIDENCIADOS (
    ATIVIDADE INTEGER NOT NULL,
    CATEGORIA VARCHAR(30) NOT NULL,
    INSTRUMENTO_PROVIDENCIADO VARCHAR(40),
    CONSTRAINT FK_INSTRUMENTOS_PROVIDENCIADOS FOREIGN KEY (ATIVIDADE, CATEGORIA) 
        REFERENCES GRUPO_DE_PARTICIPANTES(ATIVIDADE, CATEGORIA)                      
        ON DELETE CASCADE,
    CONSTRAINT PK_INSTRUMENTOS_PROVIDENCIADOS PRIMARY KEY (ATIVIDADE, CATEGORIA, INSTRUMENTO_PROVIDENCIADO)
);

/* Entidade estadia */
CREATE TABLE ESTADIA (
    ID SERIAL NOT NULL,
    ENDERECO_POSTAL VARCHAR(60) NOT NULL,
    CHECK_IN TIMESTAMP NOT NULL,
    CHECK_OUT TIMESTAMP NOT NULL,
    LOTACAO_MAXIMA INTEGER NOT NULL,
    ITINERARIO INTEGER NOT NULL,
    CONSTRAINT FK_ESTADIA FOREIGN KEY (ITINERARIO) 
        REFERENCES ITINERARIO(ID)                      
        ON DELETE CASCADE,
    CONSTRAINT PK_ESTADIA PRIMARY KEY (ID),
    CONSTRAINT SK_ESTADIA UNIQUE(ENDERECO_POSTAL, CHECK_IN, CHECK_OUT)
);

CREATE TABLE SERVICO_OFERECIDO (
    ESTADIA INTEGER NOT NULL,
    SERVICO VARCHAR(20) NOT NULL,
    CONSTRAINT FK_SERVICO_OFERECIDO FOREIGN KEY (ESTADIA) 
        REFERENCES ESTADIA(ID)                      
        ON DELETE CASCADE,
    CONSTRAINT PK_SERVICO_OFERECIDO PRIMARY KEY (ESTADIA, SERVICO)
);

/* Entidade do transporte */
CREATE TABLE TRANSPORTE (
    CODIGO_DO_TRANSPORTE CHAR(10) NOT NULL,
    DATA_PARTIDA TIMESTAMP NOT NULL,
    LOCAL_PARTIDA VARCHAR(40) NOT NULL,
    LOTACAO_MAXIMA INTEGER NOT NULL,
    DATA_CHEGADA TIMESTAMP NOT NULL,
    LOCAL_CHEGADA VARCHAR(40) NOT NULL,
    TIPO_DE_TRANSPORTE CHAR(20) NOT NULL,
    ATIVIDADE INTEGER NOT NULL,
    CONSTRAINT FK_TRANSPORTE FOREIGN KEY (ATIVIDADE) 
        REFERENCES ATIVIDADE(ID)
        ON DELETE CASCADE,
    CONSTRAINT PK_TRANSPORTE PRIMARY KEY (CODIGO_DO_TRANSPORTE, DATA_PARTIDA)
);

/* Entidade de transacoes financeiras */
CREATE TABLE TRANSACOES_FINANCEIRAS (
    USUARIO VARCHAR(15) NOT NULL,
    DATA_TRANSFERENCIA TIMESTAMP NOT NULL,
    METODO_DE_TRANSFERENCIA VARCHAR(10),
    VALOR_TRANSFERIDO REAL NOT NULL,
    CONTA VARCHAR(20),
    CONSTRAINT CK_TRANSACOES_FINANCEIRAS CHECK (UPPER(METODO_DE_TRANSFERENCIA) IN ('BOLETO','PIX','TED', 'DEPOSITO')),
    CONSTRAINT FK_TRANSACOES_FINANCEIRAS FOREIGN KEY (USUARIO) 
        REFERENCES USUARIO(USERNAME)
        ON DELETE CASCADE,
    CONSTRAINT PK_TRANSACOES_FINANCEIRAS PRIMARY KEY (USUARIO)
);

/* Relacionamentos N:M */
CREATE TABLE LOCOMOVE (
    USUARIO VARCHAR(15) NOT NULL,
    DATA_PARTIDA TIMESTAMP NOT NULL,
    CUSTO_ADICIONAL INTEGER,
    CODIGO_DO_TRANSPORTE CHAR(10) NOT NULL,
    CONSTRAINT FK_LOCOMOVE_A FOREIGN KEY (USUARIO) 
        REFERENCES USUARIO(USERNAME)
        ON DELETE CASCADE,
    CONSTRAINT FK_LOCOMOVE_B FOREIGN KEY (CODIGO_DO_TRANSPORTE, DATA_PARTIDA) 
        REFERENCES TRANSPORTE(CODIGO_DO_TRANSPORTE, DATA_PARTIDA)
        ON DELETE CASCADE,
    CONSTRAINT PK_LOCOMOVE PRIMARY KEY (USUARIO, CODIGO_DO_TRANSPORTE, DATA_PARTIDA)
);

CREATE TABLE OCUPA (
    USUARIO VARCHAR(15) NOT NULL,
    ESTADIA INTEGER NOT NULL,
    CUSTO_ADICIONAL INTEGER,
    CONSTRAINT FK_OCUPA_A FOREIGN KEY (USUARIO) 
        REFERENCES USUARIO(USERNAME)
        ON DELETE CASCADE,
    CONSTRAINT FK_OCUPA_B FOREIGN KEY (ESTADIA) 
        REFERENCES ESTADIA(ID)
        ON DELETE CASCADE,
    CONSTRAINT PK_OCUPA PRIMARY KEY (USUARIO, ESTADIA)
);

CREATE TABLE ADENTRA (
    USUARIO VARCHAR(15) NOT NULL,
    ITINERARIO INTEGER NOT NULL,
    CUSTO_BASE INTEGER,
    CONSTRAINT FK_ADENTRA_A FOREIGN KEY (USUARIO) 
        REFERENCES USUARIO(USERNAME)
        ON DELETE CASCADE,
    CONSTRAINT FK_ADENTRA_B FOREIGN KEY (ITINERARIO) 
        REFERENCES ITINERARIO(ID)
        ON DELETE CASCADE,
    CONSTRAINT PK_ADENTRA PRIMARY KEY (USUARIO, ITINERARIO)
);

CREATE TABLE PARTICIPA (
    MOCHILEIRO VARCHAR(15) NOT NULL,
    ORGANIZADOR VARCHAR(15) NOT NULL,
    CODIGO_INTERNO CHAR(10) NOT NULL,
    CONSTRAINT FK_PARTICIPA_A FOREIGN KEY (MOCHILEIRO) 
        REFERENCES MOCHILEIRO(USERNAME)
        ON DELETE CASCADE,
    CONSTRAINT FK_PARTICIPA_B FOREIGN KEY (ORGANIZADOR, CODIGO_INTERNO) 
        REFERENCES CARAVANA(ORGANIZADOR, CODIGO_INTERNO)
        ON DELETE CASCADE,
    CONSTRAINT PK_PARTICIPA PRIMARY KEY (MOCHILEIRO, ORGANIZADOR, CODIGO_INTERNO)
);

CREATE TABLE AUXILIA (
    ESPECIALISTA VARCHAR(15) NOT NULL,
    ORGANIZADOR VARCHAR(15) NOT NULL,
    CODIGO_INTERNO CHAR(10) NOT NULL,
    CONSTRAINT FK_AUXILIA_A FOREIGN KEY (ESPECIALISTA) 
        REFERENCES ESPECIALISTA(USERNAME)
        ON DELETE CASCADE, 
    CONSTRAINT FK_AUXILIA_B FOREIGN KEY (ORGANIZADOR, CODIGO_INTERNO) 
        REFERENCES CARAVANA(ORGANIZADOR, CODIGO_INTERNO)
        ON DELETE CASCADE,
    CONSTRAINT PK_AUXILIA PRIMARY KEY (ESPECIALISTA, ORGANIZADOR, CODIGO_INTERNO)
);

CREATE TABLE ENTRA (
    USUARIO VARCHAR(15) NOT NULL,
    ATIVIDADE INTEGER NOT NULL,
    CATEGORIA VARCHAR(30) NOT NULL,
    CONSTRAINT FK_ENTRA_A FOREIGN KEY (USUARIO) 
        REFERENCES USUARIO(USERNAME)
        ON DELETE CASCADE,
    CONSTRAINT FK_ENTRA_B FOREIGN KEY (ATIVIDADE, CATEGORIA) 
        REFERENCES GRUPO_DE_PARTICIPANTES(ATIVIDADE, CATEGORIA)
        ON DELETE CASCADE,
    CONSTRAINT PK_ENTRA PRIMARY KEY (USUARIO, ATIVIDADE, CATEGORIA)
);