<!-- 외주 삭제 -->

<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="jh.jhdbconn"%>
<%
// 	데이터베이스 연결
	jhdbconn db = new jhdbconn();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Insert title here</title>
</head>
<body>
<%
String p1 = request.getParameter("p1");
String query = "delete from mes.outsourcing where outsourcing_no="+p1;

db.stmt = db.conn.createStatement();
db.stmt.executeUpdate(query);

db.stmt.close();
db.conn.close();

response.sendRedirect("inandout.jsp");
%>
</body>
</html>