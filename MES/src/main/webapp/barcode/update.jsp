<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.Statement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.Date" %>

<!-- 데이터베이스 연결 -->
<%
Class.forName("com.mysql.jdbc.Driver");
Connection conn = null;
Statement stmt = null;
ResultSet rs = null;
String query= null;

String jdbcDriver = "jdbc:mysql://192.168.0.115:3306/mes?" + "useUnicode=true&characterEncoding=utf8";
String dbUser = "Usera";
String dbPass = "1234";
conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
stmt = conn.createStatement();
%>



<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Insert title here</title>
</head>
<body>
<%

int work_id = Integer.parseInt(request.getParameter("work_id"));
String work_start; //ok
String work_end; //ok
String faulty = request.getParameter("faulty"); //ok
String status; //ok
long work_time; //ok
int real_processing_time; //ok
int no_men_processing_time; //ok
int un_processing_time; //ok
int total_work_time; //ok
int total_processing_time; //ok
String regdate = LocalDate.now().toString(); //ok
String worker=""; //ok
String process = request.getParameter("process");

if(request.getParameter("work_start").equals("")){
	work_start = "null";
	status="시작";
}else{
	work_start = "'"+request.getParameter("work_start").replace("T"," ")+":00'";
	status="진행";
}
if(request.getParameter("work_end").equals("")){
	work_end = "null";
	work_time=0;
}else{
	work_end = "'"+request.getParameter("work_end").replace("T"," ")+":00'";
	status="완료";
	SimpleDateFormat f = new SimpleDateFormat("yy-MM-dd HH:mm:ss");
	Date d1 = f.parse(work_start.replace("'",""));
	
	Date d2 = f.parse(work_end.replace("'",""));
	work_time = (d2.getTime() - d1.getTime()) / (1000*60*60);
}



if(faulty==null){
	faulty = "N";
}
else{
	faulty="Y";
}

if(request.getParameter("real_processing_time").equals("")){
	real_processing_time=0;
}
else{
	real_processing_time = Integer.parseInt(request.getParameter("real_processing_time"));
}

if(request.getParameter("no_men_processing_time").equals("")){
	no_men_processing_time=0;
}
else{
	no_men_processing_time = Integer.parseInt(request.getParameter("no_men_processing_time"));
}
if(request.getParameter("un_processing_time").equals("")){
	un_processing_time=0;
}
else{
	un_processing_time = Integer.parseInt(request.getParameter("un_processing_time"));
}
total_work_time = (int)work_time + no_men_processing_time;
total_processing_time = real_processing_time + no_men_processing_time;


Object workeridob = session.getAttribute("id");
// worker = (String)workeridob;

/* if(worker==null || worker.equals("")){
	worker = "로그인안하고값넣은사용자";
}*/
worker = "admin";


int manufacturing_cost = 0; //ok
if(status.equals("완료")){
	query = "select * from process where process_name='"+process+"'";
	rs=stmt.executeQuery(query);
	if(rs.next()){
		int temp = rs.getInt("pay");
		manufacturing_cost = ((int)work_time+no_men_processing_time)*temp;
	}
	
}


query = "update my_work set work_start="+work_start+", work_end="+work_end+", faulty ='"+faulty+"', status='"+status+"', regdate='"+regdate+"', work_time="+work_time+", real_processing_time="+real_processing_time+", no_men_processing_time="+no_men_processing_time+", un_processing_time="+un_processing_time+", total_work_time="+total_work_time+", total_processing_time="+total_processing_time+", worker='"+worker+"', manufacturing_cost="+manufacturing_cost+" where work_id="+work_id;



stmt.executeUpdate(query);
response.sendRedirect("close-barcode.jsp");
	
	

	


%>
</body>
</html>