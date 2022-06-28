<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="dbcon.dbcon" %>
<%@ page import ="java.io.PrintWriter" %>
<!DOCTYPE html>
<%
	dbcon dbc = new dbcon();

	String facilities_name = request.getParameter("nfacilities_name");
	String name = request.getParameter("name");
	String[] code = request.getParameterValues("ncode");
	String[] phdate = request.getParameterValues("nphdate");
	String[] ph = request.getParameterValues("nph");
	dbc.insertfacilitiesph(facilities_name, code, phdate, ph);
	PrintWriter script = response.getWriter();
	script.println("<script>");
	script.println("alert('성공');");
	//script.println("alert(" + sf.format(proc_startday) + ");");
	script.println("location.href = document.referrer;");
	//script.println("history.back();");
	script.println("</script>");
	script.close();
%>