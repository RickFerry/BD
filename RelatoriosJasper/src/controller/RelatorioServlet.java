package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;

import javax.jws.WebService;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.JasperRunManager;
import net.sf.jasperreports.engine.util.JRLoader;
import persistence.GenericDao;

@WebService(endpointInterface = "/jasperReport/relatorio")
public class RelatorioServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		gerarRelatorio(request, response);
	}

	private void gerarRelatorio(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String erro = "";
		String cpfCliente = request.getParameter("cpfCliente");
		String dataCompra = request.getParameter("dataCompra");
		String logo = "C:/Users/f-win/Downloads/logo.png";
		String jasper = "WEB-INF/report/Relatorio.jasper";

		HashMap<String, Object> param = new HashMap<>();
		param.put("cpfCliente", cpfCliente);
		param.put("dataCompra", dataCompra);
		param.put("logo", logo);

		byte[] bytes = null;
		ServletContext contexto = getServletContext();

		try {
			JasperReport relatorio = (JasperReport) JRLoader.loadObjectFromFile(contexto.getRealPath(jasper));
			bytes = JasperRunManager.runReportToPdf(relatorio, param, new GenericDao().getConnection());
		} catch (JRException | ClassNotFoundException | SQLException e) {
			erro = e.getMessage();
			System.out.println(e.getMessage());
		} finally {
			if (bytes != null) {
				response.setContentType("application/pdf");
				response.setContentLength(bytes.length);
				ServletOutputStream sos = response.getOutputStream();
				sos.write(bytes);
				sos.flush();
				sos.close();
			} else {
				RequestDispatcher rd = request.getRequestDispatcher("index.jsp");
				request.setAttribute("erro", erro);
				rd.forward(request, response);
			}
		}
	}
}
