<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ page import="dbcon.dbcon"%>
<%@ page import="dbcon.manage_porderdb"%>
<%@ page import="java.util.Vector"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<%
dbcon dbc = new dbcon();
Vector<manage_porderdb> mp = dbc.manage_porderdbtable();
int lastpage = (mp.size() - 1) / 10 + 1;
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
<link rel="stylesheet" href="managepordercss.css?ver02">
<link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
        <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
<style>
.select2-container .select2-selection--single{
	height:33px;
	position:relative;
	bottom:5px;
}
</style>
<script>
	var request = new XMLHttpRequest();
	var hlastpage = <%=lastpage%>;
	var paging = 1;
	var checkarr = new Array();
	function checkboxclick(obj) {
		var trobj = obj.parentElement.parentElement;
		var myid = document.getElementById(trobj.getAttribute("id")).getAttribute("id");
		var tr = $("#" + myid);
		var td = tr.children();
		var part_name = td.eq(1).text();
		var order_name = td.eq(2).text();
		var nor = td.eq(3).text();
		var type = td.eq(4).text();
		var m_no = td.eq(5).text();
		var trcolor = document.getElementById(myid);
		var pushid = obj.getAttribute("id");
		if (obj.checked == true) {
			var addordertable = document.getElementById("ordertbody");
			var row = addordertable.insertRow(addordertable.rows.lenght);
			row.id = "row" + myid;
			var cell1 = row.insertCell(0);
			var cell2 = row.insertCell(1);
			var cell3 = row.insertCell(2);
			var cell4 = row.insertCell(3);
			var cell5 = row.insertCell(4);
			var cell6 = row.insertCell(5);
			cell1.innerHTML = '<input type="text" id="p' + myid + '" name="npart_name" value="'
					+ part_name
					+ '" class="form-control" readonly style="width:80%; margin-top:10px;">';
			cell2.innerHTML = '<input type="text" id="n' + myid +'"name="nnor" value="'
					+ nor
					+ '" class="form-control" readonly style="width:80%; margin-top:10px;">';
			cell3.innerHTML = '<input type="text" id="c' + myid + '" name="nprice" class="form-control" style="width:80%; margin-top:10px;">';
			cell4.innerHTML = '<input type="text" name="ntype" value="'+ type +'" class="form-control" style="display:none;">';
			cell5.innerHTML = '<input type="text" name="nm_no" value="'+ m_no +'" class="form-control" style="display:none;">';
			cell6.innerHTML = '<input type="text" name="norder_name" value="'+ order_name +'" class="form-control" style="display:none;">';
			trcolor.style.background = 'rgb(68,80,132)';
			checkarr.push(pushid);
		}
		if (obj.checked == false) {
			document.getElementById("row" + myid).remove();
			trcolor.style.background = 'white';
			checkarr.splice(checkarr.indexOf(pushid), 1);
		}
	}

	function changecolor(obj1) {
		var obj = document.getElementById(obj1)
		var trobj = obj.parentElement.parentElement;
		var myid = document.getElementById(trobj.getAttribute("id"))
				.getAttribute("id");
		var tr = $("#" + myid);
		var trcolor = document.getElementById(myid);
		trcolor.style.background = 'rgb(68,80,132)';
	}

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

	function previous() {
		if (paging > 1) {
			paging -= 1;
			pagenation(paging);
		}
	}

	function next() {
		if (paging < hlastpage) {
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

	function search() {
		if (window.event.keyCode == 13) {
			var searchpartname = document.getElementById("searchpartname").value;
			var searchorder = document.getElementById("searchorder").value;
			request.open("Post",
					"../searchmanage_porder?searchpartname="
							+ searchpartname + "&searchorder=" + searchorder,
					true);
			request.onreadystatechange = searchmanage_porder;
			request.send(null);
		}
	}

	function searchmanage_porder() {
		var manage_pordertable = document.getElementById("manage_pordertbody");
		var resultpage = 0;
		if (request.readyState == 4 && request.status == 200) {
			manage_pordertable.innerHTML = "";
			var object = eval('(' + request.responseText + ')');
			var result = object.result;
			for (var i = 0; i < result.length; i++) {
				var row = manage_pordertable.insertRow(manage_pordertable.rows.length);
				var resultpage = parseInt(i / 10) + 1;
				$(row).attr('name', 'page' + resultpage);
				$(row).attr('id', 'tr' + result[i][4].value);
				var cell = row.insertCell(0);
				var checkarrtf = 0;

				for (var k = 0; k < checkarr.length; k++) {
					if (checkarr[k] == result[i][4].value) {
						cell.innerHTML = '<input type="checkbox" id="'
								+ result[i][4].value
								+ '" checked onclick="checkboxclick(this)">';
						changecolor(result[i][4].value);
						checkarrtf = 1;
						break;
					}
				}
				if (checkarrtf == 0) {
					cell.innerHTML = '<input type="checkbox" id="'
							+ result[i][4].value
							+ '"onclick="checkboxclick(this)">';
				}
				for (var j = 1; j <= result[i].length; j++) {
					if (j > 3) {
						var cell = row.insertCell(j);
						cell.innerHTML = result[i][j - 1].value;
						cell.style.display = 'none';
					} else {
						var cell = row.insertCell(j);
						cell.innerHTML = result[i][j - 1].value;
					}
				}
			}
			hlastpage = parseInt((result.length - 1) / 10) + 1
			uladd(hlastpage);
			pagenation(1);
			paging = 1;
		}
	}
	
	function insertform(frm){
		var odercom = document.getElementById('ordercom');
		var partname = document.getElementsByName('npart_name');
		var nor = document.getElementsByName('nnor');
		var price = document.getElementsByName('nprice');
		
		var check = 0;
		
		if (check == 0 && odercom.value == ""){
			alert("필수값을 입력하세요.");
			check = 1;
		}
		if(check == 0 && partname.length == 0){
			alert("필수값을 입력하세요.");
			check = 1;
		}
		if(check == 0 && nor.length == 0){
			alert("필수값을 입력하세요.");
			check = 1;
		}
		if(check == 0 && price.length == 0){
			alert("필수값을 입력하세요.");
			check = 1;
		}
		for(var i=0; i<partname.length; i++){
			if(check == 0 && partname[i].value == ""){
				alert("필수값을 입력하세요.");
				check = 1;
				break;
			}	
		}
		for(var i=0; i<nor.length; i++){
			if(check == 0 && nor[i].value == ""){
				alert("필수값을 입력하세요.");
				check = 1;
				break;
			}	
		}
		for(var i=0; i<price.length; i++){
			if(check == 0 && price[i].value == ""){
				alert("필수값을 입력하세요.");
				check = 1;
				break;
			}	
		}
		if(check == 0){
			frm.action='./insertplace_order.jsp';
			frm.submit();
		}
	}
	function deleteform(frm){
		var m_no = document.getElementsByName('nm_no');
		var check = 0;
		if(m_no.length == 0){
			alert('필수값을 입력하세요.')
			check = 1;
		}
		if(check == 0){
			frm.action='./deletemanage_porder.jsp';
			frm.submit();
		}
	}
	$(document).ready(function() {
        $('select[id="ordercom"]').select2();
        $('select[id="ordercom"]').val("").select2();
    });
	
	function exceldownload(){
		var cnt = 0;
		var pst = '';
		for(var i=0; i<checkarr.length; i++){
			var pid = document.getElementById("ptr" + checkarr[i]).value;
			var nid = document.getElementById("ntr" + checkarr[i]).value;
			var cid = document.getElementById("ctr" + checkarr[i]).value;
			pst += '&part' + cnt + '=' + pid + '&nor' + cnt + '=' + nid + '&cost' + cnt + '=' + cid;
			cnt ++;
		}
		var url = "../mpExcel/mpExcel?mode=excelinfo&cnt=" +cnt + pst;

		location.href = url;	

	}
</script>
</head>
<body>
	<div class="title">발주입고 관리/발주 관리</div>
	<div class="panel panel-default border searchbox">
		<div class="panel-body">
			부품명:&nbsp;&nbsp;&nbsp;<input type="text" id="searchpartname" name="nsearchpartname"
				class="form-control searchtitle" onkeyup="search()"> 수주명:&nbsp;&nbsp;&nbsp;<input
				type="text" id="searchorder" name="nsearchorder"
				class="form-control searchtitle" onkeyup="search()">
		</div>
	</div>
	<div class="row">
		<div class="panel panel-default border p1box col-md-6">
			<div class="panel-heading" style="height: 60px;">
				<div style="height: 40px;">
					<h5 class="panel-title" style="float: left; margin-top: 10px;">발주
						관리</h5>
				</div>
			</div>
			<div class="panel-body">
				<table class="table table-bordered table-hover"
					id="manage_pordertable">
					<thead class="tablehead">
						<th style="width: 10%;"></th>
						<th style="width: 30%;">부품명</th>
						<th style="width: 30%;">수주명</th>
						<th style="width: 30%;">요청갯수</th>
					</thead>
					<tbody id="manage_pordertbody">
						<%
						for (int i = 0; i < mp.size(); i++) {
							int pageid = i / 10 + 1;
						%>
						<tr id="tr" name="page<%=pageid%>">
							<td><input type="checkbox" id="<%=mp.get(i).getM_no()%>"
								onclick="checkboxclick(this)"></td>
							<td><%=mp.get(i).getPart_name()%></td>
							<td><%=mp.get(i).getOrder_name()%></td>
							<td><%=mp.get(i).getNumber_of_request()%></td>
							<td style="display:none;"><%=mp.get(i).getType()%></td>
							<td style="display:none;"><%=mp.get(i).getM_no() %></td>
							
						</tr>
						<script>
							var tr = document.getElementById("tr");
							tr.id = "tr" +
						<%=mp.get(i).getM_no()%>
							;
						</script>
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
		<div class="panel panel-default border p2box col-md-6">
			<form id="insertformid">
				<div class="panel-heading" style="height: 60px;">
					<h5 class="panel-title" style="float: left; margin-top: 10px;">
						발주 요청</h5>
				</div>
				<div class="panel-body">
					<table style="border: 0; width: 98%; margin-left: 10px;">
						<thead>
							<th style="width: 33%;"></th>
							<th style="width: 33%;"></th>
							<th style="width: 33%;"></th>
						</thead>
						<tbody id="ordertbody">
							<tr>
								<td>발주요청 업체<span style="color: red;">*</span></td>
								<td>납품장소</td>
								<td>비고</td>
							</tr>
							<tr>
								<td><select id="ordercom" name="nordercom"
									class="form-control"
									style="width: 80%; margin-top: 10px; margin-bottom: 20px;">
									<option value="" selected="selected" hidden="hidden"></option>
										<%
										Vector<String> v2 = new Vector<String>();
										v2 = dbc.selectcomname();
										for (int i = 0; i < v2.size(); i++) {
										%>
										<option value="<%=v2.get(i)%>"><%=v2.get(i)%></option>
										<%
										}
										%>
								</select></td>
								<td><input type="text" id="place" name="nplace"
									class="form-control"
									style="width: 80%; margin-top: 10px; margin-bottom: 20px;"></td>
								<td><input type="text" id="note" name="nnote"
									class="form-control"
									style="width: 80%; margin-top: 10px; margin-bottom: 20px;"></td>
							</tr>
							<tr>
								<td>부품<span style="color: red;">*</span></td>
								<td>수량<span style="color: red;">*</span></td>
								<td>단가(원)<span style="color: red;">*</span></td>
							</tr>
						</tbody>
					</table>
				</div>
			<div class="buttongruops">
				<input class="btn btn-primary" type="button" value="발주서 출력"
					id="boardreset" onclick="exceldownload()" /> <input class="btn btn-primary" id="insert" type="button"
					value="저장" onclick="insertform(this.form)">
					<input class="btn btn-danger" type="button"
					value="삭제" onclick="deleteform(this.form)">
			</div>
			</form>
		</div>
	</div>
</body>
</html>