
CREATE DATABASE querydinamica
GO
USE querydinamica

CREATE TABLE produto(
idProduto INT NOT NULL,
tipo VARCHAR(100),
cor VARCHAR(50)
PRIMARY KEY(idProduto)
)

CREATE TABLE camiseta(
idProduto INT NOT NULL,
tamanho VARCHAR(3)
PRIMARY KEY(idProduto)
FOREIGN KEY (idProduto) REFERENCES produto(idProduto))

CREATE TABLE tenis(
idProduto INT NOT NULL,
tamanho INT
PRIMARY KEY(idProduto)
FOREIGN KEY (idProduto) REFERENCES produto(idProduto))

SELECT * FROM produto
SELECT * FROM tenis
SELECT * FROM camiseta

SELECT p.idProduto, p.cor, p.tipo, t.tamanho
FROM tenis t, produto p
WHERE p.idProduto = t.idProduto

SELECT p.idProduto, p.cor, p.tipo, c.tamanho
FROM camiseta c, produto p
WHERE p.idProduto = c.idProduto

/* Java
String path = "C:\\Windows"
*/
--Exemplo query dinâmica
DECLARE @query VARCHAR(MAX)
SET @query = 'INSERT INTO produto VALUES (1, ''Produto'', ''Azul'')'
PRINT @query
EXEC (@query)

CREATE PROCEDURE sp_insereproduto(@id INT, @tipo VARCHAR(100), 
	@cor VARCHAR(50), @tamanho VARCHAR(3))
AS
	DECLARE @tam	INT,
			@tabela	VARCHAR(10),
			@query	VARCHAR(MAX),
			@erro	VARCHAR(MAX)
	SET @tabela = 'tenis'

	BEGIN TRY
		SET @tam = CAST(@tamanho AS INT)
	END TRY
	BEGIN CATCH
		SET @tabela = 'camiseta'
	END CATCH

	SET @query = 'INSERT INTO '+@tabela+' VALUES ('+
				CAST(@id AS VARCHAR(5))+','''+@tamanho+''')'
	PRINT @query

	BEGIN TRY
		INSERT INTO produto VALUES (@id, @tipo, @cor)
		EXEC (@query)
	END TRY
	BEGIN CATCH
		SET @erro = ERROR_MESSAGE()
		IF (@erro LIKE '%primary%')
		BEGIN
			RAISERROR('ID produto duplicado', 16, 1)
		END
		ELSE
		BEGIN
			RAISERROR('Erro de processamento', 16, 1)
		END
	END CATCH

EXEC sp_insereproduto 1001, 'Regata', 'Preta', 'GG'
EXEC sp_insereproduto 10001, 'Kichute', 'Preto', '40'

/*
Considere a tabela Produto com os seguintes atributos:
Produto (Codigo | Nome | Valor)
Considere a tabela ENTRADA e a tabela SAÍDA com os seguintes atributos:
(Codigo_Transacao | Codigo_Produto | Quantidade | Valor_Total)
Cada produto que a empresa compra, entra na tabela ENTRADA. Cada produto que a empresa vende, entra na tabela SAIDA.
Criar uma procedure que receba um código (‘e’ para ENTRADA e ‘s’ para SAIDA), criar uma exceção de erro para código
inválido, receba o codigo_transacao, codigo_produto e a quantidade e preencha a tabela correta, com o valor_total de
cada transação de cada produto.
*/