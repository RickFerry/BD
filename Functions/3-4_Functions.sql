/*
3) A partir das tabelas abaixo, faça:
Funcionário (Código, Nome, Salário)
Dependendente (Código_Funcionário, Nome_Dependente, Salário_Dependente)

a) Uma Function que Retorne uma tabela:
(Nome_Funcionário, Nome_Dependente, Salário_Funcionário, Salário_Dependente)

b) Uma Scalar Function que Retorne a soma dos Salários dos dependentes, mais a do funcionário.
*/

CREATE DATABASE func_dependente
GO
USE func_dependente

use master

drop database func_dependente

CREATE TABLE funcionario(
codigo INT IDENTITY,
nome VARCHAR(50) NOT NULL,
salario DECIMAL(7,2) NOT NULL,
PRIMARY KEY (codigo))

CREATE TABLE dependente(
codigo INT IDENTITY,
codigo_funcionario INT,
nome_dependente VARCHAR(50) NOT NULL,
salario_dependente DECIMAL(7,2) NOT NULL,
PRIMARY KEY (codigo)
)

INSERT INTO funcionario VALUES 
('Fulano',1400),
('Cicrano',2000),
('Cachubeira',700)

select * from funcionario

INSERT INTO dependente VALUES 
(1,'fulaninho',700),
(1,'fulaninha',500),
(2,'Cicraninho',1200),
(3,'Cachu',2000),
(3,'Cachubinha',1000)

select * from dependente

CREATE FUNCTION fn_func_depen()
RETURNS @table TABLE (
nome_funcionario		VARCHAR(50),
nome_dependentes		VARCHAR(50),
salario_funcionario		DECIMAL(7,2),
salario_dependente		DECIMAL(7,2)
)
AS
BEGIN
	INSERT INTO @table (nome_funcionario, nome_dependentes, salario_funcionario, salario_dependente)
		SELECT f.nome, d.nome_dependente, f.salario, d.salario_dependente FROM funcionario f , dependente d WHERE f.codigo = d.codigo_funcionario
 
	RETURN
END

SELECT * FROM fn_func_depen()


CREATE FUNCTION fn_calcsalario(@cod INT)
RETURNS DECIMAL(7,2)
AS
BEGIN
	DECLARE @salario	DECIMAL(7,2),
			@salario_dependente	DECIMAL(7,2),
			@total	DECIMAL(7,2)

		SELECT @salario = salario FROM funcionario
			WHERE codigo = @cod

        SELECT @salario_dependente = SUM(salario_dependente) FROM dependente WHERE codigo_funcionario = @cod
		SET @total = @salario + @salario_dependente
	RETURN (@total)
END

select dbo.fn_calcsalario(1) as soma_salario
----------------------------------------------------------------------------------------------------------
/*
4)A partir das tabelas abaixo, faça:
Cliente (CPF, nome, telefone, e-mail)
Produto (Código, nome, descrição, valor_unitário)
Venda (CPF_Cliente, Código_Produto, Quantidade, Data(Formato DATE))

a) Uma Function que Retorne uma tabela:
(Nome_Cliente, Nome_Produto, Quantidade, Valor_Total)

b) Uma Scalar Function que Retorne a soma dos produtos comprados na Última Compra
*/

CREATE DATABASE comercio
GO
USE comercio

CREATE TABLE cliente(
cpf CHAR(11),
nome VARCHAR(50) NOT NULL,
telefone CHAR(9) NOT NULL,
email VARCHAR(100) NOT NULL,
PRIMARY KEY (cpf))

CREATE TABLE produto(
codigo INT IDENTITY,
nome VARCHAR(50) NOT NULL,
descricao VARCHAR(200) NOT NULL,
valor_unitario DECIMAL(7,2) NOT NULL,
PRIMARY KEY (codigo)
)

CREATE TABLE venda(
cpf_cliente CHAR(11),
codigo_produto INT,
quantidade INT NOT NULL,
dt DATE,
PRIMARY KEY (cpf_cliente, codigo_produto),
FOREIGN KEY (cpf_cliente) REFERENCES cliente(cpf),
FOREIGN KEY (codigo_produto) REFERENCES produto(codigo))

INSERT INTO cliente VALUES
('11111111111', 'Fulano', '999999999', 'fulano@gmail.com' ),
('22222222222', 'Cicrano', '888888888', 'cicrano@gmail.com' )

INSERT INTO produto VALUES
('placa de video','gtx 2080 TI super poderosa', 5000.00),
('placa mãe',' asus rogue sei lá oq', 3000.00)

INSERT INTO venda VALUES
('11111111111',1,20,'06/03/2021'),
('22222222222',2,30,'06/03/2021'),
('11111111111',2,10,'12/03/2021')

select * from venda


CREATE FUNCTION fn_total()
RETURNS @table TABLE (
nome_cliente VARCHAR(50),
nome_produto VARCHAR(50),
quantidade INT,
valor_total DECIMAL(10,2)
)
AS
BEGIN
	INSERT INTO @table (nome_cliente, nome_produto, quantidade, valor_total)
		SELECT c.nome, p.codigo, v.quantidade, (v.quantidade*p.valor_unitario) FROM cliente c, produto p, venda v
		WHERE c.cpf = v.cpf_cliente AND v.codigo_produto = p.codigo
 
	RETURN
END


CREATE FUNCTION fn_somaultimacompra(@cpf INT)
RETURNS DECIMAL(20,2)
AS
BEGIN
	RETURN (SELECT SUM(p.valor_unitario * v.quantidade) FROM cliente c, produto p , venda v 
			WHERE c.cpf = v.cpf_cliente and v.codigo_produto = p.codigo and v.cpf_cliente = @cpf
			and v.dt = (select MAX(v.dt) from venda v where v.cpf_cliente = @cpf))
END