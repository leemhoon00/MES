<!--  
대시 보드 페이지 ajax 데이터 처리 입니다.
기능 : 일별 원형 차트 및 타임 라인 차트 표기
return : chart 1,2
@author : 양동빈 , fost008@gmail.com
@version 1
-->
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import="dbcon.dbcon"%>
<%@ page import="java.util.ArrayList"%>

<!DOCTYPE html>
<html>
<%
dbcon db = new dbcon();
String val = request.getParameter("facilityname");
String date = request.getParameter("date");
long []data = db.chart_A(val,date);

dbcon db2 = new dbcon();
ArrayList<String> data2 = db2.chart_B(val, date);
%>
<head>

</head>
<body>
<div id="chart"></div>
<!--  원형 차트  -->
<script>
var options = {
        series: [<% 
                 // 차트 목록 부분 데이터 구현 부 
                 // data[0] : ALARM
                 // data[1] : STOP
                 // data[2] : RUN
                 // data[3] : NULL
                 out.print(Long.toString(data[2])+","+Long.toString(data[1])+","+Long.toString(data[0])); 
                 %>],
        colors:['#92d050', '#ffc000', '#ff0000'],
        chart: {
        width: 370,
        type: 'pie',
      },
      labels: [
      <% // 원형 차트 그래프 부분 데이터 구현 부
      		out.print
          ("'RUN "+Long.toString(data[2]/60/60)+"h "+Long.toString(data[2]/60%60)+"m'"+","+
           "'STOP "+Long.toString(data[1]/60/60)+"h "+Long.toString(data[1]/60%60)+"m'"+","+
           "'ALARM "+Long.toString(data[0]/60/60)+"h "+Long.toString(data[0]/60%60)+"m'"
		  ); %>],
      responsive: [{
        breakpoint: 100,
        options: {
          chart: {
            width: 200
          },
          legend: {
            position: 'bottom'
          }
        }
      }]
      };

      var chart = new ApexCharts(document.querySelector("#chart"), options);
      chart.render();
</script>




<div id="chart2" style ="width:100%;"></div>
<!--  타임 라인 차트  -->
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript">
  google.charts.load("current", {packages:["timeline"]});
  google.charts.setOnLoadCallback(drawChart);
  function drawChart() {
    var container = document.getElementById('chart2');
    var chart = new google.visualization.Timeline(container);
    var dataTable = new google.visualization.DataTable();

    dataTable.addColumn({ type: 'string', id: 'Role' });
    dataTable.addColumn({ type: 'string', id: 'Name' });
    dataTable.addColumn({ type: 'string', id: 'style', role: 'style' });
    dataTable.addColumn({ type: 'date', id: 'Start' });
    dataTable.addColumn({ type: 'date', id: 'End' });
    dataTable.addRows([
    	
      <%
      // 차트 목록 부분 데이터 구현 부 
      // data[0] : ALARM
      // data[1] : STOP
      // data[2] : RUN
      // data[3] : NULL
      // 배열 내부의 스테이터스에 따라 분기  
      for(int i = 0; i<data2.size(); i+=3){
    	  if(!data2.get(i).equals("-100")){
    		  out.print("[ 'Time', ");
    	  }
    	  
    	  if(data2.get(i).equals("-1")){
    		  out.print("'ALARM' , '#ff0000',");
    	  }else if(data2.get(i).equals("0")){
    		  out.print("'STOP' , '#ffc000',");
    	  }else if(data2.get(i).equals("1")){
    		  out.print("'RUN' , '#92d050',");
    	  }
    	  if(!data2.get(i).equals("-100")){
    		  out.print("new Date('"+ data2.get(i+1)+"'), new Date('"+data2.get(i+2)+"') ]");
        	  if(data2.size()-3 == i){
        		  out.println("");
        	  }else{
        		  out.println(",");
        	  }
    	  }
    	  
      }
      %>
      ]);

    var options = {
      timeline: { groupByRowLabel: true }
    };

    chart.draw(dataTable, options);
  }
</script>
</body>
</html>