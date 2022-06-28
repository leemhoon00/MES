<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <script type="text/javascript" src="barcode-1.0.0.total.js"></script>
<%
	String code = request.getParameter("code");
	String identify = request.getParameter("uniqueId");
	String blank = "";
	
	for (int i = 0; i < 12 - code.length() - identify.length(); i++) { 
		blank = blank + "0";
	}
	String  data = code + blank + identify;
%>


</head>

<body>
    <div id="capture_result_div" width="600" height="300"></div>

    <br>

    <button type="button" onclick="elementPrint('#capture_result_div', 'http://127.0.0.1:5000/Printer')"> Print Barcode </button>
    <script>drawBarcode('#capture_result_div', '<%=data%>', 3);</script>
</body>

</html>