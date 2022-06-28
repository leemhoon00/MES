package estimateExcel;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.net.InetAddress;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Vector;

import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import dbcon.dbcon;
import dbcon.material_etdb;
import dbcon.other_costdb;
import dbcon.proc_costdb;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletResponse;

public class estimateexcelwrite {
	public XSSFWorkbook writeExcel(String realpath, String id, String degree, String com) {
		File file = null;
		FileOutputStream fos= null;
		XSSFWorkbook workbook = null;
		dbcon db = new dbcon();
		Vector<material_etdb> me = db.getmaterial_etdb(id, degree);
		Vector<proc_costdb> pc = db.getproc_costdb(id, degree);
		Vector<other_costdb> oc = db.getother_cost(id, degree);
		Vector<String> up = db.getunitprice(me);


		try {
			String filepath = realpath + "\\견적서.xlsx";
			FileInputStream fileinput = new FileInputStream(filepath);
			workbook = new XSSFWorkbook(fileinput);
			XSSFRow xssfRow = null;
			XSSFCell xssfCell = null;
			Date from = new Date();

			SimpleDateFormat transFormat = new SimpleDateFormat("yyyyMMdd");

			String to = transFormat.format(from);
			
			XSSFSheet sheet = workbook.getSheetAt(0);
			
			xssfRow = sheet.getRow(3);
			xssfCell = xssfRow.getCell((short)3);
			xssfCell.setCellValue(id);
			
			xssfRow = sheet.getRow(3);
			xssfCell = xssfRow.getCell((short)6);
			xssfCell.setCellValue(com);
			
			xssfRow = sheet.getRow(3);
			xssfCell = xssfRow.getCell((short)11);
			xssfCell.setCellValue(to);
			
			int rowno = 7;
			int totaltotalprice1 = 0;
			for(int i=0; i<me.size(); i++) {
				xssfRow = sheet.getRow(rowno);
				xssfCell = xssfRow.getCell((short)1);
				xssfCell.setCellValue(me.get(i).getMaterials_no());
				
				xssfRow = sheet.getRow(rowno);
				xssfCell = xssfRow.getCell((short)4);
				xssfCell.setCellValue(me.get(i).getQuantity());
				
				xssfRow = sheet.getRow(rowno);
				xssfCell = xssfRow.getCell((short)5);
				xssfCell.setCellValue(up.get(i));
				
				int totalprice = Integer.parseInt(me.get(i).getQuantity()) * Integer.parseInt(up.get(i));
				totaltotalprice1 += totalprice;
				xssfRow = sheet.getRow(rowno);
				xssfCell = xssfRow.getCell((short)6);
				xssfCell.setCellValue(Integer.toString(totalprice));
				rowno++;
				if(rowno > 38) {
					break;
				}
			}
			
			rowno = 8;
			int totaltotalprice2 = 0;
			for(int i=0; i<pc.size(); i++) {
				xssfRow = sheet.getRow(rowno);
				xssfCell = xssfRow.getCell((short)7);
				xssfCell.setCellValue(pc.get(i).getStandard_proc());
				
				xssfRow = sheet.getRow(rowno);
				xssfCell = xssfRow.getCell((short)8);
				xssfCell.setCellValue(pc.get(i).getMd());
				
				xssfRow = sheet.getRow(rowno);
				xssfCell = xssfRow.getCell((short)10);
				xssfCell.setCellValue(pc.get(i).getCost());
				totaltotalprice2 += pc.get(i).getCost();
				rowno++;
				if(rowno > 27) {
					break;
				}
			}
			
			rowno = 30;
			int totaltotalprice3 = 0;
			for(int i=0; i<oc.size(); i++) {
				xssfRow = sheet.getRow(rowno);
				xssfCell = xssfRow.getCell((short)7);
				xssfCell.setCellValue(oc.get(i).getOther_et_id());
				
				xssfRow = sheet.getRow(rowno);
				xssfCell = xssfRow.getCell((short)10);
				xssfCell.setCellValue(oc.get(i).getCost());
				totaltotalprice3 += Integer.parseInt(oc.get(i).getCost());
				rowno++;
				if(rowno > 37){
					break;
				}
			}
			
			xssfRow = sheet.getRow(39);
			xssfCell = xssfRow.getCell((short)6);
			xssfCell.setCellValue(totaltotalprice1);
			
			xssfRow = sheet.getRow(27);
			xssfCell = xssfRow.getCell((short)10);
			xssfCell.setCellValue(totaltotalprice2);
			
			xssfRow = sheet.getRow(38);
			xssfCell = xssfRow.getCell((short)10);
			xssfCell.setCellValue(totaltotalprice3);
			
			int totaltotalprice4 = totaltotalprice2 + totaltotalprice3;
			
			xssfRow = sheet.getRow(39);
			xssfCell = xssfRow.getCell((short)10);
			xssfCell.setCellValue(totaltotalprice4);
			
			int totaltotalprice5 = totaltotalprice1 + totaltotalprice4;
			
			xssfRow = sheet.getRow(40);
			xssfCell = xssfRow.getCell((short)10);
			xssfCell.setCellValue(totaltotalprice5);
			
			int totaltotalprice6 = totaltotalprice4/10;
			
			xssfRow = sheet.getRow(41);
			xssfCell = xssfRow.getCell((short)10);
			xssfCell.setCellValue(totaltotalprice6);
			
			int totaltotalprice7 = totaltotalprice5 + totaltotalprice6;
			
			xssfRow = sheet.getRow(42);
			xssfCell = xssfRow.getCell((short)10);
			xssfCell.setCellValue(totaltotalprice7);
			
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return workbook;
	}
	public void deletefile(String path) {
		File file = new File(path);
		if(file.exists()) {
			file.delete();
		}
	}
}
