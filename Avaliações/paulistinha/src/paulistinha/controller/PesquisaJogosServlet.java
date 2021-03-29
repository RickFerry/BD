package paulistinha.controller;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/pesquisaJogos")
public class PesquisaJogosServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		//Logica para pegar do banco e mandar para tela os jogos pesquisados
		RequestDispatcher rd = request.getRequestDispatcher("pesquisaJogos.jsp");
		rd.forward(request, response);
	}
}
