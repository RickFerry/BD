package paulistinha.persistence;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;

public class TabelaDao {

	private Connection c;

	public TabelaDao() throws ClassNotFoundException, SQLException {
		GenericDao gDao = new GenericDao();
		gDao.getConnection();
	}
	
	public void procGerar() throws SQLException {
		String sql = "{}";
		CallableStatement cs = c.prepareCall(sql);
		cs.execute();
		//Logica para pegar os grupos do banco e mandar para o servlet
		cs.close();
	}
}
