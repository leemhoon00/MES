<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ page import="dbcon.dbcon"%>
<%@ page import="dbcon.facilitiesdb"%>
<%@ page import="java.util.Vector"%>
<%@ page import="java.io.PrintWriter"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<%
dbcon db = new dbcon();
Vector<facilitiesdb> fc = db.facilitiestable();
Vector<String> facilities_status = db.selectfacilities_status();
int lastpage = (fc.size()-1)/10 + 1;
Vector<String> code = db.getcode_sub();
%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"
	integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4="
	crossorigin="anonymous"></script>

<!--bootstrap-->
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css">

<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>

<script type="text/javascript"
	src="https://cdn.jsdelivr.net/jquery/latest/jquery.min.js"></script>
<script type="text/javascript"
	src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
<script type="text/javascript"
	src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
<link rel="stylesheet" type="text/css"
	href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />
<link rel="stylesheet" href="facilitiesph.css?ver02">
<title>Insert title here</title>
<script>
var request = new XMLHttpRequest();
var hlastpage = <%=lastpage%>;
var paging = 1

$(function(){
    $("#facilitiestabletbody tr").click(function(){
    	var tr = $(this);
    	var td = tr.children();
    	 $("#facilities_name").val(td.eq(0).text());
         var facilities_name = td.eq(0).text();
        
        var imgname = td.eq(1).text();
		if(imgname != 'null'){
			document.getElementById("img_div").innerHTML = '<img style="width: 500px;" src="../facilitiesupload/' + imgname + '">'
		}
		else{
			document.getElementById("img_div").innerHTML = "";
		}
		request.open("Post", "../facilitiesph?facilities_name=" + facilities_name, true);
    	request.onreadystatechange = getph;
    	request.send(null);
    
    });
});

function pagenation(page){
	var pagetable = document.getElementsByName("page" + page);

	for(var i=1; i<=hlastpage; i++){
		var nopagetable = document.getElementsByName("page" + i);
		for(var j=0; j<nopagetable.length; j++){
			nopagetable[j].style.display = "none";
		}
	}
	for(var i=0; i<pagetable.length; i++){
		pagetable[i].style.display = "";	
	}
	paging = page;
	for(var i=1; i<=hlastpage; i++){
		document.getElementById('a' + i).style.color = 'rgb(51,122,183)';
		document.getElementById('a' + i).style.background = 'white';	
		document.getElementById('aprevious').style.color = 'rgb(51,122,183)';
		document.getElementById('anext').style.color = 'rgb(51,122,183)';
	}
	document.getElementById('a' + page).style.background = 'rgb(51,122,183)';
	document.getElementById('a' + page).style.color = 'white';
	if(page == 1){
		document.getElementById('aprevious').style.color = 'gray';
	}
	if(page == hlastpage){
		document.getElementById('anext').style.color = 'gray';
	}
}

function previous(){
	if(paging > 1){
		paging -= 1;
		pagenation(paging);
	}
}

function next(){
	if(paging < hlastpage){
		paging += 1;
		pagenation(paging);
	}
}

function uladd(lastpage){
	var ul_list = $('#pageul');
	ul_list.empty();
	ul_list.append('<li class="page-item pages" id="previous"' + i +'" onclick="previous()"><a id="aprevious" class="page-link" style="color:rgb(51,122,183);">Previous</a></li>')
	for(var i=1; i<=lastpage; i++){
		ul_list.append('<li class="page-item pages" id="page"' + i +'" onclick="pagenation(' + i + ')"><a id="a' + i + '" class="page-link" style="color:rgb(51,122,183);">' + i + '</a></li>')	
	}
	ul_list.append('<li class="page-item pages" id="next"' + i +'" onclick="next()"><a id="anext" class="page-link" style="color:rgb(51,122,183);">Next</a></li>')
}

function addph(){
	var table = document.getElementById("facilitiesphtbody");
	var row = table.insertRow(table.rows.lenght);
	var cell1 = row.insertCell(0);
	var cell2 = row.insertCell(1);
	var cell3 = row.insertCell(2);
	var cell4 = row.insertCell(3);
	var string = '<select name="ncode" class="form-control">';
	<%
	String option = "'";
	for(int i=0; i<code.size(); i++){
		String s = "<option>" + code.get(i) + "</option>";
		option += s;
	}
	option += "'";
	%>
	string += <%=option%> + '</select>';
	cell1.innerHTML = '<input type="button" id="0" value="삭제" class="form-control" onclick="deleterow(this)">';
	cell2.innerHTML = string;
	cell3.innerHTML = '<input type="date" id="phdate" name="nphdate" class="form-control">';
	cell4.innerHTML = '<input type="text" style="width:95%" name="nph" class="form-control">';
	cell1.style.textAlign = 'center';
	cell2.style.textAlign = 'center';
	cell3.style.textAlign = 'center';
	cell4.style.textAlign = 'center';
}

function search(){
	var searchword = document.getElementById("search").value;
	request.open("Post", "../searchfacilities?searchword=" + searchword, true);
	request.onreadystatechange = searchfacilities;
	request.send(null);
}

function searchfacilities(){
	var facilitiestable = document.getElementById("facilitiestabletbody");
	var resultpage = 0;
	if(request.readyState == 4 && request.status == 200){
		facilitiestable.innerHTML = "";
		var object = eval('(' + request.responseText + ')');
		var result = object.result;
		for(var i=0; i<result.length; i++){
			var row = facilitiestable.insertRow(facilitiestable.rows.length);
			var resultpage = parseInt(i/10) + 1;
			$(row).attr('name', 'page' + resultpage);
			var cell1 = row.insertCell(0);
			var cell2 = row.insertCell(1);
			cell1.innerHTML = result[i][0].value;
			cell2.innerHTML = result[i][9].value;
			cell2.style.display = 'none';
		}
		hlastpage = parseInt((result.length-1)/10)+1
		uladd(hlastpage);
		pagenation(1);
		paging = 1;
		$(function(){
		    $("#facilitiestabletbody tr").click(function(){
		    	var tr = $(this);
		    	var td = tr.children();
		        $("#facilities_name").val(td.eq(0).text());
		        var facilities_name = td.eq(0).text();
		        
		        var imgname = td.eq(1).text();
				if(imgname != 'null'){
					document.getElementById("img_div").innerHTML = '<img style="width: 500px;" src="../facilitiesupload/' + imgname + '">'
				}
				else{
					document.getElementById("img_div").innerHTML = "";
				}
				request.open("Post", "../facilitiesph?facilities_name=" + facilities_name, true);
		    	request.onreadystatechange = getph;
		    	request.send(null);
		    });
		});
	}
	
}

function getph(){
	if(request.readyState == 4 && request.status == 200){
		var object = eval('(' + request.responseText + ')');
		var result = object.result;
		var table = document.getElementById("facilitiesphtbody");
		table.innerHTML = "";
		for(var i=0; i<result.length; i++){
			var row = table.insertRow(table.rows.lenght);
			var cell1 = row.insertCell(0);
			var cell2 = row.insertCell(1);
			var cell3 = row.insertCell(2);
			var cell4 = row.insertCell(3);
			var string = '<select id ="' + i +'" name="ncode" class="form-control">';
			<%
			String option1 = "'";
			for(int i=0; i<code.size(); i++){
				String s = "<option>" + code.get(i) + "</option>";
				option1 += s;
			}
			option1 += "'";
			%>
			string += <%=option1%> + '</select>';
			cell1.innerHTML = '<input type="button" value="삭제" class="form-control" onclick="deleterow(this)">';
			cell2.innerHTML = string;
			cell3.innerHTML = '<input type="date" id="phdate" name="nphdate" value="' + result[i][1].value + '" class="form-control">';
			cell4.innerHTML = '<input type="text" style="width:95%" name="nph" value="' + result[i][2].value + '" class="form-control">';
			cell1.style.textAlign = 'center';
			cell2.style.textAlign = 'center';
			cell3.style.textAlign = 'center';
			cell4.style.textAlign = 'center';	
			document.getElementById(i).value = result[i][0].value;
		}
	}
}
function insertform(frm){
	var facilities_name = document.getElementById("facilities_name").value;
	var code = document.getElementsByName("ncode");
	var date = document.getElementsByName("nphdate");
	var ph = document.getElementsByName("nph");
	var check = 0;
	
	if(facilities_name == "" ){
		alert("설비를 선택하세요");
		check = 1;
	}
	for(var i=0; i<ph.length; i++){
		if(check == 0 && code[i].value == ""){
			alert("값을 입력하세요.");
			check = 1;
			break;
		}
		if(check == 0 && date[i].value == ""){
			alert("값을 입력하세요.");
			check = 1;
			break;
		}
		if(check == 0 && ph[i].value == ""){
			alert("값을 입력하세요.");
			check = 1;
			break;
		}
	}
	if(check == 0){
		frm.action = './insertfacilitiesph.jsp';
		frm.submit();
	}
}

function deleteform(frm){
	var facilities_name = document.getElementById("facilities_name");
	var check = 0 
	if(facilities_name == ""){
		alert("필수값을 입력하세요.");
		check = 1;
	}
	if(check == 0){
		frm.action = './deletefacilitiesph.jsp';
		frm.submit();
	}
}

function deleterow(obj){
	var row = obj.parentElement.parentElement;
	row.remove();
}

</script>
</head>
<body>
	<div class="title">기준정보 관리 / 설비 관리</div>
	<div class="row">
		<div class="panel panel-default border boardlistbox col-md-6">
			<div class="panel-heading" style="height: 60px;">
				<div style="height: 40px;">
					<h5 class="panel-title" style="float: left; margin-top: 10px;">설비
						관리</h5>
				</div>
			</div>
			<div class="panel-body">
				<div style="margin-bottom: 20px;">
					<h5 style="float: left; margin-right: 10px;">검색 :</h5>
					<input id="search" type="text" onkeyup="search()">
				</div>
				<table class="table table-bordered table-hover" id="facilitiestable">
					<thead class="tablehead">
						<th>설비이름</th>
						
					</thead>
					<tbody id="facilitiestabletbody">
						<%
						for (int i = 0; i < fc.size(); i++) {
							int pageid = i/10 + 1;
						%>
						<tr name="page<%=pageid%>">
							<td><%=fc.get(i).getFacilities_name()%></td>
							<td style="display:none"><%=fc.get(i).getFacilities_img() %></td>
						</tr>
						<%
						}
						%>
					</tbody>
				</table>

				<ul class="pagination justify-content-end" id="pageul">

				</ul>
				<script>
					uladd(hlastpage);
					pagenation(1);
				</script>
			</div>
		</div>
		<div class="panel panel-default border boardinputbox col-md-6">
			<div class="panel-heading" style="height: 60px;">
				<h5 class="panel-title" style="float: left; margin-top: 10px;">설비
					등록/수정</h5>
			</div>
			<div class="panel-body">
				<form>
				<table style="border: 0; width: 98%; margin-left: 10px;">
					<tr>
						<td>
						
							<div style="display: flex">
								<div style="flex: 1; margin-right: 30px;">
									<label for="boardnuminput">설비 이름</label>
									<input type="text" id="facilities_name" name="nfacilities_name" class="form-control" readonly>
								</div>
								<div style="flex: 1;">
									<div><label for="writedayinput">설비이미지</label></div> 
									<div id="img_div"></div>
								</div>
							</div>
						</td>
					</tr>
				   
					<tr>
						<td>
							<div style="margin-top:10px;">
								<label for="boardnuminput">설비이력</label>
								<input type="button" value="추가" onclick="addph()">
							</div>
						</td>
					</tr>
							    
				  <tr>
				  	<table class="table table-bordered table-hover" id="facilitieschecktable">
					<thead class="tablehead">
						<th style="width: 10%;"></th>
						<th style="width: 10%;">분류</th>
						<th style="width: 40%;">일자</th>
						<th style="width: 40%;">조치사항</th>
					</thead>
					<tbody id="facilitiesphtbody">
						<td style="display:none">
						</td>
					</tbody>
				</table>
				  </tr>
			</table>
			</div>
			<div class="buttongruops">
				<input class="btn btn-primary" type="button" value="등록" onclick="insertform(this.form)"> 
			</div>
			</form>
		</div>
	</div>
</body>
</html>