<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@page import="standardProcess.StandardProcessPDTO" %>
<%@page import="java.util.List" %>
<jsp:useBean id="dao" class="standardProcess.StandardProcessDAO"/>
<%request.setCharacterEncoding("UTF-8"); %>
<table class="table table-bordered table-hover table-striped sptable" id="splist">
    <thead class="tablehead">
        <th style="width: 16%;"></th>
        <th style="width: 30%;">공정/설비명</th>
        <th style="width: 10%;">유형</th>
        <th style="width: 19%;">임률</th>
        <th style="width: 15%;">부하율</th>
        <th style="width: 10%;">사용유무</th>
    </thead>

	<%
	List<StandardProcessPDTO> spProcessList = dao.getTopStandardProcessProcesses();
	if(spProcessList != null){
		for(StandardProcessPDTO pdto : spProcessList){
	%>
    <tr class="tablecontent processcontent" name="none" id="<%=pdto.getProcess_name() %>"> 
    <%		if(pdto.isLowerlevel()){ %>
        <td id="spicon" name="spopenicon"><span class="glyphicon glyphicon-triangle-bottom" aria-hidden="true"></span></td>
    <%		}else{ %>
    	<td id="spicon"></td>
    <%		} %> 
        <td id="spnames"><%=pdto.getProcess_name() %></td>
        <td id="sptype"><%=pdto.getType() %></td>
        <td id="sppay"><%=pdto.getPay() %></td>
        <td id="sploadfac"><%=pdto.getLoad_factor() %></td>
        <td id="spusing"><%=pdto.isUsing() %></td>
        
        <td id="spmanager" style="display:none;"><%=pdto.getProcess_manager() %></td>
    </tr>
    <%}}else{ %>
    <tr>
        <td colspan="6" align="center"><div>등록된 표준공정이 없습니다.</div></td>
    </tr>
    <%} %>
    
    <script>
    $(document).on("click",".processcontent",function(){
		$(".processcontent, .facilitycontent").css("background","white");
		$(this).css("background","lightgray");
		
		$("#insertselpcpanel").show();
		$("#insertpcpanel").hide();
        $("#insertpceqpanel").hide();
		
        $("#dnprocess_name").val($(this).children("#spnames").text());
		$("#selpcpnameinput").val($(this).children("#spnames").text());
		$("#selpcfreratesinput").val($(this).children("#sppay").text());
		$("#selpcloadfacinput").val($(this).children("#sploadfac").text());
		
		let usingbool = "0";
		if($(this).children("#spusing").text() == "Y"){
			usingbool = "1";
		}
		$("#selpcusingselect").val(usingbool).prop("selected",true);
		
		$("#selectedprocessname").val($(this).attr("name"));
		$("#selectedprocessid").val($(this).attr("id"));
		
		let spmstr = $(this).children("#spmanager").text();
		let spmanagers = spmstr.split(',');
		$("#selpcinchargeselect").html(null);
		for(var s of spmanagers){
			let htmlstr = "<option>" + s + "</option>";
			$("#selpcinchargeselect").append(htmlstr);
		}
	});
    
    $(document).on("click",".facilitycontent",function(){
    	$(".processcontent, .facilitycontent").css("background","white");
		$(this).css("background","lightgray");
		
		$("#insertselpcpanel").hide();
		$("#insertpcpanel").hide();
        $("#insertpceqpanel").show();
		
		$("#pceqpnameselect").val($(this).attr("name")).select2();
		$("#pceqenameselect").val($(this).attr("id")).select2();
    });
    
    </script>
</table>