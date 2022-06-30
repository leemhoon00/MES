<!-- 서브 코드 추가 -->

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
String txtmain = request.getParameter("txtmain");
String txtsub = request.getParameter("txtsub");
String subusing = request.getParameter("subusing");
String revisemain = request.getParameter("revisemain");
if(subusing.equals("Y")){
	subusing = "1";
}
else{
	subusing="0";
}
String submitcheck = request.getParameter("submitcheck");

if(txtmain.equals("") || txtsub.equals("")){
	response.sendRedirect("user_management.jsp");
}

else{
	if(submitcheck.equals("1")){
		query = "delete from code_sub where sub_code='" + revisemain + "'";

		// Create Statement 
		stmt = conn.createStatement();
		// Run Qeury 
		stmt.executeUpdate(query);
		stmt.close();
	}
	query = "insert into code_sub values('"+txtmain+"','"+txtsub+"',"+subusing+")";

	try{
		stmt = conn.createStatement();
		stmt.executeUpdate(query);
		response.sendRedirect("common_code.jsp");
	}catch(Exception e){
		out.println("<script>alert('이미있는 서브코드 입니다.');document.location.href='common_code.jsp';</script>");
	}finally{
		stmt.close();
		conn.close();
	}
	
}

%>
</body>
</html>