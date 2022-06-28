<!-- main page -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="login.LoginDAO"%>


<%
String id = request.getParameter("id");
String pw = request.getParameter("pw");
%>

<!-- index페이지에서 넘어온 아이디 값 비교해서 맞으면 session저장, 아니면 index로 -->
<%
LoginDAO login = new LoginDAO();
String p = login.login(id);

if(p != null){
	if(p.equals(pw)){
		session.setAttribute("id", id);
	}
	else{
		response.sendRedirect("index.jsp");
	}
}
else{
	response.sendRedirect("index.jsp");
}

%>

<%@ include file="navbar.jsp"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>MES</title>

<style>
	#pframe{
		margin-left: 14.5%;
		width: 84%;
		height: 95vh;
		
		overflow: scroll;
	}
</style>

</head>
<body>
	<iframe id="pframe" src="./main/main.jsp" frameborder="0px"></iframe>
</body>
</html>