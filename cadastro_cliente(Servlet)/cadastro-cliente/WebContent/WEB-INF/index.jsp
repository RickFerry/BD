<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>    

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<div align="center">
		<form action="insereCliente" method="post">
			<table>
				<tr>
					<td><input type="text" name="nome" id="nome" placeholder="nome"></td>
				</tr>
				<tr>
					<td><input type="text" name="telefone" id="telefone" placeholder="telefone"></td>
				</tr>
				<tr>
					<td><input type="submit" name="enviar" id="enviar" placeholder="enviar"></td>
				</tr>
				<c:if test="${not empty saida}">
					<tr>
						<td><c:out value="${saida}"></c:out></td>
					</tr>
				</c:if>
			</table>
		</form>
	</div>
</body>
</html>