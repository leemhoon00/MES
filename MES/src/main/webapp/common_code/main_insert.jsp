<!-- 메인 코드 추가 -->

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

String txtmaingroup = request.getParameter("txtmaingroup");
String txtmainmain = request.getParameter("txtmainmain");
String mainusing = request.getParameter("mainusing");
String maincontents = request.getParameter("maincontents");


if(txtmaingroup.equals("") || txtmainmain.equals("")){
	response.sendRedirect("common_code.jsp");
}
else{
	
	db.query = "insert into code_main values('"+txtmaingroup+"','"+txtmainmain+"',"+mainusing+",'"+maincontents+"')";

	try{
		db.stmt = db.conn.createStatement();
		db.stmt.executeUpdate(db.query);
		response.sendRedirect("common_code.jsp");
	}catch(Exception e){
		out.println("<script>alert('이미있는 메인코드 입니다.');document.location.href='common_code.jsp';</script>");
	}finally{
		db.stmt.close();
		db.conn.close();
	}
	
}

%>
</body>
</html>