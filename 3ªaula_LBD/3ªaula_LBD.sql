--Algoritmo CPF:

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

SET @cpf = '33355577738'
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
	PRINT 'CPF com n�meros iguais, � inv�lido'
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
		PRINT 'CPF verificado, � v�lido'
	END
	ELSE
	BEGIN
		PRINT 'CPF verificado, � inv�lido'
	END
END
---------------------------------------------------------------------------------------------------

/*
Fazer um algoritmo que leia 3 valores e retorne se os valores formam um tri�ngulo e se ele � is�celes, escaleno ou equil�tero.
Condi��es para formar um tri�ngulo: Nenhum valor pode ser = 0. Um lado n�o pode ser maior que a soma dos outros 2.
*/
DECLARE @v1 INT,
		@v2 INT,
		@v3 INT

SET @v1 = 13
SET @v2 = 15
SET @v3 = 22

IF (@v1 > @v2 + @v3 OR @v2 > @v1 + @v3 OR @v3 > @v1 + @v2 OR @v1 = 0 OR @v2 = 0 OR @v3 = 0)
BEGIN
	PRINT 'N�o � tri�ngulo'
END
ELSE
BEGIN
	IF (@v1 = @v2 AND @v2 = @v3)
	BEGIN
		PRINT 'Tri�ngulo equil�tero'
	END
	ELSE
	BEGIN
		IF (@v1 = @v2 AND @v1 != @v3
			OR @v1 = @v3 AND @v1 != @v2
			OR @v2 = @v3 AND @v2 != @v1)
		BEGIN
			PRINT 'Tri�ngulo is�sceles' 
		END
		ELSE
		BEGIN
			PRINT 'Tri�ngulo escaleno'
		END
	END
END
----------------------------------------------------------------------------------------------------------------

--Fazer um algoritmo que leia 3 n�meros e mostre o maior e o menor

DECLARE @num1 INT,
		@num2 INT,
		@num3 INT,
		@maior INT,
		@menor INT

SET @num1 = 2
SET @num2 = 3
SET @num3 = 1

IF (@num1 = @num2 AND @num1 = @num3)
BEGIN
	PRINT 'Os n�meros s�o iguais'
END
ELSE
BEGIN
	IF (@num1 > @num2)
	BEGIN
		SET @maior = @num1
		SET @menor = @num2
	END
	ELSE
	BEGIN
		SET @maior = @num2
		SET @menor = @num1
	END
	IF (@num3 > @menor)
	BEGIN
		IF (@num3 > @maior)
		BEGIN
			SET @maior = @num3
		END
	END
	ELSE
	BEGIN
		SET @menor = @num3
	END
	PRINT 'MAIOR = ' + CAST(@maior AS VARCHAR(15))
	PRINT 'MENOR = ' + CAST(@menor AS VARCHAR(15))
END
------------------------------------------------------------------------------------------------------------------------

--Fazer um algoritmo que calcule os 15 primeiros termos da s�rie 1,1,2,3,5,8,13,21,... E calcule a soma dos 15 termos

DECLARE @soma INT,
		@cont INT,
		@fibo INT,
		@anterior INT,
		@atual INT

SET @soma = 0
SET @anterior = 0
SET @atual = 1
SET @cont = 0

WHILE (@cont < 15)
BEGIN
	SET @fibo = @atual + @anterior
	SET @atual = @anterior
	SET @anterior = @fibo
	SET @soma = @soma + @fibo
	SET @cont = @cont + 1
	PRINT @fibo
END
PRINT ''
PRINT 'SOMA = ' + CAST(@soma AS VARCHAR(5))
---------------------------------------------------------------------------------------------------

--Fazer um algoritmo que separa uma frase, colocando todas as letras em mai�sculo e em min�sculo

DECLARE @fraseOriginal VARCHAR(100),
		@fraseUpper VARCHAR(100),
		@fraseLower VARCHAR(100)

SET @fraseOriginal = 'A vOlTa DOs QuE n�o FoRaM'
SET @fraseUpper = UPPER(@fraseOriginal)
SET @fraseLower = LOWER(@fraseOriginal)

PRINT @fraseOriginal
PRINT @fraseUpper
PRINT @fraseLower
------------------------------------------------------------------------------------------------------------

--Fazer um algoritmo que inverta uma palavra

DECLARE @palavraOriginal VARCHAR(45),
		@palavraInvertida VARCHAR(45),
		@cont INT

SET @palavraOriginal = 'vitor'
SET @cont = LEN(@palavraOriginal)
SET @palavraInvertida = ''

WHILE (@cont >= 0)
BEGIN
	SET @palavraInvertida = @palavraInvertida + SUBSTRING(@palavraOriginal, @cont, 1)
	SET @cont = @cont - 1
END
PRINT 'Palavra original: ' + @palavraOriginal
PRINT 'Palavra invertida: ' + @palavraInvertida
-------------------------------------------------------------------------------------------------

--Verificar pal�ndromo

DECLARE @palavraOriginal VARCHAR(45),
		@palavraInvertida VARCHAR(45),
		@cont INT

SET @palavraOriginal = 'romametemamor'
SET @cont = LEN(@palavraOriginal)
SET @palavraInvertida = ''

WHILE (@cont >= 0)
BEGIN
	SET @palavraInvertida = @palavraInvertida + SUBSTRING(@palavraOriginal, @cont, 1)
	SET @cont = @cont - 1
END
IF (@palavraInvertida = @palavraOriginal)
BEGIN
	PRINT 'A palavra "' + CAST(@palavraOriginal AS VARCHAR(45)) + '" � um pal�ndromo'
END
ELSE
BEGIN
	PRINT 'A palavra "' + CAST(@palavraOriginal AS VARCHAR(45)) + '" n�o � um pal�ndromo'
END
----------------------------------------------------------------------------------------------------------------

--Fazer um algoritmo que leia 1 n�mero e mostre se s�o m�ltiplos de 2,3,5 ou nenhum deles

DECLARE @num INT
SET @num = 7

IF (@num % 2 = 0 AND @num % 3 = 0)
BEGIN
	PRINT 'O n�mero ' +CAST(@num AS VARCHAR(3)) + ' � m�ltiplo de 2 e 3'
END
ELSE
BEGIN
	IF (@num % 2 = 0 AND @num % 5 = 0)
	BEGIN
		PRINT 'O n�mero ' +CAST(@num AS VARCHAR(3)) + ' � m�ltiplo de 2 e 5'
	END
	ELSE
	BEGIN
		IF (@num % 2 = 0)
		BEGIN
			PRINT 'O n�mero ' +CAST(@num AS VARCHAR(3)) + ' � m�ltiplo de 2'
		END
		ELSE
		BEGIN
			IF (@num % 3 = 0 AND @num % 5 = 0)
			BEGIN
				PRINT 'O n�mero ' +CAST(@num AS VARCHAR(3)) + ' � m�ltiplo de 3 e 5'
			END
			ELSE
			BEGIN
				IF (@num % 3 = 0)
				BEGIN
					PRINT 'O n�mero ' +CAST(@num AS VARCHAR(3)) + ' � m�ltiplo de 3'
				END
				ELSE
				BEGIN
					IF (@num % 5 = 0)
					BEGIN
						PRINT 'O n�mero ' +CAST(@num AS VARCHAR(3)) + ' � m�ltiplo de 5'
					END
					ELSE
					BEGIN
						PRINT 'O n�mero ' +CAST(@num AS VARCHAR(3)) + ' N�O � m�ltiplo de 2, 3, 5'
					END
				END
			END
		END
	END
END
