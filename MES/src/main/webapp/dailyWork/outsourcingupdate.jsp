<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.Statement"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.time.LocalDate"%>


<%
// 	데이터베이스 연결
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = null;
	ResultSet rs = null;
	String query= null;
	PreparedStatement pstmt=null;
	
	String jdbcDriver = "jdbc:mysql://192.168.0.115:3306/mes?" + "useUnicode=true&characterEncoding=utf8";
	String dbUser = "Usera";
	String dbPass = "1234";
	conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
String outsourcing_no = request.getParameter("outsourcing_no");
int price = Integer.parseInt(request.getParameter("price"));
String whdate = request.getParameter("whdate");
String outsstarttime = request.getParameter("outsstarttime");
String outsendtime = request.getParameter("outsendtime");
String faultycheck = request.getParameter("faultycheck");

if(whdate.equals("")){
	whdate="NULL";
}
else{
	
}



query = "update mes.outsourcing set price=?,warehousing_exp_date=?,outstart_date=?,outend_date=?,faulty=? where outsourcing_no="+outsourcing_no;

pstmt = conn.prepareStatement(query);

pstmt.setInt(1,price);

if(whdate.equals("")){
	pstmt.setString(2,null);
}
else{
	pstmt.setString(2,whdate);
}
if(outsstarttime.equals("")){
	pstmt.setString(3,null);
}
else{
	pstmt.setString(3,outsstarttime);
}
if(outsendtime.equals("")){
	pstmt.setString(4,null);
}
else{
	pstmt.setString(4,outsendtime);
}

if(faultycheck==null){
	pstmt.setString(5,"N");
}
else{
	pstmt.setString(5,"Y");
}

pstmt.executeUpdate();

pstmt.close();
conn.close();

response.sendRedirect("dailyWork.jsp");
%>
</body>
</html>