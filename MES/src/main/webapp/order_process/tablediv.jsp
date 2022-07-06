<!-- 수주 공정 관리 table DIV -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="jh.jhdbconn"%>
<%
// 	데이터베이스 연결
	
	String query= null;
	String query2=null;
	
	jhdbconn db = new jhdbconn();
	jhdbconn db2 = new jhdbconn();
	
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
db.rs=db.stmt.executeQuery(query);
db.rs.next();
int processcount = db.rs.getInt(1);
String [] process = new String[processcount];
query="select * from process";
db.rs=db.stmt.executeQuery(query);
int j=0;
while(db.rs.next()){
	process[j] = db.rs.getString("process_name");
	j++;
}

query="select * from process";
db.rs=db.stmt.executeQuery(query);
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
				while(db.rs.next()){
				%>
				<th>
				<%=db.rs.getString("process_name")%>
				<input type="checkbox" value="<%=db.rs.getString("process_name")%>" onclick="processchecked(this)">
				</th>
				<%} %>
			</tr>
		</thead>
		<%
		query = "select * from parts_by_order where parts_by_order.order='"+ordername+"'";
		db.rs=db.stmt.executeQuery(query);
		
		query2="select * from process";
		db2.rs=db2.stmt.executeQuery(query2);
		%>
		<tbody>
		<% while(db.rs.next()){%>
			<tr>
				<td>
					<%=db.rs.getString("part")%>
					<input type="checkbox" value="<%=db.rs.getString("part")%>" onclick="partchecked(this)">
				</td>
				<td><%=db.rs.getInt("quantity") %></td>
				<%for(int i=0;i<processcount;i++){ 
					boolean check;
					query2="select * from order_process where part_name='"+db.rs.getString("part")+"' and process_name='"+process[i]+"'";
					db2.rs=db2.stmt.executeQuery(query2);
					if(db2.rs.next()){
						check = true;
					}
					else{
						check = false;
					}
				%>
				<td><input class="t<%=db.rs.getString("part")%> t<%=process[i]%>" onchange="checkboxchanged(this)" 
				value="<%=db.rs.getString("part")%>^<%=process[i]%>" type="checkbox" <%=check? "checked" : "" %>></td>
				<%} %>
			</tr>
		<%} %>
		</tbody>
	</table>
	<script>
	//열 체크 이벤트
	function processchecked(element){
		var trs = document.querySelectorAll(".t"+element.value);
		
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
		var trs = document.querySelectorAll(".t"+element.value);
		
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
	db.rs.close();
	db2.rs.close();
	db.stmt.close();
	db2.stmt.close();
	db.conn.close();
	db2.conn.close();
	%>
</body>
</html>