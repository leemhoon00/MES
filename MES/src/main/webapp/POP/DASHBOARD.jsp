<!--  
대시 보드 페이지 입니다.
기능 : POP 회원일 경우 들어올 수 있으며 기계 설비의 상태 정보를 일별로 확인 가능합니다.

@author : 양동빈 , fost008@gmail.com
@version 0.7
work list
전체 조회시 (완)
-기계 아이콘 우측은 삼색등 아이콘
-해당 설비 이미지 클릭시 해당 설비의 일별 레포트 출력 

주별 조회 시 (완)
-주별 차트는 현재 일자에서 - 7 (월 상관 없음)
-하단 차트 요일 표현
-하단 차트 하루 기준 하루의 %

달별 설비 상태 검색 페이지(완)
-Time은 총 가동시간이고 Ratio는 그 달에서 Run 상태였던 시간 총합이며 날짜는 검색 날짜입니다
-달별 검색 시 반드시 해당 달의 1일 검색.
-달력도 달별 선택 달력을 사용해주었으면 좋겠다. 
-하단 차트 세로축 가동률 하루 기준 %

공통 페이지 (완)
-설비 검색 조건 콤보 박스 고정 식
-반응 형 웹 필요없음

주별 차트,달별 차트 (완)
- 데이터 없을 경우 해당 날자만 표기 안되는 것이 아닌 한개의 날짜만 표기가 안되는 현상 

공통 페이지 (완)
- 검색 모드에 따라 타이틀 이름 바뀌게
- 검색 및 랜더링 시간이 길어 기존의 change 방식이 아닌 검색 버튼 구현을 통해 onclick 방식으로 변경

주,달,일 별 차트 (완)
- 검색 조건에 따라 달력 좌측에 검색 된 날짜 표기

달별 차트 (완)
-Time,Ratio,Date 표기하기.

-->
<%@ page import="javax.security.auth.callback.ConfirmationCallback"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="company.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="dbcon.dbcon"%>
<%@ page import="java.util.Vector"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>

<jsp:useBean id="companyDAO" class="company.companyDAO" scope="page" />
<!DOCTYPE html>
<html>
<head>
<%
request.setCharacterEncoding("UTF-8");
%>

<meta charset="UTF-8">
<!--jquery-->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"
	integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4="
	crossorigin="anonymous"></script>

<!--bootstrap-->
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css">
<link rel="stylesheet" href="companycontent.css?ver02">
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>

<script type="text/javascript"
	src="https://cdn.jsdelivr.net/jquery/latest/jquery.min.js"></script>
<script type="text/javascript"
	src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
<script type="text/javascript"
	src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
<link rel="stylesheet" type="text/css"
	href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />

<script
	src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.15.5/xlsx.full.min.js"></script>


<!-- apex차트 관련 임폴트 -->

<style>
#chart {
	padding: 0;
	max-width: 380px;
	margin: 35px auto;
}
.name {
  margin-left:50px;
  margin-right:30px;
  background-color: #0ed145;
  box-shadow: rgba(44, 187, 99, .2) 0 -25px 18px -14px inset,rgba(44, 187, 99, .15) 0 1px 2px,rgba(44, 187, 99, .15) 0 2px 4px,rgba(44, 187, 99, .15) 0 4px 8px,rgba(44, 187, 99, .15) 0 8px 16px,rgba(44, 187, 99, .15) 0 16px 32px;
  color: green;
  cursor: pointer;
  display: inline-block;
  font-family: CerebriSans-Regular,-apple-system,system-ui,Roboto,sans-serif;
  padding: 7px 20px;
  text-align: center;
  text-decoration: none;
  transition: all 250ms;
  border: 0;
  font-size: 16px;
  user-select: none;
  -webkit-user-select: none;
  touch-action: manipulation;
  width: 100%;
  height: 100%; 

}

.per {
  margin-left:50px;
  margin-right:30px;
  background-color: #fff200;
  /*border-radius: 100px;*/
  box-shadow: rgba(181, 176, 74, .2) 0 -25px 18px -14px inset,rgba(181, 176, 74, .15) 0 1px 2px,rgba(181, 176, 74, .15) 0 2px 4px,rgba(181, 176, 74, .15) 0 4px 8px,rgba(181, 176, 74, .15) 0 8px 16px,rgba(181, 176, 74, .15) 0 16px 32px;
  color: yellow;
  cursor: pointer;
  display: inline-block;
  font-family: CerebriSans-Regular,-apple-system,system-ui,Roboto,sans-serif;
  padding: 7px 20px;
  text-align: center;
  text-decoration: none;
  transition: all 250ms;
  border: 0;
  font-size: 16px;
  user-select: none;
  -webkit-user-select: none;
  touch-action: manipulation;
  width: 100%;
  height: 100%;
}
.status_y {
  margin-left:50px;
  margin-right:30px;
  background-color: #ec1c24;
  /* border-radius: 100px; */
  box-shadow: rgba(181, 72, 76, .2) 0 -25px 18px -14px inset,rgba(181, 72, 76, .15) 0 1px 2px,rgba(181, 72, 76, .15) 0 2px 4px,rgba(181, 72, 76, .15) 0 4px 8px,rgba(181, 72, 76, .15) 0 8px 16px,rgba(181, 72, 76, .15) 0 16px 32px;
  color: red;
  cursor: pointer;
  display: inline-block;
  font-family: CerebriSans-Regular,-apple-system,system-ui,Roboto,sans-serif;
  padding: 7px 20px;
  text-align: center;
  text-decoration: none;
  transition: all 250ms;
  border: 0;
  font-size: 16px;
  user-select: none;
  -webkit-user-select: none;
  touch-action: manipulation;
  width: 100%;
  height: 100%;
}
.notactive {
  margin-left:50px;
  margin-right:30px;
  opacity:0.1;
  background-color: black;
  /* border-radius: 100px; */
  color: green;
  cursor: pointer;
  display: inline-block;
  font-family: CerebriSans-Regular,-apple-system,system-ui,Roboto,sans-serif;
  padding: 7px 20px;
  text-align: center;
  text-decoration: none;
  transition: all 250ms;
  border: 1;
  font-size: 16px;
  user-select: none;
  -webkit-user-select: none;
  touch-action: manipulation;
  width: 100%;
  height: 100%;
}


</style>

<script>
	window.Promise
			|| document
					.write('<script src="https://cdn.jsdelivr.net/npm/promise-polyfill@8/dist/polyfill.min.js"><\/script>')
	window.Promise
			|| document
					.write('<script src="https://cdn.jsdelivr.net/npm/eligrey-classlist-js-polyfill@1.2.20171210/classList.min.js"><\/script>')
	window.Promise
			|| document
					.write('<script src="https://cdn.jsdelivr.net/npm/findindex_polyfill_mdn"><\/script>')
</script>
<script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>
<script>
	// 샘플 차트 출력시 필요한 랜덤 데이터 
	// 차트 테스트 용이니 언제든 삭제 
	var _seed = 42;
	Math.random = function() {
		_seed = _seed * 16807 % 2147483647;
		return (_seed - 1) / 2147483646;
	};
</script>
<!-- apex차트 관련 종료 -->

<!-- 구글 차트 관련 -->
<script type="text/javascript"
	src="https://www.gstatic.com/charts/loader.js"></script>
</head>

<body>
	<div class=title>KMM</div>
	<div class="panel panel-default border searchbox">
		<div class="panel-body">
			검색 &nbsp;&nbsp; <select name="mode" class="form-control searchtitle"
				id="target">
				<option value="NONE">==전체==</option>
				<%
				// 최상단 기기 설비 이름 콤보 박스 구현 부 
				dbcon cbbox = new dbcon();
				Vector<String> M_combobox = cbbox.dashboard_combobox();

				for (int i = 0; i < M_combobox.size(); i++) {
					out.println("<option value=\"" + M_combobox.get(i) + "\">" + M_combobox.get(i) + "</option>");
				}
				%>
			</select>
			<button class="btn btn-lg btn-primary" id="search">검색</button>
			<h5 class="panel-title" style="display: inline-block; float: right">(주)와이제이솔루션</h5>


		</div>
	</div>

	<div class="row">
		<div class="panel panel-default border companylistbox col-md-6"
			style="width: 98vw">
			<div class="panel-heading">
				<div style="text-align: center">
				
				<!-- 검색 모드 설정 (전체,일별,주별,달별) -->
					<select id="mode" class="form-control searchtitle"
						style="float: right">
						<option value="none">All</option>
						<option value="day">Daily</option>
						<option value="Week">Weekly</option>
						<option value="Month">Monthly</option>
					</select>
				
				
					<%
					// 일자 검색 조건에 페이지 로드 시 오늘 날짜 불러오는 부분
					Date now = new Date();
					SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
					SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-'W'ww");
					%>
					<!-- 검색 조건 설정 일자 -->
					<input type="date" id="date"
						class="form-control searchtitle"
						value="<%out.print(format.format(now));%>" style="float: right">
					<!-- 검색 조건 설정 월별 -->
					<input type="month" id="month"
						class="form-control searchtitle" style="float: right" >
						<h5 id="showdate" style="float: right;margin-right:10px;"><h5>
				</div>



				<h5 class="panel-title" style="display: inline-block; "id="title">Report</h5>


			</div>
			<div class="panel-body">
				<div id="companyt">
				
				<!-- 차트 불러오는 도입 부  -->
					<div id="test"></div>


				</div>
			</div>
		</div>
	</div>
</body>
<script>
/**************************** 검색 조건 변경 시 차트 표현 트리거 ***************************/
// 공통적으로 chart_draw 함수를 부르며 해당 함수 내에서 분기
/* 	// 설비 명 변경 시 [버튼 방식으로 변경]
	$('#target').change(function() { // 기기 설비 명 변경 시
		$(this).trigger('chart_draw');
	});
	// 일자 변경 시 [버튼 방식으로 변경]
	$('#date').change(function() { // 달력 변경 시 
		$(this).trigger('chart_draw');
	}); */
	// 검색 버튼 클릭시
	$('#search').click(function() {
		$(this).trigger('chart_draw');
	});
	// 모드 변경 시
	$('#mode').change(function() {
		if($('#mode').val() == "Month"){
			$('#month').val(formatDatemonth($('#date').val()));
			$('#date').hide();
			$('#month').show();
		}else{
			if($('#month').css('display')!="none"){
			$('#date').val(formatDateday($('#month').val()));
			}
			$('#date').show();
			$('#month').hide();
		}
		
	});
	// 화면 크기 변동 시 (사용 안함.)
/* 	$(window).resize(function() {
		if (this.resizeTO)
			clearTimeout(this.resizeTO);
		this.resizeTO = setTimeout(function() {
			$(this).trigger('chart_draw');
		}, 500);
	});
	 */
	 
	 
/**************************** 함수 구현 부 ***************************/
 	$(document).ready(function() {
 		if($('#mode').val() != "Month"){
 			
 			$('#month').hide();
 		}
 		if($('#mode').val() == "none"){
 			
			 $(this).trigger('chart_draw');
		 }
 		function Dailychart_event(){
 			$(this).trigger('Dailychart_draw');
 		}
 		btnchartevent_action = Dailychart_event;
 		
 	});
	// 공통 분기 함수
	$(window).on('chart_draw', function() {  
		$('#test').text("데이터를 불러오는 중입니다... 잠시만 기다려주세요...");
		if ($('#mode').val() == "none") {
			$('#title').text("DashBoard");
			$(this).trigger('allchart_draw');
			showdatechange("all");
			
		} else if ($('#mode').val() == "day") {
			$('#title').text("Daily Report");
			$(this).trigger('Dailychart_draw');
			showdatechange("day");
			
		} else if ($('#mode').val() == "Week") {
			$('#title').text("Weekly Operating Ratio");
			$(this).trigger('weeklychart_draw');
			showdatechange("week");
			
		} else if ($('#mode').val() == "Month") {
			$('#title').text("Monthly Operating Ratio");
			$(this).trigger('Monthchart_draw');
			showdatechange("month");
			
		}
	});

	
	/*
	 * allchart_draw : 메인 화면 차트
	 * Dailychart_draw : 데일리 차트 
	 * weeklychart_draw : 주간 차트
	 * Monthchart_draw : 달별 차트
	 * 공통 div 태그 id = test 에 차트 그리기.
	 */
	$(window).on('allchart_draw', function() {
		$.ajax({
			url : "AllChart.jsp",
			data : {
				date : $('#date').val()
			},
			datatype : "html",
			type : "POST",
			success : function(data) {
				$("#test").html(data);
			},
			error : function() {
				alert('allchart_draw ajax 함수 에러');
			}
		});
	});
	$(window).on('Dailychart_draw', function() {
		$.ajax({
			url : "DailyChart.jsp",
			data : {
				facilityname : $('#target').val(),
				date : $('#date').val()
			},
			datatype : "html",
			type : "POST",
			success : function(data) {
				$("#test").html(data);
			},
			error : function() {
				alert('Dailychart_draw  ajax  함수 에러');
			}
		});
		
	});
	$(window).on('weeklychart_draw', function() {
		$.ajax({
			url : "weeklyChart.jsp",
			data : {
				facilityname : $('#target').val(),
				date : $('#date').val()
			},
			datatype : "html",
			type : "POST",
			success : function(data) {
				$("#test").html(data);
			},
			error : function() {
				alert('weeklychart_draw  ajax 함수 에러');
			}
		});
	});
	$(window).on('Monthchart_draw', function() {
		$.ajax({
			url : "MonthlyChart.jsp",
			data : {
				facilityname : $('#target').val(),
				date : $('#date').val()
			},
			datatype : "html",
			type : "POST",
			success : function(data) {
				$("#test").html(data);
			},
			error : function() {
				alert('Monthchart_draw  ajax 함수 에러');
			}
		});
	});
	
	
	
/*
 ****************************** 자바 스크립트 함수*****************************
 * 날짜 변환 기능 및 포맷 변환
 * 함수 목록
 ******************************
 * getDateOfWeek(date)
 * 년 주 단위 일 단위로 변환
 * *****************************
 * thisweek()
 * 현재 날짜의 주차 반환 함수
 * *****************************
 * Date.prototype.getWeek()
 * 주차 계산 프로토 타입 함수
 * *****************************
 * formatDatemonth()
 * 날짜 타입 변경 일 -> 월
 * *****************************
 * formatDateday()
 * 날짜 타입 변경 월 -> 일 (해당 달의 첫 일 반환)
 */
 
 
/* 년 주 단위 일 단위로 변환
 *@author : 양동빈 , fost008@gmail.com
 *@param : 년도, 주차 
 *@return : 그 주차 시작 날짜 (년,월,일)  
 */
	function getDateOfWeek(date) {
		var val1 = date.toString();
		var temp1 = val1.split('-');
		var temp2 = val1.split('W');
		var w = temp2[1];// 주차
		var y = temp1[0];// 년도

		//(w-1)*7+???// 보정값

		var date = new Date(y, 0, (bozung(y) + 1 + (w - 1) * 7));

		return date;
	}
/* 	//보정값 반환 [현재 사용 안함.]
	// 프로파티 : 년도(문자열)
	function bozung(y) {

		var dummy = y + "-01-01";
		alert(dummy);
		var datevalue = new Date(dummy);// 날짜 값.

		i = (1 + 7 - datevalue.getDay()) % 7;
		return i;
	} */
	
	
	/* 현재 날짜의 주차 반환 함수
	 *@author : 양동빈 , fost008@gmail.com
	 *@param : x
	 *@return : 현재 날짜의 주차 id: Week 에 값 입력 
	 */
	function thisweek() {
		var years = new Date().getFullYear();
		var weeks = new Date().getWeek();
		var date = "" + years + "-W" + weeks;
		document.getElementById('week').value = date;
	}
	
	/* 주차 계산 프로토타입 함수
	 *@author : 양동빈 , fost008@gmail.com
	 *@param : x
	 *@return : 현재 주차 반환 var형
	 */
	Date.prototype.getWeek = function() {
		var onejan = new Date(this.getFullYear(), 0, 1);
		var today = new Date(this.getFullYear(), this.getMonth(), this
				.getDate());
		var dayOfYear = ((today - onejan + 86400000) / 86400000);
		return Math.ceil(dayOfYear / 7)
	};
	 
	/* 날짜 타입 일 -> 달
	 *@author : 양동빈 , fost008@gmail.com
	 *@param : Date(yyyy-mm-dd)
	 *@return : Date(yyyy-dd)
	 */
	function formatDatemonth(date) {
    
    var d = new Date(date),
    
    month = '' + (d.getMonth() + 1) , 
    day = '' + d.getDate(), 
    year = d.getFullYear();
    
    if (month.length < 2) month = '0' + month; 
    if (day.length < 2) day = '0' + day; 
    
    return [year, month].join('-');
    
    }
	 /*
	 *날짜 타입 변형 달 -> 일
	 *@author : 양동빈 , fost008@gmail.com
	 *@param : Date(yyyy-dd)
	 *@return : Date(yyyy-mm-dd)
	 */
	function formatDateday(date) {
    
    var d = new Date(date),
    month = '' + (d.getMonth() + 1),
    year = d.getFullYear();
    
    if (month.length < 2) month = '0' + month;
    
    return [year, month,"01"].join('-');
    
    }
	function btnchartevent(facilityname){
		document.getElementById('mode').value = "day";
		document.getElementById('target').value = facilityname.trim();
		console.log(facilityname+"x");
		btnchartevent_action();
		
	}
	function showdatechange(condition){
		
		if(condition == "week"){
			document.getElementById('showdate').innerText= lastWeek($('#date').val())+"~"+document.getElementById('date').value;
		}else if(condition == "day"){
			document.getElementById('showdate').innerText= document.getElementById('date').value;
		}else if(condition == "month"){
			document.getElementById('showdate').innerText= document.getElementById('month').value;
		}else{
			document.getElementById('showdate').innerText= document.getElementById('date').value;
		}
		
	}
	
	/* 그달의 마지막 일 리턴
	 *@author : 양동빈 , fost008@gmail.com
	 *@param : 년도, 달 
	 *@return : 그 주차 마지막 날짜 (일)  
	 */
		function monthlastday(date) {
			var val1 = date.toString();
			var temp1 = val1.split('-');
			
			var y = temp1[0];// 년도
			var m = temp1[1];// 월자


			var date = new Date(y, m+1, 0);
			var value =  date.getDate()-1;

			return value;
		}
	
	function lastWeek(date) {
		  var d = new Date(date)
		  var dayOfMonth = d.getDate();
		  d.setDate(dayOfMonth - 7);
		  return getDateStr(d);
	}
	function monthenddate(date) {
		  var d = new Date(date);
		  var dayOfMonth = d.getDate();
		  d.setDate(dayOfMonth + 30);
		  return getDateStr(d);
	}
	function getDateStr(myDate){
		var year = myDate.getFullYear();
		var month = (myDate.getMonth() + 1);
		var day = myDate.getDate();
		
		month = (month < 10) ? "0" + String(month) : month;
		day = (day < 10) ? "0" + String(day) : day;
		
		return  (year + '-' + month + '-' + day );
	}

</script>
</html>

