package paulistinha.persistence;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;

public class SimulaGruposDao {

	private Connection c;

	public SimulaGruposDao() throws ClassNotFoundException, SQLException {
		GenericDao gDao = new GenericDao();
		gDao.getConnection();
	}
	
	public void procGerar() throws SQLException {
		String sql = "{}"; //Procedure para gerar os grupos
		CallableStatement cs = c.prepareCall(sql);
		cs.execute();
		cs.close();
	}
}