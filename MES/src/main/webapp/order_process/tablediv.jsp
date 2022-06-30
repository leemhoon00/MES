<!-- 수주 공정 관리 table DIV -->

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
	Connection conn2 = null;
	Statement stmt = null;
	Statement stmt2 = null;
	ResultSet rs = null;
	ResultSet rs2 = null;
	String query= null;
	String query2=null;
	
	
	
	String jdbcDriver = "jdbc:mysql://192.168.0.115:3306/mes?" + "useUnicode=true&characterEncoding=utf8";
	String dbUser = "Usera";
	String dbPass = "1234";
	conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
	conn2 = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
	stmt = conn.createStatement();
	stmt2 = conn2.createStatement();
%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

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
<%
String ordername = request.getParameter("order");

query="select count(*) from process";
rs=stmt.executeQuery(query);
rs.next();
int processcount = rs.getInt(1);
String [] process = new String[processcount];
query="select * from process";
rs=stmt.executeQuery(query);
int j=0;
while(rs.next()){
	process[j] = rs.getString("process_name");
	j++;
}

query="select * from process";
rs=stmt.executeQuery(query);
%>

<script>
var ordername = '<%=ordername%>';
</script>
<table class="table table-bordered table-hover">
		<thead>
			<tr>
				<th>PARTLIST</th>
				<th>수량</th>
				<%
				while(rs.next()){
				%>
				<th>
				<%=rs.getString("process_name")%>
				<input type="checkbox" value="<%=rs.getString("process_name")%>" onclick="processchecked(this)">
				</th>
				<%} %>
			</tr>
		</thead>
		<%
		query = "select * from parts_by_order where parts_by_order.order='"+ordername+"'";
		rs=stmt.executeQuery(query);
		
		query2="select * from process";
		rs2=stmt2.executeQuery(query2);
		%>
		<tbody>
		<% while(rs.next()){%>
			<tr>
				<td>
					<%=rs.getString("part")%>
					<input type="checkbox" value="<%=rs.getString("part")%>" onclick="partchecked(this)">
				</td>
				<td><%=rs.getInt("quantity") %></td>
				<%for(int i=0;i<processcount;i++){ 
					boolean check;
					query2="select * from order_process where part_name='"+rs.getString("part")+"' and process_name='"+process[i]+"'";
					rs2=stmt2.executeQuery(query2);
					if(rs2.next()){
						check = true;
					}
					else{
						check = false;
					}
				%>
				<td><input class="<%=rs.getString("part")%> <%=process[i]%>" onchange="checkboxchanged(this)" 
				value="<%=rs.getString("part")%>^<%=process[i]%>" type="checkbox" <%=check? "checked" : "" %>></td>
				<%} %>
			</tr>
		<%} %>
		</tbody>
	</table>
	<script>
	//열 체크 이벤트
	function processchecked(element){
		var trs = document.querySelectorAll("."+element.value);
		
		if(element.checked==true){
			for(var i=0; i<trs.length; i++){
				var item= trs.item(i);
				item.checked = true;
				$(item).trigger('change');
			}
		}
		else{
			for(var i=0; i<trs.length; i++){
				var item= trs.item(i);
				item.checked = false;
				$(item).trigger('change');
			}
		}
	}
	
	//행 체크 이벤트
	function partchecked(element){
		var trs = document.querySelectorAll("."+element.value);
		
		if(element.checked==true){
			for(var i=0; i<trs.length; i++){
				var item= trs.item(i);
				item.checked = true;
				$(item).trigger('change');
			}
		}
		else{
			for(var i=0; i<trs.length; i++){
				var item= trs.item(i);
				item.checked = false;
				$(item).trigger('change');
			}
		}
		
	}
	
	//체크박스 체크 이벤트
	function checkboxchanged(element){
		$.ajax({
			type:"GET",
            url:"./checkboxchanged.jsp",
            data:{check:element.checked, value:element.value},
            dataType:"html"
       });
	}
	</script>
	
	<%
	rs.close();
	rs2.close();
	stmt.close();
	stmt2.close();
	conn.close();
	conn2.close();
	%>
</body>
</html>