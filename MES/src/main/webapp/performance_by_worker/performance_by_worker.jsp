<!-- 작업자별 실적 현황 페이지 -->

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
	
	query="select * from user";
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
    
    
<title>Insert title here</title>
<link rel="stylesheet" href="../jhcss.css">

</head>
<body>
	<label class="title" style="margin-left: 30px; margin-top: 10px;">Dashboard / 작업자별 실적 현황</label>

	<div class="card">
		<div class="card-body">
			<div class="form-inline">
				<label>작업자</label>
				<select class="form-select search" style="width:10%" id="select">
					<option value="전체">전체</option>
					<%
					//작업자 목록 셀렉트박스의 옵션값으로 넣기
					while(rs.next()){
					%>
					<option value="<%=rs.getString("user_id")%>"><%=rs.getString("user_id")%></option>
					<% } %>
				</select>
				<label>기간</label>
				<input type="date" id="date1">
				<label>~</label>
				<input type="date" id="date2">
				<input type="checkbox" id="checkbox"><label>불량포함</label>
				<button class="btn btn-info" onclick="buttonclick()">조회</button>
				<script>
				function buttonclick(){
					var select = document.getElementById("select").value;
					var date1 = document.getElementById("date1").value;
					var date2 = document.getElementById("date2").value;
					var checkbox = document.getElementById("checkbox");
					
					if(date1 == "" || date2 == ""){
						alert("날짜를 설정하시오");
					}
					else{
						$.ajax({
							type:"GET",
				            url:"./maindiv.jsp",
				            data:{select:select, date1:date1, date2:date2, checkbox:checkbox.checked},
				            dataType:"html",
				            success:function(data){
				                $("#maindiv").html(data);
				          }
				       });
					}
				}
				</script>
			</div>
		</div>
	</div>
	<%
	rs.close();
	stmt.close();
	conn.close();
	%>
	<div id="maindiv">
	
	</div>
</body>
</html>