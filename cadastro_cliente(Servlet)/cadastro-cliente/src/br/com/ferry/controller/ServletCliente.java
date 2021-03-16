package br.com.ferry.controller;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import br.com.ferry.model.Cliente;
import br.com.ferry.persistence.ClienteDao;

@WebServlet("/insereCliente")
public class ServletCliente extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		Cliente cli = new Cliente();
		cli.setNome(request.getParameter("nome"));
		cli.setTelefone(request.getParameter("telefone"));
		
		String saida = "";
		
		try {
			ClienteDao cDao = new ClienteDao();
			saida = cDao.procCliente(cli);
		} catch (ClassNotFoundException | SQLException e) {
			saida = e.getMessage();
		}finally {
			RequestDispatcher rd = request.getRequestDispatcher("index.jsp");
			request.setAttribute("saida", saida);
			rd.forward(request, response);
		}
	}
}
