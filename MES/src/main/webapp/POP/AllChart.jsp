<!--  
대시 보드 페이지 ajax 데이터 처리 입니다.
기능 : 모든 기기 일별 원형 차트 및 타임 라인 차트 표기
return : chart 1,2
@author : 양동빈 , fost008@gmail.com
@version 1
-->
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@ page import="dbcon.dbcon"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Vector"%>

<!DOCTYPE html>
<html>

<head>
</head>
<style>
table {
	width: 100%;
	height: 200px;
	margin: 30px;
}

td {
	width: 30%;
	height: 30%;
}
</style>
<body>
<!--  일별 설비 상태 파이 차트 출력부 (모든 기기)  
@author : 양동빈 , fost008@gmail.com
@param : String data(현재 날짜) 
@return : 모든 설비 일일 상태정보 차트 

주요 변수 : fac_list (모든 설비 이름), fac_status_list (모든 설비 상태 정보)
-->
	<%
	// 파라메터 수집 부
	String date = request.getParameter("date");//날짜 

	// 디비연결부
	dbcon dbcon_facility = new dbcon();

	// 디비 모든 설비 이름 불러오기
	Vector<String> fac_list = dbcon_facility.dashboard_combobox();

	// 에펙 차트 스크립트 선언
	out.println("<script type=\"text/javascript\" src=\"https://www.gstatic.com/charts/loader.js\"></script>");

	// 설비 목록 구현부
	for (int i = 0; i < fac_list.size(); i++) {

		/*************************************HTML 구현 부*************************************/
		out.println("<div style = \" float:left; width: 20%; margin: 50px;\">");
		out.println("<table>");
		out.println("<tr>");
		out.println("<th colspan= '2' style=\"font-size:18px\">"+fac_list.get(i)+"</th>");
		out.println("</tr>");
		out.println("<tr>");

		// 이미지 삽입 부 
		out.println("<td rowspan = '3'> <button style = \"width:120%;height:100%;background-color:transparent;\"  onClick= \" btnchartevent(' "+ fac_list.get(i) + "') \" >"
		+"<img src=\"machin.png\" width=\"100%\" height=\"100%\" "
		+" </button>");
		//notactive
		String now_status = dbcon_facility.get_facility_status(fac_list.get(i));
		// 이름 행
		out.println("</td>");
		out.print("<td><button class = ");
		if (!now_status.equals("1")) {
			out.print("\" notactive");
		}else{
			out.print("\" name");
		}
		
		out.println("\"></button>");
		out.println("</td>");

		out.println("</tr>");
		out.println("<tr>");

		// 일일 설비 가동 상태(%) 행
		out.print("<td> <button class = ");
		if (!now_status.equals("0")) {
			out.print("\" notactive");
		}else{
			out.print("\" per");
		}
		out.println("\"></button>");
		out.println("</td>");

		out.println("</tr>");
		out.println("<tr>");

		// 현재 기기 상태 행
		out.print("<td> <button class = ");
		if (!now_status.equals("-1")) {
			out.print("\" notactive");
		}else{
			out.print("\" status_y");
		}
		out.println("\"></button>");
		out.println("</td>");

		out.println("</tr>");
		out.println("</table>");
		
		// 디비 연결 문
		dbcon db2 = new dbcon();
		// 디비에서 모든 설비 일일 상태 정보 불러오기
		ArrayList<String> fac_status_list = db2.chart_B(fac_list.get(i), date);
		
		// 해당 날짜에 기기 상태 값이 없을 경우 차트 랜더하지않음.
		if (fac_status_list.size() > 4) {
		out.println("<div id=\"chart" + i + "\" style = \"margin-left:30px;width:113%; \" ></div>");
		}
		out.println("</div>");

		/*************************************스크립트 구현 부*************************************/

		if (fac_status_list.size() > 4) {// 그래프 표시 분기점.
			// 차트를 그려줄 div [동적 생성]
			
			// 하단 공통 부분 (스크립트)
			out.print(
			"<script type= \"  text/javascript \" > google.charts.load(\"current\", {packages:[\"timeline\"]}); google.charts.setOnLoadCallback(drawChart); function drawChart() { var container = document.getElementById('chart"
					+ i
					+ "'); var chart = new google.visualization.Timeline(container);					    var dataTable = new google.visualization.DataTable();					    dataTable.addColumn({ type: 'string', id: 'Role' });					    dataTable.addColumn({ type: 'string', id: 'Name' });					    dataTable.addColumn({ type: 'string', id: 'style', role: 'style' });					    dataTable.addColumn({ type: 'date', id: 'Start' });					    dataTable.addColumn({ type: 'date', id: 'End' });					    dataTable.addRows([");

			// 실제 데이터 삽입 부
			for (int j = 0; j < fac_status_list.size(); j += 3) {

		if (fac_status_list.get(j) != "-100") {
			out.print("[ 'Time', ");
		}
		if (fac_status_list.get(j).equals("-1")) {
			out.print("'ALARM' , '#ff0000',");
		} else if (fac_status_list.get(j).equals("0")) {
			out.print("'STOP' , '#ffc000',");
		} else if (fac_status_list.get(j).equals("1")) {
			out.print("'RUN' , '#92d050',");
		}
		if (fac_status_list.get(j) != "-100") {
			out.print("new Date('" + fac_status_list.get(j + 1) + "'), new Date('" + fac_status_list.get(j + 2)
					+ "') ]");
			if (fac_status_list.size() - 3 == j) {
				out.println("");
			} else {
				out.println(",");
			}
		}

			}

			// 하단 공통 부분 (스크립트)
			out.print(
			"]);  var options = { timeline: { groupByRowLabel: true }};chart.draw(dataTable, options);} </script> ");
			out.print("</div>");
		}

	}
	%>



</body>
</html>