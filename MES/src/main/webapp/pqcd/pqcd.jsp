<!-- PQCD 현황 페이지 -->

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
	<label class="title" style="margin-left: 30px; margin-top: 10px;">Dashboard / PQCD 현황</label>
	<!--------------------------------------------- 윗 섹션 ----------------------------------------------->

	<div class="card">
		<div class="card-body">
			<div class="form-inline">
				<label>PQCD</label>
				<select class="form-select search" style="width:10%" id="selectbox" onchange="selectchange(this)">
					<option value="">--선택--</option>
					<option value="설비가동률(증가)">설비가동률(증가)</option>
					<option value="납기단축(감소)">납기단축(감소)</option>
				</select>
			</div>
		</div>
	</div>
	<script>
	function selectchange(element){
		if(element.value==""){
			
		}
		else if(element.value == "설비가동률(증가)"){
			$.ajax({
				type:"GET",
	            url:"./increase.jsp",
	            data:{},
	            dataType:"html",
	            success:function(data){
	                $("#maindiv").html(data);
	          }
	       });
		}
		else{
			$.ajax({
				type:"GET",
	            url:"./decrease.jsp",
	            data:{},
	            dataType:"html",
	            success:function(data){
	                $("#maindiv").html(data);
	          }
	       });
		}
	}
	</script>
	
	<div id="maindiv">
	
	</div>
	
	
</body>
</html>