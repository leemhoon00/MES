<!-- 나의 작업 일보 페이지 -->

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
<%
query = "select count(*) from mes.order";
rs=stmt.executeQuery(query);
rs.next();
int countorder = rs.getInt(1);
String[] ordername = new String[countorder];

query = "select * from mes.order";
rs=stmt.executeQuery(query);
int i=0;
while(rs.next()){
	ordername[i] = rs.getString("item_no");
	i++;
}

query = "select count(*) from mes.process";
rs=stmt.executeQuery(query);
rs.next();
int countprocess = rs.getInt(1);
String[] processname = new String[countprocess];

query = "select * from mes.process";
rs=stmt.executeQuery(query);
i=0;
while(rs.next()){
	processname[i] = rs.getString("process_name");
	i++;
}

query = "select count(*) from part";
rs=stmt.executeQuery(query);
rs.next();
int countpart = rs.getInt(1);
String[] partname = new String[countpart];
query = "select * from part";
rs=stmt.executeQuery(query);
i=0;
while(rs.next()){
	partname[i] = rs.getString("part_name");
	i++;
}

query = "select count(*) from facilities";
rs=stmt.executeQuery(query);
rs.next();
int countfacilities = rs.getInt(1);
String[] facilitiesname = new String[countfacilities];

query = "select * from facilities";
rs=stmt.executeQuery(query);
i=0;
while(rs.next()){
	facilitiesname[i] = rs.getString("facilities_name");
	i++;
}

//db 조회 상 마지막 행의 order번호
int datalastdivnum = 0;

//작업 추가했을때를 대비한 화면상의 마지막 행의 order번호
int lastdivnum = 0;



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


<title>Insert title here</title>
<link rel="stylesheet" href="../jhcss.css">
</head>
<body>
<script>
var countorder = <%=countorder%>;
var countprocess = <%=countprocess%>;
var countpart = <%=countpart%>;
var countfacilities = <%=countfacilities%>;
var ordername = new Array(countorder);
var processname = new Array(countprocess);
var partname = new Array(countpart);
var facilitiesname = new Array(countfacilities);
var ordertocom = new Map();
var i=0;

<%
query = "select * from mes.order";
rs=stmt.executeQuery(query);
while(rs.next()){
%>
ordertocom.set('<%=rs.getString("item_no")%>','<%=rs.getString("order_com_id")%>');
<%
}
for(i=0;i<ordername.length;i++){
%>
ordername[i] = "<%=ordername[i]%>";
i++;
<%}%>

i=0;
<%
for(i=0;i<processname.length;i++){
%>
processname[i] = "<%=processname[i]%>";
i++;
<%}%>

i=0;
<%
for(i=0;i<partname.length;i++){
%>
partname[i] = "<%=partname[i]%>";
i++;
<%}%>

i=0;
<%
for(i=0;i<facilitiesname.length;i++){
%>
facilitiesname[i] = "<%=facilitiesname[i]%>";
i++;
<%}
query = "select * from my_work";
rs=stmt.executeQuery(query);
%>
</script>

<label class="title" style="margin-left: 30px; margin-top: 10px;">나의 작업일보</label>
<div class="card">
	<div class="card-header">
		작업일보 등록/수정
	</div>
	<div class="card-body">
		<div class="form-inline" class="row">
			<div class="col-12" id="maindiv">
				<%
				while(rs.next()){
					datalastdivnum = rs.getInt("work_id");
					String workstart = rs.getString("work_start");
					String workend = rs.getString("work_end");
					if(workstart != null){
						workstart = workstart.substring(0,16);
						workstart = workstart.replace(" ","T");
					}
					if(workend != null){
						workend = workend.substring(0,16);
						workend = workend.replace(" ","T");
					}
					String tempstring="";
					if(rs.getString("status")==null){
						tempstring="";
					}
					else{
						tempstring=rs.getString("status");
					}
					String tempfaulty="";
					if(rs.getString("faulty")==null){
						tempfaulty="";
					}
					else{
						tempfaulty = rs.getString("faulty");
					}
				%>
				<div id='<%=datalastdivnum%>' style="<%=tempstring.equals("완료")?"display:none":""%>">
					<form>
						<input type="text" style="display:none" name="work_id" value="<%=datalastdivnum%>">
						<table class="table">
							<thead>
								<tr>
									<th>수주명</th>
									<th>부품명</th>
									<th>공정</th>
									<th>설비</th>
									<th>시작시간</th>
									<th>종료시간</th>
									<th style="width:5%">불량</th>
									<th>상태</th>
									<th></th>
									<th></th>
								</tr>
							</thead>
							
							<tbody>
								<tr>
									<td>
									
										<input type="text" class = "form-control" value="<%=rs.getString("order_name")%>" name="order_name" disabled>
									</td>
									<td>
										<input type="text" class = "form-control" value="<%=rs.getString("part_name") %>" name="part_name" disabled>
									</td>
									<td>
										<input type="text" class = "form-control" value="<%=rs.getString("process") %>" name="process" readonly>
									</td>
									<td>
										<input type="text" class = "form-control" value="<%=rs.getString("facilities") %>" name="facilities" disabled>
									</td>
									<td>
										<input type="datetime-local" class="form-control" value="<%=workstart%>" name="work_start">
									</td>
									<td>
										<input type="datetime-local" class="form-control" value="<%=workend%>" name="work_end">
									</td>
									<td>
										<input type="checkbox" <%=tempfaulty.equals("Y")?"checked":""%> name="faulty">
									</td>
									<td>
										<input type="text" class="form-control" value="<%=rs.getString("status")%>" name="status">
									</td>
									<td style="width:5%">
										<button class="btn btn-danger" type="submit" formaction="delete.jsp" formmethod="post">삭제</button>
									</td>
									<td style="width:5%">
										<button class="btn btn-info" type="submit" formaction="update.jsp" formmethod="post">수정</button>
									</td>
								</tr>
							</tbody>
						</table>
						
						<table class="table">
							<thead>
								<tr>
									<th>업체명</th>
									<th>도번</th>
									<th>수량</th>
									<th>CORE종류</th>
									<th>작업시간(H)</th>
									<th>실가공시간(H)</th>
									<th>무인가공시간(H)</th>
									<th>비가공시간(H)</th>
									<th>TOTAL작업시간(H)</th>
									<th>TOTAL가공시간(H)</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>
										<input type="text" class="form-control" value="<%=rs.getString("client")%>" readonly name="client">
									</td>
									<td>
										<input type="text" class="form-control" value="<%=rs.getString("dobun")%>" readonly name="dobun">
									</td>
									<td>
										<input type="text" class="form-control" value="<%=rs.getInt("quantity")%>" readonly name="quantity">
									</td>
									<td>
										<input type="text" class="form-control" value="<%=rs.getString("core")%>" readonly name="core">
									</td>
									<td>
										<input type="text" class="form-control" value="<%=rs.getString("work_time")%>" readonly name="work_time">
									</td>
									<td>
										<input type="text" class="form-control" value="<%=rs.getString("real_processing_time")%>" name="real_processing_time">
									</td>
									<td>
										<input type="text" class="form-control" value="<%=rs.getString("no_men_processing_time")%>" name="no_men_processing_time">
									</td>
									<td>
										<input type="text" class="form-control" value="<%=rs.getString("un_processing_time")%>" name="un_processing_time">
									</td>
									<td>
										<input type="text" class="form-control" value="<%=rs.getString("total_work_time")%>" readonly name="total_work_time">
									</td>
									<td>
										<input type="text" class="form-control" value="<%=rs.getString("total_processing_time")%>" readonly name="total_processing_time">
									</td>
								</tr>
							</tbody>
						</table>
					</form>
				</div>
				<%} %>
				<script>
				var lastdivnum = <%=datalastdivnum%>;
				</script>
			</div>
		</div>
		<div class="col-12 mb-3" style="border-bottom: 1px dashed #eee;"></div>
		<div>
			<button class="btn btn-info float-right" style="margin-right: 5px;" onclick="addbutton()">작업추가</button>
			<script>
			
			//작업추가 버튼
				function addbutton(){
					lastdivnum++;
					var template = document.getElementById('template').cloneNode(true);
					template.id=lastdivnum;
					template.style.display="";
					document.getElementById("maindiv").appendChild(template);
					document.getElementById(lastdivnum).children[0].children[0].value=lastdivnum;
					var tr1 = document.getElementById(lastdivnum).children[0].children[1].children[1].children[0];
					
					var sel1 = tr1.children[0].children[0];
					for(i=0;i<ordername.length;i++){
						var option = document.createElement("option");
						option.text = ordername[i];
						option.value = ordername[i];
						sel1.appendChild(option);
					}
					
					var sel2 = tr1.children[2].children[0];
					for(i=0;i<processname.length;i++){
						var option = document.createElement("option");
						option.text = processname[i];
						option.value = processname[i];
						sel2.appendChild(option);
					}
					
				}
				
			//수주가 바꼈을 때 부품명 셀렉트박스의 옵션값 업데이트
				function orderchange(element){
					var order = element.value;
					var com = ordertocom.get(order);
					element.parentNode.parentNode.parentNode.parentNode.parentNode.children[2].children[1].children[0].children[0].children[0].value=com;
					$.ajax({
						type:"GET",
			            url:"./partajax.jsp",
			            data:{order:order},
			            dataType:"html",
			            success:function(data){
			                $(element.parentNode.parentNode.children[1].children[0]).html(data);
			          }
			       });
				}
				
				//공정이 바꼈을 때 설비의 셀렉트박스의 옵션값 업데이트
				function processchange(element){
					var process = element.value;
					$.ajax({
						type:"GET",
			            url:"./facilityajax.jsp",
			            data:{process:process},
			            dataType:"html",
			            success:function(data){
			                $(element.parentNode.parentNode.children[3].children[0]).html(data);
			          }
			       });
				}
				
				
				function deletebutton(element){
					element.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.remove();
				}
			</script>
		</div>
	</div>
</div>

<!-- 작업 추가 버튼을 눌렀을 때 생성되는  div의 원본 템플릿 -->
<div id="template" style="display:none">
	<form>
		<input type="text" style="display:none" name="work_id">
		<table class="table">
			<thead>
				<tr>
					<th>수주명<span class="text-danger">*</span></th>
					<th>부품명</th>
					<th>공정<span class="text-danger">*</span></th>
					<th>설비</th>
					<th>시작시간</th>
					<th>종료시간</th>
					<th>불량</th>
					<th>상태</th>
					<th></th>
					<th></th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>
						<select class="form-select" onchange="orderchange(this)" name="order_name">
							<option value="">--선택--</option>
						</select>
					</td>
					
					<td>
						<select class="form-select" name="part_name">
							<option value="">--선택--</option>
						</select>
					</td>
					<td>
						<select class="form-select" name="process" onchange="processchange(this)">
							<option value="">--선택--</option>
						</select>
					</td>
					<td>
						<select class="form-select" name="facilities">
							<option value="">--선택--</option>
						</select>
					</td>
					<td>
						<input type="datetime-local" class="form-control" name="work_start">
					</td>
					<td>
						<input type="datetime-local" class="form-control" name="work_end">
					</td>
					<td>
						<input type="checkbox" name="faulty">
					</td>
					<td>
						<input type="text" class="form-control" readonly name="status">
					</td>
					<td>
						<button class="btn btn-danger" onclick="deletebutton(this)">삭제</button>
					</td>
					<td>
						<button class="btn btn-info" type="submit" formaction="insert.jsp" formmethod="post">등록</button>
					</td>
				</tr>
			</tbody>
		</table>
		
		<table class="table">
			<thead>
				<tr>
					<th>업체명</th>
					<th>도번</th>
					<th>수량</th>
					<th>CORE종류</th>
					<th>작업시간(H)</th>
					<th>실가공시간(H)</th>
					<th>무인가공시간(H)</th>
					<th>비가공시간(H)</th>
					<th>TOTAL작업시간(H)</th>
					<th>TOTAL가공시간(H)</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>
						<input type="text" class="form-control" readonly name="client">
					</td>
					<td>
						<input type="text" class="form-control" readonly name="dobun">
					</td>
					<td>
						<input type="text" class="form-control" readonly name="quantity">
					</td>
					<td>
						<input type="text" class="form-control" readonly name="core">
					</td>
					<td>
						<input type="text" class="form-control" readonly name="work_time">
					</td>
					<td>
						<input type="text" class="form-control" name="real_processing_time">
					</td>
					<td>
						<input type="text" class="form-control" name="no_men_processing_time">
					</td>
					<td>
						<input type="text" class="form-control" name="un_processing_time">
					</td>
					<td>
						<input type="text" class="form-control" readonly name="total_work_time">
					</td>
					<td>
						<input type="text" class="form-control" readonly name="total_processing_time">
					</td>
				</tr>
			</tbody>
		</table>
	</form>
</div>
<%
rs.close();
stmt.close();
conn.close();
%>
</body>
</html>