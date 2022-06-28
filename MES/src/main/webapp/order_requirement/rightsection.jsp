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
<%

	String temp="";

	int rowcount=0;
	String order = request.getParameter("order");
	if(order == null || order.equals("")){
		query = "select count(*) from parts_by_order";
	}
	else{
		query = "select count(*) from parts_by_order where parts_by_order.order = '"+order+"'";
	}
	rs=stmt.executeQuery(query);
	if(rs.next()){rowcount=rs.getInt(1);}
	int lastpagenumber=1;
	if(rowcount != 0){
		lastpagenumber = (rowcount-1)/10 +1;
	}
	
	if(order == null || order.equals("") || order.equals("null")){
		query = "select * from parts_by_order where parts_by_order.order = 'asdhflksdhflskd'";
	}
	else{
		query = "select * from parts_by_order where parts_by_order.order = '"+order+"'";
	}
	
	rs=stmt.executeQuery(query);
%>
<script>
var selected="";
</script>
<div class="card">
	<div class="card-header"
		style="font-size: 20px; background-color: white;">수주 부품 조회</div>
	<div class="card-body">
		<table class="table table-bordered" style="width: 100%;"
			role="grid">
			<thead>
				<tr>
					<th>부품이름</th>
					<th>부품사용갯수</th>
				</tr>
			</thead>
			<tbody style="border-top: none;">
			<%
			int count=0;
			int pagegroup=0;
			while(rs.next()){
				count++;
				if(count % 10 ==1){
					pagegroup++;
				}
				temp = rs.getString("part");
				
			%>
			<tr class="trs2 pagegroup2<%=pagegroup%>" id="<%=temp%>" onclick="tableclickevent2(this)">
				<td><%=rs.getString("part")%></td>
				<td><%=rs.getInt("quantity")%></td>
			</tr>
			<%
			}
			%>
			
			<script>
			function tableclickevent2(element){
				
				var trs = document.querySelectorAll(".trs2");
				for(var i=0; i<trs.length; i++){
					var item = trs.item(i);
					item.style.backgroundColor="white";
				}
				if(selected == element.children[0].innerHTML){
					selected = "";
					element.style.backgroundColor="white";
				}
				else{
					selected = element.children[0].innerHTML;
					element.style.backgroundColor="lightgray";
				}
			}
			
			//페지네이션
			function setdisplay2(groupnumber){
				var trs = document.querySelectorAll(".trs2");
				for(var i=0; i<trs.length; i++){
					var item = trs.item(i);
					item.style.display="none";
				}
				
				trs = document.querySelectorAll(".pagegroup2"+groupnumber);
				for(var i=0; i<trs.length; i++){
					var item = trs.item(i);
					item.style.display="";
				}
				
				var pages = document.querySelectorAll(".pages2");
				for(var i=0; i<pages.length; i++){
					var item = pages.item(i);
					item.children[0].style.backgroundColor="white";
					item.children[0].style.color="#6c757d";
					item.classList.remove('active2');
					
				}
				document.getElementById("page2"+groupnumber).className += ' active2';
				document.querySelector(".active2").children[0].style.backgroundColor="rgb(51, 122, 183)";
				document.querySelector(".active2").children[0].style.color="white";
				
				//previous버튼처리
				if(groupnumber==1){
					document.getElementById("previous2").className += ' disabled';
					document.getElementById("previous2").style.pointerEvents="none";
				}
				else{
					document.getElementById("previous2").classList.remove('disabled');
					document.getElementById("previous2").style.pointerEvents="auto";
				}
				
				//next버튼처리
				if(groupnumber==document.querySelector(".lastpage2").children[0].innerHTML*1){
					document.getElementById("next2").className += ' disabled';
					document.getElementById("next2").style.pointerEvents="none";
				}
				else{
					document.getElementById("next2").classList.remove('disabled');
					document.getElementById("next2").style.pointerEvents="auto";
				}
			}
			
			function previousbutton2(){
				setdisplay2(document.querySelector(".active2").children[0].innerHTML*1-1);
			}
			
			function nextbutton2(){
				setdisplay2(document.querySelector(".active2").children[0].innerHTML*1+1);
			}
			</script>
			</tbody>
		</table>
		<ul class="pagination justify-content-end" id="pageul2">
			<li class="page-item" id="previous2" onclick="previousbutton2()"><a class="page-link">Previous</a></li>
			<%
			int pagecount = ((rowcount-1)/10)+1;
			for(int i=0;i<pagecount;i++){
			%>
			<li class="page-item pages2<%=(i+1)==pagecount?" lastpage2":"" %>" id="page2<%=i+1%>" onclick="setdisplay2(<%=i+1%>)"><a class="page-link"><%=i+1%></a></li>
			<%
			}
			%>
			<li class="page-item" id="next2" onclick="nextbutton2()"><a class="page-link">Next</a></li>
			
		</ul>
	</div>
</div>
		<script>
		setdisplay2(1);
		</script>
</body>
</html>
<%
rs.close();
stmt.close();
conn.close();
%>