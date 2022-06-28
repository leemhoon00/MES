<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ page import="dbcon.dbcon"%>
<%@ page import="dbcon.manage_porderdb"%>
<%@ page import="java.util.Vector"%>
<%@ page import="dbcon.facilitiesdb"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<%
dbcon dbc = new dbcon();
Vector<String> fn = dbc.getfacilities_name();
//int lastpage = (mp.size() - 1) / 10 + 1;
Vector<facilitiesdb> fc = dbc.facilitiestable();
Vector<String> facilities_status = dbc.selectfacilities_status();
int lastpage = (fc.size()-1)/10 + 1;
Vector<String> code = dbc.getcode_sub();

//
String temp = (String)session.getAttribute("id");

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
<link rel="stylesheet" href="facilitiescheck.css?ver02">
<link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
        <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
<script>
var request = new XMLHttpRequest();
var hlastpage = "";
var paging = 1;
var now = new Date();
var year = now.getFullYear();
var month = now.getMonth() + 1;
var day = now.getDate();

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



function dateoption(){
	for(var i=-7; i<12; i++){
		if(i == 0){
			var oyear = year + i;
			var option = $('<option selected>' + oyear + "</option>")
			$('#year').append(option);
		}
		else{
			var oyear = year + i;
			var option = $('<option>' + oyear + "</option>")
			$('#year').append(option);
		}
	}	
	for(var i=1; i<=12; i++){
		if(i == month){
			var option = $('<option selected>' + i + '</option>');
			$('#month').append(option);
		}
		else{
			var option = $('<option>' + i + '</option>');
			$('#month').append(option);
		}
	}
}
var tbs = "";
var lastday = "";
var tableresult = "";
var contentresult = "";
var dateid = "";
var vyear = "";
var vmonth = "";

var wmonth = month;
var wday1 = day;
var wday2 = "";
var date1 = "";
var date2 = ""
if(month < 10){
	wmonth = "0" + month;
}
if(day < 10){
	wday1 = "0" + day;
}
if(day != 1){
	wday2 = day - 1;
	if(wday2 < 10){
		wday2 = "0" + (day-1);

	}
}
date1 = year + "-" + wmonth + "-" + wday1;
date2 = year + "-" + wmonth + "-" + wday2;
function uptable(){
	var wb = document.getElementById("writebutton");
	var cb = document.getElementById("commitbutton");
	wb.style.display = '';
	cb.style.display = 'none';
	var facilities_name = document.getElementById("facilities_name").value;
	vyear = document.getElementById("year").value;
	vmonth = document.getElementById("month").value;
	lastday = new Date(vyear, vmonth, 0).getDate();
	if(vmonth < 10){
		dateid = vyear + '-0' + vmonth;
	}
	else{
		dateid = vyear + '-' + vmonth;
	}
	var tablehead = document.getElementById("checkthead");
	var checktbody = document.getElementById("checktbody");
	var ths = '<th style="width:200px;">담당자/날짜</th>';
	for(var i=1; i<=lastday; i++){
		if(i < 10){
			var thdateid = dateid + '-0' + i;
			ths += '<th id="' + thdateid + '" style="text-align:center">' + vmonth + '/' + i + '</th>';
		}
		else{
			var thdateid = dateid + '-' + i;
			ths += '<th id="' + thdateid + '" style="text-align:center">' + vmonth + '/' + i + '</th>';
		}
	}
	
		
	tbs += '</tr>';
	tablehead.innerHTML = ths;
	checktbody.innerHTML = tbs;
	if(year == vyear && month == vmonth){
		if(day < 10){
			if(month < 10){
				var todayth = document.getElementById(year + '-0' + month + '-0' + day);
				todayth.style.color = 'blue';
			}
			else{
				var todayth = document.getElementById(year + '-' + month + '-0' + day);
				todayth.style.color = 'blue';
			}
		}
		else{
			if(month < 10){
				var todayth = document.getElementById(year + '-0' + month + '-' + day);
				todayth.style.color = 'blue';
			}
			else{
				var todayth = document.getElementById(year + '-' + month + '-' + day);
				todayth.style.color = 'blue';
			}
			
		}
		
	}
	request.open("Post", "../facilitieschecktable?facilities_name=" + facilities_name + "&year=" + vyear + "&month=" + vmonth + "&lastday=" + lastday, true);
	request.onreadystatechange = gettable;
	request.send(null);
}

function gettable(){
	if(request.readyState == 4 && request.status == 200){
		var object = eval('(' + request.responseText + ')');
		contentresult = object.contentresult;
		hlastpage = parseInt((contentresult.length-1)/10)+1
		tableresult = object.tableresult;
		tbs = '<tr><td>담당자</td>';
		for(var i=1; i<=lastday; i++){
			if(i < 10){
				var userid = 'user' + dateid + '-0' + i;
				tbs += '<td id="' + userid +'" style="text-align:center"></td>';
				
			}
			else{
				var userid = 'user' + dateid + '-' + i;
				tbs += '<td id="' + userid +'" style="text-align:center"></td>';
			}
		}
		for(var i=0; i<contentresult.length; i++){
			var resultpage = parseInt(i/10) + 1;
			tbs += '<tr name="page' + resultpage + '"><td>' + contentresult[i].value + '</td>';
			for(var j=1; j<=lastday; j++){
				if(j < 10){
					var contentid = contentresult[i].value + dateid + '-0' + j;
				}
				else{
					var contentid = contentresult[i].value + dateid + '-' + j;	
				}
				tbs += '<td id="' + contentid + '" style="text-align:center"></td>';
				
			}	
			tbs += '</tr>';
		}
		uladd(hlastpage);
		
		checktbody.innerHTML = tbs;
		var table = document.getElementById("writedaytable");
		var table2 = document.getElementById("writedayvaluetable");
		var table3 = document.getElementById("deletetable");
		table.innerHTML = '';
		table2.innerHTML = '';
		table3.innerHTML = '';
		for(var i=0; i<tableresult.length; i++){
			var contenttable = document.getElementById(tableresult[i][0].value + tableresult[i][2].value);
			var usertable = document.getElementById('user' + tableresult[i][2].value);	
			if(tableresult[i][2].value == date2 || tableresult[i][2].value == date2){
				var row = table.insertRow(table.rows.lenght);
				var row2 = table2.insertRow(table2.rows.lenght);
				var cell1 = row.insertCell(0);
				var cell2 = row2.insertCell(0);
				cell1.innerHTML = '<input type="text" name="selectup" value="' + tableresult[i][0].value + tableresult[i][2].value +'" style="display:none">';
				cell2.innerHTML = '<input type="text" id="u' + tableresult[i][0].value + tableresult[i][2].value + '" value="' + tableresult[i][3].value + '" style="display:none">';
			}
			if(tableresult[i][3].value == 1){
				contenttable.innerHTML = '<label style="font-size:20pt">&#9675</label><input type="text" id="t' + tableresult[i][0].value + tableresult[i][2].value +'" value="1"  style="display:none">'+
				'<br><input type="button" value="삭제" id="b' + tableresult[i][0].value + tableresult[i][2].value + '" name="dbutton" onclick="deletecheck(this)" style="display:none;">'+
				'<input type="text" id="d' + tableresult[i][0].value + tableresult[i][2].value + '" value="' + tableresult[i][4].value + '" style="display:none;">';
			}
			if(tableresult[i][3].value == 2){
				contenttable.innerHTML = '<label style="font-size:15pt">&#9651</label><input type="text" id="t' + tableresult[i][0].value + tableresult[i][2].value +'" value="2"  style="display:none">'+
				'<br><input type="button" value="삭제" id="b' + tableresult[i][0].value + tableresult[i][2].value + '" name="dbutton" onclick="deletecheck(this)" style="display:none;">'+
				'<input type="text" id="d' + tableresult[i][0].value + tableresult[i][2].value + '" value="' + tableresult[i][4].value + '" style="display:none;">';
			}
			if(tableresult[i][3].value == 3){
				contenttable.innerHTML = '<label style="font-size:15pt">&#9747</label><input type="text" id="t' + tableresult[i][0].value + tableresult[i][2].value +'" value="3"  style="display:none">'+
				'<br><input type="button" value="삭제" id="b' + tableresult[i][0].value + tableresult[i][2].value + '" name="dbutton" onclick="deletecheck(this)" style="display:none;">'+
				'<input type="text" id="d' + tableresult[i][0].value + tableresult[i][2].value + '" value="' + tableresult[i][4].value + '" style="display:none;">';
			}
			usertable.innerHTML = tableresult[i][1].value;
			
		}
		pagenation(1);
		paging = 1;
	}
}

function writeevent(){
	var delbutton = document.getElementsByName("dbutton");
	for(var i=0; i<delbutton.length; i++){
		delbutton[i].style.display = '';
	}
	var wb = document.getElementById("writebutton");
	var cb = document.getElementById("commitbutton");
	wb.style.display = 'none';
	cb.style.display = '';
	if(year==vyear && month == vmonth){
		var usercheck = document.getElementById('user' + date1);
		for(var i=0; i<contentresult.length; i++){
			if(day == 1){
				usercheck.innerHTML = '<%=temp%>';
				var contenttd = document.getElementById(contentresult[i].value + date1);
				contenttd.innerHTML = '<select id="s' + contentresult[i].value + date1 +'" name="insertselect" class="form-control" style="font-size:20px; text-align:center">' +
				'<option value="1">&#9675</option><option value="2">&#9651</option><option value="3">&#9747</option></select>' + 
				'<input type="button" value="삭제" id="b' + contentresult[i].value + date1 + '" name="dbutton" onclick="deletecheck2(this)" style="width:30%">'
			}
			else{
				var usercheck2 = document.getElementById('user' + date2);
				usercheck.innerHTML = '<%=temp%>';
				usercheck2.innerHTML = '<%=temp%>';
				var contenttd = document.getElementById(contentresult[i].value + date1);
				contenttd.innerHTML = '<select id="s' + contentresult[i].value + date1 +'" name="insertselect" class="form-control" style="font-size:20px; text-align:center">' +
				'<option value="1">&#9675</option><option value="2">&#9651</option><option value="3">&#9747</option></select>' + 
				'<input type="button" value="삭제" id="b' + contentresult[i].value + date1 + '" name="dbutton" onclick="deletecheck2(this)" style="width:30%">';
				var contenttd2 = document.getElementById(contentresult[i].value + date2);
				contenttd2.innerHTML = '<select id="s' + contentresult[i].value + date2 +'" name="insertselect" class="form-control" style="font-size:20px; text-align:center">' +
				'<option value="1">&#9675</option><option value="2">&#9651</option><option value="3">&#9747</option></select>' + 
				'<input type="button" value="삭제" id="b' + contentresult[i].value + date2 + '" name="dbutton" onclick="deletecheck2(this)" style="width:30%">';
				
			}
		}
	}
	var selectup = document.getElementsByName("selectup");
	for(var i=0; i<selectup.length; i++){
		document.getElementById("s" + selectup[i].value).value = document.getElementById("u" + selectup[i].value).value;
	}
}

function deletecheck(obj){
	var tdid = obj.parentElement.id;
	var dtext = document.getElementById("d" + tdid);
	document.getElementById(tdid).innerHTML = '';
	var table = document.getElementById("deletetable");
	var row = table.insertRow(table.rows.lenght);
	var cell1 = row.insertCell(0);
	cell1.innerHTML = '<input type="text" name="deletenum" value="' + dtext.value +'">';
}

function deletecheck2(obj){
	var tdid = obj.parentElement.id;
	document.getElementById(tdid).innerHTML = '';
	
}

function commitevent(frm){
	var table = document.getElementById("inserttable");
	var datetabee = document.getElementById("datetable");
	var insertselect = document.getElementsByName("insertselect");
	for(var i=0; i<insertselect.length; i++){
		var row = table.insertRow(table.rows.length);
		var cell1 = row.insertCell(0);
		var cell2 = row.insertCell(1);	
		var tdid = insertselect[i].parentElement.id;
		var value = insertselect[i].value;
		cell1.innerHTML = '<input type="text" name="ctdate" value="' + tdid + '" style="display:none">'
		cell2.innerHTML = '<input type="text" name="status" value="' + value + '" style="display:none">'
		
	}
	var row = datetable.insertRow(datetable.rows.length);
	var cell1 = row.insertCell(0);
	var cell2 = row.insertCell(1);
	cell1.innerHTML = '<input type="text" name="date1" value="' + date1 +'" style="display:none">';
	cell2.innerHTML = '<input type="text" name="date2" value="' + date2 +'" style="display:none">';
	frm.action = './insertfacilitiescheck.jsp';
	frm.submit();
	
}




</script>
</head>
<body>
	<div class="title">설비 관리 / 설비일상점검</div>
	<form>
	<div class="panel panel-default border searchbox">
		<div class="panel-body">
			설비명&nbsp;&nbsp;&nbsp;
			<select id="facilities_name" name="nfacilities_name" class="form-control searchtitle" style="width:15%">
			<option value="" selected disabled hidden><option>
			<%for(int i=0; i<fn.size(); i++){
				%>
				<option><%=fn.get(i) %></option>
				<%
			}
				%>
			</select>
			&nbsp;&nbsp;&nbsp; 날짜:
			<select id="year" name="nyear" class="form-control searchtitle" style="width:5%;"></select>
			<select id="month" name="nmonth" class="form-control searchtitle" style="width:4%;"></select>
			<script>
			dateoption();
			</script>
			&nbsp;&nbsp;&nbsp;<input class="btn btn-primary" type="button" value="선택" onclick="uptable()"> 
		</div>
	</div>
	<div class="row">
		<div class="panel panel-default border boardlistbox col-md-6">
			<div class="panel-heading" style="height: 60px;">
				<div style="height: 40px;">
					<h5 class="panel-title" style="float: left; margin-top: 10px;">설비일상점검 항목</h5>
					&nbsp;&nbsp;&nbsp;<input class="btn btn-primary" id="writebutton" type="button" value="작성" style="margin-top:2px;" onclick="writeevent(this)"> 
					<input class="btn btn-primary" type="button" id="commitbutton" value="저장" style="margin-top:2px; display:none" onclick="commitevent(this.form)">
				</div>
			</div>
			<div class="panel-body">
				<div style="overflow-x:scroll;">
				<table class="table table-bordered table-hover" id="checktable" style="width:5000px; max-width:none; table-layout:fixed;">
					<thead class="tablehead" id ="checkthead">
						
					</thead>
					<tbody id="checktbody">
						
					</tbody>
				</table>
				
				</div>
				<ul class="pagination justify-content-end" id="pageul">

				</ul>	
				<script>
				uptable();

				</script>	
			</div>
		</div>
	</div>
	<table>
		<tbody id="deletetable" style="display:none">
		
		</tbody>
	</table>
	<table>
		<tbody id="writedaytable" style="display:none">
			
		</tbody>
	</table>
	<table>
		<tbody id="writedayvaluetable" style="display:none">
		
		</tbody>
	</table>
	<table>
		<tbody id="inserttable">
		
		</tbody>
	</table>
	<table>
		<tbody id="datetable">
		
		</tbody>
	</table>
	</form>
</body>
</html>