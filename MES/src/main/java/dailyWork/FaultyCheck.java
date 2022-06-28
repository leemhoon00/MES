package dailyWork;

import java.io.IOException;
import java.io.PrintWriter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/dailyWork/FaultyCheck")
public class FaultyCheck extends HttpServlet {
    public FaultyCheck() {
        super();
    }

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PrintWriter writer = response.getWriter();

		DailyWorkDAO dao = new DailyWorkDAO();
		
		String mode = request.getParameter("mode");
		String ordername = request.getParameter("ordername");
		String checked = request.getParameter("checked");
		
		
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
