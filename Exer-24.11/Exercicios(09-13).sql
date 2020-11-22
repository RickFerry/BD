CREATE DATABASE exercicio09
GO 
USE exercicio09

CREATE TABLE estoque (
codigo INT NOT NULL,
nome VARCHAR(100) NOT NULL UNIQUE,
quantidade INT NOT NULL,
valor DECIMAL(7,2) NOT NULL CHECK( valor > 0 ),
cod_editora INT NOT NULL,
cod_autor INT NOT NULL,
PRIMARY KEY (codigo),
FOREIGN KEY (cod_editora) REFERENCES editora (codigo),
FOREIGN KEY (cod_autor) REFERENCES autor (codigo)
)

INSERT INTO estoque VALUES 
(10001,	'Sistemas Operacionais Modernos', 	4,	108.00,	1,	101),
(10002,	'A Arte da Política',	2,	55.00,	2,	102),
(10003,	'Calculo A',	12,	79.00,	3,	103),
(10004,	'Fundamentos de Física I',	26,	68.00,	4,	104),
(10005,	'Geometria Analítica',	1,	95.00,	3,	105),
(10006,	'Gramática Reflexiva',	10,	49.00,	5,	106),
(10007,	'Fundamentos de Física III',	1,	78.00,	4,	104),
(10008,	'Calculo B',	3,	95.00,	3,	103)

CREATE TABLE editora (
codigo INT NOT NULL,
nome VARCHAR(50) NOT NULL,
sites VARCHAR (100) NULL,
PRIMARY KEY (codigo)
)

INSERT INTO editora VALUES
(1,	'Pearson',	'www.pearson.com.br'),
(2,	'Civilização Brasileira', NULL),	
(3,	'Makron Books',	'www.mbooks.com.br'),
(4,	'LTC',	'www.ltceditora.com.br'),
(5,	'Atual',	'www.atualeditora.com.br'),
(6,	'Moderna',	'www.moderna.com.br')

CREATE TABLE autor (
codigo INT NOT NULL,
nome VARCHAR(100) NOT NULL,
breve_biografia VARCHAR(100) NOT NULL,
PRIMARY KEY (codigo)
)

INSERT INTO autor VALUES 
(101,	'Andrew Tannenbaun',	'Desenvolvedor do Minix'),
(102,	'Fernando Henrique Cardoso',	'Ex-Presidente do Brasil'),
(103,	'Diva Marília Flemming',	'Professora adjunta da UFSC'),
(104,	'David Halliday',	'Ph.D. da University of Pittsburgh'),
(105,	'Alfredo Steinbruch',	'Professor de Matemática da UFRS e da PUCRS'),
(106,	'Willian Roberto Cereja',	'Doutorado em Lingüística Aplicada e Estudos da Linguagem'),
(107,	'William Stallings',	'Doutorado em Ciências da Computacão pelo MIT'),
(108,	'Carlos Morimoto',	'Criador do Kurumin Linux')

CREATE TABLE compras (
codigo INT NOT NULL,
cod_livro INT NOT NULL,
qtd_comprada INT NOT NULL CHECK ( qtd_comprada > 0 ),
valor DECIMAL(7,2) NOT NULL, CHECK ( valor > 0 ), 
data_compra DATE NOT NULL,
PRIMARY KEY (codigo, cod_livro),
FOREIGN KEY (cod_livro) REFERENCES estoque (codigo)
)

INSERT INTO compras VALUES
(15051,	10003,	2,	158.00,	'04/07/2020'),
(15051,	10008,	1,	95.00,	'04/07/2020'),
(15051,	10004,	1,	68.00,	'04/07/2020'),
(15051,	10007,	1,	78.00,	'04/07/2020'),
(15052,	10006,	1,	49.00,	'05/07/2020'),
(15052,	10002,	3,	165.00,	'05/07/2020'),
(15053,	10001,	1,	108.00,	'05/07/2020'),
(15054,	10003,	1,	79.00,	'06/08/2020'),
(15054,	10008,	1,	95.00,	'06/08/2020')

--Pede-se:												
--Consultar nome, valor unitário, nome da editora e nome do autor dos livros do estoque que foram vendidos. Não podem haver repetições.
SELECT DISTINCT e.nome AS LIVRO, e.valor AS VALOR_UNITARIO, ed.nome AS EDITORA, a.nome AS AUTOR 
FROM estoque e INNER JOIN autor a
ON e.cod_autor = a.codigo INNER JOIN editora ed 
ON e.cod_editora = ed.codigo INNER JOIN compras c
ON e.codigo = c.cod_livro
									
--Consultar nome do livro, quantidade comprada e valor de compra da compra 15051
SELECT e.nome AS LIVRO, c.qtd_comprada AS QUANTIDADE, c.valor AS VALOR 
FROM estoque e INNER JOIN compras c
ON e.codigo = c.cod_livro
WHERE c.codigo = 15051
											
--Consultar Nome do livro e site da editora dos livros da Makron books (Caso o site tenha mais de 10 dígitos, remover o www.).	
SELECT e.nome AS LIVRO, 
	CASE WHEN (LEN(ed.sites) > 10)
			THEN
			SUBSTRING(ed.sites,5 ,13)
			ELSE 
			ed.sites 
			END AS SITE_EDITORA
FROM estoque e INNER JOIN editora ed
ON e.cod_editora = ed.codigo
WHERE ed.nome = 'Makron books'
											
--Consultar nome do livro e Breve Biografia do David Halliday
SELECT e.nome AS LIVRO, a.breve_biografia AS BREVE_BIOGRAFIA
FROM estoque e INNER JOIN autor a
ON e.cod_autor = a.codigo
WHERE a.nome = 'David Halliday'	
											
--Consultar código de compra e quantidade comprada do livro Sistemas Operacionais Modernos
SELECT c.codigo AS CODIGO, c.qtd_comprada AS QUANTIDADE
FROM compras c INNER JOIN estoque e
ON	e.codigo = c.cod_livro
WHERE e.nome = 'Sistemas Operacionais Modernos'
											
--Consultar quais livros não foram vendidos	
SELECT e.nome AS Não_foi_vendido
FROM estoque e LEFT OUTER JOIN compras c
ON 	e.codigo = c.cod_livro
WHERE c.cod_livro IS NULL		
								
--Consultar quais livros foram vendidos e não estão cadastrados	
SELECT  e.nome AS LIVRO_VENDIDO_NÃO_CADASTRADO
FROM estoque e INNER JOIN compras c
ON e.codigo = c.cod_livro
WHERE e.quantidade - c.qtd_comprada < 0
											
--Consultar Nome e site da editora que não tem Livros no estoque (Caso o site tenha mais de 10 dígitos, remover o www.)
SELECT ed.nome AS EDITORA,
		CASE WHEN (LEN(ed.sites) > 10)
			THEN
			RTRIM(SUBSTRING(ed.sites,5 ,14))
			END AS SITE_EDITORA
FROM estoque e RIGHT OUTER JOIN editora ed
ON e.cod_editora = ed.codigo
WHERE e.cod_editora IS NULL		
										
--Consultar Nome e biografia do autor que não tem Livros no estoque (Caso a biografia inicie com Doutorado, substituir por Ph.D.)	
SELECT a.nome AS AUTOR, 
	CASE WHEN (a.breve_biografia LIKE 'doutorado%')
			THEN 'Ph.D.'+ SUBSTRING(a.breve_biografia, 10, 50)
			ELSE a.breve_biografia
			END AS BIOGRAFIA
FROM autor a LEFT OUTER JOIN estoque e
ON a.codigo = e.cod_autor	
WHERE e.cod_autor IS NULL	

--Consultar o nome do Autor, e o maior valor de Livro no estoque. Ordenar por valor descendente	
SELECT a.nome AS AUTOR, MAX(e.valor) AS VALOR_LIVROS  
FROM autor a INNER JOIN estoque e
ON e.cod_autor = a.codigo
GROUP BY a.nome, e.valor
ORDER BY e.valor DESC
 									
--Consultar o código da compra, o total de livros comprados e a soma dos valores gastos. Ordenar por Código da Compra ascendente.
SELECT codigo AS CODIGO, SUM (qtd_comprada) AS TOTAL_LIVROS, SUM (valor) AS SOMA_VALORES
FROM compras 		
GROUP BY codigo		
ORDER BY codigo ASC
					
--Consultar o nome da editora e a média de preços dos livros em estoque.Ordenar pela Média de Valores ascendente.
SELECT ed.nome AS EDITORA, CAST(AVG (e.valor) AS DECIMAL(7,2)) AS MEDIA
FROM editora ed INNER JOIN estoque e
ON e.cod_editora = ed.codigo
GROUP BY ed.nome
ORDER BY MEDIA ASC
												
--Consultar o nome do Livro, a quantidade em estoque o nome da editora, o site da editora (Caso o site tenha mais de 10 dígitos, remover o www.), criar uma coluna status onde:												
	--Caso tenha menos de 5 livros em estoque, escrever Produto em Ponto de Pedido											
	--Caso tenha entre 5 e 10 livros em estoque, escrever Produto Acabando											
	--Caso tenha mais de 10 livros em estoque, escrever Estoque Suficiente											
	--A Ordenação deve ser por Quantidade ascendente			
SELECT e.nome AS LIVRO, e.quantidade AS ESTOQUE, ed.nome AS EDITORA, 
		CASE WHEN (LEN(ed.sites) > 10)
			THEN
			SUBSTRING(ed.sites,5 ,50)
			ELSE 
			ed.sites 
			END AS SITES,
--------------------------------------------------------------
		CASE WHEN (e.quantidade < 5)
			THEN
			'Produto em Ponto de Pedido'
			WHEN (e.quantidade >= 5 AND e.quantidade <= 10 )
			THEN
			'Produto Acabando'
			WHEN (e.quantidade > 10)
			THEN
			'Estoque Suficiente'
			END AS SITUAÇÃO
--------------------------------------------------------------
FROM estoque e INNER JOIN editora ed
ON e.cod_editora = ed.codigo
ORDER BY e.quantidade ASC			
					
--Para montar um relatório, é necessário montar uma consulta com a seguinte saída: Código do Livro, Nome do Livro, Nome do Autor, Info Editora (Nome da Editora + Site) de todos os livros												
	--Só pode concatenar sites que não são nulos
SELECT e.codigo AS CODIGO, e.nome AS LIVRO, a.nome AS AUTOR, 
		CASE WHEN (ed.sites IS NOT NULL)
		THEN 
		(ed.nome + ' ( ' + ed.sites + ' )') 
		ELSE
		(ed.nome + ' ( ------ )')
		END AS INFO_EDITORA
FROM estoque e INNER JOIN autor a
ON e.cod_autor = a.codigo INNER JOIN editora ed
ON e.cod_editora = ed.codigo		
									
--Consultar Codigo da compra, quantos dias da compra até hoje e quantos meses da compra até hoje
SELECT codigo AS CODIGO, DATEDIFF (DAY, data_compra, GETDATE()) AS DIAS, DATEDIFF (MONTH, data_compra, GETDATE()) AS MESES
FROM compras

--Consultar o código da compra e a soma dos valores gastos das compras que somam mais de 200.00
SELECT codigo AS CODIGO, SUM (valor) AS SOMA
FROM compras
GROUP BY codigo
HAVING SUM (valor) > 200


------------------------------------------------------------------------------------------------------------------------------------------------
CREATE DATABASE exercicio12
GO
USE exercicio12

CREATE TABLE planos (
cod_plano INT NOT NULL,
nome_plano VARCHAR(50) NOT NULL,
valor_plano INT NOT NULL,
PRIMARY KEY (cod_plano)
)

INSERT INTO planos VALUES
(1,	'100 Minutos',	80),
(2,	'150 Minutos',	130),
(3,	'200 Minutos',	160),
(4,	'250 Minutos',	220),
(5,	'300 Minutos',	260),
(6,	'600 Minutos',	350)

CREATE TABLE servicos (
cod_servico INT NOT NULL,
nome_servico VARCHAR(50) NOT NULL,
valor_servico INT NOT NULL,
PRIMARY KEY (cod_servico)
)

INSERT INTO servicos VALUES
(1,	'100 SMS',	10),
(2,	'SMS Ilimitado',	30),
(3,	'Internet 500 MB',	40),
(4,	'Internet 1 GB',	60),
(5,	'Internet 2 GB',	70)

CREATE TABLE cliente (
cod_cliente INT NOT NULL,
nome_cliente VARCHAR(50) NOT NULL,
data_inicio CHAR(10) NOT NULL,
PRIMARY KEY (cod_cliente)
)

INSERT INTO cliente VALUES
(1234,	'Cliente A',	'15/10/2012'),
(2468,	'Cliente B',	'20/11/2012'),
(3702,	'Cliente C',	'25/11/2012'),
(4936,	'Cliente D',	'01/12/2012'),
(6170,	'Cliente E',	'18/12/2012'),
(7404,	'Cliente F',	'20/01/2013'),
(8638,	'Cliente G',	'25/01/2013')

CREATE TABLE contratos (
cod_cliente INT NOT NULL,
cod_plano INT NOT NULL,
cod_servico INT NOT NULL,
status_contrato CHAR(1) NOT NULL,
dat CHAR(10) NOT NULL,
PRIMARY KEY (cod_cliente, cod_plano, cod_servico, status_contrato),
FOREIGN KEY (cod_cliente) REFERENCES cliente (cod_cliente),
FOREIGN KEY (cod_plano) REFERENCES planos (cod_plano),
FOREIGN KEY (cod_servico) REFERENCES servicos (cod_servico)
)

INSERT INTO contratos VALUES 
(1234,	3,	1,	'E',	'15/10/2012'),
(1234,	3,	3,	'E',	'15/10/2012'),
(1234,	3,	3,	'A',	'16/10/2012'),
(1234,	3,	1,	'A',	'16/10/2012'),
(2468,	4,	4,	'E',	'20/11/2012'),
(2468,	4,	4,	'A',	'21/11/2012'),
(6170,	6,	2,	'E',	'18/12/2012'),
(6170,	6,	5,	'E',	'19/12/2012'),
(6170,	6,	2,	'A',	'20/12/2012'),
(6170,	6,	5,	'A',	'21/12/2012'),
(1234,	3,	1,	'D',	'10/01/2013'),
(1234,	3,	3,	'D',	'10/01/2013'),
(1234,	2,	1,	'E',	'10/01/2013'),
(1234,	2,	1,	'A',	'11/01/2013'),
(2468,	4,	4,	'D',	'25/01/2013'),
(7404,	2,	1,	'E',	'20/01/2013'),
(7404,	2,	5,	'E',	'20/01/2013'),
(7404,	2,	5,	'A',	'21/01/2013'),
(7404,	2,	1,	'A',	'22/01/2013'),
(8638,	6,	5,	'E',	'25/01/2013'),
(8638,	6,	5,	'A',	'26/01/2013'),
(7404,	2,	5,	'D',	'03/02/2013')

--Status de contrato A(Ativo), D(Desativado), E(Espera)										
--Um plano só é válido se existe pelo menos um serviço associado a ele										
								
-- Consultar o nome do cliente, o nome do plano, a quantidade de estados de contrato (sem repetições) por contrato, dos planos cancelados, ordenados pelo nome do cliente
SELECT c.nome_cliente AS CLIENTE, p.nome_plano AS PLANO, COUNT (co.status_contrato) AS PLANOS_CANCELADOS
FROM cliente c 	INNER JOIN contratos co
ON c.cod_cliente = co.cod_cliente INNER JOIN planos p
ON p.cod_plano = co.cod_plano
GROUP BY c.nome_cliente, p.nome_plano, co.status_contrato
HAVING (co.status_contrato = 'D')
ORDER BY c.nome_cliente

-- Consultar o nome do cliente, o nome do plano, a quantidade de estados de contrato (sem repetições) por contrato, dos planos não cancelados, ordenados pelo nome do cliente										
SELECT DISTINCT c.nome_cliente AS CLIENTE, p.nome_plano AS PLANO, COUNT (co.status_contrato) AS PLANOS_NÃO_CANCELADOS
FROM cliente c 	INNER JOIN contratos co
ON c.cod_cliente = co.cod_cliente INNER JOIN planos p
ON p.cod_plano = co.cod_plano
GROUP BY c.nome_cliente, p.nome_plano, co.status_contrato
HAVING (co.status_contrato <> 'D')
ORDER BY c.nome_cliente

-- Consultar o nome do cliente, o nome do plano, e o valor da conta de cada contrato que está ou esteve ativo, sob as seguintes condições:										
	-- A conta é o valor do plano, somado à soma dos valores de todos os serviços									
	-- Caso a conta tenha valor superior a R$400.00, deverá ser incluído um desconto de 8%									
	-- Caso a conta tenha valor entre R$300,00 a R$400.00, deverá ser incluído um desconto de 5%									
	-- Caso a conta tenha valor entre R$200,00 a R$300.00, deverá ser incluído um desconto de 3%									
	-- Contas com valor inferiores a R$200,00 não tem desconto			
SELECT DISTINCT c.nome_cliente AS CLIENTE, p.nome_plano AS PLANO, s.valor_servico AS VALOR,  
		CASE WHEN (s.valor_servico > 40.00)
		THEN 
		(s.valor_servico * 0.92)
		WHEN (s.valor_servico >= 30.00 AND s.valor_servico <= 40.00)
		THEN
		(s.valor_servico * 0.95)
		WHEN (s.valor_servico >= 20.00 AND s.valor_servico <= 30.00)
		THEN 
		(s.valor_servico * 0.97)
		ELSE 
		NULL 
		END AS DESCONTO 
FROM cliente c INNER JOIN contratos co
ON c.cod_cliente = co.cod_cliente INNER JOIN planos p
ON p.cod_plano = co.cod_plano INNER JOIN servicos s
ON s.cod_servico = co.cod_servico
WHERE co.status_contrato = 'A' OR co.status_contrato = 'E'
						
-- Consultar o nome do cliente, o nome do serviço, e a duração, em meses (até a data de hoje) do serviço, dos cliente que nunca cancelaram nenhum plano										
SELECT DISTINCT c.nome_cliente AS CLIENTE, s.nome_servico AS SERVIÇO, DATEDIFF(MONTH, CONVERT(DATE, co.dat, 103), GETDATE()) AS DURAÇÃO_MESES
FROM cliente c INNER JOIN contratos co
ON c.cod_cliente = co.cod_cliente INNER JOIN servicos s
ON s.cod_servico = co.cod_servico
WHERE co.status_contrato <> 'D'

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
create database exercicio13
go
use exercicio13

create table empresa(
id int identity not null primary key,
nome varchar(50))

create table carro(
id int identity(1001,1) not null primary key,
marca varchar(50),
modelo varchar(50), 
idEmpresa int
foreign key (idEmpresa) references empresa(id))

create table viagem(
idCarro int not null,
distanciaPercorrida decimal(7,2),
dat char(10) not null
primary key (idCarro, dat)
foreign key (idCarro) references carro(id))

select * from carro
select * from empresa
select * from viagem


insert into empresa(nome) values
('Empresa 1'),
('Empresa 2'),
('Empresa 3'),
('Empresa 4'),
('Empresa 5'),
('Empresa 6')

insert into carro(idEmpresa, marca, modelo) values
(1,'Fiat', 'Uno'),
(1,'Renault', 'Sandero'),
(1,'Chevrolet','Celta'),
(1,'Fiat', 'Palio'),
(1,'Peugeot','307'),
(1,'Renault', 'Duster'),
(2,'Fiat', 'Bravo'),
(2,'Renault', 'Logan'),
(4,'Peugeot','207'),
(4,'Renault', 'Duster'),
(6,'Chevrolet','Celta'),
(6,'Fiat', 'Doblo'),
(6,'Volksvagen', 'Jetta')

insert into viagem values
(1006,97,'01/05/2016'),
(1005,2090,'02/05/2016'),
(1005,3387,'03/05/2016'),
(1005,487,'04/05/2016'),
(1004,3141,'05/05/2016'),
(1006,1895,'06/05/2016'),
(1005,3050,'07/05/2016'),
(1003,1974,'08/05/2016'),
(1005,1779,'09/05/2016'),
(1006,1727,'10/05/2016'),
(1002,641,'11/05/2016'),
(1004,1577,'12/05/2016'),
(1003,2697,'13/05/2016'),
(1005,832,'14/05/2016'),
(1002,2033,'15/05/2016'),
(1003,1930,'16/05/2016'),
(1005,2606,'17/05/2016'),
(1002,1424,'18/05/2016'),
(1005,2484,'19/05/2016'),
(1005,2711,'20/05/2016'),
(1003,3049,'21/05/2016'),
(1003,2446,'22/05/2016'),
(1003,1307,'23/05/2016'),
(1003,778,'24/05/2016'),
(1003,2202,'25/05/2016'),
(1004,2571,'26/05/2016'),
(1005,2736,'27/05/2016'),
(1003,3128,'28/05/2016'),
(1002,2513,'29/05/2016'),
(1006,1201,'30/05/2016'),
(1002,3319,'31/05/2016'),
(1006,2755,'01/06/2016'),
(1004,864,'02/06/2016'),
(1004,1833,'03/06/2016'),
(1004,1265,'04/06/2016'),
(1006,1670,'05/06/2016'),
(1006,3037,'06/06/2016'),
(1004,3134,'07/06/2016'),
(1002,358,'08/06/2016'),
(1003,2531,'09/06/2016'),
(1004,1515,'10/06/2016'),
(1005,3461,'11/06/2016'),
(1001,2963,'12/06/2016'),
(1003,2240,'13/06/2016'),
(1004,3403,'14/06/2016'),
(1001,621,'15/06/2016'),
(1005,1264,'16/06/2016'),
(1006,1121,'17/06/2016'),
(1005,88,'18/06/2016'),
(1006,2721,'19/06/2016'),
(1001,1146,'20/06/2016'),
(1005,515,'21/06/2016'),
(1005,3060,'22/06/2016'),
(1006,641,'23/06/2016'),
(1004,2037,'24/06/2016'),
(1006,2595,'25/06/2016'),
(1001,3064,'26/06/2016'),
(1002,2551,'27/06/2016'),
(1005,1380,'28/06/2016'),
(1001,611,'29/06/2016'),
(1002,2759,'30/06/2016'),
(1001,537,'01/07/2016'),
(1003,2581,'02/07/2016'),
(1004,3289,'03/07/2016'),
(1005,3335,'04/07/2016'),
(1004,3273,'05/07/2016'),
(1005,1736,'06/07/2016'),
(1006,2259,'07/07/2016'),
(1006,2269,'08/07/2016'),
(1002,2881,'09/07/2016'),
(1005,888,'10/07/2016'),
(1003,476,'11/07/2016'),
(1006,2944,'12/07/2016'),
(1002,373,'13/07/2016'),
(1005,1885,'14/07/2016'),
(1005,3416,'15/07/2016'),
(1004,1370,'16/07/2016'),
(1005,560,'17/07/2016'),
(1002,657,'18/07/2016'),
(1006,297,'19/07/2016'),
(1001,1661,'20/07/2016'),
(1005,2218,'21/07/2016'),
(1003,381,'22/07/2016'),
(1005,3284,'23/07/2016'),
(1004,771,'24/07/2016'),
(1002,1583,'25/07/2016'),
(1005,1841,'26/07/2016'),
(1005,2210,'27/07/2016'),
(1001,1512,'28/07/2016'),
(1004,1913,'29/07/2016'),
(1003,1065,'30/07/2016'),
(1006,3109,'31/07/2016'),
(1005,3393,'01/08/2016'),
(1003,1791,'02/08/2016'),
(1004,2652,'03/08/2016'),
(1002,1588,'04/08/2016'),
(1004,3154,'05/08/2016'),
(1005,2322,'06/08/2016'),
(1005,2750,'07/08/2016'),
(1006,460,'08/08/2016'),
(1004,465,'09/08/2016'),
(1006,2459,'10/08/2016'),
(1006,2354,'11/08/2016'),
(1006,1320,'12/08/2016'),
(1001,1478,'13/08/2016'),
(1003,2736,'14/08/2016'),
(1004,1908,'15/08/2016'),
(1005,1823,'16/08/2016'),
(1002,3202,'17/08/2016'),
(1001,2952,'18/08/2016'),
(1002,339,'19/08/2016'),
(1006,1092,'20/08/2016'),
(1003,1607,'21/08/2016'),
(1002,991,'22/08/2016'),
(1001,2123,'23/08/2016'),
(1001,1963,'24/08/2016'),
(1001,3359,'25/08/2016'),
(1006,119,'26/08/2016'),
(1003,1635,'27/08/2016'),
(1001,364,'28/08/2016'),
(1001,2672,'29/08/2016'),
(1005,324,'30/08/2016'),
(1002,1402,'31/08/2016'),
(1004,2902,'01/09/2016'),
(1004,1842,'02/09/2016'),
(1001,1113,'03/09/2016'),
(1005,373,'04/09/2016'),
(1002,157,'05/09/2016'),
(1002,1816,'06/09/2016'),
(1001,2413,'07/09/2016'),
(1003,1702,'08/09/2016'),
(1002,1871,'09/09/2016'),
(1006,3234,'10/09/2016'),
(1006,3165,'11/09/2016'),
(1004,360,'12/09/2016'),
(1004,1491,'13/09/2016'),
(1006,2653,'14/09/2016'),
(1002,886,'15/09/2016'),
(1001,1567,'16/09/2016'),
(1002,2642,'17/09/2016'),
(1006,1839,'18/09/2016'),
(1002,3418,'19/09/2016'),
(1004,1959,'20/09/2016'),
(1001,540,'21/09/2016'),
(1003,2510,'22/09/2016'),
(1002,2916,'23/09/2016'),
(1001,1519,'24/09/2016'),
(1006,241,'25/09/2016'),
(1003,728,'26/09/2016'),
(1003,1511,'27/09/2016'),
(1004,1738,'28/09/2016'),
(1002,646,'29/09/2016'),
(1003,253,'30/09/2016'),
(1006,2714,'01/10/2016'),
(1001,2114,'02/10/2016'),
(1004,725,'03/10/2016'),
(1010,348,'01/09/2016'),
(1008,194,'02/09/2016'),
(1012,1250,'03/09/2016'),
(1007,1291,'04/09/2016'),
(1009,1879,'05/09/2016'),
(1007,2466,'06/09/2016'),
(1010,900,'07/09/2016'),
(1011,2743,'08/09/2016'),
(1011,769,'09/09/2016'),
(1010,3284,'10/09/2016'),
(1009,811,'11/09/2016'),
(1010,434,'12/09/2016'),
(1007,1271,'13/09/2016'),
(1008,1492,'14/09/2016'),
(1008,3047,'15/09/2016'),
(1007,2305,'16/09/2016'),
(1007,2886,'17/09/2016'),
(1008,3226,'18/09/2016'),
(1011,1542,'19/09/2016'),
(1007,2150,'20/09/2016'),
(1011,1897,'21/09/2016'),
(1011,3022,'22/09/2016'),
(1007,3495,'23/09/2016'),
(1011,365,'24/09/2016'),
(1007,3265,'25/09/2016'),
(1011,2938,'26/09/2016'),
(1012,2136,'27/09/2016'),
(1008,891,'28/09/2016'),
(1011,833,'29/09/2016'),
(1009,1528,'30/09/2016'),
(1008,952,'01/10/2016'),
(1007,2310,'02/10/2016'),
(1008,1657,'03/10/2016'),
(1007,2007,'04/10/2016'),
(1007,2657,'05/10/2016'),
(1007,1509,'06/10/2016'),
(1010,737,'07/10/2016'),
(1008,2156,'08/10/2016'),
(1008,3263,'09/10/2016'),
(1007,1329,'10/10/2016'),
(1007,140,'11/10/2016'),
(1010,1701,'12/10/2016'),
(1009,3300,'13/10/2016'),
(1010,1324,'14/10/2016'),
(1011,1936,'15/10/2016'),
(1010,2961,'16/10/2016'),
(1007,781,'17/10/2016'),
(1012,3296,'18/10/2016'),
(1007,174,'19/10/2016'),
(1012,2894,'20/10/2016'),
(1009,2965,'21/10/2016'),
(1010,452,'22/10/2016'),
(1012,2077,'23/10/2016'),
(1009,2581,'24/10/2016'),
(1011,1503,'25/10/2016'),
(1008,1382,'26/10/2016'),
(1012,3379,'27/10/2016'),
(1010,351,'28/10/2016'),
(1007,553,'29/10/2016'),
(1011,1660,'30/10/2016'),
(1008,1045,'31/10/2016'),
(1008,1919,'01/11/2016'),
(1010,922,'02/11/2016'),
(1010,2983,'03/11/2016'),
(1012,1229,'04/11/2016'),
(1010,3083,'05/11/2016'),
(1010,1318,'06/11/2016'),
(1011,3018,'07/11/2016'),
(1011,2227,'08/11/2016'),
(1011,3304,'09/11/2016'),
(1011,2078,'10/11/2016'),
(1008,3388,'11/11/2016'),
(1007,1136,'12/11/2016'),
(1007,2043,'13/11/2016'),
(1009,2224,'14/11/2016'),
(1007,1413,'15/11/2016'),
(1008,496,'16/11/2016'),
(1008,3370,'17/11/2016'),
(1008,1524,'18/11/2016'),
(1008,2996,'19/11/2016'),
(1007,502,'20/11/2016'),
(1010,2314,'21/11/2016'),
(1007,1946,'22/11/2016'),
(1007,1042,'23/11/2016'),
(1007,141,'24/11/2016'),
(1011,1967,'25/11/2016'),
(1012,585,'26/11/2016'),
(1010,737,'27/11/2016'),
(1010,504,'28/11/2016'),
(1011,2351,'29/11/2016'),
(1008,1046,'30/11/2016'),
(1008,3117,'01/12/2016'),
(1008,229,'02/12/2016'),
(1008,3079,'03/12/2016'),
(1011,339,'04/12/2016'),
(1010,2335,'05/12/2016'),
(1007,3139,'06/12/2016'),
(1011,1632,'07/12/2016'),
(1010,3253,'08/12/2016'),
(1010,265,'09/12/2016')


--Exercícios
--Apresentar marca e modelo de carro e a soma total da distância percorrida pelos carros,
--em viagens, de uma dada empresa, ordenado pela distância percorrida
select c.marca, c.modelo, sum (v.distanciaPercorrida) as soma_distancia, e.nome as empresa
from carro c inner join viagem v
on c.id = v.idCarro inner join empresa e
on e.id = c.idEmpresa
group by c.marca, c.modelo, e.nome
order by sum (v.distanciaPercorrida)

--Consultar Nomes das empresas que não tem carros cadastrados
select distinct e.nome, c.id
from empresa e left outer join carro c
on e.id = c.idEmpresa
where c.id is null 

--Consultar quantas viagens foram feitas por cada carro (marca e modelo) de cada empresa
--em ordem ascendente de nome de empresa e descendente de quantidade
select count(c.id) as viagens, c.marca, c.modelo, e.nome as empresa
from viagem v inner join carro c
on c.id = v.idCarro inner join empresa e
on e.id = c.idEmpresa
group by c.marca, c.modelo, e.nome
having count(v.distanciaPercorrida) is not null 
order by empresa asc, viagens desc

--Consultar o nome da empresa, a marca e o modelo do carro, a distância percorrida
--e o valor total ganho por viagem, sabendo que para distâncias inferiores a 1000 km, o valor é R$10,00
--por km e para viagens superiores a 1000 km, o valor é R$15,00 por km.
select e.nome as empresa, c.marca, c.modelo, v.distanciaPercorrida, 
		case when (v.distanciaPercorrida < 1000.00)
		then (v.distanciaPercorrida * 10)
		when (v.distanciaPercorrida > 1000.00)
		then (v.distanciaPercorrida * 15)
		else
		'vc nao deveria cair aqui'
		end as valor_total
from empresa e inner join carro c
on e.id = c.idEmpresa inner join viagem v
on v.idCarro = c.id

											
