<!-- 설비 가동 현황 -->

<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
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
	<label class="title" style="margin-left: 30px; margin-top: 10px;">Dashboard / 설비 가동 현황</label>
	<div class="card">
		<div class="card-body">
			<div class="form-inline">
				
				<label>기간</label>
				<input type="date" id="date1">
				<label>~</label>
				<input type="date" id="date2">
				
				<button class="btn btn-info" onclick="buttonclick()">조회</button>
				<script>
				function buttonclick(){
					
					var date1 = document.getElementById("date1").value;
					var date2 = document.getElementById("date2").value;
					
					
					if(date1 == "" || date2 == ""){
						alert("날짜를 설정하시오");
					}
					else{
						$.ajax({
							type:"GET",
				            url:"./maindiv.jsp",
				            data:{date1:date1, date2:date2},
				            dataType:"html",
				            success:function(data){
				                $("#maindiv").html(data);
				          }
				       });
					}
				}
				</script>
			</div>
		</div>
	</div>
	
	<div id="maindiv">
	
	</div>
	
	<script>
	
	window.onload = function(){
		var today = new Date();
		var year = today.getFullYear();
		var month = ('0' + (today.getMonth() + 1)).slice(-2);
		var day = ('0' + today.getDate()).slice(-2);

		var dateString = year + '-' + month  + '-' + day;
		
		document.getElementById("date1").value=dateString;
		document.getElementById("date2").value = dateString;
		
		$.ajax({
			type:"GET",
	        url:"./maindiv.jsp",
	        data:{date1:"2022-03-11", date2:"2022-03-11"},
	        dataType:"html",
	        success:function(data){
	            $("#maindiv").html(data);
	      }
	   });
		
		$.ajax({
			type:"GET",
	        url:"./maindiv.jsp",
	        data:{date1:"2022-03-11", date2:"2022-03-11"},
	        dataType:"html",
	        success:function(data){
	            $("#maindiv").html(data);
	      }
	   });
	}
	
	</script>
</body>
</html>