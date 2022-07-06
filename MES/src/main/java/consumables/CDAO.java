package consumables;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.ParseException;
import java.util.ArrayList;

import dbconn.DBconn;
import faulty.Faulty;

public class CDAO {

	private DBconn db;
	private Statement stmt;
	private PreparedStatement pstmt;
	private CallableStatement cstmt;
	private ResultSet rs;
	private Connection con;
	
	public CDAO() {
		DBconn();
	}
	
	private String driver = "com.mysql.cj.jdbc.Driver";
	private String url = "jdbc:mysql://192.168.0.115:3306/mes?" + "useUnicode=true&characterEncoding=utf8"; 
	private String id = "Usera";
	private String pw = "1234";
	
	private void DBconn() {
		try {
			Class.forName(driver);
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	
	//소재구분 서브코드명 가져오기
	public ArrayList<String> getSub(){
		ArrayList<String> list = new ArrayList<String>();
		String SQL="SELECT sub_code FROM mes.code_sub where main_code = '소재구분';";
		try {
			con = DriverManager.getConnection(url, id, pw);
			PreparedStatement pstmt = con.prepareStatement(SQL);
			rs=pstmt.executeQuery();
			while(rs.next()) {
				list.add(rs.getString(1));
			}
			rs.close();
			pstmt.close();
			con.close();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return list.isEmpty() ? null : list;	//삼항 연산자 빈값이면 null 반환 빈값이 아니면 list 값 반환
	}
	
	//소모품 현황 데이터 메소드
		public ArrayList<Consumables> getCList(String cstart, String cend ) {
			ArrayList<Consumables> list = new ArrayList<Consumables>();
			String SQL1="select price, tool_name from tool  where reg_date >= ? and reg_date <= ? ";
			
			for(int i =0 ; i<getSub().size(); i++) {
				Consumables b = new Consumables();
				b.setTool_name(getSub().get(i));
				b.setPrice(0);
				list.add(b);
			}
			
			try {
				con = DriverManager.getConnection(url, id, pw);
				PreparedStatement pstmt=con.prepareStatement(SQL1);
				pstmt.setString(1, cstart);
				pstmt.setString(2, cend);
				rs=pstmt.executeQuery();
				while(rs.next()) {
					for(int i=0;i<list.size();i++) {
						if(list.get(i).getTool_name().equals(rs.getString("tool_name"))) {
							list.get(i).setPrice(rs.getInt("price"));
						}
					
					}
				}
				rs.close();
				pstmt.close();
				con.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
			return list;
		}
	
		//소모품 현황 합계 
		public int getCsum(String cstart, String cend) {
			String SQL = "select sum(price) from tool where reg_date >= '" + cstart + "' and reg_date <= '" + cend + "'";
			int csum = 0;
			try {
				con = DriverManager.getConnection(url, id, pw);
				PreparedStatement pstmt=con.prepareStatement(SQL);
				rs=pstmt.executeQuery();
				if(rs.next()) {
					csum = rs.getInt(1);
				}
				rs.close();
				pstmt.close();
				con.close();
			}catch(Exception e){
				e.printStackTrace();
			}
			return csum; 
		}
		
		//소모품 현황 평균 
			public int getCavg(String cstart, String cend) {
				String SQL = "select avg(price) from tool where reg_date >= '" + cstart + "' and reg_date <= '" + cend + "'";
				int cavg = 0;
				try {
					con = DriverManager.getConnection(url, id, pw);
					PreparedStatement pstmt=con.prepareStatement(SQL);
					rs=pstmt.executeQuery();
					if(rs.next()) {
						cavg = rs.getInt(1);
					}
					rs.close();
					pstmt.close();
					con.close();
				}catch(Exception e){
					e.printStackTrace();
				}
				return cavg; 
			}
	
		//소모품 현황 시작일자 세팅
		public String getdate() {
			String SQL = "select reg_date from tool order by reg_date";
			String result=null;
			
			try {
				con = DriverManager.getConnection(url, id, pw);
				PreparedStatement pstmt = con.prepareStatement(SQL);
				rs=pstmt.executeQuery();
				if(rs.next()) {
					result=rs.getString(1);
				}else {
					result="2022-01-01";
				}
				
				rs.close();
				pstmt.close();
				con.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
			
			
			return result;
		}
}
