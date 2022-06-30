<!-- 발주 관련 -->

<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.Statement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.SQLException"%>

<!-- 데이터베이스 연결 -->
<%
Class.forName("com.mysql.jdbc.Driver");
Connection conn = null;
Statement stmt = null;
String query= null;

String jdbcDriver = "jdbc:mysql://192.168.0.115:3306/mes?" + "useUnicode=true&characterEncoding=utf8";
String dbUser = "Usera";
String dbPass = "1234";
conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Insert title here</title>
</head>
<body>

<%

String part_name = request.getParameter("part_name");
String part_type = request.getParameter("part_type");

String number_of_request = request.getParameter("number_of_request");

if(part_name.equals("")){
	response.sendRedirect("part_management.jsp");
}
else{
	
	query = "insert into manage_porder(part_name, order_name, number_of_request, type) values('"+part_name+"',null,"+number_of_request+",'"+part_type+"')";

	stmt = conn.createStatement();
	stmt.executeUpdate(query);
	
	stmt.close();
	conn.close();
	
	response.sendRedirect("part_management.jsp");
}
%>

</body>
</html>