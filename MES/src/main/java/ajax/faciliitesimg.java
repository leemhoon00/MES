package ajax;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import dbcon.dbcon;

/**
 * Servlet implementation class faciliitesimg
 */
@WebServlet("/faciliitesimg")
@MultipartConfig(
		fileSizeThreshold = 1024*1024,
		maxFileSize = 1024*1024*50,
		maxRequestSize = 1024*1024*50*5
)
public class faciliitesimg extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public faciliitesimg() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		dbcon dbc = new dbcon();

		String facilities_name = request.getParameter("nfacilities_name");
		String facilities_status = request.getParameter("nfacilities_status");
		String pay = request.getParameter("npay");
		String using = request.getParameter("nusing");
		String using_all_day = request.getParameter("nusing_all_day");
		String facilities_start = request.getParameter("nfacilities_start");
		String facilities_end = request.getParameter("nfacilities_end");
		String facilities_date = request.getParameter("nfacilities_date");
		String facilities_priority = request.getParameter("nfacilities_priority");
		String[] num = request.getParameterValues("num");
		String[] content = request.getParameterValues("content");
		String[] deletenum = request.getParameterValues("deletenum");
		
		String filename = facilities_name + ".JPG";
		dbc.insertfacilitiesfile(facilities_name, facilities_status, pay, using, using_all_day, facilities_start, facilities_end, facilities_date, facilities_priority, filename);
		dbc.insertcheck(facilities_name, content, num, deletenum);
		
		Part filePart = request.getPart("img");
		String realfileName = filePart.getSubmittedFileName();
		InputStream fis = filePart.getInputStream();
		String realPath = request.getServletContext().getRealPath("/upload");
		String filePath = realPath + File.separator + filename;
		FileOutputStream fos = new FileOutputStream(filePath);
		byte[] buf = new byte[1024];
		int size = 0;
		while((size = fis.read(buf)) != -1) {
			fos.write(buf, 0, size);
		}
		fos.close();
		fis.close();
		
		PrintWriter writer = response.getWriter();
		writer.println("<script>");
		writer.println("alert('성공');"); 
		writer.println("location.href = document.referrer;");       
		writer.println("</script>");
	
	}
}
