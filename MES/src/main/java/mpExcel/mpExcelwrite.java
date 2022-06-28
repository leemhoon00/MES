package mpExcel;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Vector;

import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import dbcon.dbcon;
import dbcon.material_etdb;
import dbcon.other_costdb;
import dbcon.proc_costdb;

public class mpExcelwrite {
	public XSSFWorkbook writeExcel(String realpath, Vector<String> part, Vector<String> nor, Vector<String> cost) {
		File file = null;
		FileOutputStream fos= null; 
		XSSFWorkbook workbook = null;
		
		try {
			String filepath = realpath + "\\발주서.xlsx";
			FileInputStream fileinput = new FileInputStream(filepath);
			workbook = new XSSFWorkbook(fileinput);
			XSSFRow xssfRow = null;
			XSSFCell xssfCell = null;
			Date from = new Date();

			SimpleDateFormat transFormat = new SimpleDateFormat("yyyyMMdd");

			String to = transFormat.format(from);
			
			XSSFSheet sheet = workbook.getSheetAt(0);
			
			int rowno = 12;
			int ttotalcost = 0;
			for(int i=0; i<part.size(); i++) {
				xssfRow = sheet.getRow(rowno);
				xssfCell = xssfRow.getCell((short)2);
				xssfCell.setCellValue(part.get(i));
				
				xssfRow = sheet.getRow(rowno);
				xssfCell = xssfRow.getCell((short)6);
				xssfCell.setCellValue(nor.get(i));
				
				xssfRow = sheet.getRow(rowno);
				xssfCell = xssfRow.getCell((short)8);
				xssfCell.setCellValue(cost.get(i));
				
				int cost1 = 0;
				int totalcost = 0;
				if(cost.get(i).equals("")) {
					totalcost = Integer.parseInt(nor.get(i)) * cost1;
				}
				else {
					totalcost = Integer.parseInt(nor.get(i)) * Integer.parseInt(cost.get(i));
				}
		
				ttotalcost += totalcost;
				xssfRow = sheet.getRow(rowno);
				xssfCell = xssfRow.getCell((short)11);
				xssfCell.setCellValue(totalcost);
				rowno++;
				if(rowno > 21) {
					break;
				}
			}
			
			xssfRow = sheet.getRow(22);
			xssfCell = xssfRow.getCell((short)8);
			xssfCell.setCellValue(ttotalcost);


			
			
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
