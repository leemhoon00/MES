<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="dailyWork.DailyWorkDTO" %>
<%@page import="java.util.List" %>
<jsp:useBean id="dao" class="dailyWork.DailyWorkDAO"/>
<%
	int lastnum = -1;
	String condition = "WHERE";
	
	String pagenum = request.getParameter("page");
	int p = 1;
	if(pagenum != null){
		p = Integer.parseInt(pagenum);
	}
	
	String duration = request.getParameter("date");
	String startdate = null, enddate = null;
	
	if(duration != "" && duration != null){
		int index = duration.indexOf(" ");
		startdate = duration.substring(0,index);
		enddate = duration.substring(index+3);
	}
	
	if(duration == ""){
		duration = null;
	}
	
	String wk = request.getParameter("wk");
	if(wk == ""){
		wk = null;
	}
	
	List<DailyWorkDTO> dwlist = null;
	if(duration == null && wk == null){
		dwlist = dao.getDailyWorkList(p);
		lastnum = dao.getDailyWorkNext();
		
	}
	else{
		
		if(startdate != null && enddate != null) {
			condition = condition + " regdate >= \'" + startdate + "\' and regdate <= \'" + enddate + "\'";
			
			if(wk != null) {
				condition = condition + " and worker like \'%" + wk + "%\'";
			}
		}
		
		else if(wk != null) {
			condition = condition + " title worker \'%" + wk + "%\'";
		}
		
		lastnum = dao.getDailyWorkListSearchNext(condition);
		dwlist = dao.getDailyWorkListSearch(p, condition);
		
	}
%>
<table class="table table-bordered table-hover">
	<thead class="tablehead">
	    <th style="width: 16%">작업자</th>
	    <th style="width: 16%">유형</th>
	    <th style="width: 17%">수주명</th> <!-- 금형번호? -->
	    <th style="width: 17%">부품명</th>
	    <th style="width: 17%">공정</th>
	    <th style="width: 17%">등록일</th>
	</thead>
	
	<%
	if(dwlist != null){
		int index = 0;
		for(DailyWorkDTO dto : dwlist){
			index += 1;
	%>
	<tr class="tablecontent dwtablecontent" id="#<%=index %>"> 
	    <td id="dwmanager"><%=dto.getWorker() %></td>
	    <td id="dwtype"><%=dto.getDwtype() %></td>
	    <td id="dworder"><%=dto.getOrder_name() %></td>
	    <td id="dwpart"><%=dto.getPart_name() %></td>
	    <td id="dwproc"><%=dto.getProcess() %></td>
	   <td id="dwregdate"><%=dto.getRegdate() %></td>
	    
	    <td id="dwstart" style="display:none;"><%=dto.getStart_date() %></td>
	    <td id="dwend" style="display:none;"><%=dto.getEnd_date() %></td>
	    <td id="dwfaulty" style="display:none;"><%=dto.getFaulty() %></td>
	    <td id="dwcom" style="display:none;"><%=dto.getCompany() %></td>
	    <td id="dwprice" style="display:none;"><%=dto.getPrice() %></td>
	    <td id="dwwed" style="display:none;"><%=dto.getWarehousing_exp_date() %></td>
	    <td id="dwfac" style="display:none;"><%=dto.getFacilities() %></td>
	    <td id="dwsta" style="display:none;"><%=dto.getStatus() %></td>
	    <td id="dwwid" style="display:none;"><%=dto.getWork_id() %></td>
	</tr>
	<%
		}
	}else{
	%>
	    <tr>
	        <td colspan="7" align="center"><div>등록된 작업일보가 없습니다.</div></td>
	    </tr>
	<%
	}
	%>
</table>
<script>
//테이블 열 클릭 이벤트
$(".dwtablecontent").on("click",function(){
	if($(this).children("#dwtype").text() == "사내"){
		$("#mwform").each(function(){this.reset();});
		$("#mwform2").each(function(){this.reset();});
		
		$("#worklogmodal #ordername").val($(this).children("#dworder").text());
		$("#worklogmodal #partname").val($(this).children("#dwpart").text());
		$("#worklogmodal #processname").val($(this).children("#dwproc").text());
		$("#worklogmodal #facilityname").val($(this).children("#dwfac").text());
		
		let wlst = toISO($(this).children("#dwstart").text());
		let wled = toISO($(this).children("#dwend").text());
		
		$("#worklogmodal #startdtime").val(wlst);
		$("#worklogmodal #enddtime").val(wled);
		
		if($(this).children("#dwfaulty").text() == "Y"){
			$("#worklogmodal #faultycheck").attr("checked",true);
		}else{
			$("#worklogmodal #faultycheck").attr("checked",false);
		}
		
		status($(this).children("#dwsta").text());
		
		$.ajax({
			data: "GET",
			asycn: false,
			url: "./MyWorkSearch",
			data:{workid:$(this).children("#dwwid").text()},
			dataType:"JSON",
			success:function(data){
				$("#worklogmodal #comname").val(data.client);
				$("#worklogmodal #dobun").val(data.dobun);
				$("#worklogmodal #amount").val(data.quantity);
				$("#worklogmodal #coretype").val(data.core);
				$("#worklogmodal #worktime").val(data.work_time);
				$("#worklogmodal #aworktime").val(data.real_processing_time);
				$("#worklogmodal #npworktime").val(data.no_men_processing_time);
				$("#worklogmodal #nworktime").val(data.un_processing_time);
				$("#worklogmodal #totalwt").val(data.total_work_time);
				$("#worklogmodal #totalmt").val(data.total_processing_time);
			}
		})
		
		$("#worklogmodalbtn").click();
	}
	else if($(this).children("#dwtype").text() == "외주"){
		$("#osform").each(function(){this.reset();});
		
		$("#outsoumodal #ordername").val($(this).children("#dworder").text());
		$("#outsoumodal #partname").val($(this).children("#dwpart").text());
		$("#outsoumodal #processname").val($(this).children("#dwproc").text());
		$("#outsoumodal #companyname").val($(this).children("#dwcom").text());
		$("#outsoumodal #price").val($(this).children("#dwprice").text());
		$("#outsoumodal #whdate").val($(this).children("#dwwed").text());

		$("#outsoumodal #outsstarttime").val($(this).children("#dwstart").text());
		$("#outsoumodal #outsendtime").val($(this).children("#dwend").text());
		
		if($(this).children("#dwfaulty").text() == "Y"){
			$("#outsoumodal #faultycheck").attr("checked",true);
		}else{
			$("#outsoumodal #faultycheck").attr("checked",false);
		}
		
		$("#outsoumodalbtn").click();
	}   
});

function toISO(dtime){
	let ymd = dtime.substring(0,10);
	let h = dtime.substring(11,13);
	let mm = dtime.substring(14,16);
	let s = dtime.substring(17,19);
	
	let result = ymd + 'T' + h + ':' + mm + ':' + s;
	return result;
}

function status(st){
	let stt = "<button type='button' class='btn btn-primary' style='text-align:center;' id='sttdiv' disabled></button>";
	
	$("#statusdiv").html(stt);
	$("#sttdiv").text(st);
	
}
</script>
<ul class="pagination">
	<li><a class="preanpage">Previous</a></li>
	<%
	int block = p/5 + 1;
	
	if(p % 5 == 0){
		block = block -1;
	}
	
	int startpage = (block-1) * 5 + 1;
	int endpage = ((lastnum-1)/10) + 1;
	int endexpage = endpage;
	
	if(endexpage > 4 + startpage){
		endexpage = startpage + 4;
	}
	
	for(; startpage<=endexpage; startpage++){
	%>
	<li id="p<%=startpage%>"><a class="anpage"><%=startpage %></a></li>
	<%} %>
	<li><a class="nextanpage">Next</a></li>
</ul>
	
<script>
	$(".anpage").removeClass("active");
	$("#p" + <%=p%>).addClass("active");
	
	$(".anpage").click(function(){
		$("li").removeClass("active");
		$(this).parent().addClass("active");
		
		var pnum = $(this).text();
		var wk = "<%=request.getParameter("wk") %>";
		var date = "<%=request.getParameter("date") %>";
		
		if(wk == "null"){
			wk = null;
		}
		if(date == "null"){
			date = null;
		}
		
		$.ajax({
			type:"GET",
			url:"./dailyWorksearch.jsp",
			data:{page:pnum, "wk":wk, "date":date},
			dataType:"html",
			success:function(data){
	            $("#dailyWorkt").html(data);
	        }
		});
	});
	
	$(".preanpage").click(function(){
		$("li").removeClass("active");
		
		var k = Number($(this).parent().next().text());
		if(k != 1){
			k = k - 5;
		}
		
		$("#p" + k).addClass("active");
		
		var pnum = k;
		var wk = "<%=request.getParameter("wk") %>";
		var date = "<%=request.getParameter("date") %>";
		
		if(wk == "null"){
			wk = null;
		}
		if(date == "null"){
			date = null;
		}
		
		$.ajax({
			type:"GET",
			url:"./dailyWorksearch.jsp",
			data:{page:pnum, "wk":wk, "date":date},
			dataType:"html",
			success:function(data){
	            $("#dailyWorkt").html(data);
	        }
		});
		
	});
	
	$(document).ready(function(){
		var kp = Number($(".preanpage").parent().next().text());
		var kn = Number($(".nextanpage").parent().prev().text());
		
		if(kp == 1){
			$(".preanpage").parent().addClass("disabled");
			$(".preanpage").css({"cursor":"Default"});
		}
		
		else{
			$(".preanpage").css({"color":"#337ab7"});
		}
		
		if(kn == <%= endpage %>){
			$(".nextanpage").parent().addClass("disabled");
			$(".nextanpage").css({"cursor":"Default"});
		}
		
		else{
			$(".nextanpage").css({"color":"#337ab7"});
		}
	});
	
	$(".nextanpage").click(function(){
		$("li").removeClass("active");
		
		var k = Number($(this).parent().prev().text());
		if(k != <%=endpage %>){
			k = k + 1; 
		}
		
		$("#p" + k).addClass("active");
		
		var pnum = k;
		var wk = "<%=request.getParameter("wk") %>";
		var date = "<%=request.getParameter("date") %>";
		
		if(wk == "null"){
			wk = null;
		}
		if(date == "null"){
			date = null;
		}
		
		$.ajax({
			type:"GET",
			url:"./dailyWorksearch.jsp",
			data:{page:pnum, "wk":wk, "date":date},
			dataType:"html",
			success:function(data){
	            $("#dailyWorkt").html(data);
	        }
		});
		
	});
	
</script>