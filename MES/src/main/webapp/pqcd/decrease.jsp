<!-- 납기단축(감소) -->

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
	<div class="card">
		<div class="card-body">
			<div class="form-inline">
				<label>조회</label>
				<input type="date" id="date1">
				<label>~</label>
				<input type="date" id="date2">
				<button class="btn btn-info" onclick="buttonclick()">조회</button>
			</div>
			
			<div id="graphdiv">
			
			</div>
			
		</div>
	</div>
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
	            url:"./graphdiv.jsp",
	            data:{date1:date1, date2:date2},
	            dataType:"html",
	            success:function(data){
	                $("#graphdiv").html(data);
	          }
	       });
		}
	}
	
	
	$.ajax({
		type:"GET",
        url:"./graphdiv.jsp",
        data:{date1:"2022-03-21", date2:"2022-03-21"},
        dataType:"html",
        success:function(data){
            $("#graphdiv").html(data);
      }
   });
	</script>
</body>
</html>