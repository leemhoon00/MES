<!-- 나의 작업 일보 수정 -->

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
	if(work_start.length()>=23){
		work_start = work_start.substring(0,work_start.length()-4);
		work_start += "'";
	}
}
if(request.getParameter("work_end").equals("")){
	work_end = "null";
	work_time=0;
}else{
	work_end = "'"+request.getParameter("work_end").replace("T"," ")+":00'";
	status="완료";
	if(work_end.length()>=23){
		work_end = work_end.substring(0,work_end.length()-4);
		work_end += "'";
	}
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

if(request.getParameter("real_processing_time")==null || request.getParameter("real_processing_time").equals("")){
	real_processing_time=0;
}
else{
	real_processing_time = Integer.parseInt(request.getParameter("real_processing_time"));
}

if(request.getParameter("no_men_processing_time")==null || request.getParameter("no_men_processing_time").equals("")){
	no_men_processing_time=0;
}
else{
	no_men_processing_time = Integer.parseInt(request.getParameter("no_men_processing_time"));
}
if(request.getParameter("un_processing_time")==null || request.getParameter("un_processing_time").equals("")){
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
	db.query = "select * from process where process_name='"+process+"'";
	db.rs=db.stmt.executeQuery(db.query);
	if(db.rs.next()){
		int temp = db.rs.getInt("pay");
		manufacturing_cost = ((int)work_time+no_men_processing_time)*temp;
	}
	
}


db.query = "update my_work set work_start="+work_start+", work_end="+work_end+", faulty ='"+faulty+"', status='"+status+"', regdate='"+regdate+"', work_time="+work_time+", real_processing_time="+real_processing_time+", no_men_processing_time="+no_men_processing_time+", un_processing_time="+un_processing_time+", total_work_time="+total_work_time+", total_processing_time="+total_processing_time+", worker='"+worker+"', manufacturing_cost="+manufacturing_cost+" where work_id="+work_id;



db.stmt.executeUpdate(db.query);

db.stmt.close();
db.conn.close();

response.sendRedirect("dailyWork.jsp");
	


%>
</body>
</html>