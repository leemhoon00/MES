<!-- 입출고 관리 페이지 -->

<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.Statement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.time.LocalDate"%>

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
int temp;

//발주 관련 페이지네이션 용
int orderrowcount=0;
query="select count(*) from place_order";
rs=stmt.executeQuery(query);
if(rs.next()){orderrowcount=rs.getInt(1);}
int orderlastpagenumber=1;
if(orderrowcount != 0){
	orderlastpagenumber = (orderrowcount-1)/10 +1;
}

//외주 관련 페이지네이션 용
int outsourcingrowcount=0;
query="select count(*) from outsourcing";
rs=stmt.executeQuery(query);
if(rs.next()){outsourcingrowcount=rs.getInt(1);}
int outsourcinglastpagenumber=1;
if(outsourcingrowcount != 0){
	outsourcinglastpagenumber = (outsourcingrowcount-1)/10 +1;
}
%>
<%
query = "select * from place_order";
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
<script>
	//셀렉트박스가 발주인지 외주인지 저장하는 변수
	var selectbox = "발주";
	//선택된 발주 변수
	var selectedorder = "";
	//선택된 외주 변수
	var selectedoutsourcing = "";
	
	//페이지네이션 용
	var orderlastpage = <%=orderlastpagenumber%>
	var outsourcinglastpage = <%=outsourcinglastpagenumber%>
</script>
	<label class="title" style="margin-left: 30px; margin-top: 10px;">발주입고 관리 / 입출고 관리</label>

<!--------------------------------------------- 윗 섹션 ----------------------------------------------->

	<div class="card">
		<div class="card-body">
			<div class="form-inline">
				<label>구분</label>
				<select class="form-select search" id="selectbox" onchange="divisionchange()">
					<option value="발주">발주</option>
					<option value="외주">외주</option>
				</select>
				<label>자재명</label>
				<input class="form-control search" id="search" type="text" onKeypress="javascript:if(event.keyCode==13) {search(this)}">
				<label>긴급</label>
				<input type="checkbox" id="hurryup" onclick="checkboxchange(this)">
				<button class="btn btn-info" data-bs-toggle="modal" data-bs-target="#exampleModal">입고</button>
				<button class="btn btn-info" onclick="showorder()" id="showorderbutton" data-bs-toggle="modal" data-bs-target="#exampleModal2">발주서 보기</button>
				<button class="btn btn-danger" type="button" onclick="deletebutton()">삭제</button>
			</div>
		</div>
	</div>
	<script>
	function checkboxchange(element){
		if(selectbox == "외주"){
			if(element.checked == true){
				var trs = document.querySelectorAll(".outsourcingtrs");
				for(var i=0; i<trs.length; i++){
					var item= trs.item(i);
					item.style.display="none";
				}
				trs = document.querySelectorAll(".notcomplete");
				for(var i=0; i<trs.length; i++){
					var item= trs.item(i);
					item.style.display="";
				}
				document.getElementById("outsourcingpageul").style.display="none";
			}
			else{
				outsourcingsetdisplay(1);
				document.getElementById("outsourcingpageul").style.display="";
			}
		}
	}
	
	function deletebutton(){
		if(selectbox=="발주"){
			if(selectedorder==""){
				alert("발주를 선택해주세요");
			}
			else{
				location.href="orderdelete.jsp?p1="+selectedorder;
			}
		}
		else if(selectbox=="외주"){
			if(selectedoutsourcing==""){
				alert("외주를 선택해주세요");
			}
			else{
				location.href="outsourcingdelete.jsp?p1="+selectedoutsourcing;
			}
		}
	}
	
	function showorder(){
		if(selectedorder==""){
			alert("발주를 선택해주세요");
			document.getElementById("porder_company").value = "";
			document.getElementById("place_of_delivery").value = "";
			document.getElementById("note").value = "";
			document.getElementById("p_date").value = "";
			document.getElementById("receiving_day").value = "";
			document.getElementById("part_name").value = "";
			document.getElementById("number_of_request").value = "";
			document.getElementById("unit_price").value = "";
		}
		
		else{
			var target = document.getElementById("order"+selectedorder);
			document.getElementById("porder_company").value = target.children[4].innerHTML;
			document.getElementById("place_of_delivery").value = target.children[8].innerHTML;
			document.getElementById("note").value = target.children[10].innerHTML;
			document.getElementById("p_date").value = target.children[5].innerHTML;
			document.getElementById("receiving_day").value = target.children[6].innerHTML;
			document.getElementById("part_name").value = target.children[1].innerHTML;
			document.getElementById("number_of_request").value = target.children[3].innerHTML;
			document.getElementById("unit_price").value = target.children[9].innerHTML;
		}
	}
	
	//검색
	function search(element){
		
		//셀렉트박스가 발주일때
		if(document.getElementById("selectbox").value=="발주"){
			var trs = document.querySelectorAll(".ordertrs");
			//텍스트박스에 값이 있을때
			if(element.value!=""){
				var searchcount=0;
				var searchlastpagenumber=1;
				
				for(var i=0; i<trs.length; i++){
					var item = trs.item(i);
					
					item.classList.remove('notsearch');
					item.classList.remove('yessearch');
					
					if(item.children[1].innerHTML.search(element.value) == -1){
						item.style.display="none";
						item.className += ' notsearch';
					}
					else{
						item.style.display="";
						searchcount++;
						item.className += ' yessearch';
					}
				}
				searchlastpagenumber = parseInt((searchcount-1)/10) +1;
				
				tempitem = document.querySelector(".orderlastpage");
				tempitem.classList.remove('orderlastpage');
				document.getElementById("orderpage"+searchlastpagenumber).className += ' orderlastpage';
				
				var temppages = document.querySelectorAll(".orderpages");
				for(var i=0; i<temppages.length; i++){
					var item = temppages.item(i);
					item.style.display="none";
				}
				
				for(var i=0; i<trs.length; i++){
					var item = trs.item(i);
					for(var i2=1; i2<searchlastpagenumber+1; i2++){
						item.classList.remove('orderpagegroup'+i2);
						document.getElementById('orderpage'+i2).style.display="";
					}
					
				}
				
				var trs2 = document.querySelectorAll(".yessearch");
				var tempgroupcount=1;
				var tempcount=0;
				for(var i=0;i<trs2.length;i++){
					var item = trs2.item(i);
					tempcount++;
					if(tempcount>10){
						tempcount = tempcount-10;
						tempgroupcount++;
					}
					
					item.className += ' orderpagegroup'+tempgroupcount;
					
				}
				
				ordersetdisplay(1);
				
			}
			//텍스트박스가 비어있을 때
			else{
				orderinitialpage();
				ordersetdisplay(1);
			}
		}
		
		
		//셀렉트박스가 외주일때
		else{
			var trs = document.querySelectorAll(".outsourcingtrs");
			var searchcount=0;
			var searchlastpagenumber=1;
			
			//텍스트박스에 값이 있을때
			if(element.value!=""){
				for(var i=0; i<trs.length; i++){
					var item = trs.item(i);
					item.classList.remove('yessearch');
					
					if(item.children[2].innerHTML.search(element.value) == -1){
						item.style.display="none";
						item.className += ' notsearch';
					}
					else{
						item.style.display="";
						searchcount++;
						item.className += ' yessearch';
					}
				}
				searchlastpagenumber = parseInt((searchcount-1)/10) +1;
				tempitem = document.querySelector(".outsourcinglastpage");
				tempitem.classList.remove('outsourcinglastpage');
				document.getElementById("outsourcingpage"+searchlastpagenumber).className += ' outsourcinglastpage';
				
				var temppages = document.querySelectorAll(".outsourcingpages");
				for(var i=0; i<temppages.length; i++){
					var item = temppages.item(i);
					item.style.display="none";
				}
				
				for(var i=0; i<trs.length; i++){
					var item = trs.item(i);
					for(var i2=1; i2<searchlastpagenumber+1; i2++){
						item.classList.remove('outsourcingpagegroup'+i2);
						document.getElementById('outsourcingpage'+i2).style.display="";
					}
					
				}
				
				var trs2 = document.querySelectorAll(".yessearch");
				var tempgroupcount=1;
				var tempcount=0;
				for(var i=0;i<trs2.length;i++){
					var item = trs2.item(i);
					tempcount++;
					if(tempcount>10){
						tempcount = tempcount-10;
						tempgroupcount++;
					}
					
					item.className += ' outsourcingpagegroup'+tempgroupcount;
					
				}
				
				outsourcingsetdisplay(1);
			}
			//텍스트박스가 비어있을 때
			else{
				outsourcinginitialpage();
				outsourcingsetdisplay(1);
			}
		}
		
	}
	function orderinitialpage(){
		var trs = document.querySelectorAll(".ordertrs");
		for(var i=0; i<trs.length; i++){
			item = trs.item(i);
			item.classList.remove('yessearch');
			for(var i2=1; i2<orderlastpage+1;i2++){
				item.classList.remove('orderpagegroup'+i2);
			}
		}
		tempitem = document.querySelector(".orderlastpage");
		tempitem.classList.remove('orderlastpage');
		document.getElementById("orderpage"+orderlastpage).className += ' orderlastpage';
		
		var temppages = document.querySelectorAll(".orderpages");
		for(var i=0; i<temppages.length; i++){
			var item = temppages.item(i);
			item.style.display="";
		}
		var trs2 = document.querySelectorAll(".ordertrs");
		var tempgroupcount=1;
		var tempcount=0;
		for(var i=0;i<trs2.length;i++){
			var item = trs2.item(i);
			tempcount++;
			if(tempcount>10){
				tempcount = tempcount-10;
				tempgroupcount++;
			}
			
			item.className += ' orderpagegroup'+tempgroupcount;
			
		}
	}
	
	function outsourcinginitialpage(){
		var trs = document.querySelectorAll(".outsourcingtrs");
		for(var i=0; i<trs.length; i++){
			item = trs.item(i);
			item.classList.remove('yessearch');
			for(var i2=1; i2<outsourcinglastpage+1;i2++){
				item.classList.remove('outsourcingpagegroup'+i2);
			}
		}
		
		tempitem = document.querySelector(".outsourcinglastpage");
		tempitem.classList.remove('outsourcinglastpage');
		document.getElementById("outsourcingpage"+outsourcinglastpage).className += ' outsourcinglastpage';
		
		var temppages = document.querySelectorAll(".outsourcingpages");
		for(var i=0; i<temppages.length; i++){
			var item = temppages.item(i);
			item.style.display="";
		}
		var trs2 = document.querySelectorAll(".outsourcingtrs");
		var tempgroupcount=1;
		var tempcount=0;
		for(var i=0;i<trs2.length;i++){
			var item = trs2.item(i);
			tempcount++;
			if(tempcount>10){
				tempcount = tempcount-10;
				tempgroupcount++;
			}
			
			item.className += ' outsourcingpagegroup'+tempgroupcount;
			
		}
	}
	
	function divisionchange(){
		if(document.getElementById("selectbox").value=="발주"){
			selectbox = "발주";
			selectedorder = "";
			selectedoutsourcing = "";
			
			orderinitialpage();
			document.getElementById("showorderbutton").style.display="";
			document.getElementById("ordersection").style.display="";
			document.getElementById("outsourcingsection").style.display="none";
			
		}
		else{
			
			selectbox = "외주";
			selectedorder = "";
			selectedoutsourcing = "";
			
			outsourcinginitialpage();
			document.getElementById("showorderbutton").style.display="none";
			document.getElementById("ordersection").style.display="none";
			document.getElementById("outsourcingsection").style.display="";
			
		}
	}
	</script>
	<div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
 		<div class="modal-dialog" style="max-width: 100%; width: auto; display: table;">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="exampleModalLabel">입고일</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body" style="padding:1px">
					<div class="row" style="width:300px">
						<div class="col-12">
							<label style="margin:10px;">입고일</label>
						</div>
						<div class="col-12">
							<input type="date" id="date" style="margin:10px; width:200px;">
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-info" onclick="savebutton()">저장</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	<script>
	
	function savebutton(){
		if(selectbox =="발주" && selectedorder != ""){
			p1 = document.getElementById("order"+selectedorder).children[0].innerHTML;
			p2 = document.getElementById("date").value;
			location.href="ordersave.jsp?p1="+p1+"&p2="+p2;
		}
		else if(selectbox =="발주" && selectedorder == ""){
			alert("선택된 발주가 없습니다.");
		}
		else if(selectbox =="외주" && selectedoutsourcing != ""){
			p1 = document.getElementById("outsourcing"+selectedoutsourcing).children[0].innerHTML;
			p2 = document.getElementById("date").value;
			location.href="outsourcingsave.jsp?p1="+p1+"&p2="+p2;
		}
		else{
			alert("선택된 외주가 없습니다.");
		}
		
	}
	</script>
	<div class="modal fade" id="exampleModal2" tabindex="-1" aria-labelledby="exampleModalLabel2" aria-hidden="true">
 		<div class="modal-dialog" style="max-width: 100%; width: auto; display: table;">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="exampleModalLabel2">발주서</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body" style="padding:1px">
					<div class="row" style="width:900px">
						<div class="col-4">
							<label style="margin:10px;">입고일</label>
						</div>
						<div class="col-4">
							<label style="margin:10px;">납품장소</label>
						</div>
						<div class="col-4">
							<label style="margin:10px;">비고</label>
						</div>
						<div class="col-4">
							<input type="text" class="form-control" id="porder_company" disabled>
						</div>
						<div class="col-4">
							<input type="text" class="form-control" id="place_of_delivery" disabled>
						</div>
						<div class="col-4">
							<input type="text" class="form-control" id="note" disabled>
						</div>
						<div class="col-6">
							<label style="margin:10px;">발주요청일</label>
						</div>
						<div class="col-6">
							<label style="margin:10px;">발주입고일</label>
						</div>
						<div class="col-6">
							<input type="text" class="form-control" id="p_date" disabled>
						</div>
						<div class="col-6">
							<input type="text" class="form-control" id="receiving_day" disabled>
						</div>
						<div class="col-4">
							<label style="margin:10px;">제품명</label>
						</div>
						<div class="col-4">
							<label style="margin:10px;">수량</label>
						</div>
						<div class="col-4">
							<label style="margin:10px;">단가(원)</label>
						</div>
						<div class="col-4">
							<input type="text" class="form-control" id="part_name" disabled>
						</div>
						<div class="col-4">
							<input type="text" class="form-control" id="number_of_request" disabled>
						</div>
						<div class="col-4">
							<input type="text" class="form-control" id="unit_price" disabled>
						</div>
						
						
						
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
					</div>
				</div>
			</div>
		</div>
	</div>
<!--------------------------------------------- 발주 섹션 ----------------------------------------------->
	
 	<div class="card" id="ordersection">
	    <div class="card-header">
	        <h5 style="display:inline-block;">발주</h5>
			<div class="warningbox" style="float: right;">
				<div class="completegreenbox" style="display:table-cell;"></div>
				<div class="completegreenexp" style="display:table-cell; background: white;"><h4 style="font-weight: bold; margin: 10px;">완료</h4></div>
			</div>
	    </div>
        <div class="card-body">
        	<table class="table table-bordered" style="width: 100%;" role="grid">
				<thead>
					<tr>
						<th>자재명</th>
						<th>유형</th>
						<th>요청갯수</th>
						<th>발주 업체</th>
						<th>발주 요청일</th>
						<th>입고일</th>
						<th>입고여부</th>
					</tr>
				</thead>
				<tbody style="border-top: none;">
						
					<%
					String complete = "";
					int ordercount=0;
					int orderpagegroup=0;
					
					while(rs.next()){
						ordercount++;
						if(ordercount % 10 ==1){
							orderpagegroup++;
						}
						temp = rs.getInt("porder_no");
						if(rs.getString("receiving_status").equals("N")){
							complete = "";
						}
						else{
							complete = " complete";
						}
						
					%>
					
					<tr class="ordertrs<%=complete%> orderpagegroup<%=orderpagegroup%>" id="order<%=temp%>" onclick="orderclickevent(this)">
						<td style="display:none"><%=rs.getString("porder_no")%></td>
						<td><%=rs.getString("part_name")%></td>
						<td><%=rs.getString("type")%></td>
						<td><%=rs.getInt("number_of_request")%></td>
						<td><%=rs.getString("porder_company")%></td>
						<td><%=rs.getString("p_date")%></td>
						<td><%=rs.getString("receiving_day")%></td>
						<td><%=rs.getString("receiving_status")%></td>
						<td style="display:none"><%=rs.getString("place_of_delivery")%></td>
						<td style="display:none"><%=rs.getInt("unit_price")%></td>
						<td style="display:none"><%=rs.getString("note")%></td>
					</tr>
					<%
					}
					%>
				</tbody>
			</table>
			<script>
			function orderclickevent(element){
				trs = document.querySelectorAll(".ordertrs");
				for(var i=0; i<trs.length; i++){
					var item = trs.item(i);
					item.style.backgroundColor="white";
				}
				if(selectedorder == element.children[0].innerHTML){
					selectedorder = "";
					selectedoutsourcing = "";
					element.style.backgroundColor="white";
				}
				else{
					selectedorder = element.children[0].innerHTML;
					selectedoutsourcing = "";
					element.style.backgroundColor="rgb(68,80,132)";
				}
			}
			
			//페지네이션
			function ordersetdisplay(groupnumber){
				var trs = document.querySelectorAll(".ordertrs");
				for(var i=0; i<trs.length; i++){
					var item = trs.item(i);
					item.style.display="none";
				}
				
				trs = document.querySelectorAll(".orderpagegroup"+groupnumber);
				for(var i=0; i<trs.length; i++){
					var item = trs.item(i);
					item.style.display="";
				}
				
				var pages = document.querySelectorAll(".orderpages");
				for(var i=0; i<pages.length; i++){
					var item = pages.item(i);
					item.classList.remove('active');
				}
				document.getElementById("orderpage"+groupnumber).className += ' active';
				
				//previous버튼처리
				if(groupnumber==1){
					document.getElementById("orderprevious").className += ' disabled';
					document.getElementById("orderprevious").style.pointerEvents="none";
				}
				else{
					document.getElementById("orderprevious").classList.remove('disabled');
					document.getElementById("orderprevious").style.pointerEvents="auto";
				}
				
				//next버튼처리
				if(groupnumber==document.querySelector(".orderlastpage").children[0].innerHTML*1){
					document.getElementById("ordernext").className += ' disabled';
					document.getElementById("ordernext").style.pointerEvents="none";
				}
				else{
					document.getElementById("ordernext").classList.remove('disabled');
					document.getElementById("ordernext").style.pointerEvents="auto";
				}
			}
			
			function orderpreviousbutton(){
				ordersetdisplay(document.querySelector(".active").children[0].innerHTML*1-1);
			}
			
			function ordernextbutton(){
				ordersetdisplay(document.querySelector(".active").children[0].innerHTML*1+1);
			}
			</script>
			<ul class="pagination justify-content-end">
				<li class="page-item" id="orderprevious" onclick="orderpreviousbutton()"><a class="page-link">Previous</a></li>
				<%
					int orderpagecount = ((orderrowcount-1)/10)+1;
					for(int i=0;i<orderpagecount;i++){
					%>
					<li class="page-item orderpages<%=(i+1)==orderpagecount?" orderlastpage":"" %>" id="orderpage<%=i+1%>" onclick="ordersetdisplay(<%=i+1%>)"><a class="page-link"><%=i+1%></a></li>
					<%
					}
				%>
				
				<li class="page-item" id="ordernext" onclick="ordernextbutton()"><a class="page-link">Next</a></li>
			</ul>
        </div>
        <script>
        ordersetdisplay(1);
        </script>
        
	</div>
	
	
<!--------------------------------------------- 외주 섹션 ----------------------------------------------->
	
 	<div class="card" id="outsourcingsection" style="display:none;">
	    <div class="card-header">
	        <h5 style="display:inline-block;">외주 관리</h5>
	        <div class="warningbox" style="float: right;">
				<div class="completegreenbox" style="display:table-cell;"></div>
				<div class="completegreenexp" style="display:table-cell; background: white;"><h4 style="font-weight: bold; margin: 10px;">완료</h4></div>
				<div class="warningredbox" style="display:table-cell;"></div>
				<div class="warningboxexp" style="display:table-cell; background: white;"><h4 style="font-weight: bold; margin: 10px;">비상</h4></div>                    
			</div>
	    </div>
        <div class="card-body">
        	<table class="table table-bordered" style="width: 100%;" role="grid">
				<thead>
					<tr>
						<th>수주명</th>
						<th>부품명</th>
						<th>공정</th>
						<th>유형</th>
						<th>업체</th>
						<th>금액</th>
						<th>입고예정일</th>
						<th>외주시작일</th>
						<th>입고일</th>
						<th>불량</th>
					</tr>
				</thead>
				<tbody style="border-top: none;">
					<%
					int outsourcingcount=0;
					int outsourcingpagegroup=0;
					query = "select * from outsourcing";
					rs=stmt.executeQuery(query);
					
					Date day;
					Date today = java.sql.Date.valueOf(LocalDate.now());
					while(rs.next()){
						outsourcingcount++;
						day = rs.getDate("warehousing_exp_date");
						
						if(outsourcingcount % 10 ==1){
							outsourcingpagegroup++;
						}
						temp = rs.getInt("outsourcing_no");
						
						if(rs.getString("outend_date") != null || rs.getString("warehousing_date") != null){
							complete=" complete";
						}
						else if(day == null || today.equals(day) || today.after(day)){
							complete=" notcomplete";
						}
						else{
							complete = "";
						}
					%>
					<tr class="outsourcingtrs<%=complete%> outsourcingpagegroup<%=outsourcingpagegroup%>" id="outsourcing<%=temp%>" onclick="outsourcingclickevent(this)">
						<td style="display:none"><%=rs.getInt("outsourcing_no")%></td>
						<td><%=rs.getString("orders_name")%></td>
						<td><%=rs.getString("prod_name")%></td>
						<td><%=rs.getString("process")%></td>
						<td><%=rs.getString("type")%></td>
						<td><%=rs.getString("company")%></td>
						<td><%=rs.getInt("price")%></td>
						<td><%=rs.getString("warehousing_exp_date")%></td>
						<td><%=rs.getString("outstart_date")%></td>
						<td><%=rs.getString("warehousing_date")%></td>
						<td><%=rs.getString("faulty")%></td>
					</tr>
					<%
					}
					%>
				</tbody>
			</table>
			<ul class="pagination justify-content-end" id="outsourcingpageul">
				<li class="page-item" id="outsourcingprevious" onclick="outsourcingpreviousbutton()"><a class="page-link">Previous</a></li>
				<%
					int outsourcingpagecount = ((outsourcingrowcount-1)/10)+1;
					for(int i=0;i<outsourcingpagecount;i++){
					%>
					<li class="page-item outsourcingpages<%=(i+1)==outsourcingpagecount?" outsourcinglastpage":"" %>" id="outsourcingpage<%=i+1%>" onclick="outsourcingsetdisplay(<%=i+1%>)"><a class="page-link"><%=i+1%></a></li>
					<%
					}
				%>
				
				<li class="page-item" id="outsourcingnext" onclick="outsourcingnextbutton()"><a class="page-link">Next</a></li>
			</ul>
			<script>
			function outsourcingclickevent(element){
				trs = document.querySelectorAll(".outsourcingtrs");
				for(var i=0; i<trs.length; i++){
					var item = trs.item(i);
					item.style.backgroundColor="white";
				}
				if(selectedoutsourcing == element.children[0].innerHTML){
					selectedorder = "";
					selectedoutsourcing = "";
					element.style.backgroundColor="white";
				}
				else{
					selectedorder = "";
					selectedoutsourcing = element.children[0].innerHTML;
					element.style.backgroundColor="rgb(68,80,132)";
				}
			}
			
			//페지네이션
			function outsourcingsetdisplay(groupnumber){
				var trs = document.querySelectorAll(".outsourcingtrs");
				for(var i=0; i<trs.length; i++){
					var item = trs.item(i);
					item.style.display="none";
				}
				
				trs = document.querySelectorAll(".outsourcingpagegroup"+groupnumber);
				for(var i=0; i<trs.length; i++){
					var item = trs.item(i);
					item.style.display="";
				}
				
				var pages = document.querySelectorAll(".outsourcingpages");
				for(var i=0; i<pages.length; i++){
					var item = pages.item(i);
					item.classList.remove('active2');
				}
				document.getElementById("outsourcingpage"+groupnumber).className += ' active2';
				
				//previous버튼처리
				if(groupnumber==1){
					document.getElementById("outsourcingprevious").className += ' disabled';
					document.getElementById("outsourcingprevious").style.pointerEvents="none";
				}
				else{
					document.getElementById("outsourcingprevious").classList.remove('disabled');
					document.getElementById("outsourcingprevious").style.pointerEvents="auto";
				}
				
				//next버튼처리
				if(groupnumber==document.querySelector(".outsourcinglastpage").children[0].innerHTML*1){
					document.getElementById("outsourcingnext").className += ' disabled';
					document.getElementById("outsourcingnext").style.pointerEvents="none";
				}
				else{
					document.getElementById("outsourcingnext").classList.remove('disabled');
					document.getElementById("outsourcingnext").style.pointerEvents="auto";
				}
			}
			
			function outsourcingpreviousbutton(){
				outsourcingsetdisplay(document.querySelector(".active2").children[0].innerHTML*1-1);
			}
			
			function outsourcingnextbutton(){
				outsourcingsetdisplay(document.querySelector(".active2").children[0].innerHTML*1+1);
			}
			
			outsourcingsetdisplay(1);
			</script>
        </div>
	</div>
	
	<%
	rs.close();
	stmt.close();
	conn.close();
	%>
</body>
</html>