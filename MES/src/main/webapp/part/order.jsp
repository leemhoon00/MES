<!-- 발주 관련 -->

<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="jh.jhdbconn"%>
<!-- 데이터베이스 연결 -->
<%
jhdbconn db = new jhdbconn();
String query;
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Insert title here</title>
</head>
<body>

<%

String part_name = request.getParameter("part_name");
String part_type = request.getParameter("part_type");

String number_of_request = request.getParameter("number_of_request");

if(part_name.equals("")){
	response.sendRedirect("part_management.jsp");
}
else{
	
	query = "insert into manage_porder(part_name, order_name, number_of_request, type) values('"+part_name+"',null,"+number_of_request+",'"+part_type+"')";

	db.stmt = db.conn.createStatement();
	db.stmt.executeUpdate(query);
	
	db.stmt.close();
	db.conn.close();
	
	response.sendRedirect("part_management.jsp");
}
%>

</body>
</html>