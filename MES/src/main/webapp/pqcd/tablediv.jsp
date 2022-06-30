<!-- 설비가동률(증가)의 테이블 영역 -->

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
	
	
	String year = request.getParameter("year");
	String month = request.getParameter("month");
	
	
	query = "SELECT * FROM mes.order WHERE MONTH(order_date) = "+month+" AND YEAR(order_date) = "+year;
	rs=stmt.executeQuery(query);
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<script type="text/javascript"
	src="https://cdn.jsdelivr.net/jquery/latest/jquery.min.js"></script>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3"
	crossorigin="anonymous">
<script src="https://code.jquery.com/jquery-3.6.0.min.js" 
        integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"
	integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p"
	crossorigin="anonymous">
    </script>
<link rel="stylesheet" href="../jhcss.css">
<title>Insert title here</title>

</head>
<body>
	<table class="table table-bordered table-hover">
		<thead>
			<tr>
				<th>NO</th>
				<th>수주제품</th>
				<th>고객사</th>
				<th>계획공수</th>
				<th>실적공수</th>
				<th>감소 %</th>
			</tr>
		</thead>
		<tbody>
		<%
		while(rs.next()){
		%>
			<tr>
				<td><%=rs.getInt("order_num") %></td>
				<td><%=rs.getString("item_no") %></td>
				<td><%=rs.getString("order_com_id") %></td>
				<td>0.0</td>
				<td>0.0</td>
				<td>0 %</td>
			</tr>
		<%} 
		
		rs.close();
		stmt.close();
		conn.close();
		%>
		</tbody>
	</table>
</body>
</html>