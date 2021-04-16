create database evento

create table curso(
codigo_curso int not null,
nome varchar(70) not null,
sigla varchar(10) not null
primary key(codigo_curso)
)

insert into curso values
(1, 'Analise e Desenvolvimento de Software', 'ADS'),
(2, 'Comercio Exterior', 'COMEX'),
(3, 'Administração', 'ADM')

create table aluno(
ra char(7) not null,
nome varchar(250) not null,
codigo_curso int not null
primary key(ra)
foreign key(codigo_curso) references curso(codigo_curso)
)

insert into aluno values
('1234567', 'R. Souza', 3),
('7654321', 'G. Thomas', 1),
('7651234', 'W. Gill', 2)

create table palestrante(
codigo_palestrante int identity(1, 1),
nome varchar(250) not null,
empresa varchar(100) not null
primary key(codigo_palestrante)
)

insert into palestrante values
('S Silva', 'King'),
('Y. Yoshida', 'Emyll'),
('B. Paul', 'Vrum')

create table palestra(
codigo_palestra int identity(1, 1),
titulo varchar(max) not null,
carga_horaria int null,
dt datetime not null,
codigo_palestrante int not null
primary key(codigo_palestra)
foreign key(codigo_palestrante) references palestrante(codigo_palestrante)
)

insert into palestra values
('Liderança', 90, '2021-02-01', 1),
('Comodismo', 60, '2021-02-02', 2),
('Persistencia', 120, '2021-02-03', 3)

create table aluno_inscritos(
ra char(7) not null,
codigo_palestra int not null
foreign key(ra) references aluno(ra),
foreign key(codigo_palestra) references palestra(codigo_palestra)
)

insert into aluno_inscritos values
('7654321', 1),
('1234567', 2),
('7651234', 3)

create table nao_alunos(
rg varchar(9) not null,
orgao_exp char(5) not null,
nome varchar(250) not null
primary key(rg, orgao_exp)
)

insert into nao_alunos values
('123456789', 'SSP', 'V. Davi'),
('987654321', 'DPF', 'M. Nani'),
('123498765', 'POM', 'E. Vargas')

create table nao_alunos_inscritos(
codigo_palestra int not null,
rg varchar(9) not null,
orgao_exp char(5) not null
foreign key(codigo_palestra) references palestra(codigo_palestra),
foreign key(rg, orgao_exp) references nao_alunos(rg, orgao_exp)
)

insert into nao_alunos_inscritos values
(3, '987654321', 'DPF'),
(1, '123456789', 'SSP'),
(2, '123498765', 'POM')

--------------------------------------------------------------------------------------------------------------

/*A lista de presença deverá vir de uma consulta que retorna (Num_Documento, Nome_Pessoa, Titulo_Palestra,
Nome_Palestrante, Carga_Horária e Data). A lista deverá ser uma só, por palestra (A condição da consulta é o
código da palestra) e contemplar alunos e não alunos (O Num_Documento se referencia ao RA para alunos e
RG + Orgao_Exp para não alunos) e estar ordenada pelo Nome_Pessoa. Fazer uma view de select que forneça a saída conforme se pede.*/

create view v_lista
as
SELECT a.ra as Num_Documento, a.nome as Nome_Pessoa, p.titulo as Titulo_Palestra, pl.nome as Nome_Palestrante,
	p.carga_horaria as Carga_Horária, p.dt as [Data] FROM
aluno a inner join aluno_inscritos ai 
on a.ra = ai.ra
inner join palestra p
on ai.codigo_palestra = p.codigo_palestra
inner join palestrante pl
on p.codigo_palestrante = pl.codigo_palestrante
UNION
SELECT na.rg + '-' + na.orgao_exp as Num_Documento, na.nome as Nome_Pessoa, p.titulo as Titulo_Palestra,
	pl.nome as Nome_Palestrante, p.carga_horaria as Carga_Horária, p.dt as [Data] FROM
nao_alunos na inner join nao_alunos_inscritos nai
on na.rg = nai.rg AND na.orgao_exp = nai.orgao_exp
inner join palestra p
on nai.codigo_palestra = p.codigo_palestra
inner join palestrante pl
on p.codigo_palestrante = pl.codigo_palestrante
WHERE p.codigo_palestra = 1

SELECT * FROM v_lista
order by Nome_Pessoa
