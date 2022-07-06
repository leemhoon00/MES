<!-- 부품에 따른 공정 옵션 값 -->

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
String part = request.getParameter("part");
String query="select * from order_process where part_name='"+part+"' order by process_name asc";
db.rs=db.stmt.executeQuery(query);
%>
<option value="">--선택--</option>
<%
while(db.rs.next()){
%>
<option value="<%=db.rs.getString("process_name")%>"><%=db.rs.getString("process_name")%></option>
<%} 
db.rs.close();
db.stmt.close();
db.conn.close();
%>
</body>
</html>