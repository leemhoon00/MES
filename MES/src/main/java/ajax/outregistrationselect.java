package ajax;

import jakarta.servlet.http.HttpServlet;
import java.io.IOException;
import java.util.Vector;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import dbcon.dbcon;
import dbcon.mainwork;

/**
 * Servlet implementation class outregistrationselect
 */
@WebServlet("/outregistrationselect")
public class outregistrationselect extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	  protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
			request.setCharacterEncoding("UTF-8");
			response.setContentType("text/html;charset=UTF-8");
			String ordername = request.getParameter("ordername");
			response.getWriter().write("{");
			response.getWriter().write(getpart(ordername));
			response.getWriter().write("}");
		}
		public String getpart(String ordername) {
			StringBuffer result = new StringBuffer("");
			result.append("\"result\" : \"");
			dbcon db = new dbcon();
			Vector<String> v = db.getpart(ordername);
			for(int i=0; i<v.size(); i++) {
				result.append(""+v.get(i) + ",");
				//result.append("{\"value\": \"" + v.get(i) + "\"},");
	
			}
			result.append("\"");
			return result.toString();
		}
		
}
