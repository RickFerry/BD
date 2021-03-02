/*
Criar uma database chamada academia, com 3 tabelas como seguem:

Aluno
|Codigo_aluno|Nome|

Atividade
|Codigo|Descrição|IMC|

Atividade
codigo      descricao                           imc
----------- ----------------------------------- --------
1           Corrida + Step                       18.5
2           Biceps + Costas + Pernas             24.9
3           Esteira + Biceps + Costas + Pernas   29.9
4           Bicicleta + Biceps + Costas + Pernas 34.9
5           Esteira + Bicicleta                  39.9                                                                                                                     
Atividadesaluno
|Codigo_aluno|Altura|Peso|IMC|Atividade|

IMC = Peso (Kg) / Altura² (M)

Atividade: Buscar a PRIMEIRA atividade referente ao IMC imediatamente acima do calculado.
* Caso o IMC seja maior que 40, utilizar o código 5.

Criar uma Stored Procedure (sp_alunoatividades), com as seguintes regras:

 - Se, dos dados inseridos, o código for nulo, mas, existirem nome, altura, peso, deve-se inserir um novo registro nas tabelas aluno e aluno atividade com o imc calculado e as atividades pelas regras estabelecidas acima.

 - Se, dos dados inseridos, o nome for (ou não nulo), mas, existirem código, altura, peso, deve-se 
 verificar se aquele código existe na base de dados e atualizar a altura, o peso, o imc calculado e 
 as atividades pelas regras estabelecidas acima.
*/

CREATE database academia
go
use academia

create table aluno(
codigo_aluno int,
nome varchar(100)
)

create table atividade(
codigo int,
descricao varchar(100),
imc float
)

create table atividade_aluno(
codigo_aluno int,
altura float,
peso float,
imc float,
atividade int
)

create procedure sp_aluno_atividades(@nome varchar(100), @codigo int, @altura float, @peso float, @retorno varchar(max) output) as
	declare @imc float
	exec sp_calcula_imc @peso, @altura, @imc output

		if(@codigo is null)
			and (@nome is not null)
			and (@peso is not null)
			and (@altura is not null)
			and (@imc > 18.4) and (@imc < 24.9)
		begin
			insert into aluno values(null, @nome)
			insert into atividade_aluno values(null, @altura, @peso, @imc, 1)
			set @retorno = 'Sucesso!!!'
		end
		if(@codigo is not null)
			and (@peso is not null)
			and (@altura is not null)
		begin
			update atividade_aluno set altura = @altura, peso = @peso, imc = @imc, atividade = 1 where codigo_aluno = @codigo
			set @retorno = 'Sucesso!!!'
		end
		if(@codigo is null)
			and (@nome is not null)
			and (@peso is not null)
			and (@altura is not null)
			and (@imc > 24.8)
			and (@imc < 29.9)
		begin
			insert into aluno values(null, @nome)
			insert into atividade_aluno values(null, @altura, @peso, @imc, 2)
			set @retorno = 'Sucesso!!!'
		end
		if(@codigo is not null)
			and (@peso is not null)
			and (@altura is not null)
		begin
			update atividade_aluno set altura = @altura, peso = @peso, imc = @imc, atividade = 2 where codigo_aluno = @codigo
			set @retorno = 'Sucesso!!!'
		end
		if(@codigo is null)
			and (@nome is not null)
			and (@peso is not null)
			and (@altura is not null)
			and (@imc > 29.8)
			and (@imc < 34.9)
		begin
			insert into aluno values(null, @nome)
			insert into atividade_aluno values(null, @altura, @peso, @imc, 3)
			set @retorno = 'Sucesso!!!'
		end
		if(@codigo is not null)
			and (@peso is not null)
			and (@altura is not null)
		begin
			update atividade_aluno set altura = @altura, peso = @peso, imc = @imc, atividade = 3 where codigo_aluno = @codigo
			set @retorno = 'Sucesso!!!'
		end
		if(@codigo is null)
			and (@nome is not null)
			and (@peso is not null)
			and (@altura is not null)
			and (@imc > 34.8)
			and (@imc < 39.9)
		begin
			insert into aluno values(null, @nome)
			insert into atividade_aluno values(null, @altura, @peso, @imc, 4)
			set @retorno = 'Sucesso!!!'
		end
		if(@codigo is not null)
			and (@peso is not null)
			and (@altura is not null)
		begin
			update atividade_aluno set altura = @altura, peso = @peso, imc = @imc, atividade = 4 where codigo_aluno = @codigo
			set @retorno = 'Sucesso!!!'
		end
		if(@codigo is null)
			and (@nome is not null)
			and (@peso is not null)
			and (@altura is not null)
			and (@imc > 39.9)
		begin
			insert into aluno values(null, @nome)
			insert into atividade_aluno values(null, @altura, @peso, @imc, 5)
			set @retorno = 'Sucesso!!!'
		end
		if(@codigo is not null)
			and (@peso is not null)
			and (@altura is not null)
		begin
			update atividade_aluno set altura = @altura, peso = @peso, imc = @imc, atividade = 5 where codigo_aluno = @codigo
			set @retorno = 'Sucesso!!!'
		end
	
	
create procedure sp_calcula_imc(@peso float, @altura float, @imc float output) as
	set @imc = @peso / (@altura * @altura)
	
	
declare @out varchar(MAX)
exec sp_aluno_atividades 'Maria', null, 1.52, 51.8, @out output
print @out
