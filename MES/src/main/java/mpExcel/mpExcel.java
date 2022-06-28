package mpExcel;

import jakarta.servlet.http.HttpServlet;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Vector;

import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.json.simple.JSONObject;

import mpExcel.mpExcelwrite;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class mpExcel
 */
@WebServlet("/mpExcel/mpExcel")
public class mpExcel extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		JSONObject result = null;
		String mode = request.getParameter("mode");
	
	
		switch(mode) {
	      
	      case "excelinfo":
	    	  String cnt = request.getParameter("cnt");
	    	  Vector<String> pv = new Vector<String>();
	    	  Vector<String> nv = new Vector<String>();
	    	  Vector<String> cv = new Vector<String>();
	    	  for(int i=0; i<Integer.parseInt(cnt); i++) {
	    		  String part = request.getParameter("part" + Integer.toString(i));
	    		  String nor = request.getParameter("nor" + Integer.toString(i));
	    		  String cost = request.getParameter("cost" + Integer.toString(i));
	    		  pv.add(part);
	    		  nv.add(nor);
	    		  cv.add(cost);
	    	  }
	    	  
			  result = new JSONObject();
			  String excelformpath = request.getSession().getServletContext().getRealPath("excelforms");

			  
			  mpExcelwrite excel = new mpExcelwrite();
			  XSSFWorkbook wb = excel.writeExcel(excelformpath, pv, nv, cv);
			  
			//파일 저장
				
				Date from = new Date();

				SimpleDateFormat transFormat = new SimpleDateFormat("yyyyMMdd");

				String to = transFormat.format(from);

				String localfile = "order_" + to +".xlsx";
				
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
