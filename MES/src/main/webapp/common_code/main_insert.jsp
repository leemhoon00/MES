<!-- 메인 코드 추가 -->

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

String txtmaingroup = request.getParameter("txtmaingroup");
String txtmainmain = request.getParameter("txtmainmain");
String mainusing = request.getParameter("mainusing");
String maincontents = request.getParameter("maincontents");


if(txtmaingroup.equals("") || txtmainmain.equals("")){
	response.sendRedirect("common_code.jsp");
}
else{
	
	query = "insert into code_main values('"+txtmaingroup+"','"+txtmainmain+"',"+mainusing+",'"+maincontents+"')";

	try{
		stmt = conn.createStatement();
		stmt.executeUpdate(query);
		response.sendRedirect("common_code.jsp");
	}catch(Exception e){
		out.println("<script>alert('이미있는 메인코드 입니다.');document.location.href='common_code.jsp';</script>");
	}finally{
		stmt.close();
		conn.close();
	}
	
}

%>
</body>
</html>