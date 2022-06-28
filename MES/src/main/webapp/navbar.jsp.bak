<!-- 사이드와 nav menu  -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.util.HashMap" %>
<%@ page import = "java.util.Map" %>
<%@ page import = "java.util.Map.Entry" %>
<%@ page import = "java.util.Set" %>
<%@ page import = "java.util.Iterator" %>
<%@ page import = "org.json.simple.JSONObject" %>

<%@ page import="dbconn.DBconn"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.Statement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.SQLException"%>
<jsp:useBean id="alarmDAO" class="login.alarmDAO"/>
<!DOCTYPE html>
<html>
    <head>
        <!--jquery-->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js" 
        integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>

        <!--bootstrap-->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css">
        <link rel="stylesheet" href="sidemenu.css?ver5">
        <link rel="stylesheet" href="navbar.css?ver4">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.1/font/bootstrap-icons.css">
        
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
        
        <meta charset="UTF-8"/>
    </head>
    <body id="menup">
    	<nav class="navbar navbar-default">
            <div class="container-fluid">
              <div class="navbar-header row">
                <div class="col-md-8">
                    <a class="navbar-brand" id="menuicon">
                    <span class="glyphicon glyphicon-menu-hamburger"><span style="margin-left:10px" class="sidemenuselect upmenu" id="maincontent">home</span></span>
                    </a>
                </div>
                <div id="userinfo" class="col-md-4" style="margin-left:'10px'">
                    <a class="navbar-text" id="user">
                    <% String userid = (String)session.getAttribute("id"); %>
                        <%=userid %>님 반갑습니다
                    </a>
                    <%
                    JSONObject alarm = alarmDAO.getAlarm();
                    int acnt = 0;
                    if(alarm != null){
                    	acnt = alarm.size();
                    }
                    %>
	                 <div class="dropdown">
					  <button class="dropdown-toggle navbar-text" type="button" id="useralarm" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true" style="border:none; background:rgba(0,0,0,0);">
					    <span id="useralarmicon" class="glyphicon glyphicon-comment"></span>
	                    <span id="useralarmicon2" class="badge"><%=acnt %></span>
					  </button>
					  <ul class="dropdown-menu dropdown-menu-right" aria-labelledby="useralarm">
					  <%
					  if(alarm != null){
						  Set key = alarm.keySet();
						  Iterator<String> iter = key.iterator();
						  while(iter.hasNext()){
							  String keyname = iter.next();
						  
					  %>
					    <li><a class="dropdown-submenu" value="<%=keyname%>"><%=keyname %> : <%=alarm.get(keyname) %></a></li>
					   <%
						  }
					  }					   
					   %>
					  </ul>
					</div>
                </div>
              </div>
            </div>
          </nav>
          
          
          <script>
               $("#menuicon").click(function(){
                $(this).toggleClass("foldmenu");

                if($(this).hasClass("foldmenu")){
                    $("#sidemenu").animate({left:"-12%"}, 500);
                    $(".glyphicon-menu-hamburger").animate({left:"-=235px"}, 500);
                    $("#pframe").animate({"margin-left":"-=12%", "width":"+=12%"}, 500);
                }
                else{
                    $("#sidemenu").animate({left:"+=12%"}, 500);
                    $(".glyphicon-menu-hamburger").animate({left:"+=235px"}, 500);
                    $("#pframe").animate({"margin-left":"+=12%", "width":"-=12%"}, 500);                   
                }
            });
            
             $(document).ready(function(){
                $("#sidemenu").hover(function(){
                    if($("#menuicon").hasClass("foldmenu")){
                        $("#sidemenu").animate({left:"0%"}, 500);
                    }
                },
                function(){
                    if($("#menuicon").hasClass("foldmenu")){
                        $("#sidemenu").animate({left:"-12%"}, 500);
                    }
                }
            );
            });
            
             $("#user").click(function(){
                 let logoutbool = false;
                 logoutbool = window.confirm("로그아웃 하시겠습니까?");
                 if(logoutbool){
                    location.href = "./index.jsp"
                 }
               });
          </script>
    
        <aside id="sidemenu" class="sidebar">
            <div id="ptitle"><h3 style="font-weight: bold;">(회사이름)</h3></div>
            <div id="psubtitle"><h4>MES</h4></div>

            <ul>
                <div class="accordion" id="accordion2">
                <li name="영업 관리">
                    <div class="accordion-group">
                    <div class="accordion-heading">
                        <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2" href="#collapseOne">
                        영업 관리
                        </a>
                    </div>

                    <ul>
                    <div id="collapseOne" class="accordion-body collapse"> <!--열려있기 바라면 class에 in-->
                        <li name="견적서 관리">
                        <div class="accordion-inner">
                        <a class="sidemenuselect" id="quotation">견적서 관리</a>
                        </div>
                        </li>

                        <li name="수주 관리">
                        <div class="accordion-inner">
                        <a class="sidemenuselect" id="order">수주 관리</a>
                        </div>
                        </li>
                    </div>
                    </ul>
                    </div>
                </li>

                <li name="생산 관리">
                    <div class="accordion-group">
                    <div class="accordion-heading">
                        <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2" href="#collapseTwo">
                        생산 관리
                        </a>
                    </div>
                    
                    <ul>
                    <div id="collapseTwo" class="accordion-body collapse">
                        <li name="생산 진행 관리">
                        <div class="accordion-inner">
                        <a class="sidemenuselect" id="productionprog">생산 진행 관리</a>
                        </div>
                        </li>
                        
                         <li name="수주 공정 관리">
                        <div class="accordion-inner">
                        <a class="sidemenuselect" id="order_process">수주 공정 관리</a>
                        </div>
                        </li>

                        <li name="진척 현황">
                        <div class="accordion-inner">
                        <a class="sidemenuselect" id="progress">진척 현황</a>
                        </div>
                        </li>
                    </div>
                    </ul>
                    </div>
                </li>
                
                <li name="작업 관리">
                    <div class="accordion-group">
                    <div class="accordion-heading">
                        <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2" href="#collapseThree">
                        작업 관리
                        </a>
                    </div>

                    <ul>
                    <div id="collapseThree" class="accordion-body collapse">
                        <li name="전체작업일보">
                        <div class="accordion-inner">
                        <a class="sidemenuselect" id="allwork">전체작업일보</a>
                        </div>
                        </li>

                        <li name="나의작업일보">
                        <div class="accordion-inner">
                        <a class="sidemenuselect" id="mywork">나의작업일보</a>
                        </div>
                        </li>

                        <li name="외주작업일보">
                        <div class="accordion-inner">
                        <a class="sidemenuselect" id="outsourcwork">외주작업일보</a>
                        </div>
                        </li>

                        <li name="불량 관리">
                        <div class="accordion-inner">
                        <a class="sidemenuselect" id="faulty">불량 관리</a>
                        </div>
                        </li>

                        <li name="게시판">
                        <div class="accordion-inner">
                        <a class="sidemenuselect" id="board">게시판</a>
                        </div>
                        </li>
                    </div>
                    </ul>

                    </div>
                </li>
                    
                <li name="자재 제품 관리">
                    <div class="accordion-group">
                    <div class="accordion-heading">
                        <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2" href="#collapseFour">
                        자재 제품 관리
                        </a>
                    </div>

                    <ul>
                    <div id="collapseFour" class="accordion-body collapse">

                        <li name="부품 관리">
                        <div class="accordion-inner">
                        <a class="sidemenuselect" id="part">부품 관리</a>
                        </div>
                        </li>

                        <li name="자재 관리">
                        <div class="accordion-inner">
                        <a class="sidemenuselect" id="material">자재 관리</a>
                        </div>
                        </li>

                        <li name="자재 현황 조회">
                        <div class="accordion-inner">
                        <a class="sidemenuselect" id="materialcur">자재 현황 조회</a>
                        </div>
                        </li>
                        
                        <li name="수주별 소요량">
                        <div class="accordion-inner">
                        <a class="sidemenuselect" id="order_requirement">수주별 소요량</a>
                        </div>
                        </li>
                    </div>
                    </ul>

                    </div>
                </li>

                <li name="발주입고 관리">
                    <div class="accordion-group">
                    <div class="accordion-heading">
                        <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2" href="#collapseFive">
                        발주입고 관리
                        </a>
                    </div>

                    <ul>
                    <div id="collapseFive" class="accordion-body collapse">

                        <li name="발주 관리">
                        <div class="accordion-inner">
                        <a class="sidemenuselect" id="orderb">발주 관리</a>
                        </div>
                        </li>

                        <li name="외주 관리">
                        <div class="accordion-inner">
                        <a class="sidemenuselect" id="outsourcing">외주 관리</a>
                        </div>
                        </li>

                        <li name="입출고 관리">
                        <div class="accordion-inner">
                        <a class="sidemenuselect" id="io">입출고 관리</a>
                        </div>
                        </li>
                    </div>
                    </ul>

                    </div>
                </li>
                    
                <li name="Dashboard">
                    <div class="accordion-group">
                    <div class="accordion-heading">
                        <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2" href="#collapseSix">
                        Dashboard
                        </a>
                    </div>

                    <ul>
                    <div id="collapseSix" class="accordion-body collapse">

                        <li name="작업자별 실적 현황">
                        <div class="accordion-inner">
                        <a class="sidemenuselect" id="performancecur">작업자별 실적 현황</a>
                        </div>
                        </li>
                        
                        <li name="수주별 작업공수표">
                        <div class="accordion-inner">
                        <a class="sidemenuselect" id="workcheck">수주별 작업공수표</a>
                        </div>
                        </li>

                        <li name="불량현황">
                        <div class="accordion-inner">
                        <a class="sidemenuselect" id="faultycur">불량현황</a>
                        </div>
                        </li>

                        <li name="PQCD 현황">
                        <div class="accordion-inner">
                        <a class="sidemenuselect" id="pqcdcur">PQCD 현황</a>
                        </div>
                        </li>

                        <li name="설비 가동 현황">
                        <div class="accordion-inner">
                        <a class="sidemenuselect" id="facilitiesopercur">설비 가동 현황</a>
                        </div>
                        </li>

                        <li name="외주 비용 현황">
                        <div class="accordion-inner">
                        <a class="sidemenuselect" id="outsourccostcur">외주 비용 현황</a>
                        </div>
                        </li>

                        <li name="소모품 현황">
                        <div class="accordion-inner">
                        <a class="sidemenuselect" id="suppliescur">소모품 현황</a>
                        </div>
                        </li>
                        
                    </div>
                    </ul>

                    </div>
                </li>

                <li name="기준정보 관리">
                    <div class="accordion-group">
                    <div class="accordion-heading">
                        <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2" href="#collapseSeven">
                        기준정보 관리
                        </a>
                    </div>

                    <ul>
                    <div id="collapseSeven" class="accordion-body collapse">

                        <li name="공통코드 관리">
                        <div class="accordion-inner">
                        <a class="sidemenuselect" id="commoncode">공통코드 관리</a>
                        </div>
                        </li>

                        <li name="업체 관리">
                        <div class="accordion-inner">
                        <a class="sidemenuselect" id="company">업체 관리</a>
                        </div>
                        </li>

                        <li name="표준공정 관리">
                        <div class="accordion-inner">
                        <a class="sidemenuselect" id="stanprocess">표준공정 관리</a>
                        </div>
                        </li>

                        <li name="설비 관리">
                        <div class="accordion-inner">
                        <a class="sidemenuselect" id="facilities">설비 관리</a>
                        </div>
                        </li>
                    </div>
                    </ul>

                    </div>
                </li>
                 <li name="설비 관리">
                    <div class="accordion-group">
                    <div class="accordion-heading">
                        <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2" href="#collapseNine">
                        설비 관리
                        </a>
                    </div>

                    <ul>
                    <div id="collapseNine" class="accordion-body collapse">

                        <li name="설비이력관리">
                        <div class="accordion-inner">
                        <a class="sidemenuselect" id="facilitiesph">설비이력관리</a>
                        </div>
                        </li>

                        <li name="설비일상점검">
                        <div class="accordion-inner">
                        <a class="sidemenuselect" id="facilitiescheck">설비일상점검</a>
                        </div>
                        </li>

                    

                       
                    </div>
                    </ul>

                    </div>
                </li>
                

                <li name="Admin">
                    <div class="accordion-group">
                    <div class="accordion-heading">
                        <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2" href="#collapseEight">
                        Admin
                        </a>
                    </div>

                    <ul>
                    <div id="collapseEight" class="accordion-body collapse">
                        <li name="사용자 관리">
                        <div class="accordion-inner">
                        <a class="sidemenuselect" id="userinformation">사용자 관리</a>
                        </div>
                        </li>

                        <li name="사용자 메뉴 관리">
                        <div class="accordion-inner">
                        <a class="sidemenuselect" id="usermenu">사용자 메뉴 관리</a>
                        </div>
                        </li>
                    </div>
                    </ul>

                    </div>
                </div>
                </li>
                
                
                
                <!-- pop 화면 권한설정 -->
                <li name="POP">
                    <div class="accordion-group">
                    <div class="accordion-heading">
                        <a class="sidemenuselect" id="pop">
                        POP
                        </a>
                    </div>
                	</div>
                </li>

            </ul>
        </aside>
    
    <jsp:useBean id="usermenudao" class="userMenu.UserMenuDAO"/>  
    <script>
    //메뉴 display 처리(권한 처리)
    $(document).ready(function(){
    	$("li").hide();
    	$(".dropdown-menu li").show();
    	<%
    	Map<String,String[]> allmenu = usermenudao.getUserMenu(userid);
    	if(allmenu != null){
			for(Entry<String,String[]> menus : allmenu.entrySet()){
		%>
		$("li[name='<%=menus.getKey()%>']").show();
		<%
				for(String lowermenu : menus.getValue()){
		%>
		$("li[name='<%=lowermenu%>']").show();
		<%
				}
			}
    	}
    	%>
    	
    	// pop 화면 권한설정
    	<%
		DBconn db = new DBconn();
		Connection con = db.getCon();
		String sql = "SELECT * FROM user_auth";
		Statement stmt = con.createStatement();
		ResultSet rs = stmt.executeQuery(sql);
		
		int idx = 0, status = 0;
		
		while(rs.next()){
			idx = rs.getInt("idx");
			status = rs.getInt("status");
		}

    	if(status == 3){
    	%>
    	
    	$("li[name='POP']").show();
    	<%}%>
    	
    });
    
    //알람클릭 이벤트
    $(".dropdown-submenu").on("click",function(){
    	event.stopPropagation()
    	let selectedid = $(this).attr('value');
    	
    	switch (selectedid){
    	case "수주 비상":
			$("#pframe").attr('src', 'Order/Order.jsp');
			break;
			
    	case "불량 갯수":
			$("#pframe").attr('src','faulty/faulty.jsp');
			break;
			
    	case "부품 부족":
			$("#pframe").attr('src', 'part/part_management.jsp');
			break;
			
    	case "자재 부족":
			$("#pframe").attr('src', 'material/material.jsp');
			break;
    	}
    });
    
    
    //메뉴 클릭 이벤트
    $(".sidemenuselect").on("click",function(){
    	event.stopPropagation()
    	let selectedid = $(this).attr('id');
    	
    	switch (selectedid){
    	
    		case "maincontent":
			let mainbool = false;
			mainbool = window.confirm("작업한 내용이 모두 사라집니다. 홈으로 돌아가시겠습니까?");
			if(mainbool){
				location.reload();
			}
			break;
    	
    		case "board":
    			$("#pframe").attr('src', 'board/board.jsp');
    			break;
    			
    		case "userinformation":
    			$("#pframe").attr('src','admin/user_management.jsp');
    			break;
    			
    		case "part":
    			$("#pframe").attr('src', 'part/part_management.jsp');
    			break;
    		
    		case "material":
    			$("#pframe").attr('src', 'material/material.jsp');
    			break;
    			
    		case "commoncode":
    			$("#pframe").attr('src', 'common_code/common_code.jsp');
    			break;
    			
    		case "order":
    			$("#pframe").attr('src', 'Order/Order.jsp');
    			break;
    			
    		case "quotation":
    			$("#pframe").attr('src', 'estimate/estimate.jsp');
    			break;
    			
    		case "facilities":
    			$("#pframe").attr('src', 'facilities/facilities.jsp');
    			break;
    		
    		case "stanprocess":
    			$("#pframe").attr('src','standardProcess/standardProcess.jsp');
    			break;
    			
    		case "company":
    			$("#pframe").attr('src','Company/company.jsp');
    			break;
    			
    		case "usermenu":
    			$("#pframe").attr('src','userMenu/userMenu.jsp');
    			break;
    			
    		case "orderb":
    			$("#pframe").attr('src','manage_porder/manage_porder.jsp');
    			break;
    			
    		case "outsourcing":
    			$("#pframe").attr('src','Outsourcing/outsourcing.jsp');
    			break;
    			
    		case "io":
    			$("#pframe").attr('src','inandout/inandout.jsp');
    			break;
    			
    		case "allwork":
    			$("#pframe").attr('src','dailyWork/dailyWork.jsp');
    			break;
    			
    		case "mywork":
    			$("#pframe").attr('src','my_work/my_work.jsp');
    			break;
    			
    		case "materialcur":
    			$("#pframe").attr('src','pminquiry/pminquiry.jsp');
    			break;
    		
    		case "outsourcwork":
    			$("#pframe").attr('src','Outregistration/outregistration.jsp');
    			break;
    			
    		case "faulty":
    			$("#pframe").attr('src','faulty/faulty.jsp');
    			break;
    			
    		case "performancecur":
    			$("#pframe").attr('src','performance_by_worker/performance_by_worker.jsp');
    			break;
    			
    		case "productionprog":
    			$("#pframe").attr('src','prodProgress/prodProgress.jsp');
    			break;
    			
    		case "workcheck":
    			$("#pframe").attr('src','dashboardorder/dashboardorder.jsp');
    			break;
    			
    		case "outsourccostcur":
    			$("#pframe").attr('src','dashboardoutsourcing/dashboardoutsourcing.jsp');
    			break;
    			
    		case "facilitiesopercur":
    			$("#pframe").attr('src','performance_by_facility/performance_by_facility.jsp');
    			break;
    		
    		case "faultycur":
    			$("#pframe").attr('src','defectivePerform/defectiveP.jsp');
    			break;
    			
    		case "suppliescur":
    			$("#pframe").attr('src','consumables/consumables.jsp');
    			break;
    			
    		case "pqcdcur":
    			$("#pframe").attr('src','pqcd/pqcd.jsp');
    			break;
    			
    		case "progress":
    			window.open("statusProgress/statusProgress.jsp");
    			break;
    			
    		case "order_process":
    			$("#pframe").attr('src','order_process/order_process.jsp');
    			break;
    			
    		case "facilitiesph":
    			$("#pframe").attr('src','facilitiesph/facilitiesph.jsp');
    			break;
    		
    		case "facilitiescheck":
    			$("#pframe").attr('src','facilitiescheck/facilitiescheck.jsp');
    			break;
    			
    		case "order_requirement":
    			$("#pframe").attr('src','order_requirement/order_requirement.jsp');
    			break;
    			
 
    			
    		case "pop":
    			window.open('./POP/DASHBOARD.jsp');
    			break;
    	}
    });
    
    $("#ptitle").click(function(){
    	let mainbool = false;
		mainbool = window.confirm("작업한 내용이 모두 사라집니다. 홈으로 돌아가시겠습니까?");
		if(mainbool){
			location.reload();
		}
    });
    </script>