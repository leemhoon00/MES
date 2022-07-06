<!-- 부품 등록,수정 -->

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
//submitcheck가 1이면 수정 아니면 등록
String submitcheck = request.getParameter("submitcheck");

String part_name = request.getParameter("part_name");
String part_type = request.getParameter("part_type");
String core = request.getParameter("core");
String unit_price = request.getParameter("unit_price");
String stock = request.getParameter("stock");
String safety_stock = request.getParameter("safety_stock");
String standard = request.getParameter("standard");
if(standard==null || standard.equals("") || standard.equals("null")){
	standard="";
}
String unit = request.getParameter("unit");
if(unit==null || unit.equals("") || unit.equals("null")){
	unit="";
}

if(part_name.equals("")){
	response.sendRedirect("part_management.jsp");
}
else{
	if(submitcheck.equals("1")){
		query = "update part set part_name='"+part_name+"', part_type='"+part_type+"', core='"+core+"', unit_price="+unit_price+", stock="+stock+", safety_stock="+safety_stock+", standard='"+standard+"', unit='"+unit+"' where part_name='"+part_name+"'";
	}
	else{
		query = "insert into part(part_name,part_type,core,unit_price,stock,safety_stock,standard, unit) values('"+part_name+"','"+part_type+"','"+core+"',"+unit_price+","+stock+","+safety_stock+",'"+standard+"','"+unit+"')";
	}
	

	try{
		db.stmt = db.conn.createStatement();
		db.stmt.executeUpdate(query);
		
		db.stmt.close();
		db.conn.close();
		response.sendRedirect("part_management.jsp");
	}catch(Exception e){
		out.println("<script>alert('이미있는 부품명 입니다.');document.location.href='part_management.jsp';</script>");
	}
	

	
}



%>
</body>
</html>