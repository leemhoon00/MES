package ajax;

import jakarta.servlet.http.HttpServlet;
import java.io.IOException;
import java.util.Vector;

import dbcon.dbcon;
import dbcon.facilitiescheckdatedb;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class facilitieschecktable
 */
@WebServlet("/facilitieschecktable")
public class facilitieschecktable extends HttpServlet {
	private static final long serialVersionUID = 1L;
 
    public facilitieschecktable() {
        super();
    }
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		String facilities_name = request.getParameter("facilities_name");
		String year = request.getParameter("year");
		String month = request.getParameter("month");
		String lastday = request.getParameter("lastday");
		response.getWriter().write("{");
		response.getWriter().write(getfacilitiescheck(facilities_name)); 
		response.getWriter().write(getfacilitiescheckdate(facilities_name, year, month, lastday)); 
		response.getWriter().write("}");
	}
	public String getfacilitiescheck(String facilities_name) {
		if(facilities_name == null) facilities_name = "";
		StringBuffer result = new StringBuffer("");
		result.append("\"contentresult\":[");
		dbcon db = new dbcon();
		Vector<String> v = db.getcontentdate(facilities_name);
		for(int i=0; i<v.size(); i++) {
			result.append("{\"value\": \"" + v.get(i) + "\"},");
		}
		result.append("],");
		return result.toString();
	}
	public String getfacilitiescheckdate(String facilities_name, String year, String month, String lastday) {
		if(facilities_name == null) facilities_name = "";
		String date1 = year + "-" + month + "-01"; 
		String date2 = year + "-" + month + "-" + lastday;
		StringBuffer result = new StringBuffer("");
		result.append("\"tableresult\":[");
		dbcon db = new dbcon();
		Vector<facilitiescheckdatedb> v = db.getcheck(facilities_name, date1, date2);
		for(int i=0; i<v.size(); i++) {
			result.append("[{\"value\": \"" + v.get(i).getContent()+ "\"},");
			result.append("{\"value\": \"" + v.get(i).getUser() + "\"},");
			result.append("{\"value\": \"" + v.get(i).getDate() + "\"},");
			result.append("{\"value\": \"" + v.get(i).getStatus() + "\"},");
			result.append("{\"value\": \"" + v.get(i).getNum() + "\"}],");
		}
		result.append("]");
		return result.toString();
	}
}
