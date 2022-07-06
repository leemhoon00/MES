<!-- 서브 코드 추가 -->

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
String txtmain = request.getParameter("txtmain");
String txtsub = request.getParameter("txtsub");
String subusing = request.getParameter("subusing");
String revisemain = request.getParameter("revisemain");
if(subusing.equals("Y")){
	subusing = "1";
}
else{
	subusing="0";
}
String submitcheck = request.getParameter("submitcheck");

if(txtmain.equals("") || txtsub.equals("")){
	response.sendRedirect("user_management.jsp");
}

else{
	if(submitcheck.equals("1")){
		db.query = "delete from code_sub where sub_code='" + revisemain + "'";

		
		db.stmt.close();
	}
	db.query = "insert into code_sub values('"+txtmain+"','"+txtsub+"',"+subusing+")";

	try{
		db.stmt = db.conn.createStatement();
		db.stmt.executeUpdate(db.query);
		response.sendRedirect("common_code.jsp");
	}catch(Exception e){
		out.println("<script>alert('이미있는 서브코드 입니다.');document.location.href='common_code.jsp';</script>");
	}finally{
		db.stmt.close();
		db.conn.close();
	}
	
}

%>
</body>
</html>