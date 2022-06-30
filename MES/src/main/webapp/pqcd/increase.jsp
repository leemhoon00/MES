<!-- 설비가동률(증가) -->

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
				<label>조회(년월)</label>
				<select class="form-select search" style="width:5%" id="selectyear">
					<option value="2020">2020</option>
					<option value="2021">2021</option>
					<option value="2022">2022</option>
				</select>
				<select class="form-select search" style="width:5%" id="selectmonth">
					<option value="1">1</option>
					<option value="2">2</option>
					<option value="3">3</option>
					<option value="4">4</option>
					<option value="5">5</option>
					<option value="6">6</option>
					<option value="7">7</option>
					<option value="8">8</option>
					<option value="9">9</option>
					<option value="10">10</option>
					<option value="11">11</option>
					<option value="12">12</option>
				</select>
				<button class="btn btn-info" onclick="buttonclick()">조회</button>
			</div>
			
			<div id="tablediv">
			
			</div>
			
		</div>
	</div>



	<script>
	function buttonclick(){
		var year = document.getElementById("selectyear").value;
		var month = document.getElementById("selectmonth").value;
		$.ajax({
		    type:"GET",
		      url:"./tablediv.jsp",
		      data:{year:year, month:month},
		      dataType:"html",
		      success:function(data){
		          $("#tablediv").html(data);
		    }
		 });
	}
	</script>
</body>
</html>