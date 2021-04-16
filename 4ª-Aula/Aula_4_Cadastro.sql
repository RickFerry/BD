/*
Criar uma database chamada cadastro, criar uma tabela pessoa (CPF CHAR(11) PK, nome VARCHAR(80)),
pegar o algoritmo de validação de CPF, transformar em uma Stored Procedure sp_inserepessoa, que
receba como parâmetro @cpf e @nome e @saida como parâmtero de saída. Valide o CPF e, só insira na
tabela pessoa (cpf e nome) com CPF válido e nome com LEN Maior que zero. @saida deve dizer que foi
inserido com sucesso. Raiserrors devem tratar violações.
*/

create database cadastro
go
use cadastro

create table pessoa(
cpf char(11) not null,
nome varchar(80) not null
primary key(cpf)
)

create procedure sp_insere_pessoa(@cpf char(11), @nome varchar(80), @saida varchar(max) output) as
	declare @check_cpf bit
	exec sp_valida_cpf @cpf, @check_cpf output
	
	if(len(@nome) > 0) and (@check_cpf != 0)
	begin
		insert into pessoa values(@cpf, @nome)
		set @saida = 'Cadastro feito com sucesso.'
	end
	else
	begin
		raiserror('Operação sem sucesso!', 16, 1)
	end
	
	
create procedure sp_valida_cpf(@cpf_ char(11), @resp bit output) as
	DECLARE @cpf CHAR(11),
			@cpfVerificado CHAR(11),
			@CpfValido INT,
			@cont INT,
			@cont2 INT,
			@digitoVerificador VARCHAR(2),
			@calc INT,
			@soma INT,
			@aux INT,
			@aux2 INT

SET @cpf = @cpf_
SET @cont = 2
SET @CpfValido = 1
SET @soma = 0

WHILE (@cont <= LEN(@cpf))
BEGIN
	IF (SUBSTRING(@cpf, @cont, 1) = SUBSTRING(@cpf, @cont - 1, 1))
	BEGIN
		SET @CpfValido = @CpfValido + 1
		SET @cont = @cont + 1
	END
	ELSE
	BEGIN
		SET @cont = @cont + 1
	END
END
IF (@CpfValido = LEN(@cpf))
BEGIN
	set @resp = 0
END
ELSE
BEGIN
	SET @cont = 10
	SET @cont2 = 1
	WHILE (@cont >= 2)
	BEGIN
		SET @aux = CONVERT(INT, SUBSTRING(@cpf, @cont2, 1))
		SET @soma = @soma + (@aux * @cont)
		SET @cont = @cont - 1
		SET @cont2 = @cont2 + 1
	END
	SET @calc = @soma % 11
	IF (@calc < 2)
	BEGIN
		SET @digitoVerificador = @digitoVerificador + '0'
	END
	ELSE
	BEGIN
		SET @aux2 = 11 - @calc
		SET @digitoVerificador = CAST(@aux2 AS CHAR(1))
	END

	SET @cont = 11
	SET @cont2 = 1
	SET @soma = 0
	WHILE (@cont >= 2)
	BEGIN
		SET @aux = CONVERT(INT, SUBSTRING(@cpf, @cont2, 1))
		SET @soma = @soma + (@aux * @cont)
		SET @cont = @cont - 1
		SET @cont2 = @cont2 + 1
	END
	SET @calc = @soma % 11
	IF (@calc < 2)
	BEGIN
		SET @digitoVerificador = @digitoVerificador + '0'
	END
	ELSE
	BEGIN
		SET @aux2 = 11 - @calc
		SET @digitoVerificador = @digitoVerificador + CAST(@aux2 AS CHAR(1))
	END
	SET @cpfVerificado = SUBSTRING(@cpf, 1, 9) + @digitoVerificador
	IF (@cpfVerificado = @cpf)
	BEGIN
		set @resp = 1
	END
	ELSE
	BEGIN
		set @resp = 0
	END
END

DECLARE @saida varchar(max)
EXEC sp_insere_pessoa '40573084076', 'Ferry', @saida OUTPUT
print @saida
