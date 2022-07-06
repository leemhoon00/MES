<!-- 나의 작업 일보 등록 -->

<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.Date" %>
<%@ page import="jh.jhdbconn"%>

<!-- 데이터베이스 연결 -->
<%
jhdbconn db = new jhdbconn();
String query;
%>



<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Insert title here</title>
</head>
<body>
<%
String order_name = request.getParameter("order_name"); //ok
String part_name; // ok
if(request.getParameter("part_name") == null){
	part_name = "";
}
else{
	part_name = request.getParameter("part_name");
}
String process = request.getParameter("process"); //ok

String facilities; //ok
if(request.getParameter("facilities") == null){
	facilities = "";
}
else{
	facilities = request.getParameter("facilities");
}
String work_start; //ok
String work_end; //ok
String faulty = request.getParameter("faulty"); //ok

String status; //ok

String client = request.getParameter("client"); //ok

String dobun = ""; //ok
int quantity = 0; //ok
String core =""; //ok
long work_time; //ok
int real_processing_time; //ok
int no_men_processing_time; //ok
int un_processing_time; //ok

int total_work_time; //ok
int total_processing_time; //ok
String regdate = LocalDate.now().toString(); //ok
String worker=""; //ok

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
worker = (String)workeridob;


if(worker==null || worker.equals("")){
	worker = "로그인안하고값넣은사용자";
}

int manufacturing_cost = 0; //ok
if(status.equals("완료")){
	query = "select * from process where process_name='"+process+"'";
	db.rs=db.stmt.executeQuery(query);
	if(db.rs.next()){
		int temp = db.rs.getInt("pay");
		manufacturing_cost = ((int)work_time+no_men_processing_time)*temp;
	}
	db.rs.close();
	
	
}

if(order_name.equals("") || order_name == null){
	response.sendRedirect("my_work.jsp");
}
else{
	
	
	query = "insert into mes.my_work(order_name,part_name,process,facilities,work_start,work_end,faulty,status,client,regdate,dobun,quantity,core,work_time,real_processing_time,no_men_processing_time,un_processing_time,total_work_time,total_processing_time,worker,manufacturing_cost) values('"+order_name+"','"+part_name+"','"+process+"','"+facilities+"',"+work_start+","+work_end+",'"+faulty+"','"+status+"','"+client+"','"+regdate+"','"+dobun+"',"+quantity+",'"+core+"',"+work_time+","+real_processing_time+","+no_men_processing_time+","+un_processing_time+","+total_work_time+","+total_processing_time+",'"+worker+"',"+manufacturing_cost+")";

	
	
	db.stmt.executeUpdate(query);
	
	db.stmt.close();
	db.conn.close();
	
	response.sendRedirect("my_work.jsp");
	
	

	
}

%>
</body>
</html>