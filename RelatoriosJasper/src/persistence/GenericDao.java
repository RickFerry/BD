package persistence;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class GenericDao {
	
	private Connection c;

	public Connection getConnection() throws ClassNotFoundException, SQLException {
		
		String driver = "net.sourceforge.jtds.jdbc.Driver";
		String hostName = "localhost";
		String dbName = "relatorio";
		String user = "";
		String password = "";
		
		Class.forName(driver);
		c = DriverManager.getConnection(String.format("jdbc:jtds:sqlserver://%s:1433;databaseName=%s;user=%s;password=%s;", 
			hostName, dbName, user, password));
		
		return c;
	}
}
