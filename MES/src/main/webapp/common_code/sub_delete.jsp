<!-- 서브 코드 삭제 -->
<%@ page import="jh.jhdbconn"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Insert title here</title>
</head>
<body>
	<%
	jhdbconn db = new jhdbconn();
	
	String subcode = request.getParameter("p1");
	
	if(subcode.equals("")){
		response.sendRedirect("common_code.jsp");
	}
	else{
		
		db.query = "delete from code_sub where sub_code='" + subcode + "';";
		
		
		// Run Qeury 
		db.stmt.executeUpdate(db.query);
		
		db.stmt.close();
		db.conn.close();
		response.sendRedirect("common_code.jsp");
	}
	
	%>
</body>
</html>