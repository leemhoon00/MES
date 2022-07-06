<!-- 수주명 셀렉트박스 값의 변화에 따른 부품명 셀렉트박스의 옵션 값 -->

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
String order = request.getParameter("order");
String query = "select * from parts_by_order where parts_by_order.order='"+order+"' and order_status='내부'";
db.rs=db.stmt.executeQuery(query);
%>
<option value="">--선택--</option>
<%
while(db.rs.next()){
%>
<option value="<%=db.rs.getString("part")%>"><%=db.rs.getString("part")%></option>
<%} 
db.rs.close();
db.stmt.close();
db.conn.close();
%>
</body>
</html>