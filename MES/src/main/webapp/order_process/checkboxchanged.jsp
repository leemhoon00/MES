<!-- 체크박스 change 이벤트 처리 -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="jh.jhdbconn"%>
<%
// 	데이터베이스 연결
	jhdbconn db = new jhdbconn();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
String query;

String value = request.getParameter("value");
String check = request.getParameter("check");

String part = value.substring(0,value.indexOf("^"));
String process = value.substring(value.indexOf("^")+1);


if(check.equals("true")){
	query = "delete from order_process where part_name='"+part+"' and process_name='"+process+"'";
	db.stmt.executeUpdate(query);
	query = "insert into order_process values('"+part+"','"+process+"')";
}
else{
	query = "delete from order_process where part_name='"+part+"' and process_name='"+process+"'";
}

db.stmt.executeUpdate(query);
db.conn.close();

%>
</body>
</html>