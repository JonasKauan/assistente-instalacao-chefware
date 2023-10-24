CREATE DATABASE IF NOT EXISTS chefware;
USE chefware;

CREATE TABLE IF NOT EXISTS Empresa (
  idEmpresa INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(45) NULL,
  cnpj CHAR(14) NULL,
  telefone VARCHAR(11) NULL,
  PRIMARY KEY (idEmpresa)
);
insert into Empresa (nome, cnpj, telefone) VALUES
("ChefWare", "24583958023502", "11945293503");

CREATE TABLE IF NOT EXISTS Maquina (
  id INT NOT NULL AUTO_INCREMENT,
  numSerie VARCHAR(45) NULL,
  nome VARCHAR(45) NULL,
  modelo VARCHAR(45) NULL,
  local VARCHAR(45) NULL,
  descComponentes VARCHAR(100) NULL,
  Empresa_idEmpresa INT NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (Empresa_idEmpresa)
    REFERENCES Empresa (idEmpresa)
);
insert into Maquina VALUES
(null, "0A239QAW500685", "Notebook", "550XDA", "Escritório", "Memoria", 1);


CREATE TABLE IF NOT EXISTS Funcionario (
  id INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(45) NULL,
  email VARCHAR(45) NULL,
  senha VARCHAR(45) NULL,
  cpf CHAR(11) NULL,
  cargo VARCHAR(45) NULL,
  privilegio VARCHAR(45) NULL,
  fkEmpresa INT NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (fkEmpresa)
    REFERENCES Empresa (idEmpresa)
);

CREATE TABLE IF NOT EXISTS Endereco (
  idEndereco INT NOT NULL AUTO_INCREMENT,
  logradouro VARCHAR(45) NULL,
  cep CHAR(8) NULL,
  bairro VARCHAR(45) NOT NULL,
  numero VARCHAR(45) NULL,
  estado VARCHAR(45) NULL,
  fkEmpresa INT NOT NULL,
  PRIMARY KEY (idEndereco),
  FOREIGN KEY (fkEmpresa)
    REFERENCES Empresa (idEmpresa)
);

CREATE TABLE IF NOT EXISTS Telefone (
  id INT NOT NULL AUTO_INCREMENT,
  numero CHAR(11) NULL,
  Empresa_idEmpresa INT NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (Empresa_idEmpresa)
    REFERENCES Empresa (idEmpresa)
);

CREATE TABLE IF NOT EXISTS Componente (
  idComponente INT NOT NULL AUTO_INCREMENT,
  marca VARCHAR(45) NULL,
  compatibilidade VARCHAR(45) NULL,
  dataVencimento VARCHAR(45) NULL,
  PRIMARY KEY (idComponente)
);

INSERT INTO Componente VALUES
(null, "Kingston", "Windows/Linux", "2002-09-02"),
(null, "XrayDisk", "Windows/Linux", "2030-09-02"),
(null, "RealtekRK", "Windows/Linux", "2030-09-02"), 	
(null, "Intel", "Windows/Linux", "2030-09-02");

CREATE TABLE IF NOT EXISTS Especificacoes (
  idEspecificacoes INT AUTO_INCREMENT NOT NULL,
  fkMaquina INT NOT NULL,
  fkComponente INT NOT NULL,
  tipo VARCHAR(100) NULL,
  PRIMARY KEY (idEspecificacoes, fkMaquina, fkComponente),
  FOREIGN KEY (fkMaquina) REFERENCES Maquina (id),
  FOREIGN KEY (fkComponente) REFERENCES Componente (idComponente)
);
INSERT INTO Especificacoes VALUES
(null, 1, 1, "Memória"),
(null, 1, 2, "Disco"),
(null, 1, 3, "Rede"),
(null, 1, 4, "CPU");

CREATE TABLE IF NOT EXISTS Dados (
  idDados INT NOT NULL AUTO_INCREMENT,
  descricao VARCHAR(100) NULL,
  valor VARCHAR(100) NULL,
  unidadeMedida VARCHAR(100) NULL,
  fkEspecificacoes INT NOT NULL,
  fkMaquina INT NOT NULL,
  fkComponente INT NOT NULL,
  PRIMARY KEY (idDados, fkEspecificacoes, fkMaquina, fkComponente),
  FOREIGN KEY (fkMaquina) REFERENCES Maquina(id),
  FOREIGN KEY (fkEspecificacoes) REFERENCES Especificacoes(idEspecificacoes),
  FOREIGN KEY (fkComponente) REFERENCES Componente (idComponente)
  );
  
CREATE TABLE IF NOT EXISTS Historico (
  idHistorico INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  fkMaquina INT NOT NULL,
  fkEspecificacoes INT NOT NULL,
  fkComponente INT NOT NULL,
  dataHora DATETIME NULL,
  nome VARCHAR(45) NULL,
  leitura VARCHAR(45) NULL,
  unidadeMedida VARCHAR(45) NULL,
  FOREIGN KEY (fkMaquina) REFERENCES Maquina (id),
  FOREIGN KEY (fkComponente) REFERENCES Componente (idComponente),
  FOREIGN KEY (fkEspecificacoes) REFERENCES Especificacoes (idEspecificacoes)
);

-- Dados Estaticos
SELECT Especificacoes.tipo, Dados.descricao, Dados.valor, Dados.unidadeMedida from Dados JOIN Especificacoes ON fkEspecificacoes = idEspecificacoes;

-- Dados Dinamicos
select Especificacoes.tipo, Historico.nome, Historico.leitura, Historico.unidadeMedida, Historico.dataHora from Historico 
JOIN Especificacoes ON fkEspecificacoes = idEspecificacoes;



