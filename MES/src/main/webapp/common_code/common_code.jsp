<!-- 공통 코드 관리 페이지 -->

<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
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

<script>

var mainclass = [];
var subclass = [];
<%
int subcount=0;
int maincount=0;

rs=stmt.executeQuery("select count(*) from code_sub");
if(rs.next()){subcount=rs.getInt(1);}

rs=stmt.executeQuery("select count(*) from code_main");
if(rs.next()){maincount=rs.getInt(1);}
rs=stmt.executeQuery("select * from code_sub");
%>

var subcount = <%=subcount%>;
var subtomainmap = new Map();
var maincount= <%=maincount%>;
var maintogroupmap = new Map();


</script>

<script>

<%

while(rs.next()){
%>
subclass.push({main_code: '<%=rs.getString("main_code").replace(" ","_")%>', sub_code: '<%=rs.getString("sub_code").replace(" ","_")%>', using: '<%=rs.getInt("using")%>'});
subtomainmap.set('<%=rs.getString("sub_code")%>','<%=rs.getString("main_code").replace(" ","_")%>');
<% } 
rs = stmt.executeQuery("select * from code_main");
while(rs.next()){
%>
mainclass.push({group_code:'<%=rs.getString("group_code")%>', main_code: '<%=rs.getString("main_code").replace(" ","_")%>', using: '<%=rs.getInt("using")%>', contents: '<%=rs.getString("contents").replaceAll("(\r\n|\r|\n|\n\r)", "^&^&")%>'});
maintogroupmap.set('<%=rs.getString("main_code").replace(" ","_")%>','<%=rs.getString("group_code")%>');
<% } %>

var selectedgroup = "전체";
var selectedmain = "선택";

</script>
</head>
<body>
<label class="title" style="margin-left: 30px; margin-top: 10px;">기준정보 관리/공통코드 관리</label>
<div class="card">
	<div class="card-body">
		<div class="form-inline">
			<label>그룹</label>
			<select class="form-select search" id="groupselect" onchange="groupchange()">
				<option value="전체">전체</option>
				<%
				rs=stmt.executeQuery("select * from code_group");
				while(rs.next()){
				%>
				<option value="<%=rs.getString("group_code")%>"><%=rs.getString("group_code")%></option>
				<%} %>
				
				<script>
				
				//그룹 셀렉트박스 change 이벤트
				function groupchange(){
					selectedgroup = document.getElementById("groupselect").value;
					document.getElementById("txtmaingroup").value = selectedgroup;
					
					if(selectedgroup=="전체"){
						var temp = document.querySelectorAll(".Allmain");
						for(var i=0; i<temp.length; i++){
							var item = temp.item(i);
							item.style.display="";
						}
					}
					else{
						var temp = document.querySelectorAll(".Allmain");
						for(var i=0; i<temp.length; i++){
							var item = temp.item(i);
							item.style.display="none";
						}
						temp = document.querySelectorAll("."+selectedgroup);
						for(var i=0; i<temp.length; i++){
							var item = temp.item(i);
							item.style.display="";
						}
					}
				}
				</script>
				
			</select>
			<label>메인코드</label>
			<select class="form-select search" id="mainselect" onchange="mainchange()">
				<option value="선택">선택</option>
				<%
				rs=stmt.executeQuery("select * from code_main");
				while(rs.next()){
				%>
				<option class="Allmain <%=rs.getString("group_code") %>" value="<%=rs.getString("main_code").replace(" ","_")%>"><%=rs.getString("main_code")%></option>
				<% } %>
				<script>
				//메인코드 셀렉트박스 change 이벤트
				function mainchange(){
					selectedmain = document.getElementById("mainselect").value;
					if(selectedmain=="선택"){
						document.getElementById("txtmainmain").value = "";
						document.getElementById("maincontents").value ="";
					}
					else{
						document.getElementById("txtmainmain").value = selectedmain;
						for(var i=0; i<mainclass.length;i++){
							if(mainclass[i].main_code == selectedmain){
								document.getElementById("maincontents").value = mainclass[i].contents.replaceAll("^&^&","\n");//줄바꿈 처리
								document.getElementById("txtmaingroup").value = mainclass[i].group_code;
							}
						}
					}
					
					document.getElementById("mainrevise").value = selectedmain;
					document.getElementById("txtmain").value = selectedmain;
					document.getElementById("txtsub").value = "";
					
					var trs = document.querySelectorAll(".trs");
					for(var i=0; i<trs.length; i++){
						var item = trs.item(i);
						item.style.display="none";
					}
					trs = document.querySelectorAll("."+selectedmain);
					for(var i=0; i<trs.length; i++){
						var item = trs.item(i);
						item.style.display="";
					}
				}
				</script>
			</select>
			<button class="btn btn-info" onclick="maincodebutton()">메인코드등록</button>
			<button type="button" class="btn btn-info" data-bs-toggle="modal" data-bs-target="#exampleModal" onclick="wholebutton()">
			  전체보기
			</button>
			<script>
			//전체보기 버튼 이벤트
			function wholebutton(){
				trs = document.querySelectorAll(".modalgrouptrs");
				for(var i=0; i<trs.length; i++){
					var item = trs.item(i);
					item.style.backgroundColor="white";
				}
				trs = document.querySelectorAll(".modalmaintrs");
				for(var i=0; i<trs.length; i++){
					var item = trs.item(i);
					item.style.display="";
				}
				trs = document.querySelectorAll(".modalmaintrs");
				for(var i=0; i<trs.length; i++){
					var item = trs.item(i);
					item.style.backgroundColor="white";
				}
				trs = document.querySelectorAll(".modalsubtrs");
				for(var i=0; i<trs.length; i++){
					var item = trs.item(i);
					item.style.display="";
				}
			}
			function maincodebutton(){
				document.getElementById("maindiv").style.display="";
				document.getElementById("subdiv").style.display="none";
			}
			var modalgroup="";
			var modalmain="";
			var modalsub="";
			</script>
			<!-- Modal -->
			<div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
			  <div class="modal-dialog" style="max-width: 100%; width: auto; display: table;">
			    <div class="modal-content">
			      <div class="modal-header">
			        <h5 class="modal-title" id="exampleModalLabel">전체 공통코드 보기</h5>
			        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			      </div>
			      <div class="modal-body" style="padding:1px">
			        <div class="row" style="width:1300px">
			        	<div class="col-4">
					        <div class="card" style="margin:5px">
					            <div class="card-header">
					                그룹
					            </div>
					            <div class="card-body">
					                <table class="table table-bordered" style="width: 100%;" role="grid">
					                <thead>
										<tr>
											<th>그룹코드명</th>
										</tr>
									</thead>
									<tbody style="border-top: none;">
										<%
										rs=stmt.executeQuery("select * from code_group");
										while(rs.next()){
										%>
										<tr class="modalgrouptrs" onclick="changemodalgroup(this)">
											<td><%=rs.getString("group_code")%></td>
										</tr>
										<%} %>
										<script>
										function changemodalgroup(element){
											trs = document.querySelectorAll(".modalgrouptrs");
											for(var i=0; i<trs.length; i++){
												var item = trs.item(i);
												item.style.backgroundColor="white";
											}
											
											element.style.backgroundColor="rgb(68,80,132)";
											modalgroup=element.children[0].innerHTML;
											
											trs = document.querySelectorAll(".modalmaintrs");
											for(var i=0; i<trs.length; i++){
												var item = trs.item(i);
												item.style.display="none";
											}
											
											trs = document.querySelectorAll("."+modalgroup);
											for(var i=0; i<trs.length; i++){
												var item = trs.item(i);
												item.style.display="";
											}
											
										}
										</script>
									</tbody>
					                </table>
					            </div>
					        </div>
					    </div>
					    <div class="col-4">
					        <div class="card" style="margin:5px">
					        	<div class="card-header">
					                메인코드
					            </div>
					            <div class="card-body">
					            	 <table class="table table-bordered" style="width: 100%;" role="grid">
					            	 <thead>
										<tr>
											<th>메인코드명</th>
										</tr>
									</thead>
									<tbody style="border-top: none;">
										<%
										rs=stmt.executeQuery("select * from code_main");
										while(rs.next()){
										%>
										<tr class="modalmaintrs <%=rs.getString("group_code")%>" onclick="changemodalmain(this)">
											<td><%=rs.getString("main_code")%></td>
										</tr>
										<% } %>
									</tbody>
					            	 </table>
					            	 <script>
					            	 function changemodalmain(element){
					            		 trs = document.querySelectorAll(".modalmaintrs");
											for(var i=0; i<trs.length; i++){
												var item = trs.item(i);
												item.style.backgroundColor="white";
											}
											
											element.style.backgroundColor="rgb(68,80,132)";
											modalmain=element.children[0].innerHTML.replace(" ","_");
											
											
											trs = document.querySelectorAll(".modalsubtrs");
											for(var i=0; i<trs.length; i++){
												var item = trs.item(i);
												item.style.display="none";
											}
											
											trs = document.querySelectorAll(".modal"+modalmain);
											for(var i=0; i<trs.length; i++){
												var item = trs.item(i);
												item.style.display="";
											}
					            	 }
					            	 </script>
					            </div>
					        </div>
					    </div>
					    <div class="col-4">
					        <div class="card" style="margin:5px">
					        	<div class="card-header">
					                서브코드
					            </div>
					            <div class="card-body">
					            	 <table class="table table-bordered" style="width: 100%;" role="grid">
					            	 <thead>
										<tr>
											<th>서브코드명</th>
										</tr>
									</thead>
									<tbody style="border-top: none;">
										<%
										rs=stmt.executeQuery("select * from code_sub");
										while(rs.next()){
										%>
										<tr class="modalsubtrs modal<%=rs.getString("main_code").replace(" ","_")%>">
											<td><%=rs.getString("sub_code")%></td>
										</tr>
										<%} %>
									</tbody>
					            	 </table>
					            </div>
					        </div>
					    </div>
			        </div>
			      </div>
			      <div class="modal-footer">
			        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
			      </div>
			    </div>
			  </div>
			</div>
		</div>
	</div>
</div>

<div class="row">
	
<!----------------------------------------------- 왼쪽 섹션 -------------------------------------------->
	<div class="col-6" style="margin-right: 0px;">
		<div class="card" style="margin-right: 0px;">
			<div class="card-header"
				style="font-size: 20px; background-color: white;">공통코드 관리<button class="btn btn-info float-right" onclick="subcodebutton()">서브코드등록</button></div>
			<div class="card-body">
			<script>
			function subcodebutton(){
				document.getElementById("submitcheck").value="0";
				document.getElementById("txtsub").value="";
				document.getElementById("subusing").value="Y";
				
				trs = document.querySelectorAll(".trs");
				for(var i=0; i<trs.length; i++){
					var item = trs.item(i);
					item.style.backgroundColor="white";
				}
				document.getElementById("maindiv").style.display="none";
				document.getElementById("subdiv").style.display="";
			}
			</script>
				<table id="mytable" class="table table-bordered" style="width: 100%;"
					role="grid">
					<thead>
						<tr>
							<th>서브코드명</th>
							<th>사용여부</th>
						</tr>
					</thead>
					<tbody style="border-top: none;">
						<%
						rs=stmt.executeQuery("select * from code_sub");
						String sub_using="";
						while(rs.next()){
							if(rs.getInt("using") == 0){
								sub_using="N";
							}
							else{
								sub_using="Y";
							}
						%>
						<tr class="trs <%=rs.getString("main_code").replace(" ","_")%>" id="<%=rs.getString("sub_code").replace(" ","_")%>" onclick="tableclickevent(this)">
							<td style="display:none"><%=rs.getString("main_code")%></td>
							<td><%=rs.getString("sub_code")%></td>
							<td><%=sub_using%></td>
						</tr>
						<%
						}
						%>
						<script>
						trs = document.querySelectorAll(".trs");
						for(var i=0; i<trs.length; i++){
							var item = trs.item(i);
							item.style.display="none";
						}
						
						function tableclickevent(element){
							document.getElementById("txtmain").value=element.children[0].innerHTML;
							document.getElementById("txtsub").value=element.children[1].innerHTML;
							document.getElementById("subusing").value=element.children[2].innerHTML;
							
							document.getElementById("submitcheck").value="1";
							document.getElementById("revisemain").value=element.children[1].innerHTML;
							
							document.getElementById("maindiv").style.display="none";
							document.getElementById("subdiv").style.display="";
							
							trs = document.querySelectorAll(".trs");
							for(var i=0; i<trs.length; i++){
								var item = trs.item(i);
								item.style.backgroundColor="white";
							}
							
							element.style.backgroundColor="rgb(68,80,132)";
						}
						</script>
					</tbody>
				</table>
			</div>
		</div>
	</div>

<!------------------------------------------------------ 오른쪽 섹션 --------------------------------------------->
	<div id="subdiv" class="col-6" style="margin-left: 0px; display:none;">
		<div class="col" style="margin-left: 0px;">
			<div class="card">
				<div class="card-header">서브코드 등록/수정</div>
				<div class="card-body">
				
				<form>
					<div class="row">
						<div class="col-4">
							<label>부모코드 명<span class="text-danger">*</span></label>
						</div>
						<div class="col-4">
							<label>서브코드 명<span class="text-danger">*</span></label>
						</div>
						<div class="col-4">
							<label>사용유무<span class="text-danger">*</span></label>
						</div>
						<div class="col-4">
							<input type="text" class="form-control" id="txtmain" name="txtmain">
						</div>
						<div class="col-4">
							<input type="text" class="form-control" id="txtsub" name="txtsub">
						</div>
						<div class="col-4">
							<select class="form-select" name="subusing" id="subusing">
								<option value="Y">Y</option>
								<option value="N">N</option>
							</select>
						</div>
						<input type="text" style="display:none" value="0" name="submitcheck" id="submitcheck">
						<input type="text" style="display:none" value="0" name="revisemain" id="revisemain">
						<div class="col-12">
							<button class="btn btn-danger float-right" type="button" onclick="sub_deletebutton()">삭제</button>
							<button class="btn btn-info float-right"
								style="margin-right: 5px;" type="submit" formaction="sub_insert.jsp" formmethod="post">등록</button>
							<script>
							function sub_deletebutton(){
								location.href="sub_delete.jsp?p1="+document.getElementById('txtsub').value;
							}
							</script>
						</div>
					</div>
					</form>
				</div>
			</div>
		</div>
	</div>
	
	<div id="maindiv" class="col-6" style="margin-left: 0px; display:none;">
		<div class="col" style="margin-left: 0px;">
			<div class="card">
				<div class="card-header">메인코드 등록/수정</div>
				<div class="card-body">
				
				<form>
					<div class="row">
						<div class="col-4">
							<label>그룹<span class="text-danger">*</span></label>
						</div>
						<div class="col-4">
							<label>메인코드명<span class="text-danger">*</span></label>
						</div>
						<div class="col-4">
							<label>사용유무<span class="text-danger">*</span></label>
						</div>
						<div class="col-4">
							<input type="text" class="form-control" name="txtmaingroup" id="txtmaingroup">
						</div>
						<div class="col-4">
							<input type="text" class="form-control" name="txtmainmain" id="txtmainmain">
						</div>
						<div class="col-4">
							<select class="form-select" name="mainusing" id="mainusing">
								<option value="1">Y</option>
								<option value="0">N</option>
							</select>
						</div>
						<div class="col-12">
							<label>설명</label>
						</div>
						<div class="col-12">
							<p>
								<textarea class="form-control" rows="5" name="maincontents" id="maincontents"></textarea>
							</p>
						</div>
						<input style="display:none" name="mainrevise" id="mainrevise">
						<div class="col-12">
							<button class="btn btn-info float-right"
								style="margin-right: 5px;" type="submit" formaction="main_revise.jsp" formmethod="post">수정</button>
							<button class="btn btn-info float-right"
								style="margin-right: 5px;" type="submit" formaction="main_insert.jsp" formmethod="post">등록</button>
							
						</div>
					</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>
<%
rs.close();
stmt.close();
conn.close();
%>
</body>
</html>