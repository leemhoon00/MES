<!-- 발주 저장 -->

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
String p2 = request.getParameter("p2");

if(p2.equals("") || p2==null){
	out.println("<script>alert('날짜를 입력하시오');document.location.href='inandout.jsp';</script>");
}
else{
	String query = "update place_order set receiving_day = '"+p2+"', receiving_status='Y' where porder_no = "+p1;
	db.stmt = db.conn.createStatement();
	db.stmt.executeUpdate(query);

	db.stmt.close();
	db.conn.close();

	response.sendRedirect("inandout.jsp");
}

%>

</body>
</html>