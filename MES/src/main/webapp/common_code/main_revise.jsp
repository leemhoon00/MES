<!-- 메인 코드 수정 -->

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
ResultSet rs = null;
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

String mainrevise = request.getParameter("mainrevise");
String txtmaingroup = request.getParameter("txtmaingroup");
String txtmainmain = request.getParameter("txtmainmain");
String mainusing = request.getParameter("mainusing");
String maincontents = request.getParameter("maincontents");


if(txtmaingroup.equals("") || txtmainmain.equals("")){
	response.sendRedirect("common_code.jsp");
}
else{
	query = "update code_main set main_code = '"+txtmainmain+"' where main_code = '"+mainrevise+"'";
	stmt = conn.createStatement();
	stmt.executeUpdate(query);
	stmt.close();
	conn.close();
	
	
	response.sendRedirect("common_code.jsp");
	
}

%>
</body>
</html>