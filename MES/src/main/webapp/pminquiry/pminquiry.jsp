<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ page import="dbcon.dbcon"%>
<%@ page import="dbcon.pmdb"%>
<%@ page import="java.util.Vector"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<%
dbcon dbc = new dbcon();
Vector<pmdb> pm = dbc.pmtable();
Vector<String> selecttype = dbc.selecttype();
int lastpage = (pm.size() - 1) / 10 + 1;
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
<link rel="stylesheet" href="pminquirycss.css?ver02">
<link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
        <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
<style>
.select2-container .select2-selection--single{
	margin-top:0px;
	height:33px;
	padding:0px;
	position : relative;
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
		var type = td.eq(1).text();
		var pm_name = td.eq(2).text();
		var stock = td.eq(3).text();
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
			cell1.innerHTML = '<input type="text" name="npart_name" value="'
					+ pm_name
					+ '" class="form-control" readonly style="width:80%; margin-top:10px;">';
			cell2.innerHTML = '<input type="number" name="nnor" '
					+ '" class="form-control" style="width:80%; margin-top:10px;">';
			cell3.innerHTML = '<input type="number" name="nprice" value="' + stock + '" class="form-control" style="width:80%; margin-top:10px;">';
			cell4.innerHTML = '<input type="text" name="ntype" value="'+ type +'" class="form-control" style="display:none;">';

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
		var searchtype = document.getElementById("searchtype").value;
		var searchpmname = document.getElementById("searchpmname").value;
		var safetycheck = document.getElementById("safetycheck");
		var check = 0;
		if(safetycheck.checked == true){
			check = 1;
		}
		else{
			check = 0;
		}
		request.open("Post", "../searchpm?searchtype=" + searchtype + "&searchpmname=" + searchpmname +"&check=" + check, true);
		request.onreadystatechange = searchmanage_porder;
		request.send(null);
	}

	function searchmanage_porder() {
		var pmtable = document.getElementById("pmtbody");
		var resultpage = 0;
		if (request.readyState == 4 && request.status == 200) {
			pmtable.innerHTML = "";
			var object = eval('(' + request.responseText + ')');
			var result = object.result;
			for (var i = 0; i < result.length; i++) {
				var row = pmtable.insertRow(pmtable.rows.length);
				var resultpage = parseInt(i / 10) + 1;
				$(row).attr('name', 'page' + resultpage);
				$(row).attr('id', 'tr' + result[i][1].value);
				var cell = row.insertCell(0);
				var checkarrtf = 0;

				for (var k = 0; k < checkarr.length; k++) {
					if (checkarr[k] == result[i][1].value) {
						cell.innerHTML = '<input type="checkbox" id="'
								+ result[i][1].value
								+ '" checked onclick="checkboxclick(this)">';
						changecolor(result[i][1].value);
						checkarrtf = 1;
						break;
					}
				}
				if (checkarrtf == 0) {
					cell.innerHTML = '<input type="checkbox" id="'
							+ result[i][1].value
							+ '"onclick="checkboxclick(this)">';
				}
				for (var j = 1; j <= result[i].length; j++) {
					var cell = row.insertCell(j);
					cell.innerHTML = result[i][j - 1].value;
				}
				if(result[i][3].value - result[i][4].value < 0){
					row.style.color = 'red';
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
			alert("확인");
			check = 1;
		}
		if(check == 0 && partname.length == 0){
			alert("확인");
			check = 1;
		}
		if(check == 0 && nor.length == 0){
			alert("확인");
			check = 1;
		} 
		if(check == 0 && price.length == 0){
			alert("확인");
			check = 1;
		}
		for(var i=0; i<partname.length; i++){
			if(check == 0 && partname[i].value == ""){
				alert("확인");
				check = 1;
				break;
			}	
		}
		for(var i=0; i<nor.length; i++){
			if(check == 0 && nor[i].value == ""){
				alert("확인");
				check = 1;
				break;
			}	
		}
		for(var i=0; i<price.length; i++){
			if(check == 0 && price[i].value == ""){
				alert("확인");
				check = 1;
				break;
			}	
		}
		if(check == 0){
			frm.action='./insertplace_order.jsp';
			frm.submit();
		}
	}
	$(document).ready(function() {
        $('select[id="ordercom"]').select2();
        $('select[id="ordercom"]').val("").select2();
    });
</script>
</head>
<body>
	<div class="title">자재현황조회</div>
	<div class="panel panel-default border searchbox">
		<div class="panel-body">
			유형:&nbsp;<select id="searchtype" name="nsearchtype"
				class="form-control searchtitle" onchange="search()">
				<option value="전체" selected="selected">전체</option>
				<option>자재</option>
				<%
				for (int i = 0; i < selecttype.size(); i++) {
				%>
				<option><%=selecttype.get(i)%></option>
				<%
				}
				%>
			</select>
		
			&nbsp; 자재명:&nbsp;<input type="text" id="searchpmname"
				name="nsearchpmname" class="form-control searchtitle"
				onkeyup="if(window.event.keyCode == 13){search()}">
			&nbsp;&nbsp;안전재고수량 <input type="checkbox" id="safetycheck"
				onclick="search()">
		</div>
	</div>
	<div class="row">
		<div class="panel panel-default border p1box col-md-6">
			<div class="panel-heading" style="height: 60px;">
				<div style="height: 40px;">
					<h5 class="panel-title" style="float: left; margin-top: 10px;">자재
						현황 조회</h5>
					<div class="warningbox" style="float: right;">
						<div class="warningredbox" style="display: table-cell;"></div>
						<div class="warningboxexp"style="display: table-cell; background: white;">
							<h4 style="font-weight: bold; margin: 10px;">재고부족</h4>
						</div>
					</div>
				</div>
			</div>
			<div class="panel-body">
				<table class="table table-bordered table-hover" id="pmtable">
					<thead class="tablehead">
						<th style="width: 10%;"></th>
						<th style="width: 18%;">유형</th>
						<th style="width: 18%;">자재명</th>
						<th style="width: 18%;">단가(원)</th>
						<th style="width: 18%;">수량</th>
						<th style="width: 18%;">안전재고수량</th>
					</thead>
					<tbody id="pmtbody">
						<%
						System.out.println(pm.get(0).getStock());
						for (int i = 0; i < pm.size(); i++) {
							int pageid = i / 10 + 1;
							int stock = Integer.parseInt(pm.get(i).getStock());
							int safes = Integer.parseInt(pm.get(i).getSafety_stock());
							int changecolorcheck = 0;
							if(stock < safes){
								changecolorcheck = 1;
							}
						%>
						<tr id="tr" name="page<%=pageid%>">
							<td><input type="checkbox" id="<%=pm.get(i).getPm_name()%>"
								onclick="checkboxclick(this)"></td>
							<td><%=pm.get(i).getType()%></td>
							<td><%=pm.get(i).getPm_name()%></td>
							<td><%=pm.get(i).getPrice()%></td>
							<td><%=pm.get(i).getStock()%></td>
							<td><%=pm.get(i).getSafety_stock()%></td>
						</tr>
						<script>
							var tr = document.getElementById("tr");
							tr.id = "tr" + "<%=pm.get(i).getPm_name()%>";
							<%if(changecolorcheck == 1){%>
							tr.style.color = 'red';
							<%}%>
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
					<input class="btn btn-primary" id="insert" type="button"
						value="발주 요청" onclick="insertform(this.form)">
				</div>
			</form>
		</div>
	</div>
</body>
</html>