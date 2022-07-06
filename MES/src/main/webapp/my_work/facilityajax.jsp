<!-- 공정셀렉트 값의 변화에 따른 설비 셀렉트박스의 값 -->

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
String process = request.getParameter("process");
String query = "select * from process_multi where proc_name='"+process+"' and sortation='f'";
db.rs=db.stmt.executeQuery(query);
%>
<option value="">--선택--</option>
<%
while(db.rs.next()){
%>
<option value="<%=db.rs.getString("sub_proc")%>"><%=db.rs.getString("sub_proc")%></option>
<%} 
db.rs.close();
db.stmt.close();
db.conn.close();
%>
</body>
</html>