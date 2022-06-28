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
	Statement stmt2 = null;
	ResultSet rs = null;
	ResultSet rs2 = null;
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
rs = stmt.executeQuery(query);
i = 0;

while(rs.next()){
	processname[i] = rs.getString("process_name");
	i++;
}

query = "select * from facilities";
rs = stmt.executeQuery(query);
String processtotaljson = "{";
while(rs.next()){
	processtotaljson += "\"" + rs.getString("b_num") + "\":\"" + rs.getString("facilities_name") + "\",";
}
processtotaljson = processtotaljson.substring(0, processtotaljson.length() - 1);
processtotaljson += "}";


query = "select * from part";
rs = stmt.executeQuery(query);
String parttotaljson = "{";
while(rs.next()){
	parttotaljson += "\"" + rs.getString("b_num") + "\":\"" + rs.getString("part_name") + "\",";
}
parttotaljson = parttotaljson.substring(0, parttotaljson.length() - 1);
parttotaljson += "}";

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

query = "select * from parts_by_order where order_status='내부'";
rs = stmt.executeQuery(query);
String partjson = "{";
while(rs.next()){
	partjson += "\"" + rs.getString("part") + "\":\"" + rs.getString("order") + "\",";
}
partjson = partjson.substring(0, partjson.length() - 1);
partjson += "}";

query = "select * from process_multi where sortation='f'";
rs=stmt.executeQuery(query);
String processjson = "";
processjson += "{";
while(rs.next()){
	processjson += "\"" + rs.getString("sub_proc") + "\":\"" + rs.getString("proc_name") + "\",";
}
processjson = processjson.substring(0, processjson.length() - 1);
processjson += "}";

int datalastdivnum = 0;
int lastdivnum = 0;
%>
<%-- JSON.parse(<%=result%>) --%>


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

	<script type="text/javascript" src="jquery-3.2.1.min.js"></script>
    <script type="text/javascript" src="barcode-reader-1.0.0.total.js"></script>
    <script type="text/javascript">
		partjson = JSON.parse('<%=partjson%>');
		processjson = JSON.parse('<%=processjson%>');
		parttotaljson = JSON.parse('<%=parttotaljson%>');
		processtotaljson = JSON.parse('<%=processtotaljson%>');
		
        barcodeReaderCallback = function(data) {
			var code = data.substr(0, 2);
			// 55 : 명령어 
			// 23 : 부품
			// 71 : 사용자
			// 14 : 설비
			
			if (data.length != 13) { 
				return;
			}

			// 맨 마지막은 Checksum 이므로 지움.
			// 맨 앞은 명령어 세트 이므로 지움.
			data = data.substr(2, data.length - 3);
			var uniqueId = parseInt(data);

			console.log(code);
			console.log(uniqueId);

			// 명령어
			if (code == "55") { 
				const offset = new Date().getTimezoneOffset() * 60000;
				const today = new Date(Date.now() - offset);
				// 현재 시간 입력 코드 작성
				if (uniqueId == 3) { 
					$("#absolute_starttime")[0].value = today.toISOString().slice(0, -8)
				} // 종료 시간 입력 코드 작성
				else if (uniqueId == 4) { 
					$("#absolute_endtime")[0].value = today.toISOString().slice(0, -8)
					} // 등록 버튼 코드 작성
				else if (uniqueId == 5) { 
					$("#absolute_submit")[0].click();
				} // 뒤로 가기 코드
				else if (uniqueId == 6) { 
					history.back();
				}
			}
			// 부품
			else if (code == "23") { 
				// 부품 추가하는 코드 작성함.
				console.log(parttotaljson[uniqueId])
				console.log(parttotaljson)
				console.log(partjson[parttotaljson[uniqueId]])
				var tr1 = document.getElementById(lastdivnum).children[0].children[1].children[1].children[0];
				var sel0 = tr1.children[0].children[0];
				var sel1 = tr1.children[1].children[0];
				sel0.value = partjson[parttotaljson[uniqueId]]
				sel1.value = parttotaljson[uniqueId]

				// orderchange(this);
			}
			// 설비
			else if (code == "14") { 
				// 설비 추가하는 코드 작성함.
				console.log(processtotaljson)
				console.log(processtotaljson[uniqueId])
				console.log(processjson)
				console.log(processjson[processtotaljson[uniqueId]])

				var tr1 = document.getElementById(lastdivnum).children[0].children[1].children[1].children[0];
				var sel0 = tr1.children[2].children[0];
				var sel1 = tr1.children[3].children[0];
				sel0.value = processjson[processtotaljson[uniqueId]]
				sel1.value = processtotaljson[uniqueId]
			}
			// 사용자 입력
			else if (code == "71") { 
				// 사용자.. 정보는 왜 필요할까? 추가하는 코드 작성함.
			}
			

        }
    </script>


<title>Insert title here</title>
<link rel="stylesheet" href="../jhcss.css">
</head>
<body>
<script>
var countorder = <%=countorder%>;
var processname = new Array(<%=countprocess%>);
var countfacilities = <%=countfacilities%>;
var ordername = new Array(countorder);
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
				} 
				%>
				<script>
				var lastdivnum = <%=datalastdivnum%>;
				</script>
			</div>
		</div>
		<div class="col-12 mb-3" style="border-bottom: 1px dashed #eee;"></div>
		<div>
			<%-- <button class="btn btn-info float-right" style="margin-right: 5px;" onclick="addbutton()">작업추가</button> --%>
			<script>
				function orderchange(element){
					var order = element.value;
					var com = ordertocom.get(order);
					element.parentNode.parentNode.parentNode.parentNode.parentNode.children[2].children[1].children[0].children[0].children[0].value=com;
				}

				function addbutton(){
					lastdivnum++;
					var template = document.getElementById('template').cloneNode(true);
					template.id=lastdivnum;
					template.style.display="";
					document.getElementById("maindiv").appendChild(template);
					document.getElementById(lastdivnum).children[0].children[0].value=lastdivnum;
					var tr1 = document.getElementById(lastdivnum).children[0].children[1].children[1].children[0];

					var sel1 = tr1.children[0].children[0];
					for(i = 0; i < ordername.length; i++){
						var option = document.createElement("option");
						option.text = ordername[i];
						option.value = ordername[i];
						sel1.appendChild(option);
					}

					var partdata = Object.keys(partjson);
					var sel2 = tr1.children[1].children[0];
					for(i = 0; i < partdata.length; i++){
						var option = document.createElement("option");
						option.text = partdata[i];
						option.value = partdata[i];
						sel2.appendChild(option);
					}
					
					var sel3 = tr1.children[2].children[0];
					for(i=0;i<processname.length;i++){
						var option = document.createElement("option");
						option.text = processname[i];
						option.value = processname[i];
						sel3.appendChild(option);
					}

					var processdata = Object.keys(processjson);
					var sel4 = tr1.children[3].children[0];
					for(i=0;i<processdata.length;i++){
						var option = document.createElement("option");
						option.text = processdata[i];
						option.value = processdata[i];
						sel4.appendChild(option);
					}

					tr1.children[4].children[0].id = "absolute_starttime";
					tr1.children[5].children[0].id = "absolute_endtime";
					tr1.children[8].children[0].id = "absolute_submit";
				}
			</script>
		</div>
	</div>
</div>
<div id="template" style="display:none">
	<form>
		<input type="text" style="display:none" name="work_id">
		<table class="table">
			<thead>
				<tr>
					<th>수주명<span class="text-danger">*</span></th>
					<th>부품명</th>
					<th>공정<span class="text-danger">*</span></th>
					<th>설비<span class="text-danger">*</span></th>
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
						<%-- <select class="form-select" onchange="orderchange(this)" name="order_name"> --%>
						<select class="form-select" name="order_name" onchange="orderchange(this)">
							<option value="">--선택--</option>
						</select>
					</td>
					
					<td>
						<select class="form-select" name="part_name">
							<option value="">--선택--</option>
						</select>
					</td>
					<td>
						<%-- <select class="form-select" name="process" onchange="processchange(this)"> --%>
						<select class="form-select" name="process">
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
<div style="display: flex; justify-content: center;">
	<img src="./resources/55_3_starttime.png" style="margin: 10px;">
	<img src="./resources/55_4_endtime.png" style="margin: 10px;">
	<img src="./resources/55_5_apply.png" style="margin: 10px;">
	<img src="./resources/55_6_previous.png" style="margin: 10px;">
</div>
<script>
addbutton();
</script>
</body>
</html>