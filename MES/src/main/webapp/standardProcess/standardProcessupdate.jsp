<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="jh.jhdbconn"%>


<%
request.setCharacterEncoding("UTF-8"); 
jhdbconn db = new jhdbconn();
String query;
%>


<%
String p1=request.getParameter("p1");
String p2=request.getParameter("p2");
String p3=request.getParameter("p3");
String p4=request.getParameter("p4");
String p5=request.getParameter("p5");



int result=0;

query = "update mes.process set process_name='"+p2+"', pay="+p3+", load_factor ="+p4+", process.using="+p5+" where process_name='"+p1+"'";

try{
	db.stmt.executeUpdate(query);
	result=1;
	
}
catch(Exception e){
	result=0;
}finally{
	db.stmt.close();
	db.conn.close();
}
%>
{"result":<%=result%>}
