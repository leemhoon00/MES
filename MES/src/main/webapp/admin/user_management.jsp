<!-- 부품 관리 페이지 -->

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

<%
String temp="";

//rowcount = row갯수 (페이지네이션 용)
int rowcount=0;
query="select count(*) from user";
rs=stmt.executeQuery(query);
if(rs.next()){rowcount=rs.getInt(1);}

//lastpagenumber : 페이지네이션 용 마지막페이지
int lastpagenumber=1;
if(rowcount != 0){
	lastpagenumber = (rowcount-1)/10 +1;
}
%>
<%
query = "select * from user";
rs=stmt.executeQuery(query);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

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
<title>MES</title>



</head>
<body>
	<label class="title" style="margin-left: 30px; margin-top: 10px;">Admin / 사용자 관리</label>
	
<!--------------------------------------------- 윗 섹션 ----------------------------------------------->

	<div class="card">
		<div class="card-body">
			<div class="form-inline">
				<label>이름:</label> <input class="search form-control" id="search" type="text" onKeypress="javascript:if(event.keyCode==13) {search()}">
				<script>
				function search(){
					var text = document.getElementById("search").value;
					var trs = document.querySelectorAll(".trs");
					
					if(text!=""){
						document.getElementById("pageul").style.display="none";
						for(var i=0; i<trs.length; i++){
							var item = trs.item(i);
							if(item.children[2].innerHTML.search(text) == -1){
								item.style.display="none";
							}
							else{
								item.style.display="";
							}
						}
					}
					
					else{
						document.getElementById("pageul").style.display="";
						groupnumber=1;

						for(var i=0; i<trs.length; i++){
							var item = trs.item(i);
							item.style.display="none";
						}
						
						trs = document.querySelectorAll(".pagegroup1");
						for(var i=0; i<trs.length; i++){
							var item = trs.item(i);
							item.style.display="";
						}
						
						var pages = document.querySelectorAll(".pages");
						for(var i=0; i<pages.length; i++){
							var item = pages.item(i);
							item.classList.remove('active');
						}
						document.getElementById("page1").className += ' active';
						
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
				}
				</script>
			</div>
		</div>
	</div>

	<div class="row">
	
<!----------------------------------------------- 왼쪽 섹션 -------------------------------------------->
		<div class="col-6" style="margin-right: 0px;">
			<div class="card" style="margin-right: 0px;">
				<div class="card-header"
					style="font-size: 20px; background-color: white;">사용자 관리</div>
				<div class="card-body">
					<table id="mytable" class="table table-bordered" style="width: 100%;"
						role="grid">
						<thead>
							<tr>
								<th>사번</th>
								<th>이름</th>
								<th>Email</th>
								<th>Phone</th>
								<th>직위</th>
								<th>사용여부</th>
								<th></th>
							</tr>
						</thead>
						<tbody style="border-top: none;">
						<%
						//페이지네이션 용
						int count=0;
						int pagegroup=0;
						
						while(rs.next()){
							count++;
							if(count % 10 ==1){
								pagegroup++;
							}
							temp = rs.getString("user_name");
							String YN="";
							if(rs.getString("use_yn").equals("0")){
								YN="N";
							}
							else{
								YN="Y";
							}
						%>
						<tr class="trs pagegroup<%=pagegroup%>" id="<%=temp%>" onclick="tableclickevent(this)">
							<td><%=rs.getString("user_id")%></td>
							<td style="display:none"><%=rs.getString("user_pw")%></td>
							<td><%=rs.getString("user_name")%></td>
							<td><%=rs.getString("email")%></td>
							<td><%=rs.getString("phone")%></td>
							<td><%=rs.getString("first_position")%></td>
							<td><%=YN%></td>
							<td style="display:none"><%=rs.getString("second_position")%></td>
							<td style="display:none"><%=rs.getString("third_position")%></td>
							<td style="display:none"><%=rs.getString("note")%></td>
							<td style="display:none"><%=rs.getString("state")%></td>
							<td style="display:none"><%=rs.getString("use_yn")%></td>
							<td><button type="button" class="btn btn-secondary" onclick="location.href='/MES/barcode/barcode.jsp?code=71&uniqueId=<%=rs.getString("b_num")%>'">인쇄</button></td>
						</tr>
						<%
						}
						%>
						
						<script>
						function tableclickevent(element){
							document.getElementById("user_id").value=element.children[0].innerHTML;
							document.getElementById("user_pw").value=element.children[1].innerHTML;
							document.getElementById("user_name").value=element.children[2].innerHTML;
							document.getElementById("first_position").value=element.children[5].innerHTML;
							document.getElementById("second_position").value=element.children[7].innerHTML;
							document.getElementById("third_position").value=element.children[8].innerHTML;
							document.getElementById("phone").value=element.children[4].innerHTML;
							document.getElementById("email").value=element.children[3].innerHTML;
							document.getElementById("note").value=element.children[9].innerHTML;
							document.getElementById("state").value=element.children[10].innerHTML;
							document.getElementById("use_yn").value=element.children[11].innerHTML;
							
							document.getElementById("submitcheck").value="1";
							
							// 테이블 배경색 설정
							resetbutton();
							element.style.backgroundColor="lightgray";
						}
						
						//페이지네이션
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

<!------------------------------------------------------ 오른쪽 섹션 --------------------------------------------->
		<div class="col-6" style="margin-left: 0px;">
			<div class="col" style="margin-left: 0px;">
				<div class="card">
					<div class="card-header">사용자 등록/수정</div>
					<div class="card-body">
					<form>
						<div class="row">
							<div class="col-4">
								<label>사번(아이디)<span class="text-danger">*</span></label>
							</div>
							<div class="col-4">
								<label>비밀번호<span class="text-danger">*</span></label>
							</div>
							<div class="col-4">
								<label>이름<span class="text-danger">*</span></label>
							</div>
							<div class="col-4">
								<input type="text" class="form-control" name="user_id" id="user_id">
							</div>
							<div class="col-4">
								<input type="text" class="form-control" name="user_pw" id="user_pw">
							</div>
							<div class="col-4">
								<input type="text" class="form-control" name="user_name" id="user_name">
							</div>
							<div class="col-4">
								<label>직위</label>
							</div>
							<div class="col-4">
								<label>직책</label>
							</div>
							<div class="col-4">
								<label>직급</label>
							</div>
							<div class="col-4">
								<input type="text" class="form-control" name="first_position" id="first_position">
							</div>
							<div class="col-4">
								<input type="text" class="form-control" name="second_position" id="second_position">
							</div>
							<div class="col-4">
								<input type="text" class="form-control" name="third_position" id="third_position">
							</div>
							<div class="col-6">
								<label>Phone</label>
							</div>
							<div class="col-6">
								<label>Email</label>
							</div>
							<div class="col-6">
								<input type="text" class="form-control" name="phone" id="phone">
							</div>
							<div class="col-6">
								<input type="text" class="form-control" name="email" id="email">
							</div>
							<div class="col-6">
								<label>비고</label>
							</div>
							<div class="col-3">
								<label>상태<span class="text-danger">*</span></label>
							</div>
							<div class="col-3">
								<label>사용여부<span class="text-danger">*</span></label>
							</div>
							<div class="col-6">
									<input type="text" class="form-control" name="note" id="note">
							</div>
							<div class="col-3">
								<select class="form-select" name="state" id="state">
									<option value="1">Y</option>
									<option value="0">N</option>
								</select>
							</div>
							<div class="col-3">
								<select class="form-select" name="use_yn" id="use_yn">
									<option value="1">Y</option>
									<option value="0">N</option>
								</select>
							</div>
							<input type="text" style="display:none" value="0" name="submitcheck" id="submitcheck">
							<div class="col-12">
								<button class="btn btn-danger float-right" type="button" onclick="deletebutton()">삭제</button>
								<button class="btn btn-info float-right"
									style="margin-right: 5px;" type="submit" formaction="insert.jsp" formmethod="post">등록</button>
								<button class="btn btn-info float-right" type="reset" style="margin-right: 5px;" onclick="resetbutton()">초기화</button>
								<script>
								function deletebutton(){
									location.href="delete.jsp?p1="+document.getElementById('user_id').value;
								}
								
								//테이블 배경색 초기화
								function resetbutton(){
									var trs = document.querySelectorAll(".trs");
									for(var i=0; i<trs.length; i++){
										var item = trs.item(i);
										item.style.backgroundColor="white";
									}
								}
								</script>
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