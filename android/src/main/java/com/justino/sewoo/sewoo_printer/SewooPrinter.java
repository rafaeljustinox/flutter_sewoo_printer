package com.justino.sewoo.sewoo_printer;

import android.graphics.Typeface;

import com.sewoo.jpos.command.CPCLConst;
import com.sewoo.jpos.printer.CPCLPrinter;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Map;

public class SewooPrinter {

  private CPCLPrinter cpclPrinter;
  private int labelWidth = 384;
  private int labelHeight = 406;

  private final int MEASURE_INCH = 0;
  private final int MEASURE_CENTIMETERS = 1;
  private final int MEASURE_MILLIMETERS = 2;
  private final int MEASURE_DOTS = 3;

  public SewooPrinter()
  {
    cpclPrinter = new CPCLPrinter();    //Default = English.
    //cpclPrinter.setMeasure(MEASURE_INCH);
    //cpclPrinter = new CPCLPrinter("EUC-KR"); // Korean.
    //cpclPrinter = new CPCLPrinter("GB2312"); //Chinese.
  }

  public void setLabelSize(int width, int height) {

    this.labelWidth = width;
    this.labelHeight = height;

  }

  public Map<String, Number> getLabelSize() {
    Map<String, Number> size = new HashMap<>();
    size.put("width", this.labelWidth);
    size.put("height", this.labelHeight);
    return size;
  }

  public void Print_Profile(int count, int paper_type) throws UnsupportedEncodingException
  {
    //2-inch
    //cpclPrinter.setForm(0, 200, 200, 406, 384, count);
    cpclPrinter.setForm(0, 200, 200, this.labelHeight, this.labelWidth, count);
    cpclPrinter.setMedia(paper_type);

    cpclPrinter.printCPCLText(0, 5, 1, 1, 1, "SEWOO TECH CO.,LTD.", 0);
    cpclPrinter.printCPCLText(0, 0, 2, 1, 70, "Global leader in the mini-printer industry.", 0);
    cpclPrinter.printCPCLText(0, 0, 2, 1, 110, "Total Printing Solution", 0);
    cpclPrinter.printCPCLText(0, 0, 2, 1, 150, "Diverse innovative and reliable products", 0);
    // Telephone
    cpclPrinter.printCPCLText(CPCLConst.LK_CPCL_0_ROTATION, 7, 0, 1, 200, "TEL : 82-31-459-8200", 0);
    // Homepage
    cpclPrinter.printCPCL2DBarCode(0, CPCLConst.LK_CPCL_BCS_QRCODE, 0, 250, 4, 0, 1, 0, "http://www.miniprinter.com");
    cpclPrinter.printCPCLText(CPCLConst.LK_CPCL_0_ROTATION, 7, 0, 130, 250, "www.miniprinter.com", 0);
    cpclPrinter.printCPCLText(CPCLConst.LK_CPCL_0_ROTATION, 1, 0, 130, 300, "<-- Check This.", 0);
    cpclPrinter.printForm();

        /*//3-inch
        cpclPrinter.setForm(0, 200, 200, 576, count);
		cpclPrinter.setMedia(paperType);
		cpclPrinter.printCPCLText(0, 5, 2, 30, 1, "SEWOO TECH CO.,LTD.", 0);
    	cpclPrinter.printCPCLText(0, 0, 3, 30, 70, "Global leader in the mini-printer industry.", 0);
    	cpclPrinter.printCPCLText(0, 0, 3, 30, 110, "Total Printing Solution", 0);
    	cpclPrinter.printCPCLText(0, 0, 3, 30, 150, "Diverse innovative and reliable products", 0);
    	// Telephone
		cpclPrinter.printCPCLText(CPCLConst.LK_CPCL_0_ROTATION, 7, 1, 30, 220, "TEL : 82-31-459-8200", 0);
    	// Homepage
		cpclPrinter.printCPCL2DBarCode(0, CPCLConst.LK_CPCL_BCS_QRCODE, 30, 300, 6, 0, 1, 0, "http://www.miniprinter.com");
		cpclPrinter.printCPCLText(CPCLConst.LK_CPCL_0_ROTATION, 7, 1, 210, 300, "www.miniprinter.com", 0);
		cpclPrinter.printCPCLText(CPCLConst.LK_CPCL_0_ROTATION, 1, 1, 210, 390, "<-- Check This.", 0);
    	cpclPrinter.printForm();
        */
  }

  public void Print_1DBarcode(int count, int paper_type) throws UnsupportedEncodingException
  {
    cpclPrinter.setForm(0, 200, 200, this.labelHeight, this.labelWidth, count);
    cpclPrinter.setMedia(paper_type);
//		cpclPrinter.userString("BACKFEED", true); // Back feed.

    // CODABAR
    cpclPrinter.setCPCLBarcode(0, 0, 0);
    cpclPrinter.printCPCLBarcode(CPCLConst.LK_CPCL_0_ROTATION, CPCLConst.LK_CPCL_BCS_CODABAR, 2, CPCLConst.LK_CPCL_BCS_0RATIO, 30, 19, 45, "A37859B", 0);
    cpclPrinter.printCPCLText(0, 7, 0, 19, 18, "CODABAR", 0);
    // Code 39
    cpclPrinter.setCPCLBarcode(0, 0, 0);
    cpclPrinter.printCPCLBarcode(CPCLConst.LK_CPCL_0_ROTATION, CPCLConst.LK_CPCL_BCS_39, 2, CPCLConst.LK_CPCL_BCS_1RATIO, 30, 19, 130, "0123456", 0);
    cpclPrinter.printCPCLText(0, 7, 0, 21, 103, "CODE 39", 0);
    // Code 93
    cpclPrinter.setCPCLBarcode(0, 0, 0);
    cpclPrinter.printCPCLBarcode(CPCLConst.LK_CPCL_0_ROTATION, CPCLConst.LK_CPCL_BCS_93, 2, CPCLConst.LK_CPCL_BCS_1RATIO, 30, 19, 215, "0123456", 0);
    cpclPrinter.printCPCLText(0, 7, 0, 21, 180, "CODE 93", 0);
    // BARCODE 128 1 1 50 150 10 HORIZ.
    cpclPrinter.setCPCLBarcode(0, 0, 0);
    cpclPrinter.printCPCLBarcode(CPCLConst.LK_CPCL_0_ROTATION, CPCLConst.LK_CPCL_BCS_128, 2, CPCLConst.LK_CPCL_BCS_1RATIO, 30, 19, 300, "A37859B", 0);
    cpclPrinter.printCPCLText(0, 7, 0, 21, 270, "CODE 128", 0);
    // Print
    cpclPrinter.printForm();

        /* //3-inch
        cpclPrinter.setForm(0, 200, 200, 576, count);
		cpclPrinter.setMedia(paperType);
		cpclPrinter.setCPCLBarcode(0, 2, 0);
		// CODABAR
		cpclPrinter.printCPCLBarcode(CPCLConst.LK_CPCL_0_ROTATION, CPCLConst.LK_CPCL_BCS_CODABAR, 2, CPCLConst.LK_CPCL_BCS_0RATIO, 50, 109, 45, "A1234567890B", 0);
		// Code 39
		cpclPrinter.printCPCLBarcode(CPCLConst.LK_CPCL_0_ROTATION, CPCLConst.LK_CPCL_BCS_39, 2, CPCLConst.LK_CPCL_BCS_1RATIO, 50, 19, 150, "01234567890", 0);
		// Code 93
		cpclPrinter.printCPCLBarcode(CPCLConst.LK_CPCL_0_ROTATION, CPCLConst.LK_CPCL_BCS_93, 2, CPCLConst.LK_CPCL_BCS_1RATIO, 50, 79, 255, "01234567890", 0);
		// Code 128
		cpclPrinter.printCPCLBarcode(CPCLConst.LK_CPCL_0_ROTATION, CPCLConst.LK_CPCL_BCS_128, 2, CPCLConst.LK_CPCL_BCS_1RATIO, 50, 109, 360, "01234567890", 0);
		// Print
		cpclPrinter.printForm();
        */
  }

  public void Print_2DBarcode(int count, int paper_type) throws UnsupportedEncodingException
  {
    cpclPrinter.setForm(0, 200, 200, this.labelHeight, this.labelWidth, count);
    cpclPrinter.setMedia(paper_type);

    cpclPrinter.printCPCL2DBarCode(0, CPCLConst.LK_CPCL_BCS_DATAMATRIX, 10, 10, 4, 0, 0, 0, "1234567890");
    cpclPrinter.printCPCL2DBarCode(0, CPCLConst.LK_CPCL_BCS_PDF417, 80, 90, 2, 7, 2, 1, "SEWOO TECH\r\nLK-P11");
    cpclPrinter.printCPCL2DBarCode(0, CPCLConst.LK_CPCL_BCS_QRCODE, 30, 170, 4, 0, 1, 0, "LK-P11");
    cpclPrinter.printForm();
  }

  public boolean Print_Image(String path, int count, int paper_type) throws IOException {

    cpclPrinter.setForm(0, 200, 200, this.labelHeight, this.labelWidth, count);
    cpclPrinter.setMedia(paper_type);

    int result = cpclPrinter.printBitmap(path, 1, 1);
    if (result == 0) {
      // Success
      cpclPrinter.printForm();
      return true;
    } else {
      // Fail
      return false;
    }
    //cpclPrinter.printBitmap("//sdcard//temp//test//sample_3.jpg", 100, 200);
    //cpclPrinter.printBitmap("//sdcard//temp//test//sample_4.jpg", 120, 245);
    //cpclPrinter.printForm();

  }

  public void Print_Stamp(int count, int paper_type) throws IOException
  {
    cpclPrinter.setForm(0, 200, 200, this.labelHeight, this.labelWidth, count);
    cpclPrinter.setMedia(paper_type);

    cpclPrinter.printBitmap("//sdcard//temp//test//danmark_windmill.jpg", 10, 10);
    cpclPrinter.printBitmap("//sdcard//temp//test//denmark_flag.jpg", 222, 55);
    cpclPrinter.setCPCLBarcode(0, 0, 0);
    cpclPrinter.printCPCLBarcode(CPCLConst.LK_CPCL_0_ROTATION, CPCLConst.LK_CPCL_BCS_128, 2, CPCLConst.LK_CPCL_BCS_1RATIO, 30, 19, 290, "0123456", 1);
    cpclPrinter.printCPCLText(0, 0, 1, 21, 345, "Quantity 001", 1); //count
    cpclPrinter.printForm();
  }

  public void Print_Font(int count, int paper_type) throws UnsupportedEncodingException
  {
    cpclPrinter.setForm(0, 200, 200, this.labelHeight, this.labelWidth, count); //500x384
    cpclPrinter.setMedia(paper_type);

    //FONT Size
    cpclPrinter.printCPCLText(0, 0, 0, 1, 1,   "FONT-0-0", 2);
    cpclPrinter.printCPCLText(0, 0, 1, 100, 1,  "FONT-0-1", 0);
    cpclPrinter.printCPCLText(0, 0, 2, 1, 17, "FONT-0-2", 0);
    // FONT Type 0,1,2,4,5,6,7
    cpclPrinter.printCPCLText(0, 0, 0, 1, 75,   "ABCD1234", 0);
    cpclPrinter.printCPCLText(0, 1, 0, 1, 95,  "ABCD1234", 0);
    cpclPrinter.printCPCLText(0, 2, 0, 1, 145, "ABCD1234", 0);
    cpclPrinter.printCPCLText(0, 4, 0, 1, 160, "ABCD1234", 0);
    cpclPrinter.printCPCLText(0, 5, 0, 1, 200, "ABCD1234", 0);
    cpclPrinter.printCPCLText(0, 6, 0, 1, 230,  "ABCD1234", 0);
    cpclPrinter.printCPCLText(0, 7, 0, 1, 265,  "ABCD1234", 0);
    //FONT Concat
    cpclPrinter.setConcat(CPCLConst.LK_CPCL_CONCAT, 1, 310);
    cpclPrinter.concatText(4, 2, 5, "$");
    cpclPrinter.concatText(4, 3, 0, "12");
    cpclPrinter.concatText(4, 2, 5, "34");
    cpclPrinter.resetConcat();
    // Print
    cpclPrinter.printForm();
  }

  public void Print_SetMag(int count, int paper_type) throws UnsupportedEncodingException
  {
    cpclPrinter.setForm(0, 200, 200, this.labelHeight, this.labelWidth, count);
    //cpclPrinter.setForm(0, 200, 200, 406, 384, count);
    cpclPrinter.setMedia(paper_type);

    cpclPrinter.setMagnify(CPCLConst.LK_CPCL_TXT_2WIDTH, CPCLConst.LK_CPCL_TXT_2HEIGHT);
    cpclPrinter.setJustification(CPCLConst.LK_CPCL_LEFT);
    cpclPrinter.printCPCLText(CPCLConst.LK_CPCL_0_ROTATION, CPCLConst.LK_CPCL_FONT_0, 0, 1, 1, "FONT-0-0", 2);
    cpclPrinter.setMagnify(CPCLConst.LK_CPCL_TXT_1WIDTH, CPCLConst.LK_CPCL_TXT_1HEIGHT);
    cpclPrinter.printCPCLText(CPCLConst.LK_CPCL_0_ROTATION, CPCLConst.LK_CPCL_FONT_0, 1, 1, 50,  "FONT-0-1", 0);
    cpclPrinter.setJustification(CPCLConst.LK_CPCL_CENTER);
    cpclPrinter.printCPCLText(CPCLConst.LK_CPCL_0_ROTATION, CPCLConst.LK_CPCL_FONT_4, 0, 1, 100, "FONT-4-0", 0);
    cpclPrinter.setMagnify(CPCLConst.LK_CPCL_TXT_2WIDTH, CPCLConst.LK_CPCL_TXT_1HEIGHT);
    cpclPrinter.printCPCLText(CPCLConst.LK_CPCL_0_ROTATION, CPCLConst.LK_CPCL_FONT_4, 1, 1, 150,  "FONT-4-1", 0);
    cpclPrinter.setMagnify(CPCLConst.LK_CPCL_TXT_1WIDTH, CPCLConst.LK_CPCL_TXT_1HEIGHT);
    cpclPrinter.setJustification(CPCLConst.LK_CPCL_RIGHT);
    cpclPrinter.printCPCLText(CPCLConst.LK_CPCL_0_ROTATION, CPCLConst.LK_CPCL_FONT_4, 2, 1, 260,  "4-2", 0);
    cpclPrinter.resetMagnify();
    // Print
    cpclPrinter.printForm();
  }

  public void Print_Multiline(int count, int paper_type) throws UnsupportedEncodingException
  {
    String data = "ABCDEFGHIJKLMNOPQRSTUVWXYZ;0123456789!@#%^&*\r\n";
    StringBuffer sb = new StringBuffer();
    for(int i=0;i<16;i++)
    {
      sb.append(data);
    }

    //cpclPrinter.setForm(0, 200, 200, 406, 384, count);
    cpclPrinter.setForm(0, 200, 200, this.labelHeight, this.labelWidth, count);
    cpclPrinter.setMedia(paper_type);

    // MultiLine mode.
    cpclPrinter.setMultiLine(15);
    cpclPrinter.multiLineText(0, 0, 0, 10, 20);
    cpclPrinter.multiLineData(sb.toString());
    cpclPrinter.resetMultiLine();
    // Print
    cpclPrinter.printForm();
  }

  public void Print_AndroidFont(int count, int paper_type) throws IOException
  {
    int nLineWidth = 384;     //2-inch
    //int nLineWidth = 576;   //3-inch
    //int nLineWidth = 832;   //4-inch

    String data = "Receipt";
//    	String data = "영수증";
    Typeface typeface = null;

    cpclPrinter.setForm(0, 200, 200, 406, nLineWidth, count);
    cpclPrinter.setMedia(paper_type);

    cpclPrinter.printAndroidFont(data, nLineWidth, 100, 0, CPCLConst.LK_CPCL_LEFT);
    cpclPrinter.printAndroidFont("Left Alignment", nLineWidth, 24, 120, CPCLConst.LK_CPCL_LEFT);
    cpclPrinter.printAndroidFont("Center Alignment", nLineWidth, 24, 150, CPCLConst.LK_CPCL_CENTER);
    cpclPrinter.printAndroidFont("Right Alignment", nLineWidth, 24, 180, CPCLConst.LK_CPCL_RIGHT);

    cpclPrinter.printAndroidFont(Typeface.SANS_SERIF, "SANS_SERIF : 1234iwIW", nLineWidth, 24, 210, CPCLConst.LK_CPCL_LEFT);
    cpclPrinter.printAndroidFont(Typeface.SERIF, "SERIF : 1234iwIW", nLineWidth, 24, 240, CPCLConst.LK_CPCL_LEFT);
    cpclPrinter.printAndroidFont(typeface.MONOSPACE, "ComingSoon : 1234iwIW", nLineWidth, 24, 270, CPCLConst.LK_CPCL_LEFT);

    // Print
    cpclPrinter.printForm();
  }

  public void Print_MultilingualFont(int count, int paper_type) throws IOException
  {
    int nLineWidth = 384;   //2-inch
    //int nLineWidth = 576;   //3-inch
    //int nLineWidth = 832;   //4-inch
    String Koreandata = "영수증";
    String Turkishdata = "Turkish(İ,Ş,Ğ)";
    String Russiandata = "Получение";
    String Arabicdata = "الإيصال";
    String Greekdata = "Παραλαβή";
    String Japanesedata = "領収書";
    String GB2312data = "收据";
    String BIG5data = "收據";


    cpclPrinter.setForm(0, 200, 200, 1000, nLineWidth, count);
    cpclPrinter.setMedia(paper_type);

    cpclPrinter.printAndroidFont("Korean Font", nLineWidth, 24, 0, CPCLConst.LK_CPCL_LEFT);
    // Korean 100-dot size font in android device.
    cpclPrinter.printAndroidFont(Koreandata, nLineWidth, 100, 30, CPCLConst.LK_CPCL_CENTER);

    cpclPrinter.printAndroidFont("Turkish Font", nLineWidth, 24, 140, CPCLConst.LK_CPCL_LEFT);
    // Turkish 50-dot size font in android device.
    cpclPrinter.printAndroidFont(Turkishdata, nLineWidth, 50, 170, CPCLConst.LK_CPCL_CENTER);

    cpclPrinter.printAndroidFont("Russian Font", nLineWidth, 24, 230, CPCLConst.LK_CPCL_LEFT);
    // Russian 60-dot size font in android device.
    cpclPrinter.printAndroidFont(Russiandata, nLineWidth, 60, 260, CPCLConst.LK_CPCL_CENTER);

    cpclPrinter.printAndroidFont("Arabic Font", nLineWidth, 24, 330, CPCLConst.LK_CPCL_LEFT);
    // Arabic 100-dot size font in android device.
    cpclPrinter.printAndroidFont(Arabicdata, nLineWidth, 100, 360, CPCLConst.LK_CPCL_CENTER);

    cpclPrinter.printAndroidFont("Greek Font", nLineWidth, 24, 470, CPCLConst.LK_CPCL_LEFT);
    // Greek 60-dot size font in android device.
    cpclPrinter.printAndroidFont(Greekdata, nLineWidth, 60, 500, CPCLConst.LK_CPCL_CENTER);

    cpclPrinter.printAndroidFont("Japanese Font", nLineWidth, 24, 570, CPCLConst.LK_CPCL_LEFT);
    // Japanese 100-dot size font in android device.
    cpclPrinter.printAndroidFont(Japanesedata, nLineWidth, 100, 600, CPCLConst.LK_CPCL_CENTER);

    cpclPrinter.printAndroidFont("GB2312 Font", nLineWidth, 24, 710, CPCLConst.LK_CPCL_LEFT);
    // GB2312 100-dot size font in android device.
    cpclPrinter.printAndroidFont(GB2312data, nLineWidth, 100, 740, CPCLConst.LK_CPCL_CENTER);

    cpclPrinter.printAndroidFont("BIG5 Font", nLineWidth, 24, 850, CPCLConst.LK_CPCL_LEFT);
    // BIG5 100-dot size font in android device.
    cpclPrinter.printAndroidFont(BIG5data, nLineWidth, 100, 880, CPCLConst.LK_CPCL_CENTER);

    // Print
    cpclPrinter.printForm();
  }

  public String Get_Status() throws UnsupportedEncodingException
  {
    String result = "";
    if(!(cpclPrinter.printerCheck() < 0))
    {
      int sts = cpclPrinter.status();
      if(sts == CPCLConst.LK_STS_CPCL_NORMAL)
        return "Normal";
      if((sts & CPCLConst.LK_STS_CPCL_BUSY) > 0)
        result = result + "Busy\r\n";
      if((sts & CPCLConst.LK_STS_CPCL_PAPER_EMPTY) > 0)
        result = result + "Paper empty\r\n";
      if((sts & CPCLConst.LK_STS_CPCL_COVER_OPEN) > 0)
        result = result + "Cover open\r\n";
      if((sts & CPCLConst.LK_STS_CPCL_BATTERY_LOW) > 0)
        result = result + "Battery low\r\n";
    }
    else
    {
      result = "Check the printer\r\nNo response";
    }
    return result;
  }
}

