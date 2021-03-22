package com.justino.sewoo.sewoo_printer;

import android.os.AsyncTask;
import android.util.Log;

import com.sewoo.jpos.command.CPCLConst;
import com.sewoo.port.android.WiFiPort;
import com.sewoo.request.android.RequestHandler;

import java.io.IOException;
import java.util.Map;
import java.util.Vector;

import io.flutter.plugin.common.MethodChannel;

public class SewooPrinterMethodChannelHandler {
  private final String TAG = "SewooPrinterHandler";
  private WiFiPort wifiPort;
  private Thread wfThread;
  private String lastConnAddr;
  private boolean disconnectflags;
  private Vector<String> ipAddrVector;
  SewooPrinter printer;
  int count = 1;
  int paperType = CPCLConst.LK_CPCL_BLACKMARK;

  MethodChannel _printerChannel;

  SewooPrinterMethodChannelHandler(MethodChannel channel) {
    _printerChannel = channel;
  }

  private void initialize() {
    if (ipAddrVector == null) {
      ipAddrVector = new Vector<String>();
    }
    if (wifiPort == null) {
      wifiPort = wifiPort.getInstance();
    }
    if (printer == null) {
      printer = new SewooPrinter();
    }
  }

  void connect() {

    try {
      initialize();
      if (wifiPort.isConnected()) {
        wifiPort.disconnect();
        wfThread.interrupt();
      }
      String input_ip = "192.168.0.107";
      wifiSetup(input_ip);

    } catch (IOException e) {
      e.printStackTrace();
    } catch (InterruptedException e) {
      e.printStackTrace();
    }
  }

  boolean isConnected() {

    try {
      if (wifiPort != null && wifiPort.isConnected()) {
        _printerChannel.invokeMethod("connect", true);
        return true;
      } else {
        _printerChannel.invokeMethod("connect", false);
        return false;
      }
    } catch (Exception e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
      _printerChannel.invokeMethod("connect", false);
      return false;
    }
  }


  void disconnect() {
    try {
      if(wifiPort.isConnected()){
        wifiPort.disconnect();
      }

      if((wfThread != null) && (wfThread.isAlive())) {
        wfThread.interrupt();
        wfThread = null;
      }
      _printerChannel.invokeMethod("connect", false);

    } catch (IOException e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
    } catch (InterruptedException e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
    }
  }

  void setLabelSize(int width, int height) {
    try {
      if (isConnected()) {
        printer.setLabelSize(width, height);
      }
    } catch (Exception e) {
      e.printStackTrace();
    }
  }

  Map<String,Number> getLabelSize() {
    try {
      return printer.getLabelSize();
    } catch (Exception e) {
      e.printStackTrace();
      return null;
    }
  }

  String getStatus() {

    try {
      String str_status = "Not connected";
      if (isConnected()) {
        str_status = printer.Get_Status();
      }
      return str_status;
    } catch (Exception e) {
      e.printStackTrace();
      return null;
    }
  }

  void print(int width, int height) {

    try {
      if (isConnected()) {
        printer.setLabelSize(width, height);
        printer.Print_Profile(count, paperType);
      }
      //printer.Print_1DBarcode(count, paperType);
      //printer.Print_2DBarcode(count, paperType);
      //printer.Print_Image(count, paperType);
      //printer.Print_Stamp(count, paperType);
      //printer.Print_Font(count, paperType);
      //printer.Print_SetMag(count, paperType);
      //printer.Print_Multiline(count, paperType);
      //printer.Print_AndroidFont(count, paperType);
      //printer.Print_MultilingualFont(count, paperType);

    } catch (Exception e) {
      e.printStackTrace();
    }

  }

  boolean printImage(String path, int width, int height) {

    try {
      if (isConnected()) {
        printer.setLabelSize(width, height);
        boolean ok = printer.Print_Image(path, count, paperType);
        return ok;
      }
      return false;
    } catch (Exception e) {
      e.printStackTrace();
      return false;
    }
  }

  void wifiSetup(String ip) {
    try {
      wifiConn(ip);
    } catch (IOException e) {
      Log.d(this.TAG, "wifiSetup: Error trying to connect to printer");
      e.printStackTrace();
    }
  }

  void wifiConn(String ipAddr) throws IOException {
    ConnWF _connWf = new ConnWF();
    _connWf.execute(ipAddr);
  }

  class ConnWF extends AsyncTask<String, Void, Boolean> {

    @Override
    protected Boolean doInBackground(String... params) {
      Boolean retVal = null;
      try {
        //IP
        String ip = params[0];
        wifiPort.connect(ip);
        lastConnAddr = ip;
        retVal = true;
      } catch (IOException e) {
        Log.wtf(TAG, "ConnWF: Error trying to connect to wifiPort");
        Log.w(TAG, e.getMessage());
        retVal = false;
      }
      return retVal;
    }

    @Override
    protected void onPostExecute(Boolean result) {

      if(result) {
        // Connection success.
        RequestHandler rh = new RequestHandler();
        wfThread = new Thread(rh);
        wfThread.start();

        if (!ipAddrVector.contains(lastConnAddr)) {
          ipAddrVector.addElement(lastConnAddr);
        }
        _printerChannel.invokeMethod("connect", true);
      } else {
        // Connection failed.
        _printerChannel.invokeMethod("connect", false);
        _printerChannel.invokeMethod("status", "Printer not found");
      }
      super.onPostExecute(result);
    }
  }


}
