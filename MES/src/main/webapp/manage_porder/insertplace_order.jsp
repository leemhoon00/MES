<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="dbcon.dbcon" %>
<%@ page import ="java.io.PrintWriter" %>
<!DOCTYPE html>
<%
	dbcon dbc = new dbcon();
	
	String[] partname = request.getParameterValues("npart_name");
	for(int i=0; i<partname.length; i++){
		System.out.println(partname[i]);
	}
	String[] nor = request.getParameterValues("nnor");
	String[] price = request.getParameterValues("nprice");
	String[] type = request.getParameterValues("ntype");
	String ordercom = request.getParameter("nordercom");
	String place = request.getParameter("nplace");
	String note = request.getParameter("nnote");
	String[] n_mo = request.getParameterValues("nm_no");
	String[] ordername = request.getParameterValues("norder_name");
	
	System.out.println("terst");
	dbc.insertplace_order(partname, type, nor, ordercom, place, price, note, n_mo, ordername);
	PrintWriter script = response.getWriter();
	script.println("<script>");
	script.println("alert('성공');");
	//script.println("alert(" + sf.format(proc_startday) + ");");
	script.println("location.href = document.referrer;");
	//script.println("history.back();");
	script.println("</script>");
	script.close();
%>

