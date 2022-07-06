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
	jhdbconn db = new jhdbconn();
	
	String part_name = request.getParameter("p1");
	
	if(part_name.equals("")){
		response.sendRedirect("part_management.jsp");
	}
	else{
		
		String query = "delete from part where part_name='" + part_name + "';";
		
		
		db.stmt.executeUpdate(query);
		
		
		db.stmt.close();
		db.conn.close();
		
		response.sendRedirect("part_management.jsp");
	}
	
	%>
</body>
</html>