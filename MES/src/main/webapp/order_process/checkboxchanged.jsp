<!-- 체크박스 change 이벤트 처리 -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.Statement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.SQLException"%>

<%
// 	데이터베이스 연결
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = null;
	Statement stmt = null;
	String query= null;
	
	String jdbcDriver = "jdbc:mysql://192.168.0.115:3306/mes?" + "useUnicode=true&characterEncoding=utf8";
	String dbUser = "Usera";
	String dbPass = "1234";
	conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
	stmt = conn.createStatement();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
String value = request.getParameter("value");
String check = request.getParameter("check");

String part = value.substring(0,value.indexOf("^"));
String process = value.substring(value.indexOf("^")+1);


if(check.equals("true")){
	query = "delete from order_process where part_name='"+part+"' and process_name='"+process+"'";
	stmt.executeUpdate(query);
	query = "insert into order_process values('"+part+"','"+process+"')";
}
else{
	query = "delete from order_process where part_name='"+part+"' and process_name='"+process+"'";
}

stmt.executeUpdate(query);
conn.close();

%>
</body>
</html>