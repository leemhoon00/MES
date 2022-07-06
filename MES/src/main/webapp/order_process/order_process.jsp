<!-- 수주 공정 관리 페이지 -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="jh.jhdbconn"%>

<%
// 	데이터베이스 연결
	jhdbconn db = new jhdbconn();
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
String query="select * from mes.order";
db.rs=db.stmt.executeQuery(query);
%>
	<label class="title" style="margin-left: 30px; margin-top: 10px;">생산 관리 / 수주 공정 관리</label>
	
	<div class="card">
		<div class="card-body">
			<div class="form-inline">
				<label>수주명:</label>
				<select class="form-select search" style="width:15%" id="select" onchange="selectchange(this)">
				<%
				while(db.rs.next()){
				%>
					<option value="<%=db.rs.getString("item_no")%>"><%=db.rs.getString("item_no")%></option>
				<%} %>
				</select>
			</div>
			<script>
			
			//selectbox change 이벤트
			function selectchange(element){
				$.ajax({
					type:"GET",
		            url:"./tablediv.jsp",
		            data:{order:element.value},
		            dataType:"html",
		            success:function(data){
		                $("#tablediv").html(data);
		          }
		       });
			}
			</script>
			
			
		</div>
	</div>
	
	<div class="card">
		<div class="card-header">수주 공정 관리</div>
					
		<div class="card-body">
			<div class="form-inline">
				<div id="tablediv">
				
				</div>
			</div>
		</div>
	</div>
	<script>
	$.ajax({
		type:"GET",
        url:"./tablediv.jsp",
        data:{order:document.getElementById("select").value},
        dataType:"html",
        success:function(data){
            $("#tablediv").html(data);
      }
   });
	</script>
	
	<%
	db.rs.close();
	db.stmt.close();
	db.conn.close();
	%>
</body>
</html>