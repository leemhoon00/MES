<!-- 외주 작업 일보 수정 -->

<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.time.LocalDate"%>
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
String outsourcing_no = request.getParameter("outsourcing_no");
int price = Integer.parseInt(request.getParameter("price"));
String whdate = request.getParameter("whdate");
String outsstarttime = request.getParameter("outsstarttime");
String outsendtime = request.getParameter("outsendtime");
String faultycheck = request.getParameter("faultycheck");

if(whdate.equals("")){
	whdate="NULL";
}
else{
	
}



db.query = "update mes.outsourcing set price=?,warehousing_exp_date=?,outstart_date=?,outend_date=?,faulty=? where outsourcing_no="+outsourcing_no;

db.pstmt = db.conn.prepareStatement(db.query);

db.pstmt.setInt(1,price);

if(whdate.equals("")){
	db.pstmt.setString(2,null);
}
else{
	db.pstmt.setString(2,whdate);
}
if(outsstarttime.equals("")){
	db.pstmt.setString(3,null);
}
else{
	db.pstmt.setString(3,outsstarttime);
}
if(outsendtime.equals("")){
	db.pstmt.setString(4,null);
}
else{
	db.pstmt.setString(4,outsendtime);
}

if(faultycheck==null){
	db.pstmt.setString(5,"N");
}
else{
	db.pstmt.setString(5,"Y");
}
db.stmt.close();
db.pstmt.executeUpdate();

db.pstmt.close();
db.conn.close();


response.sendRedirect("dailyWork.jsp");
%>
</body>
</html>