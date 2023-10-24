DROP DATABASE chefware;
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

CREATE TABLE IF NOT EXISTS tipoComponente (
  idtipoComponente INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(45) NULL,
  PRIMARY KEY (idtipoComponente)
);
INSERT INTO tipoComponente VALUES
(1, "Memória"),
(2, "Disco"),
(3, "Rede"),
(4, "CPU");

CREATE TABLE IF NOT EXISTS Componente (
  idComponente INT NOT NULL AUTO_INCREMENT,
  marca VARCHAR(45) NULL,
  compatibilidade VARCHAR(45) NULL,
  dataVencimento VARCHAR(45) NULL,
  fkTipoComponente INT NOT NULL,
  PRIMARY KEY (idComponente),
  FOREIGN KEY (fkTipoComponente) REFERENCES tipoComponente (idtipoComponente)
);

INSERT INTO Componente VALUES
(null, "Kingston", "Windows/Linux", "2002-09-02", 1),
(null, "XrayDisk", "Windows/Linux", "2030-09-02", 2),
(null, "RealtekRK", "Windows/Linux", "2030-09-02", 3), 	
(null, "Intel", "Windows/Linux", "2030-09-02", 4);

CREATE TABLE IF NOT EXISTS Especificacoes (
  idEspecificacoes INT AUTO_INCREMENT NOT NULL,
  fkTipoComponente INT NOT NULL,
  fkMaquina INT NOT NULL,
  fkComponente INT NOT NULL,
  descricao VARCHAR(100) NULL,
  dadosEstaticos VARCHAR(1000) NULL,
  unidadeMedida VARCHAR(100) NULL,
  PRIMARY KEY (idEspecificacoes, fkTipoComponente, fkMaquina, fkComponente),
  INDEX idx_tipo_maquina_componente (fkTipoComponente, fkMaquina, fkComponente),
  FOREIGN KEY (fkMaquina) REFERENCES Maquina (id),
  FOREIGN KEY (fkComponente) REFERENCES Componente (idComponente),
  FOREIGN KEY (fkTipoComponente) REFERENCES tipoComponente (idtipoComponente)
);

CREATE TABLE IF NOT EXISTS Historico (
  idHistorico INT NOT NULL AUTO_INCREMENT,
  fkTipoComponente INT NOT NULL,
  fkMaquina INT NOT NULL,
  fkComponente INT NOT NULL,
  dataHora DATETIME NULL,
  nome VARCHAR(45) NULL,
  leitura VARCHAR(45) NULL,
  unidadeMedida VARCHAR(45) NULL,
  PRIMARY KEY (idHistorico),
  FOREIGN KEY (fkTipoComponente, fkMaquina, fkComponente) REFERENCES Especificacoes (fkTipoComponente, fkMaquina, fkComponente)
);

select * from Especificacoes;
select * from Historico;

SELECT tipoComponente.nome AS componenteTipo,
date_format(dataHora, '%d/%m/%Y %H:%i:%s') AS dataHora,
Historico.nome AS dadoDinamico,
leitura,
unidadeMedida FROM Historico
JOIN tipoComponente ON fkTipoComponente = idtipoComponente
JOIN Maquina ON fkMaquina = id
ORDER BY componenteTipo;
 
select Especificacoes.descricao, Especificacoes.dadosEstaticos, Especificacoes.unidadeMedida, Historico.nome, 
Historico.dataHora, Historico.leitura, Historico.unidadeMedida from Historico
JOIN Especificacoes ON Historico.fkComponente = Especificacoes.fkComponente;

SELECT tipoComponente.nome, Componente.marca, Especificacoes.descricao, Especificacoes.dadosEstaticos, Especificacoes.unidadeMedida
FROM Especificacoes 
JOIN Componente ON Especificacoes.fkComponente = Componente.idComponente
JOIN tipoComponente ON Componente.fkTipoComponente = tipoComponente.idtipoComponente;

