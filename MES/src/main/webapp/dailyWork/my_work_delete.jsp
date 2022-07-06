<!-- 나의 작업 일보 삭제 -->

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
	
String work_id = request.getParameter("work_id");




db.query = "delete from my_work where work_id=" + work_id + ";";


// Run Qeury 
db.stmt.executeUpdate(db.query);

db.stmt.close();
db.conn.close();
response.sendRedirect("dailyWork.jsp");


%>
</body>
</html>