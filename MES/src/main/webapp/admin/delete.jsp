<!-- 부품 삭제 -->

<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="jh.jhdbconn"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Insert title here</title>
</head>
<body>
	<%
	
	
	String adminid = request.getParameter("p1");
	
	if(adminid.equals("")){
		response.sendRedirect("user_management.jsp");
	}
	else{
		jhdbconn db = new jhdbconn();
		db.query = "delete from user where user_id='" + adminid + "';";
		
		
		// Run Qeury 
		db.stmt.executeUpdate(db.query);
		db.query = "delete from user_menu where user_id='"+adminid+"'";
		db.stmt.executeUpdate(db.query);
		
		db.stmt.close();
		db.conn.close();
		
		response.sendRedirect("user_management.jsp");
	}
	
	
	%>
</body>
</html>