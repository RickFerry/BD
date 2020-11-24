CREATE DATABASE pre_p2
GO 
USE pre_p2

CREATE TABLE cliente(
cod INT IDENTITY(1001,1),
nome VARCHAR(100) NOT NULL,
logradouro VARCHAR(100),
numero INT,
telefone CHAR(9),
PRIMARY KEY (cod))

CREATE TABLE emprestimo(
cod_cli INT NOT NULL,
cod_livro INT NOT NULL,
dt DATE NOT NULL,
PRIMARY KEY (cod_cli,cod_livro),
FOREIGN KEY (cod_cli) REFERENCES cliente(cod),
FOREIGN KEY (cod_livro) REFERENCES livro(cod))

CREATE TABLE livro (
cod INT IDENTITY,
cod_autor INT NOT NULL,
cod_corredor INT NOT NULL,
nome VARCHAR(100) NOT NULL,
pag INT NOT NULL,
idioma VARCHAR(30) NOT NULL
PRIMARY KEY(cod),
FOREIGN KEY (cod_autor) REFERENCES autor(cod),
FOREIGN KEY (cod_corredor) REFERENCES corredor(cod))

CREATE TABLE corredor(
cod INT IDENTITY(3251,1),
tipo VARCHAR(30) NOT NULL,
PRIMARY KEY (cod))

CREATE TABLE autor(
cod INT IDENTITY(10001,1),
nome VARCHAR(100) NOT NULL,
pais VARCHAR(30) NOT NULL,
biografia VARCHAR(100) NOT NULL,
PRIMARY KEY (cod))

-- Fazer uma consulta que retorne o nome do cliente e a data do empréstimo formatada padrão BR (dd/mm/yyyy)
SELECT c.nome, CONVERT(CHAR(10), e.dt, 103) AS data
FROM cliente c, emprestimo e
WHERE c.cod = e.cod_cli

-- Fazer uma consulta que retorne Nome do autor e Quantos livros foram escritos por Cada autor, ordenado pelo número de livros. Se o nome do autor tiver mais de 25 caracteres, mostrar só os 13 primeiros.
SELECT 
CASE WHEN (LEN(a.nome) > 25)
THEN REPLACE(a.nome,1,13)
ELSE a.nome
END AS nome , COUNT(l.cod_autor) AS numero_de_livros
FROM autor a, livro l
WHERE a.cod = l.cod_autor
GROUP BY a.nome
ORDER BY numero_de_livros REVERT

-- Fazer uma consulta que retorne o nome do autor e o país de origem do livro com maior número de páginas cadastrados no sistema
SELECT a.nome, a.pais
FROM autor a , livro l
where a.cod = l.cod_autor
AND l.pag IN (
    SELECT Max(pag) FROM livro)

-- Fazer uma consulta que retorne nome e endereço concatenado dos clientes que tem livros emprestados
SELECT DISTINCT c.nome, c.logradouro + ' - ' + CAST(c.numero AS VARCHAR(8)) AS endereco
FROM cliente c, emprestimo e
WHERE c.cod = e.cod_cli

/*
Nome dos Clientes, sem repetir e, concatenados como
enderço_telefone, o logradouro, o numero e o telefone) dos
clientes que Não pegaram livros. Se o logradouro e o 
número forem nulos e o telefone não for nulo, mostrar só o telefone. Se o telefone for nulo e o logradouro e o número não forem nulos, mostrar só logradouro e número. Se os três existirem, mostrar os três.
O telefone deve estar mascarado XXXXX-XXXX
*/
SELECT c.nome, 
CASE WHEN ((c.logradouro IS NULL) AND (c.numero IS NULL) AND (c.telefone IS NOT NULL))
THEN  c.telefone  
WHEN ((c.telefone IS NULL) AND  (c.logradouro IS NOT NULL) AND (c.numero IS NOT NULL))
THEN c.logradouro + ' - ' + CAST(c.numero AS VARCHAR(8))
ELSE c.logradouro + ' - ' + CAST(c.numero AS VARCHAR(8)) + ' - ' + c.telefone
END AS enderço_telefone
FROM cliente c

-- Fazer uma consulta que retorne Quantos livros não foram emprestados
SELECT COUNT(l.cod) AS livros_nao_emprestados
FROM livro l LEFT JOIN emprestimo e
ON l.cod = e.cod_livro
WHERE e.cod_livro IS NULL

-- Fazer uma consulta que retorne Nome do Autor, Tipo do corredor e quantos livros, ordenados por quantidade de livro
SELECT a.nome, c.tipo, COUNT(l.cod) AS quantidade_de_livros
FROM autor a, corredor c, livro l
WHERE a.cod = l.cod_autor
AND l.cod_corredor = c.cod
GROUP BY a.nome, c.tipo
ORDER BY quantidade_de_livros

-- Considere que hoje é dia 18/05/2012, faça uma consulta que apresente o nome do cliente, o nome do livro, o total de dias que cada um está com o livro e, uma coluna que apresente, caso o número de dias seja superior a 4, apresente 'Atrasado', caso contrário, apresente 'No Prazo'
SELECT c.nome, l.nome, DATEDIFF(DAY, e.dt, '2012/05/18') as dias_empestados,
CASE WHEN (DATEDIFF(DAY, e.dt, '2012/05/18') > 4)
THEN 'atrasado'
ELSE 'No Prazo'
END AS status
FROM cliente c, livro l, emprestimo e
WHERE c.cod = e.cod_cli
AND e.cod_livro = l.cod

-- Fazer uma consulta que retorne cod de corredores, tipo de corredores e quantos livros tem em cada corredor
SELECT c.cod, c.tipo, COUNT(l.cod_corredor) AS livros
FROM corredor c, livro l 
WHERE c.cod = l.cod_corredor
GROUP BY c.cod, c.tipo

-- Fazer uma consulta que retorne o Nome dos autores cuja quantidade de livros cadastrado é maior ou igual a 2.
SELECT a.nome
FROM autor a, livro l
WHERE a.cod = l.cod_autor
GROUP BY a.nome
HAVING (COUNT(l.cod) >= 2)

-- Considere que hoje é dia 18/05/2012, faça uma consulta que apresente o nome do cliente, o nome do livro dos empréstimos que tem 7 dias ou mais
SELECT c.nome, l.nome
FROM cliente c, livro l, emprestimo e
WHERE c.cod = e.cod_cli
AND e.cod_livro = l.cod
GROUP BY c.nome, l.nome, e.dt
HAVING (DATEDIFF(DAY, e.dt, '2012/05/18') >= 7)