package faulty;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;

import dbconn.DBconn;

public class FaultyDAO {
	
	private DBconn db;

	
	private Statement stmt;
	private PreparedStatement pstmt;
	private CallableStatement cstmt;
	private ResultSet rs;
	private Connection con;
	
	public FaultyDAO() {
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
	
	
	//불량 리스트 출력 
	public List<Faulty> getList(){
		List<Faulty> list = new ArrayList<Faulty>();
		
		try {
			String sql = "select * from faulty order by faulty_no desc limit 10";
			
			con = DriverManager.getConnection(url, id, pw);
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				Faulty b = new Faulty();
				
				b.setFaulty_no(rs.getInt("faulty_no"));
				b.setLink_info(rs.getString("link_info"));
				b.setFaulty_type(rs.getString("faulty_type"));
				b.setCause_of_defect(rs.getString("cause_of_defect"));
				b.setDate_of_occurrence(rs.getString("date_of_occurrence"));
				b.setMaterials_cost(rs.getInt("materials_cost"));
				b.setCost(rs.getInt("cost"));
				b.setFaulty_title(rs.getString("faulty_title"));
				b.setFaulty_content(rs.getString("faulty_content"));
				b.setSolution(rs.getString("solution"));
				b.setUser_id(rs.getString("user_id"));
				b.setProc_date(rs.getString("proc_date"));
				b.setPart_name(rs.getString("part_name"));
				b.setProcess(rs.getString("process"));
				b.setOrder_name(rs.getString("order_name"));
				

				list.add(b);
				
				
			}
			
			rs.close();
			pstmt.close();
			con.close();
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return list;
	}
	
	

		//불량 저장
		public int updatefaulty(Faulty vo) {
			
			int result = 0;
			
			try {
				String sql = "update faulty set faulty_type = ?, cause_of_defect = ?, date_of_occurrence = ?, materials_cost = ?"
						+ ", cost = ?, faulty_title = ?, faulty_content = ?, solution = ?, user_id = ?, proc_date = ? where faulty_no = ?";
				
				con = DriverManager.getConnection(url, id, pw);
				pstmt = con.prepareStatement(sql);
				
				pstmt.setString(1, vo.getFaulty_type());
				pstmt.setString(2, vo.getCause_of_defect());
				pstmt.setString(3, vo.getDate_of_occurrence());
				pstmt.setInt(4, vo.getMaterials_cost());
				pstmt.setInt(5, vo.getCost());
				pstmt.setString(6, vo.getFaulty_title());
				pstmt.setString(7, vo.getFaulty_content());
				pstmt.setString(8, vo.getSolution());
				pstmt.setString(9, vo.getUser_id());
				pstmt.setString(10, vo.getProc_date());
				pstmt.setInt(11, vo.getFaulty_no());
				
				//pstmt.setString(2, vo.getLink_info());
				
				result = pstmt.executeUpdate();
				
				pstmt.close();
				con.close();
				
				}catch(Exception e) {
				e.printStackTrace();
			}
			System.out.println(result);
			return result;
		}
		
		
		//불량 삭제
		public int deletefaulty(String bn) {
			int result = 0;
			
			try {
				String sql = "delete from faulty where faulty_no = " + bn;
				
				con = DriverManager.getConnection(url, id, pw);
				stmt = con.createStatement();
				
				result = stmt.executeUpdate(sql);
			
				sql = "{CALL decid("+ bn + ", \'mes.faulty\', \'faulty_no\') }";
				cstmt = con.prepareCall(sql);
				cstmt.execute();
				
				con.close();
				stmt.close();
				cstmt.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
			
			return result;
		}
	
		
	// 불량원인 콤보박스 데이터 세팅
	 public ArrayList<String> getfcause() {
		ArrayList<String> list = new ArrayList<String>();
		String SQL="select sub_code from mes.code_sub where main_code = '불량원인';";
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
	
	// 불량유형 콤보박스 데이터 세팅
		 public ArrayList<String> getftype() {
			ArrayList<String> list = new ArrayList<String>();
			String SQL="select sub_code from mes.code_sub where main_code = '불량유형';";
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
		 
	// 담당자 콤보박스 데이터 세팅
		 public ArrayList<String> getfuser() {
			ArrayList<String> list = new ArrayList<String>();
			String SQL="select user_id from mes.user;";
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
		 
		 
		// 검색패널 - 발생일자 시작일자 세팅
			public String getstartdate() {
				String SQL="SELECT date_of_occurrence FROM mes.faulty order by date_of_occurrence";
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
				if(result!=null) {
					String year=result.substring(2,4);
					String mouth=result.substring(5,7);
					String day=result.substring(8,10);
					result=year.concat("/"+mouth+"/"+day);
				}
				
				return result;
			}
			
		//데이터 리스트 검색 메소드
		public ArrayList<Faulty> getFaultyList(int pagenum, String txt_where) throws ParseException{
			ArrayList<Faulty> list = new ArrayList<Faulty>();
			String SQL1="SELECT faulty_no FROM mes.faulty"+ txt_where + " ORDER BY faulty_no desc";
			String SQL2="SELECT * FROM mes.faulty"+ txt_where + " and faulty_no<? ORDER BY faulty_no desc limit 10";
			int num=-1;
			
			try {
				con = DriverManager.getConnection(url, id, pw);
				PreparedStatement pstmt=con.prepareStatement(SQL1);
				rs=pstmt.executeQuery();
				if(rs.next()) {
					num=rs.getInt(1)+1;
				}else {
					num=1;
				}
				rs.close();
				pstmt.close();
				con.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
			
			try {
				con = DriverManager.getConnection(url, id, pw);
				PreparedStatement pstmt = con.prepareStatement(SQL2);
				pstmt.setInt(1, num-(pagenum-1)*10);
				rs=pstmt.executeQuery();
				while(rs.next()) {
					Faulty rs_o=new Faulty();
					
					rs_o.setFaulty_no ( rs.getInt(1));
					rs_o.setLink_info ( rs.getString(2));
					rs_o.setFaulty_type(rs.getString(3));
					rs_o.setCause_of_defect ( rs.getString(4));
					rs_o.setDate_of_occurrence ( rs.getString(5));
					rs_o.setMaterials_cost ( rs.getInt(6));
					rs_o.setCost(rs.getInt(7));
					rs_o.setFaulty_title(rs.getString(8));
					rs_o.setFaulty_content(rs.getString(9));
					rs_o.setSolution(rs.getString(10));
					rs_o.setUser_id(rs.getString(11));
					rs_o.setProc_date(rs.getString(12));
					rs_o.setPart_name ( rs.getString(13));
					rs_o.setProcess ( rs.getString(14));
					rs_o.setOrder_name(rs.getString(15));
					//리스트에 추가
					list.add(rs_o);
				}
				rs.close();
				pstmt.close();
				con.close();
			} catch(SQLException e) {
				e.printStackTrace();
			}
			return list;
		}
		
		//열 번호 세팅
		public int getNext() {
			String SQL = "select count(faulty_no) from mes.faulty order by faulty_no desc";
			int res = -1;
			
			try {
				con = DriverManager.getConnection(url, id, pw);
				PreparedStatement pstmt = con.prepareStatement(SQL);
				rs=pstmt.executeQuery();
				if(rs.next()) {
					res = rs.getInt(1) + 1;
				}
				else {
					res = 1;
				}
				
				rs.close();
				pstmt.close();
				con.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
			return res;
		}
		
		//검색결과 총 금형번호의 수(페이지네이션에서 응용)
		public int getSearchAmount(String txt_where) {
					
			String SQL = "select count(*) as rownum from mes.faulty" + txt_where;
			
			int nextnum = -1;
			
			try {
				con = DriverManager.getConnection(url, id, pw);
				PreparedStatement pstmt = con.prepareStatement(SQL);
				rs=pstmt.executeQuery();
				
				if(rs.next()) {
					nextnum = rs.getInt("rownum");
				}
				
				rs.close();
				con.close();
				pstmt.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
			
			return nextnum;
		}	
		
		// 링크정보 데이터 세팅
		// 설비 콤보박스 데이터 세팅
		 public ArrayList<String> getfacilities() {
			ArrayList<String> list = new ArrayList<String>();
			String SQL="select distinct facilities_name from mes.facilities;";
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
}
