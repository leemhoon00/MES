package jh;

import java.sql.*;

public class jhdbconn {
	public Connection conn=null;
	public Statement stmt=null;
	public ResultSet rs=null;
	public String query=null;
	public PreparedStatement pstmt=null;
	
	String jdbcDriver = "jdbc:mysql://192.168.0.115:3306/mes?" + "useUnicode=true&characterEncoding=utf8";
	public String dbUser = "Usera";
	public String dbPass = "1234";
	
	public jhdbconn() {
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
			stmt = conn.createStatement();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
	}
}

