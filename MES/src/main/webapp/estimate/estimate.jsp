<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ page import="dbcon.dbcon"%>
<%@ page import="dbcon.estimatedb"%>
<%@ page import="java.util.Vector"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import = "java.text.DecimalFormat"%>
<%@ page import = "java.text.NumberFormat"%>
<%@ page import = "java.util.Locale"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<%
dbcon dbc = new dbcon();
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
<link rel="stylesheet" href="estimatecss.css?ver03">
<link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
        <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.15.5/xlsx.full.min.js"></script>
<style>
.select2-container .select2-selection--single{
	height:33px;
	position:relative;
}

</style>
<script>
var cellstring = "";
var request = new XMLHttpRequest();
var materialcnt = 1;
var processcnt = 1;
var othercnt = 1;
var paging = 1;
var mode = 0;
<%int materialcnt = 1;
int processcnt = 1;
int othercnt = 1;
Vector<String> mv = new Vector<String>();
Vector<String> pv = new Vector<String>();
mv = dbc.selectmaterialname();
pv = dbc.selectprocname();
Vector<estimatedb> v = new Vector<estimatedb>();
v = dbc.estimatetable();
Vector<estimatedb> degreev = dbc.degreetable();
Vector<String> selectother = dbc.selectother();
int degreelastpage = (degreev.size()-1)/10 + 1;
int lastpage = (v.size()-1)/10 + 1;
%>
var hlastpage = <%=degreelastpage%>;

function comma(str) {
    str = String(str);
    return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
}
function uncomma(str) {
    str = String(str);
    return str.replace(/[^\d]+/g, '');
}
$(document).on("keyup", "input[name='net_price']", function(e) {
	   $(this).val( $(this).val().replace(/[^0-9-]/gi,"") );
	   
	   $(this).val(comma($(this).val()));
	});
$(function(){
    $("#estitabletbody tr").click(function(){
    	var tr = $(this);
    	var td = tr.children();
    	var et_id = td.eq(0).text();
    	var degree = td.eq(1).text();
        $("#et_id").val(td.eq(0).text());
        $("#et_degree").val(td.eq(1).text());
    	$("#et_com_name").val(td.eq(2).text()).select2();
    	$("#et_price").val(td.eq(3).text());
    	var str = td.eq(5).text();
    	str = str.replaceAll('!@#', '\n');
    	document.getElementById('et_explain').value = str;
    	request.open("Post", "../estimatesearchajax?et_id="+ et_id +"&degree=" + degree, true);
    	request.onreadystatechange = searchestimate; 
    	request.send(null);
    	
    });
});


function searchestimate(){
	var materialtable = document.getElementById("estimatetbody");
	var proc_costtable = document.getElementById("estimatetbody2");
	var other_costtable = document.getElementById("estimatetbody3");
	materialtable.innerHTML = "";
	proc_costtable.innerHTML = "";
	other_costtable.innerHTML = "";
	if(request.readyState == 4 && request.status == 200){
		var object = eval('(' + request.responseText + ')');
		var materialresult = object.materialresult;
		var proc_costresult = object.proc_costresult;
		var other_costresult = object.other_costresult;
		for(var i=0; i < materialresult.length; i++){
			var materialrow = materialtable.insertRow(0);
			var cell1 = materialrow.insertCell(0);
			var cell2 = materialrow.insertCell(1);
			var cell3 = materialrow.insertCell(2);
			cell1.innerHTML ='<td>'+
			'	<select id="material_name' + materialcnt +'" value='+ materialresult[i][0].value +' name="nmaterial_name" class="form-control" style="width: 70%; margin-top:10px;">'+
			'</td>';
			cell2.innerHTML ='<td>'+
			'	<input type="number" id="material_no" value='+ materialresult[i][1].value + ' name="nmaterial_no" class="form-control" style="width:30%; margin-top:3px;">'+
			'</td>';
			cell3.innerHTML ='<td>'+
			'	<input class="btn btn-danger" type="submit" value="삭제" style="margin-top:3px;" onclick="selectdel(this);">'+
			'</td>';
			<%for (int i = 0; i < mv.size(); i++) {
			String s = "<option>" + mv.get(i) + "</option>";%>
				$("#material_name" + materialcnt).append('<%=s%>');
		    <%}
			materialcnt++;%>				
			$("#material_name" + materialcnt).val(materialresult[i][0].value);
			materialcnt++;
		}
		$(document).ready(function() {
		    $('select[name="nmaterial_name"]').select2();
		});
		
		
		for(var i=0; i < proc_costresult.length; i++){
			var proc_costrow = proc_costtable.insertRow(0);
			var cell1 = proc_costrow.insertCell(0);
			var cell2 = proc_costrow.insertCell(1);
			var cell3 = proc_costrow.insertCell(2);
			var cell4 = proc_costrow.insertCell(3);
			var cell5 = proc_costrow.insertCell(4);
			var cell6 = proc_costrow.insertCell(5);
			cell1.innerHTML ='<td>'+
			'	<select id="standard_proc' + processcnt + '" value=' + proc_costresult[i][0].value + ' name="nstandard_proc" class="form-control" style="width: 70%; margin-top:10px;">'+
			'</td>';
			cell2.innerHTML ='<td>'+
			'	<input type="date" id="proc_startday" value='+ proc_costresult[i][1].value + ' name="nproc_startday" class="form-control" style="width:80%; margin-top:3px;">'+
			'</td>';
			cell3.innerHTML ='<td>'+
			'	<input type="date" id="proc_endday" value='+ proc_costresult[i][2].value + ' name="nproc_endday" class="form-control" style="width:80%; margin-top:3px;">'+
			'</td>';
			cell4.innerHTML ='<td>'+
			'	<input type="number" id="md" value=' + proc_costresult[i][3].value + ' name="nmd" class="form-control" style="width:60%; margin-top:3px;">'+
			'</td>';
			cell5.innerHTML ='<td>'+
			'	<input type="number" id="cost" value=' + proc_costresult[i][4].value + ' name="ncost" class="form-control" style="width:60%; margin-top:3px;">'+
			'</td>';
			cell6.innerHTML ='<td>'+
			'	<input class="btn btn-danger" type="submit" value="삭제" style="margin-top:3px;" onclick="selectdel(this);">'+
			'</td>';
			<%for (int i = 0; i < pv.size(); i++) {
			String s = "<option>" + pv.get(i) + "</option>";%>
				$("#standard_proc" + processcnt).append('<%=s%>');
			<%}
			processcnt++;%>
			$("#standard_proc" + processcnt).val(proc_costresult[i][0].value);
			processcnt++;
		}
		$(document).ready(function() {
		    $('select[name="nstandard_proc"]').select2();
		});
		
		for(var i=0; i < other_costresult.length; i++){
			var other_costrow = other_costtable.insertRow(0);
			var cell1= other_costrow.insertCell(0);
			var cell2 = other_costrow.insertCell(1);
			var cell3 = other_costrow.insertCell(2);
			cell1.innerHTML ='<td>'+
			'	<select id="other_et_id' + othercnt + '" value=' + other_costresult[i][0].value + ' name="nother_et_id" class="form-control" style="width: 70%; margin-top:10px;">'+
			'</td>';
			cell2.innerHTML ='<td>'+
			'	<input type="number" id="other_cost" value=' + other_costresult[i][1].value + ' name="nother_cost" class="form-control" style="width:70%; margin-top:3px;">'+
			'</td>';
			cell3.innerHTML ='<td>'+
			'	<input class="btn btn-danger" type="submit" value="삭제" style="margin-top:3px;" onclick="selectdel(this);">'+
			'</td>';
			<%for(int i=0; i<selectother.size(); i++){
				String s = "<option>" + selectother.get(i) + "</option>";%>	
				$("#other_et_id" + othercnt).append('<%=s%>');
			<%}
			othercnt++;%>
			$("#other_et_id" + othercnt).val(other_costresult[i][0].value);
			othercnt++	;
		}
		$(document).ready(function() {
		    $('select[name="nother_et"]').select2()
		});
	}
}

function searchet_idevent(dates){
	var searchword = document.getElementById("searchet_id").value;
	alert(dates);
	request.open("Post", "../searchtableajax?searchword=" + searchword  +"&mode=" + mode, true);
	request.onreadystatechange = searchestimatetable;
	request.send(null);
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

function searchestimatetable(){
	var estitable = document.getElementById("estitabletbody");
	var resultpage = 0;
	if(request.readyState == 4 && request.status == 200){
		estitable.innerHTML = "";
		var object = eval('(' + request.responseText + ')');
		var result = object.result;
		for(var i=0; i<result.length; i++){
			var row = estitable.insertRow(estitable.rows.length);
			var resultpage = parseInt(i/10) + 1;
			$(row).attr('name', 'page' + resultpage);
			for(var j=0; j < result[i].length; j++){				
				var cell = row.insertCell(j);
				if(j == 5){
					cell.innerHTML = result[i][j].value;
					cell.style.display = 'none';
				}
				else{
					cell.innerHTML = result[i][j].value;
				}
			}
		}
		hlastpage = parseInt((result.length-1)/10)+1
		uladd(hlastpage);
		pagenation(1);
		paging = 1;
	}
	$(function(){
	    $("#estitabletbody tr").click(function(){
	    	var tr = $(this);
	    	var td = tr.children();
	    	var et_id = td.eq(0).text();
	    	var degree = td.eq(1).text();
	        $("#et_id").val(td.eq(0).text());
	        $("#et_degree").val(td.eq(1).text());
	    	$("#et_com_name").val(td.eq(2).text());
	    	$("#et_price").val(td.eq(3).text());
	    	var str = td.eq(5).text();
	    	str = str.replaceAll('!@#', '\n');
	    	document.getElementById('et_explain').value = str;
	    	request.open("Post", "../estimatesearchajax?et_id="+ et_id +"&degree=" + degree, true);
	    	request.onreadystatechange = searchestimate;
	    	request.send(null);
	    });
	});
	
}

function degreeclick(){
	var estitable = document.getElementById("estitabletbody");
	estitable.innerHTML = "";
	<% for(int i=0; i<v.size(); i++){
		int degreepage = i/10+1;
		%>
		var row = estitable.insertRow(estitable.rows.length);
		$(row).attr('name', 'page' + <%=degreepage%>);
		row.style.display = "none"; 
		var cell1 = row.insertCell(0);
		var cell2 = row.insertCell(1);
		var cell3 = row.insertCell(2);
		var cell4 = row.insertCell(3);
		var cell5 = row.insertCell(4);
		var cell6 = row.insertCell(5);
		
		
		cell1.innerHTML = '<%=v.get(i).getEt_id()%>';
		cell2.innerHTML = '<%=v.get(i).getDegree()%>';
		cell3.innerHTML = '<%=v.get(i).getEt_com_name()%>';
		cell4.innerHTML = '<%=v.get(i).getEt_price()%>';
		cell5.innerHTML = '<%=v.get(i).getEt_date()%>';
		cell6.innerHTML = '<%=v.get(i).getEt_explain()%>';
		cell6.className = "nonetd";
	<%}%>
	document.getElementById("on").style.display = 'none';
	document.getElementById("off").style.display = "";
	
	mode = 1;
	paging = 1;
	
	
	$(function(){
	    $("#estitabletbody tr").click(function(){
	    	var tr = $(this);
	    	var td = tr.children();
	    	var et_id = td.eq(0).text();
	    	var degree = td.eq(1).text();
	        $("#et_id").val(td.eq(0).text());
	        $("#et_degree").val(td.eq(1).text());
	    	$("#et_com_name").val(td.eq(2).text());
	    	$("#et_price").val(td.eq(3).text());
	    	var str = td.eq(5).text();
	    	str = str.replaceAll('!@#', '\n');
	    	document.getElementById('et_explain').value = str;
	    	request.open("Post", "../estimatesearchajax?et_id="+ et_id +"&degree=" + degree, true);
	    	request.onreadystatechange = searchestimate;
	    	request.send(null);
	    });
	});
	hlastpage = <%=lastpage%>;
	uladd(hlastpage);
	pagenation(1);
}


function degreeclickoff(){
	var estitable = document.getElementById("estitabletbody");
	estitable.innerHTML = "";
	<% for(int i=0; i<degreev.size(); i++){
		int pageid = i/10+1;
		%>
		var row = estitable.insertRow(estitable.rows.lenght);
		$(row).attr('name', 'page' + <%=pageid%>);
		row.style.display = "none";
		var cell1 = row.insertCell(0);
		var cell2 = row.insertCell(1);
		var cell3 = row.insertCell(2);
		var cell4 = row.insertCell(3);
		var cell5 = row.insertCell(4);
		var cell6 = row.insertCell(5);
		
		cell1.innerHTML = '<%=degreev.get(i).getEt_id()%>';
		cell2.innerHTML = '<%=degreev.get(i).getDegree()%>';
		cell3.innerHTML = '<%=degreev.get(i).getEt_com_name()%>';
		cell4.innerHTML = '<%=degreev.get(i).getEt_price()%>';
		cell5.innerHTML = '<%=degreev.get(i).getEt_date()%>';
		cell6.innerHTML = '<%=degreev.get(i).getEt_explain()%>';
		cell6.className = "nonetd";
	<%}%>
	document.getElementById("on").style.display = "";
	document.getElementById("off").style.display = 'none';
	
	mode = 0;
	hlastpage = <%=degreelastpage%>;
	uladd(hlastpage);
	paging = 1;
	
	
	
	$(function(){
	    $("#estitabletbody tr").click(function(){
	    	var tr = $(this);
	    	var td = tr.children();
	    	var et_id = td.eq(0).text();
	    	var degree = td.eq(1).text();
	        $("#et_id").val(td.eq(0).text());
	        $("#et_degree").val(td.eq(1).text());
	    	$("#et_com_name").val(td.eq(2).text());
	    	$("#et_price").val(td.eq(3).text());
	    	var str = td.eq(5).text();
	    	str = str.replaceAll('!@#', '\n');
	    	document.getElementById('et_explain').value = str;
	    	request.open("Post", "../estimatesearchajax?et_id="+ et_id +"&degree=" + degree, true);
	    	request.onreadystatechange = searchestimate;
	    	request.send(null);
	    });
	});
	pagenation(1);
}


$(document).ready(function(){
	  
	  $('ul.nav-tabs li').click(function(){
	    var tab_id = $(this).attr('data-tab');

	    $('ul.nav-tabs li').removeClass('current');
	    $('.tab-content').removeClass('current');
	    
	    $('ul.nav-tabs li').removeClass('active');

	    $(this).addClass('active');
	    $("#"+tab_id).addClass('current');
	  })

	})

function addrow1(){
	var tabledata = document.getElementById('estimatetbody');
	var row = tabledata.insertRow(tabledata.rows.lenght);
	var cell1 = row.insertCell(0);
	var cell2 = row.insertCell(1);
	var cell3 = row.insertCell(2);
	cell1.innerHTML ='<td>'+
	'	<select id="material_name' + materialcnt +'" name="nmaterial_name"class="form-control" style="width:70%; margin-top:10px;">'+
	'</td>';
	cell2.innerHTML ='<td>'+
	'	<input type="number" id="material_no" name="nmaterial_no" class="form-control" style="width:30%; margin-top:3px;">'+
	'</td>';
	cell3.innerHTML ='<td>'+
	'	<input class="btn btn-danger" type="submit" value="삭제" style="margin-top:3px;" onclick="selectdel(this);">'+
	'</td>';
	<%for (int i = 0; i < mv.size(); i++) {
	String s = "<option>" + mv.get(i) + "</option>";%>
			$("#material_name" + materialcnt).append('<%=s%>');
	<%}
	materialcnt++;%>			
	$('select[id="material_name'+ materialcnt + '"]').select2();
	$('select[id="material_name'+ materialcnt + '"]').val("").select2();																												
	materialcnt++;
}

function addrow2(){
	var tabledata = document.getElementById('estimatetbody2');
	var row = tabledata.insertRow(tabledata.rows.lenght);
	var cell1 = row.insertCell(0);
	var cell2 = row.insertCell(1);
	var cell3 = row.insertCell(2);
	var cell4 = row.insertCell(3);
	var cell5 = row.insertCell(4);
	var cell6 = row.insertCell(5);
	cell1.innerHTML ='<td>'+
	'	<select id="standard_proc' + processcnt + '" class="form-control" name="nstandard_proc" style="width: 70%; margin-top:10px;">'+
	'</td>';
	cell2.innerHTML ='<td>'+
	'	<input type="date" id="proc_startday" name="nproc_startday" class="form-control" style="width:80%; margin-top:3px;">'+
	'</td>';
	cell3.innerHTML ='<td>'+
	'	<input type="date" id="proc_endday" name="nproc_endday" class="form-control" style="width:80%; margin-top:3px;">'+
	'</td>';
	cell4.innerHTML ='<td>'+
	'	<input type="number" id="md" name="nmd" class="form-control" style="width:60%; margin-top:3px;">'+
	'</td>';
	cell5.innerHTML ='<td>'+
	'	<input type="number" id="cost" name="ncost" class="form-control" style="width:60%; margin-top:3px;">'+
	'</td>';
	cell6.innerHTML ='<td>'+
	'	<input class="btn btn-danger" type="submit" value="삭제" style="margin-top:3px;" onclick="selectdel(this);">'+
	'</td>';
	<%for (int i=0; i<pv.size(); i++) {
		String s = "<option>" + pv.get(i) + "</option>";%>
		$("#standard_proc" + processcnt).append('<%=s%>');
	<%}
	processcnt++;%>
	$('select[id="standard_proc'+processcnt+'"]').select2();
	$('select[id="standard_proc'+processcnt+'"]').val("").select2();
	processcnt++;
}

function addrow3(){
	var tabledata = document.getElementById('estimatetbody3');
	var row = tabledata.insertRow(tabledata.rows.lenght);
	var cell1 = row.insertCell(0);
	var cell2 = row.insertCell(1);
	var cell3 = row.insertCell(2);
	cell1.innerHTML ='<td>'+
	'	<select id="other_et_id' + othercnt + '" class="form-control" name="nother_et_id" style="width: 70%; margin-top:10px;">'+
	'</td>';
	cell2.innerHTML ='<td>'+
	'	<input type="number" id="other_cost" name="nother_cost" class="form-control" style="width:70%; margin-top:3px;">'+
	'</td>';
	cell3.innerHTML ='<td>'+
	'	<input class="btn btn-danger" type="submit" value="삭제" style="margin-top:3px;" onclick="selectdel(this);">'+
	'</td>';
	<%for(int i=0; i<selectother.size(); i++){
		String s = "<option>" + selectother.get(i) + "</option>";%>	
		$("#other_et_id" + othercnt).append('<%=s%>');
	<%}
	othercnt++;%>
	$('select[id="other_et_id'+othercnt+'"]').select2();
	$('select[id="other_et_id'+othercnt+'"]').val("").select2();
	othercnt++;
}

function alldel(rownum){
	$('#estimatetable > tbody').empty();
}

function alldel2(rownum){
	$('#estimatetable2 > tbody').empty();
}

function alldel3(rownum){
	$('#estimatetable3 > tbody').empty();
}

function delrow(){
	var tabledata = document.getElementById('estimatetbody');	
	var newrow = tabledata.deleteRow(rownum)
}

function selectdel(obj){
	var tr = obj.parentNode.parentNode;
	tr.parentNode.removeChild(tr);
	var td = tr.children();
}

function insertform(frm){
	var et_com_name = document.getElementById('et_com_name');
	var et_price = document.getElementById("et_price");
	var material_no = document.getElementsByName('nmaterial_no');
	var material_name = document.getElementsByName('nmaterial_name');
	var standard_proc = document.getElementsByName('nstandard_proc');
	var proc_startday = document.getElementsByName('nproc_startday');
	var proc_endday = document.getElementsByName('nproc_endday');
	var md = document.getElementsByName('nmd');
	var cost = document.getElementsByName('ncost');
	var other_et_id = document.getElementsByName('nother_et_id');
	var other_cost = document.getElementsByName('nother_cost');
	
	var check = 0;
	if (check == 0 && et_com_name.value== ""){	
		alert("필수값을 입력하세요.");
		check = 1;
	}
	if (check == 0 && et_price.value == ""){
		alert("필수값을 입력하세요.");
		check = 1;
	}
	for(var i=0; i<material_no.length; i++){
		if(check == 0 && material_no[i].value == ""){
			alert("필수값을 입력하세요.");
			check = 1;
			break;
		}	
	}
	for(var i=0; i<material_name.length; i++){
		if(check == 0 && material_name[i].value == ""){
			alert("필수값을 입력하세요.");
			check = 1;
			break;
		}
	}
	for(var i=0; i<standard_proc.length; i++){
		if(check == 0 && standard_proc[i].value == ""){
			alert("필수값을 입력하세요.");
			check = 1;
			break;
		}
	}
	for(var i=0; i<proc_startday.length; i++){
		if(check == 0 && proc_startday[i].value == ""){
			alert("필수값을 입력하세요.");
			check = 1;
			break;
		}
	}
	for(var i=0; i<proc_endday.length; i++){
		if(check == 0 && proc_endday[i].value == ""){
			alert("필수값을 입력하세요.");
			check = 1;
			break;
		}
	}
	for(var i=0; i<md.length; i++){
		if(check == 0 && md[i].value == ""){
			alert("필수값을 입력하세요.");
			check = 1;
			break;
		}
	}
	for(var i=0; i<cost.length; i++){
		if(check == 0 && cost[i].value == ""){
			alert("필수값을 입력하세요.");
			check = 1;
			break;
		}
	}
	for(var i=0; i<other_et_id.length; i++){
		if(check == 0 && other_et_id[i].value == ""){
			alert("필수값을 입력하세요.");
			check = 1;
			break;
		}
	}
	for(var i=0; i<other_cost.length; i++){
		if(check == 0 && other_cost[i].value == ""){
			alert("필수값을 입력하세요.");
			check = 1;
			break;
		}
	}
	if(check == 0){
		document.getElementById("et_price").value = uncomma(et_price.value);
		
		frm.action='./estimateinsert.jsp';
		frm.submit();
	}
}

function deleteform(frm){
	var et_id = document.getElementById('et_id');
	var degree = document.getElementById('et_degree');
	var check = 0;
	alert(degree.value);
	if(check == 0 && et_id.value == ""){
		alert("필수값을 입력하세요.");
		check = 1;
	}
	if(check == 0 && degree.value == ""){
		alert("필수값을 입력하세요.");
		check = 1;
	}
	if(check == 0){
		frm.action = './estimatedelete.jsp';
		frm.submit();
	}
}
$("#searchet_id").on("keydown", function(e){	// 검색 창에 값이 입력됨에 따른 이벤트 처리
	if(e.keyCode==13){	
		searchet_idevent(dates);
	}
});

$(document).ready(function() {
    $('select[id="et_com_name"]').select2();
    $('select[id="et_com_name"]').val("").select2();
});

function exceldownload(){
	var et_id = document.getElementById("et_id").value;
	var degree = document.getElementById("et_degree").value;
	var com = document.getElementById("et_com_name").value;
	var check = 0;
	if(et_id == ""){
		check = 1;
		alert("견적서를 확인하세요");
	}
	if(degree == ""){
		check = 1;
		alert("견적서를 확인하세요");
	}
	if(com == ""){
		check = 1;
		alert("견적서를 확인하세요");
	}
	if(check == 0){
		location.href = "../estimateExcel/estimateExcel?mode=excelinfo&id=" + et_id + "&degree=" + degree +"&com=" + com;	
	}
	
	
}

</script>
<%!
public String commaj(int s){
	DecimalFormat df = new DecimalFormat("###,###");
	String money = df.format(s);
	return money;
}
%>
</head>
<body>
	<div class="title">영업 관리/견적서 관리</div>
	<div class="panel panel-default border searchbox">
		<div class="panel-body">
			업체명:&nbsp;&nbsp;&nbsp;<input type="text" id="searchet_id"
				class="form-control searchtitle">
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 견적일:&nbsp;&nbsp;&nbsp;<input
				type="text" name="dates" class="form-control searchtitle">

			<script>
				var dates = "";
	                $('input[name="dates"]').daterangepicker({
	                    timePicker: false,
	                    locale:{
	                        format: 'YY/MM/DD'
	                    }
	                });
	                
	                $('input[name="dates"]').change(function(){
	                    dates = $('input[name="dates"]').val();
	                    var searchword = document.getElementById("searchet_id").value;
						request.open("Post", "../searchtableajax?searchword=" + searchword  +"&mode=" + mode + "&dates=" + dates, true);
						request.onreadystatechange = searchestimatetable;
						request.send(null); 
	                });
	                
			$("#searchet_id").on("keydown", function(e){	// 검색 창에 값이 입력됨에 따른 이벤트 처리
				if(e.keyCode==13){	
					var searchword = document.getElementById("searchet_id").value;
					request.open("Post", "../searchtableajax?searchword=" + searchword  +"&mode=" + mode + "&dates=" + dates, true);
					request.onreadystatechange = searchestimatetable;
					request.send(null); 
				}
			});	
			
			function searchestimatetable(){
				var estitable = document.getElementById("estitabletbody");
				var resultpage = 0;
				if(request.readyState == 4 && request.status == 200){
					estitable.innerHTML = "";
					var object = eval('(' + request.responseText + ')');
					var result = object.result;
					for(var i=0; i<result.length; i++){
						var row = estitable.insertRow(estitable.rows.length);
						var resultpage = parseInt(i/10) + 1;
						$(row).attr('name', 'page' + resultpage);
						for(var j=0; j < result[i].length; j++){				
							var cell = row.insertCell(j);
							if(j == 5){
								cell.innerHTML = result[i][j].value;
								cell.className = 'nonetd';
							}
							else{
								cell.innerHTML = result[i][j].value;
							}
						}
					}
					hlastpage = parseInt((result.length-1)/10)+1
					uladd(hlastpage);
					pagenation(1);
					paging = 1;
				}
				$(function(){
				    $("#estitabletbody tr").click(function(){
				    	var tr = $(this);
				    	var td = tr.children();
				    	var et_id = td.eq(0).text();
				    	var degree = td.eq(1).text();
				        $("#et_id").val(td.eq(0).text());
				        $("#et_degree").val(td.eq(1).text());
				    	$("#et_com_name").val(td.eq(2).text());
				    	$("#et_price").val(td.eq(3).text());
				    	var str = td.eq(5).text();
				    	str = str.replaceAll('!@#', '\n');
				    	document.getElementById('et_explain').value = str;
				    	request.open("Post", "../estimatesearchajax?et_id="+ et_id +"&degree=" + degree, true);
				    	request.onreadystatechange = searchestimate;
				    	request.send(null);
				    });
				});

			}
			</script>
		</div>
	</div>
	<form>
		<div class="row">
			<div class="panel panel-default border boardlistbox col-md-6">
				<div class="panel-heading" style="height:60px;">
					<div style="height:40px;">
						<h5 class="panel-title" style="float:left; margin-top:10px;">견적서 리스트</h5>
						<input id="on" class="btn btn-primary" type="button" value="ON"
								name="addtable" style="float:right;" onclick="degreeclick()">
						<input id="off" class="btn btn-primary" type="button" value="OFF"
								name="addtable" style="float:right; display:none;" onclick="degreeclickoff()">
						<h5 class="panel-title" style="float:right; margin-top:10px; margin-right:15px;">전체 차수 숨김</h5>
					</div>
				</div>
				<div class="panel-body">
					<table class="table table-bordered table-hover" id="estitable">
						<thead class="tablehead">
							<th style="width: 22%;">견적서번호</th>
							<th style="width: 12%;">차수</th>
							<th style="width: 22%;">업체명</th>
							<th style="width: 22%;">금액(원)</th>
							<th style="width: 22%;">견적일</th>
						</thead>
						<tbody id="estitabletbody">
						<%
						for (int i = 0; i < degreev.size(); i++) {
							int pageid = i/10 + 1;
						%>
						<tr name="page<%=pageid%>" style="display:none;">
							<td><%=degreev.get(i).getEt_id()%></td>
							<td><%=degreev.get(i).getDegree()%></td>
							<td><%=degreev.get(i).getEt_com_name()%></td>
							<td><%=commaj(degreev.get(i).getEt_price())%></td>
							<td><%=degreev.get(i).getEt_date()%></td>
							<td style="display:none;"><%=degreev.get(i).getEt_explain()%></td>
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
						pagenation(1)
					</script>
				</div>
			</div>
			<div class="panel panel-default border boardinputbox col-md-6">
				<div class="contab" style="background: blue;">
					<ul class="nav nav-tabs" style="background: white;">
						<li role="presentation" class="active" data-tab="tab-1"><a>기본정보</a></li>
						<li role="presentation" data-tab="tab-2"><a>자재</a></li>
						<li role="presentation" data-tab="tab-3"><a>가공비</a></li>
						<li role="presentation" data-tab="tab-4"><a>기타 비용</a></li>
					</ul>
				</div>

				<div id="tab-1" class="tab-content current">
					<div class="panel-body">
						<h5 class="rigth-panel-title panel-title">견적서 등록/수정</h5>
						<table style="border: 0; width: 98%; margin-left: 10px;">
							<tr>
								<td>
									<div class="form-group boardnum">
										<label for="boardnuminput">견적서번호 <span
											style="color: red;">*</span></label> <input type="text" id="et_id"
											name="net_id" class="form-control" readonly>
									</div>
									<div class="form-group writeday">
									<div class="row">
										<div class="col-12">
											<label for="writedayinput">업체명 <span style="color: red;">*</span></label>
										</div>
										<div class="col-12">
										<select id="et_com_name" name="net_com_name" class="form-control com_nameselect" style="margin-top:0px">
											<%
											Vector<String> v2 = new Vector<String>();
											v2 = dbc.selectcomname();
											for (int i = 0; i < v2.size(); i++) {
											%>
											<option value="<%=v2.get(i)%>"><%=v2.get(i)%></option>
											<%
											}
											%>
										</select>
										</div>
									</div>
										
									</div>
								</td>
							</tr>

							<tr>
								<td>
									<div class="form-group boardtitle">
										<label for="boardtitleinput">금액(원) <span
											style="color: red;">*</span></label> <input type="text" id="et_price"
											name="net_price" class="form-control">
									</div>
									<div class="form-group writeday">
										<input type="text" id="et_degree" name="net_degree"
											class="form-control" style="display: none">
									</div>
								</td>

							</tr>

							<tr>
								<td>
									<div class="form-group boardcontents">
										<label for="boardcontentsinput">설명</label>
										<textarea id="et_explain" name="net_explain"
											style="resize: none;" class="form-control" rows="7"
											name="content"></textarea>
									</div>
								</td>
							</tr>
						</table>
					</div>
				</div>
				<div id="tab-2" class="tab-content">
					<div class="panel-body">
						<h5 class="rigth-panel-title panel-title" style="display:inline-block">견적서 등록/수정</h5>
						<div style="display:inline-block; margin-left:580px;">
							<input class="btn btn-primary" type="button" value="추가" name="addtable" onClick="addrow1();"> 
							<input class="btn btn-danger" type="button" id="alldelbutton" value="전체삭제" onclick="alldel();">
						</div>
						
						<table id="estimatetable"
							style="border: 0; width: 98%; margin-left: 10px;">
							<thead>
								<th style="width: 60%">
									<div>품번</div>
								</th>
								<th style="width: 35%">
									<div>수량</div>
								</th>
								<th style="width: 5%"></th>
							</thead>
							<tbody id="estimatetbody">
							</tbody>
						</table>
					</div>
				</div>
				<div id="tab-3" class="tab-content">
					<div class="panel-body">
						<h5 class="rigth-panel-title panel-title" style="display:inline-block">견적서 등록/수정</h5>
						<div style="display:inline-block; margin-left:580px;">
							<input class="btn btn-primary" type="button" value="추가" name="addtable" onClick="addrow2();"> 
							<input class="btn btn-danger" type="button" id="alldelbutton" value="전체삭제" onclick="alldel();">
						</div>
						<table id="estimatetable2"
							style="border: 0; width: 98%; margin-left: 10px;">
							<thead>
								<th style="width: 15%">
									<div>표준공정</div>
								</th>
								<th style="width: 20%">
									<div>예상시작</div>
								</th>
								<th style="width: 20%">
									<div>종료일</div>
								</th>
								<th style="width: 10%">
									<div>md</div>
								</th>
								<th style="width: 15%">
									<div>비용(원)</div>
								</th>
								<th style="width: 10%">
									<div></div>
								</th>
							</thead>
							<tbody id="estimatetbody2">
							</tbody>
						</table>
					</div>
				</div>
				<div id="tab-4" class="tab-content">
					<div class="panel-body">
						<h5 class="rigth-panel-title panel-title" style="display:inline-block">견적서 등록/수정</h5>
						<div style="display:inline-block; margin-left:580px;">
							<input class="btn btn-primary" type="button" value="추가" name="addtable" onClick="addrow3();"> 
							<input class="btn btn-danger" type="button" id="alldelbutton" value="전체삭제" onclick="alldel();">
						</div>
						<table id="estimatetable3"
							style="border: 0; width: 98%; margin-left: 10px;">
							<thead>
								<th style="width: 45%">
									<div>기타견적</div>
								</th>
								<th style="width: 45%">
									<div>비용(원)</div>
								</th>
								<th style="width: 10%"></th>
							</thead>
							<tbody id="estimatetbody3">
							</tbody>
						</table>
					</div>
				</div>
				<div class="buttongruops">
					<input class="btn btn-primary" type="reset" value="초기화"
						id="boardreset" /> 
					<input class="btn btn-primary" type="button" value="견적서 출력" id="boardreset" onclick="exceldownload()"/>
					<input class="btn btn-primary" type="button" value="등록" onclick="insertform(this.form)"> 
					<input class="btn btn-danger" type="button" value="삭제" onclick="deleteform(this.form)">
				</div>
			</div>
		</div>
	</form>
</body>
</html>