<!-- 전달 받은 두 날짜로 설비 가동 현황 계산 -->

<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.Statement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import="java.text.ParseException"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
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
	
	String date1 = request.getParameter("date1");
	String date2 = request.getParameter("date2");
	String strFormat = "yyyy-MM-dd";
	SimpleDateFormat sdf = new SimpleDateFormat(strFormat);
	Date d1 = sdf.parse(date1);
	Date d2 = sdf.parse(date2);
	
	long totalday = (long)(d2.getTime() - d1.getTime()) / (24*60*60*1000)+1;
	
	
	strFormat = "yyyy-MM-dd HH:mm:ss";
	sdf = new SimpleDateFormat(strFormat);
	d1 = sdf.parse(date1+" 00:00:00");
	d2 = sdf.parse(date2+" 23:59:59");
	query = "select count(*) from facilities";
	rs=stmt.executeQuery(query);
	
	int facilitycount =0;
	if(rs.next()){facilitycount = rs.getInt(1);}
	query = "select * from facilities";
	rs=stmt.executeQuery(query);
	String[] facilityname = new String[facilitycount];
	
	int i=0;
	while(rs.next()){
		facilityname[i] = rs.getString("facilities_name");
		i++;
	}
	i=0;
	
	String[][] array = new String[facilitycount+1][3];
	array[0][0] = "";
	array[0][1] = "가동";
	array[0][2] = "비가동";
	
	SimpleDateFormat dateParser = new SimpleDateFormat("yy-MM-dd HH:mm:ss");
	double sumon=0;
	double sumoff=0;
	double averageon=0;
	double averageoff=0;
	
	for(i=0;i<facilitycount;i++){
		int totaltemp=-1;
		double ontimeday=0;
		double offtimeday=0;
		query = "select count(*) from facility_time where facility_name='"+facilityname[i]+"' and DATE(f_time) between '"+date1+"' and '"+date2+"'";
		rs=stmt.executeQuery(query);
		if(rs.next()){
			if(rs.getInt(1)==0){
				totaltemp=-1;
			}
			else{
				totaltemp = rs.getInt(1);
			}
			
		}
		query = "select * from facility_time where facility_name='"+facilityname[i]+"' and DATE(f_time) between '"+date1+"' and '"+date2+"'";
		rs=stmt.executeQuery(query);
		int temp=0;
		long ontimesecond=0;
		String previous="";
		if(totaltemp == -1){
			query = "select * from facility_time where facility_name='"+facilityname[i]+"' order by num desc limit 1";
			rs=stmt.executeQuery(query);
			if(rs.next()){
				if(rs.getString("status").equals("가동")){
					ontimeday = totalday;
					offtimeday=0;
					
				}
				else{
					ontimeday=0;
					offtimeday=totalday;
				}
			}
		}
		else{
			while(rs.next()){
				if(temp==0){
					if(rs.getString("status").equals("비가동")){
						ontimesecond += (sdf.parse(rs.getString("f_time")).getTime() - d1.getTime()) / (1000);
					}
					else{
						previous = rs.getString("f_time");
					}
					temp++;
				}
				else{
					if(rs.getString("status").equals("비가동")){
						ontimesecond += (sdf.parse(rs.getString("f_time")).getTime() - sdf.parse(previous).getTime()) / (1000);
					}
					else{
						if((temp+1)==totaltemp){
							ontimesecond += (d2.getTime() - sdf.parse(rs.getString("f_time")).getTime()) / 1000;
						}
						else{
							previous = rs.getString("f_time");
						}
						
					}
					temp++;
				}
			}
			
			
			ontimeday = Math.round(ontimesecond / (60.0*60*24) * 100.0) / 100.0;
			offtimeday = Math.round(((double)totalday - ontimeday )* 100.0) / 100.0;
			
		}
		
		
		array[i+1][0] = facilityname[i];
		array[i+1][1] = String.valueOf(ontimeday);
		array[i+1][2] = String.valueOf(offtimeday);
		sumon+=ontimeday;
		sumoff+=offtimeday;
		averageon = Math.round((double)sumon/(double)totalday * 100.0) / 100.0;
		averageoff = Math.round((double)sumoff/(double)totalday * 100.0) / 100.0;
	}
	
%>
<script type="text/javascript">

var facilitycount = <%=facilitycount%>

var array = new Array(facilitycount+1);
for(var i=0;i<facilitycount+1;i++){
	array[i] = new Array(3);
}

<%
for(i=0;i<facilitycount+1;i++){
	for(int j=0;j<3;j++){
%>



array[<%=i%>][<%=j%>] = '<%=array[i][j]%>';


<%      }
	}%>
	
	
	for(var i=0; i<facilitycount+1;i++){
		for(var j=0;j<3;j++){
			if(i!=0 && j!=0){
				array[i][j] = parseFloat(array[i][j]);
			}
		}
	}
	
	
	//구글 차트
	google.charts.load('current', {'packages':['bar']});
    google.charts.setOnLoadCallback(drawChart);

    function drawChart() {
    	 var data = google.visualization.arrayToDataTable(array);


    	 var options = {
    	         chart : {
    	            title : '',
    	         }
    	      };


      var chart = new google.charts.Bar(document.getElementById('columnchart_material'));

      chart.draw(data, google.charts.Bar.convertOptions(options));
    }
</script>
</head>
<body>
	<!-- 차트 영역 -->
	<div class="card">
		<div class="card-body" id="columnchart_material">
		
		</div>
	</div>
	
	<div class="card">
		<div class="card-body">
			<table class="table table-bordered table-hover" style="width:100%">
				<thead></thead>
				<tbody>
					<tr>
						<th class="bg-primary" style="width:20%; color:white">합계(일)</th>
						<th class="bg-primary" style="width:20%; color:white">가동</th>
						<th style="width:20%"><%=sumon %></th>
						<th class="bg-primary" style="width:20%; color:white">비가동</th>
						<th style="width:20%"><%=sumoff %></th>
					</tr>
					<tr>
						<th class="bg-primary" style="width:20%; color:white">평균(일)</th>
						<th class="bg-primary" style="width:20%; color:white">가동</th>
						<th style="width:20%"><%=averageon %></th>
						<th class="bg-primary" style="width:20%; color:white">비가동</th>
						<th style="width:20%"><%=averageoff %></th>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
	
	<%
	rs.close();
	stmt.close();
	conn.close();
	%>
</body>
</html>