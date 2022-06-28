package estimateExcel;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import estimateExcel.estimateexcelwrite;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.json.simple.JSONObject;


@WebServlet("/estimateExcel/estimateExcel")
public class estimateExcel extends HttpServlet {

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		JSONObject result = null;
		String id = null;
		String degree = null;
		String com = null;
		String mode = request.getParameter("mode");
		
	
		switch(mode) {
	      
	      case "excelinfo":
	    	  id = request.getParameter("id");
	    	  degree = request.getParameter("degree");
	    	  com = request.getParameter("com");
			  result = new JSONObject();
			  String excelformpath = request.getSession().getServletContext().getRealPath("excelforms");

			  
			  estimateexcelwrite excel = new estimateexcelwrite();
			  XSSFWorkbook wb = excel.writeExcel(excelformpath, id , degree, com);
			  
			//파일 저장
				
				Date from = new Date();

				SimpleDateFormat transFormat = new SimpleDateFormat("yyyyMMdd");

				String to = transFormat.format(from);

				String localfile = "estimate_" + id + "_" + degree + "_" +  to +".xlsx";
				
				response.setContentType("application/vnd.ms-excel");
				response.setHeader("Content-Disposition", "attachment;filename=" + localfile);
				
				try{	
					wb.write(response.getOutputStream());
					wb.close();
				}catch(Exception e) {
					e.printStackTrace();
				}
	    	  
	    	  break;
	      }
	}
		

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
