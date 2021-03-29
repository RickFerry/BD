package paulistinha.persistence;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;

public class SimulaJogosDao {
	
	private Connection c;

	public SimulaJogosDao() throws ClassNotFoundException, SQLException {
		GenericDao gDao = new GenericDao();
		gDao.getConnection();
	}
	
	public void procGerar() throws SQLException {
		String sql = "{}"; // Procedure que simulas os jogos
		CallableStatement cs = c.prepareCall(sql);
		cs.execute();
		cs.close();
	}
}