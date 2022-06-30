<!-- 수주 조회 DIV -->

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
		query = "select count(*) from mes.order";
	}
	else{
		query = "select count(*) from mes.order where item_no like '%"+order+"%'";
	}
	
	//페이지네이션 관련
	rs=stmt.executeQuery(query);
	if(rs.next()){rowcount=rs.getInt(1);}
	int lastpagenumber=1;
	if(rowcount != 0){
		lastpagenumber = (rowcount-1)/10 +1;
	}
	
	if(order == null || order.equals("") || order.equals("null")){
		query = "select * from mes.order";
	}
	else{
		query = "select * from mes.order where item_no like '%"+order+"%'";
	}
	
	rs=stmt.executeQuery(query);
%>
<script>
var selectedorder="";
</script>
<div class="row">
	<div class="col-6" style="margin-right: 0px;">
		<div class="card" style="margin-right: 0px;">
			<div class="card-header"
				style="font-size: 20px; background-color: white;">수주 조회</div>
			<div class="card-body">
				<table id="mytable" class="table table-bordered" style="width: 100%;"
					role="grid">
					<thead>
						<tr>
							<th>수주명</th>
							<th>부품명</th>
							<th>고객사명</th>
							<th>수주일</th>
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
						temp = rs.getString("item_no");
						
					%>
					<tr class="trs pagegroup<%=pagegroup%>" id="<%=temp%>" onclick="tableclickevent(this)">
						<td><%=rs.getString("item_no")%></td>
						<td><%=rs.getString("car_name")%></td>
						<td><%=rs.getString("order_com_id")%></td>
						<td><%=rs.getString("order_date").substring(0,10)%></td>
						
					</tr>
					<%
					}
					%>
					
					<script>
					function tableclickevent(element){
						
						var trs = document.querySelectorAll(".trs");
						for(var i=0; i<trs.length; i++){
							var item = trs.item(i);
							item.style.backgroundColor="white";
						}
						if(selectedorder == element.children[0].innerHTML){
							selectedorder = "";
							element.style.backgroundColor="white";
						}
						else{
							selectedorder = element.children[0].innerHTML;
							element.style.backgroundColor="lightgray";
						}
						$.ajax({
							type:"GET",
					        url:"./rightsection.jsp",
					        data:{order : selectedorder},
					        dataType:"html",
					        success:function(data){
					            $("#rightsection").html(data);
					      }
					   });
					}
					
					//페지네이션
					function setdisplay(groupnumber){
						var trs = document.querySelectorAll(".trs");
						for(var i=0; i<trs.length; i++){
							var item = trs.item(i);
							item.style.display="none";
						}
						
						trs = document.querySelectorAll(".pagegroup"+groupnumber);
						for(var i=0; i<trs.length; i++){
							var item = trs.item(i);
							item.style.display="";
						}
						
						var pages = document.querySelectorAll(".pages");
						for(var i=0; i<pages.length; i++){
							var item = pages.item(i);
							item.classList.remove('active');
						}
						document.getElementById("page"+groupnumber).className += ' active';
						
						//previous버튼처리
						if(groupnumber==1){
							document.getElementById("previous").className += ' disabled';
							document.getElementById("previous").style.pointerEvents="none";
						}
						else{
							document.getElementById("previous").classList.remove('disabled');
							document.getElementById("previous").style.pointerEvents="auto";
						}
						
						//next버튼처리
						if(groupnumber==document.querySelector(".lastpage").children[0].innerHTML*1){
							document.getElementById("next").className += ' disabled';
							document.getElementById("next").style.pointerEvents="none";
						}
						else{
							document.getElementById("next").classList.remove('disabled');
							document.getElementById("next").style.pointerEvents="auto";
						}
					}
					
					function previousbutton(){
						setdisplay(document.querySelector(".active").children[0].innerHTML*1-1);
					}
					
					function nextbutton(){
						setdisplay(document.querySelector(".active").children[0].innerHTML*1+1);
					}
					</script>
					</tbody>
				</table>
				<ul class="pagination justify-content-end" id="pageul">
					<li class="page-item" id="previous" onclick="previousbutton()"><a class="page-link">Previous</a></li>
					<%
					int pagecount = ((rowcount-1)/10)+1;
					for(int i=0;i<pagecount;i++){
					%>
					<li class="page-item pages<%=(i+1)==pagecount?" lastpage":"" %>" id="page<%=i+1%>" onclick="setdisplay(<%=i+1%>)"><a class="page-link"><%=i+1%></a></li>
					<%
					}
					%>
					
					<li class="page-item" id="next" onclick="nextbutton()"><a class="page-link">Next</a></li>
					
				</ul>
			</div>
		</div>
		<script>
		setdisplay(1);
		</script>
		
	</div>

	<div class="col-6" id="rightsection" style="margin-left:0px;">
	
	</div>
</div>


</body>
</html>
<%
rs.close();
stmt.close();
conn.close();
%>