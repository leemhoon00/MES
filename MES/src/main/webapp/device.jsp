<!--  
기계 상태 메세지 API 입니다.
기능 : HTTP Post 방식으로 body에 JSON 데이터를 받은 뒤 상태 콜백 후 데이터 베이스에 데이터를 입력합니다.

@author : 양동빈 , fost008@gmail.com
@version 1.0, API 작성 및 테스트 완료

@ param : json(facility,status,errorNo,errorMessage,time)
@ return : json(result) 상태 값 0 정상, -1 비정상 json(Message) api 오류 시 상태메시지.
@ exception : body에 json 값이 없을 경우
-->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="dbcon.dbcon"%>
<%@ page import="java.io.BufferedReader"%>
<%@ page import="java.io.IOException"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONValue"%>
<%

//선언 부 
StringBuffer data = new StringBuffer();
BufferedReader in = null;
String inputLine;
boolean acceseflag = false;

// Body의 데이터 수신 부
try {
	in = request.getReader();

	while ((inputLine = in.readLine()) != null) {
		data.append(inputLine);
	}
	acceseflag = true;

} catch (IOException ex) {
	throw ex;
} finally {
	if (in != null) {
		try {
	in.close();
		} catch (IOException ex) {
	out.println(ex);
		}
	}
}

// JSON 파일 생성
JSONObject rdata = new JSONObject(); // 상대방에게 전송할 JSON
String Message = ""; // 상대방에게 전송할 메시지

if(acceseflag){
	// 받은 데이터 JSON 파싱
	JSONObject json = null;
	json = (JSONObject) JSONValue.parse(data.toString());

	// 데이터 필요 조건 검사 및 메시지 생성 
	if(json.get("time")==null)
	{
		rdata.put("result","-1");
		Message += " time ";
	}
	if(json.get("facility")==null)
	{
		rdata.put("result","-1");
		Message += " facility ";
	}
	if(json.get("status")==null)
	{
		rdata.put("result","-1");
		Message += " status ";
	}
	
	
	// 오류 시 추가 조건
	if(json.get("status").equals("-1")){
		if(json.get("errorNo")==null)
		{
			rdata.put("result","-1");
			Message += " errorNo ";
		}
		if(json.get("errorMessage")==null)
		{
			rdata.put("result","-1");
			Message += " errorMessage ";
		}
	}else if(rdata.get("result")!="-1"){//데이터 문제 없을 시 디비에 전송하는 부분 [기기의 스테이터스가 정상 일 경우]
		
		dbcon db = new dbcon();
		db.insertMuchinstatus(json.get("facility").toString(),json.get("status").toString(),json.get("time").toString());
		rdata.put("result","0");
		out.println(rdata);
		return ;
	}
	
	if(rdata.get("result")=="-1"){// 받은 JSON 데이터가 정상이 아닐 경우 처리
		
		rdata.put("message",("Param"+Message+"is missing"));
		out.println(rdata);
	}else{//데이터 문제 없을 시 디비에 전송하는 부분 [기기의 스테이터스가 에러 상태 일 경우]
			
		dbcon db = new dbcon();
		db.insertMuchinstatus(json.get("facility").toString(),json.get("status").toString(),json.get("errorNo").toString(),json.get("errorMessage").toString(),json.get("time").toString());
		
		rdata.put("result","0");
		out.println(rdata);
	}
}



%>