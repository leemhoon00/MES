<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="dbcon.dbcon" %>
<%@ page import ="java.io.PrintWriter" %>
<!DOCTYPE html>
<%
	dbcon dbc = new dbcon();
	
	String facilities_name = request.getParameter("nfacilities_name");
	String userid = (String)session.getAttribute("id");
	String date1= request.getParameter("date1");
	String date2 = request.getParameter("date2");
	String[] contentdate = request.getParameterValues("ctdate");
	String[] status = request.getParameterValues("status");
	String[] deletenum = request.getParameterValues("deletenum");
	
	dbc.insertfcheck(facilities_name, userid, contentdate, status, date1, date2);
	dbc.deletecheck(deletenum);
	PrintWriter script = response.getWriter();
	script.println("<script>");
	script.println("alert('성공');");
	//script.println("alert(" + sf.format(proc_startday) + ");");
	script.println("location.href = document.referrer;");
	//script.println("history.back();");
	script.println("</script>");
	script.close();
%>