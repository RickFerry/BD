<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<div align="center">
		<form action="simulaGrupos">
			<div>
				<label>Clique aqui para gerar os grupos</label>
			</div>
			<div>
				<input type="submit" value="Gerar">
			</div>
		</form>
		<form action="simulaJogos">
			<div>
				<label>Clique aqui para gerar os jogos</label>
			</div>
			<div>
				<input type="submit" value="Gerar">
			</div>
		</form>
		<form action="tabela">
			<div>
				<label>Clique aqui para mostrar os grupos</label>
			</div>
			<div>
				<input type="submit" value="Mostrar">
			</div>
		</form>
		<form action="pesquisaJogos" method="post">
			<div>
				<label>Pesquise jogos por data</label>
			</div>
			<div>
				<input type="date" name="data" placeholder="Insira uma data válida">
			</div>
			<div>
				<input type="submit" value="Pesquisar">
			</div>
		</form>
	</div>
</body>
</html>