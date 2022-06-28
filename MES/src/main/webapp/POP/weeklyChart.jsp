<!--  
대시 보드 페이지 ajax 데이터 처리 입니다.
기능 : 주별 원형 차트 및 막대그래프로 주간 차트 표기
return : chart 1,2
@author : 양동빈 , fost008@gmail.com
@version 1
-->
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import="dbcon.dbcon"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.util.Locale"%>

<!DOCTYPE html>
<html>
<%
/****************선언 부 *****************/
dbcon db = new dbcon();
String val = request.getParameter("facilityname");
String date = request.getParameter("date");
SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
Date dayvalue = formatter.parse(date);
ArrayList<Long> chart2value = new ArrayList<Long>();// 막대 그래프 데이터 
long []chartAval = {0,0,0,0};

// 시작 날짜 종료 날짜 변수
String startDate = db.get_log_startdate(val);
String endDate = db.get_log_enddate(val);

// 시작 날짜 종료 날짜 비교 위해 포멧 변환
Date daystart = formatter.parse(startDate);
Date dayend = formatter.parse(endDate);
// 날짜 저장 위한 변수
ArrayList<String> datename = new ArrayList<String>();

//통합 날짜를 불러오기 위한 변수
int startdayval = -1;
int enddayval = 0;


// 일주일 전 을 시작지점으로
dayvalue.setDate(dayvalue.getDate()-6);
// 원형 차트 및 막대그래프 데이터 불러오는 부분
for(int i = 0;i<7;i++){
	System.out.println("포문 안");
	
	// 시작 날짜 종료 날짜 비교
	if(daystart.before(dayvalue) && dayend.after(dayvalue)||dayvalue.equals(daystart)||dayvalue.equals(dayend) ){
		// 시간 명칭 삽입 부
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(dayvalue);
		datename.add(calendar.getDisplayName(Calendar.DAY_OF_WEEK, Calendar.SHORT, Locale.US));
		
		//원형 차트 데이터 저장 부
		long []data2 = db.chart_A(val,formatter.format(dayvalue));
		chartAval[0]+=data2[0];
		chartAval[1]+=data2[1];
		chartAval[2]+=data2[2];
		
		//막대 차트 데이터 저장 부
		Double Dummy = Double.valueOf(data2[0]) + Double.valueOf(data2[1]) + Double.valueOf(data2[2]);// 데이터 %로 변환
		chart2value.add(Long.valueOf(Math.round((Double.valueOf(data2[0])/Dummy) * 100)));
		chart2value.add(Long.valueOf(Math.round((Double.valueOf(data2[1])/Dummy) * 100)));
		chart2value.add(Long.valueOf(Math.round((Double.valueOf(data2[2])/Dummy) * 100)));
		if (startdayval == -1) {//가로축 동적 생성을 위한 시작일 말일 저장
			startdayval = i;
			enddayval = i;
		} else {
			enddayval = i;
		}
	}
	
	dayvalue.setDate(dayvalue.getDate()+1);
	
}


long []data = chartAval;// 원형 차트 데이터


%>
<head>

</head>
<body>
<div id="chart"></div>
<!--  원형 차트  -->
<script>
var options = {
        series: [
        <%
        // 원형 차트 그래프 데이터 구현 부
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
      labels: [<%
               // 원형 차트 리스트 데이터 구현 부 
               // data[0] : ALARM
               // data[1] : STOP
               // data[2] : RUN
               // data[3] : NULL
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

<!-- 주간 차트 -->

					<div id="chart2" style="float: left;"></div>

<script>
        var options = {
          series: [{
          name: 'RUN',
          <%
          out.print("data: [");
          for(int i = 2;i<chart2value.size();i += 3){
          	out.print(chart2value.get(i));
          	if(i<chart2value.size()){
          		out.print(",");
          	}
          }
          out.println("]");
          %>
        }, {
          name: 'STOP',
          
          <%
          out.print("data: [");
          for(int i = 1;i<chart2value.size();i += 3){
          	out.print(chart2value.get(i));
          	if(i<chart2value.size()){
          		out.print(",");
          	}
          }
          out.println("]");
          %>
        }, {
            name: 'ALARM',
            <%
            out.print("data: [");
            for(int i = 0;i<chart2value.size();i += 3){
            	out.print(chart2value.get(i));
            	if(i<chart2value.size()){
            		out.print(",");
            	}
            }
            out.println("]");
            %>
          }
        ],
        colors:['#92d050', '#ffc000', '#ff0000'],
          chart: {
          type: 'bar',
          height: 250,
          width: '600%'
        },
        plotOptions: {
          bar: {
            horizontal: false,
            columnWidth: '60%',
            endingShape: 'rounded'
          },
        },
        dataLabels: {
          enabled: false
        },
        stroke: {
          show: true,
          width: 3,
          colors: ['transparent']
        },
        xaxis: {
          categories: [
        	  <%
        	  for(int i = 0; i<datename.size();i++){
        		  out.print("'"+datename.get(i)+"'");
        		  if(i<datename.size()-1){
        			  out.print(",");
        		  }
        	  }
        	  %>
        	  ],
        },
        yaxis: {
          title: {
            text: 'Time (%)'
          }
        },
        fill: {
          opacity: 1
        },
        tooltip: {
          y: {
            formatter: function (val) {
              return  val + " %"
            }
          }
        }
        };

        var chart = new ApexCharts(document.querySelector("#chart2"), options);
        chart.render();
      
      
</script>
</body>
</html>