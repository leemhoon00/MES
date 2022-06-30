<!-- 수주별 소요량 페이지 -->

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
	<label class="title" style="margin-left: 30px; margin-top: 10px;">자재 제품 관리 / 수주별 소요량</label>
	
	<div class="card">
		<div class="card-body">
			<div class="form-inline">
				<label>수주명</label>
				<input class="search form-control" id="ordertextbox" type="text" onchange="refresh()">
			</div>
		</div>
	</div>
	<script>
	//textbox change 이벤트
	function refresh(){
		var order = document.getElementById("ordertextbox").value;
		
		$.ajax({
			type:"GET",
            url:"./maindiv.jsp",
            data:{order : order},
            dataType:"html",
            success:function(data){
                $("#maindiv").html(data);
          }
       });
	}
	</script>
	
	<div id="maindiv">
	
	</div>
	<script>
		$.ajax({
			type:"GET",
	        url:"./maindiv.jsp",
	        data:{},
	        dataType:"html",
	        success:function(data){
	            $("#maindiv").html(data);
	      }
	   });
	</script>
</body>
</html>
<%
stmt.close();
conn.close();
%>