<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Relatório com Jasper Report</title>
</head>
<body>
	<div align="center">
		<h2>Gerador de Notas de Compra</h2>
		<img src="<c:url value="/images/logo.png"/>" width="110px"
			height="100px" />
		<form action="/jasperReport/relatorio" method="post" target="_blank">
			<span class="sCpf">CPF do Cliente</span> <input type="text"
				name="cpfCliente" placeholder="CPF"><br> <span
				class="sDataCompra">Data da Compra</span> <input type="datetime"
				name="dataCompra" placeholder="dd/MM/yyyy"><br>
			<button type="submit" class="btnGerarNota" value="gerar">Gerar</button>
		</form>
	</div>
</body>
</html>