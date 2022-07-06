<!-- 메인 코드 수정 -->

<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="jh.jhdbconn"%>

<!-- 데이터베이스 연결 -->
<%

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

String mainrevise = request.getParameter("mainrevise");
String txtmaingroup = request.getParameter("txtmaingroup");
String txtmainmain = request.getParameter("txtmainmain");
String mainusing = request.getParameter("mainusing");
String maincontents = request.getParameter("maincontents");


if(txtmaingroup.equals("") || txtmainmain.equals("")){
	response.sendRedirect("common_code.jsp");
}
else{
	db.query = "update code_main set main_code = '"+txtmainmain+"' where main_code = '"+mainrevise+"'";
	db.stmt = db.conn.createStatement();
	db.stmt.executeUpdate(db.query);
	db.stmt.close();
	db.conn.close();
	
	
	response.sendRedirect("common_code.jsp");
	
}

%>
</body>
</html>