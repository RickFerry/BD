package paulistinha.persistence;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;

public class PesquisaJogosDao {

	private Connection c;
	
	public PesquisaJogosDao() throws ClassNotFoundException, SQLException {
		GenericDao gDao = new GenericDao();
		gDao.getConnection();
	}
	
	public void procGerar() throws SQLException {
		String sql = "{}";
		CallableStatement cs = c.prepareCall(sql);
		cs.execute();
		//Logica para buscar no banco os jogos por data
		cs.close();
	}
}
