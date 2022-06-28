<!-- main page -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="login.LoginDAO"%>


<%
String id = request.getParameter("id");
String pw = request.getParameter("pw");
%>

<!-- index페이지에서 넘어온 아이디 값 비교해서 맞으면 session저장, 아니면 index로 -->
<%
LoginDAO login = new LoginDAO();
String p = login.login(id);

if(p != null){
	if(p.equals(pw)){
		session.setAttribute("id", id);
	}
	else{
		response.sendRedirect("index.jsp");
	}
}
else{
	response.sendRedirect("index.jsp");
}

%>

<%@ include file="navbar.jsp"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>MES</title>

<style>
	#pframe{
		margin-left: 14.5%;
		width: 84%;
		height: 95vh;
		overflow: scroll;
	}
	.pframe{
		margin-left: 14.5%;
		width: 84%;
		height: 95vh;
		overflow: scroll;
	}
	.navdata {
		margin-left: 14.5%;
	}

	.uldata { 
		display: flex;
		flex-wrap: wrap;
		padding-left: 0;
		margin-bottom: 0;
		list-style: none;
	}
	.svg { 
		    font-weight: 400;
		line-height: 1.5;
		list-style: none;
		box-sizing: border-box;
		display: inline-block;
		height: 1em;
		width: 1em;
		overflow: visible;
		margin-left: 10;
	}

</style>
<body>
<div style="margin: 8px;">
	<ul id="multipage-ul" class="uldata navdata">
		<div style="margin: 8px;" id="multipage-main-main" onclick="changePage('main/main.jsp');" type="button" class="btn btn-success">메인 화면 <svg class="svg" onclick="tabClose('main-main')" aria-hidden="true" data-prefix="fas" data-icon="minus-circle" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" data-fa-i2svg=""><path fill="currentColor" d="M256 8C119 8 8 119 8 256s111 248 248 248 248-111 248-248S393 8 256 8zM124 296c-6.6 0-12-5.4-12-12v-56c0-6.6 5.4-12 12-12h264c6.6 0 12 5.4 12 12v56c0 6.6-5.4 12-12 12H124z"></path></svg>
		</button>
	</ul>
</div>
	<div id="multipage-pframe" >
		<iframe id="multipage-pframe-main-main" class="pframe" src="main/main.jsp" frameborder="0px"></iframe>
	</div>

<script>
	// 멀티페이지를 구현하기 위해
	// 페이지마다 고유 id를 지정하였으며,
	// 페이지 고유 id는 navbar.jsp에 지정이 되어 있습니다.
	multipage_session = ["main-main"];
	var currentPage = "main-main"
	
	deleteEvent = 0;
	// 제목 그대로 탭을 삭제합니다.
	function tabClose(page_id) { 
		if (multipage_session.length == 1) { 
			alert("탭은 하나 이상이어야 합니다.");
			return;
		}
		// No
		if (confirm("탭을 닫으시겠습니까?") == 0) { 
			return;
		}

		console.log(page_id);
		deleteEvent = 1;
		$("#multipage-pframe-" + page_id).remove()
		$("#multipage-" + page_id).remove()

		multipage_session = multipage_session.filter(function(data) {
			return data != page_id;
		})

		if (page_id == currentPage) { 
			$("#multipage-pframe-" + multipage_session[0]).show()
			$("#multipage-" + multipage_session[0]).attr("class", "btn btn-success");
			currentPage = multipage_session[0];
		}
	}

	 // 페이지 이동을 구현하였습니다.
	 // 클릭 하면 멀티탭 페이지로 이동합니다.
	function changePage(url, name) { 
		if (deleteEvent == 1) { 
			deleteEvent = 0;
			return;
		}
	
		// url에 다양한 디렉토리 구조가 있으므로,
		// 마지막 path를 지우고, 파일 확장자를 지운 뒤
		// page_id를 만듭니다.
		page_id = url.replace(/\//gi, "-"); 
		page_id = page_id.replace(/.jsp/gi, ""); 

		// 이미 열린 페이지와 같다면 열지 않습니다.
		if (page_id == currentPage) { 
			console.log("데이터가 같으므로 중지합니다.")
			return;
		}
		// 다르다면, 멀티탭 페이지에 색상을 변경하고,
		// 이전 탭은 파란색으로 바꿉니다.
		if (!multipage_session.includes(page_id)) { 
			multipage_session[multipage_session.length] = page_id;
			$("#multipage-ul").append('<div style="margin: 8px;" onclick="changePage(\'' + url + '\', \'' + name + '\');" id="multipage-' + page_id + '" type="button" class="btn btn-success">' + name + ' <svg class="svg" onclick="tabClose(\'' + page_id + '\')" aria-hidden="true" data-prefix="fas" data-icon="minus-circle" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" data-fa-i2svg=""><path fill="currentColor" d="M256 8C119 8 8 119 8 256s111 248 248 248 248-111 248-248S393 8 256 8zM124 296c-6.6 0-12-5.4-12-12v-56c0-6.6 5.4-12 12-12h264c6.6 0 12 5.4 12 12v56c0 6.6-5.4 12-12 12H124z"></path></svg></div>')

			$("#multipage-pframe").append('<iframe id="multipage-pframe-' + page_id + '" class="pframe" src="' + url + '" frameborder="0px"></iframe>')

			$("#multipage-" + currentPage).attr("class", "btn btn-primary");
			$("#multipage-pframe-" + currentPage).hide();

		}else {
			$("#multipage-" + page_id).attr("class", "btn btn-success");
			$("#multipage-pframe-" + page_id).show();

			$("#multipage-" + currentPage).attr("class", "btn btn-primary");
			$("#multipage-pframe-" + currentPage).hide();

		}
		currentPage = page_id;
		console.log(page_id + " " + url)


	}
</script>
</body>
</html>