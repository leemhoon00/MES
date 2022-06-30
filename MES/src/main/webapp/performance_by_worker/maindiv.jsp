<!-- 전달받은 파라미터값으로 작업자별 실적 현황 계산하여 maindiv에 넣음 -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.Statement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.SQLException"%>

<%
// 	데이터베이스 연결
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = null;
	Statement stmt = null;
	ResultSet rs = null;
	String query= null;
	
	String jdbcDriver = "jdbc:mysql://192.168.0.115:3306/mes?" + "useUnicode=true&characterEncoding=utf8";
	String dbUser = "Usera";
	String dbPass = "1234";
	conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
	stmt = conn.createStatement();
	
%>
<%
String worker = request.getParameter("select");
String date1 = request.getParameter("date1");
String date2 = request.getParameter("date2");
String faulty = request.getParameter("checkbox");

if(worker.equals("전체") && faulty.equals("false")){
	query = "select * from my_work where status ='완료' AND faulty='N' AND regdate between '"+date1+"' and '"+date2+"' order by order_name";
}
else if(worker.equals("전체") && faulty.equals("true")){
	query = "select * from my_work where status='완료' AND regdate between '"+date1+"' and '"+date2+"' order by order_name";
}
else if(faulty.equals("false")){
	query = "select * from my_work where status='완료' AND faulty='N' AND worker='"+worker+"' AND regdate between '"+date1+"' and '"+date2+"' order by order_name";
}
else{
	query = "select * from my_work where status='완료' AND worker='"+worker+"' AND regdate between '"+date1+"' and '"+date2+"' order by order_name";
}

rs=stmt.executeQuery(query);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Insert title here</title>
</head>
<body>
<div class="card">
    <div class="card-body">
        <table class="table table-bordered table-hover">
        	<thead>
        		<tr>
        			<th style="text-align: center; width:25%">수주</th>
        			<th style="text-align: center; width:25%">공정</th>
        			<th style="text-align: center; width:25%">설비</th>
        			<th style="text-align: center; width:25%">WT</th>
        		</tr>
        	</thead>
        	<tbody>
        		<%
        		int total=0;
        		String order_name="";
        		String order_name2="";
        		while(rs.next()){
        			order_name2=rs.getString("order_name");
        			if(order_name2.equals(order_name)){
        				order_name2="";
        			}
        			else{
        				order_name=order_name2;
        			}
        			total += rs.getInt("work_time");
        		%>
        		<tr>
        			<td style="text-align: center"><%=order_name2%></td>
        			<td style="text-align: center"><%=rs.getString("process")%></td>
        			<td style="text-align: center"><%=rs.getString("facilities")%></td>
        			<td style="text-align: center"><%=rs.getInt("work_time")%></td>
        		</tr>
        		<% } %>
        	</tbody>
        	<tfoot>
        		<tr style="background-color:#99a0a9; color:white">
        			<td colspan="3" style="font-weight: bold">합계</td>
        			<td style="text-align: center; font-weight: bold"><%=total %></td>
        		</tr>
        	</tfoot>
        </table>
    </div>
</div>
</body>
</html>