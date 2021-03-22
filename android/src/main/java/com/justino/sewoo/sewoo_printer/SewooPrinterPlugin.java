package com.justino.sewoo.sewoo_printer;

import androidx.annotation.NonNull;

import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** SewooPrinterPlugin */
public class SewooPrinterPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private SewooPrinter printer;
  private SewooPrinterMethodChannelHandler handler;
  private static final String channelName = "sewoo_printer";

  private static void setup(SewooPrinterPlugin plugin, BinaryMessenger binaryMessenger) {
    plugin.channel = new MethodChannel(binaryMessenger, channelName);
    plugin.channel.setMethodCallHandler(plugin);
    plugin.handler = new SewooPrinterMethodChannelHandler(plugin.channel);
    //TODO: Inicializar handler
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    setup(this, flutterPluginBinding.getBinaryMessenger());
    //channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "sewoo_printer");
    //channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("connect")) {
      try {
        result.success(null);
        handler.connect();
      } catch (Exception ex) {
        result.error("1", ex.getMessage(), ex.getStackTrace());
      }

    } else if (call.method.equals("disconnect")) {
      try {
        result.success(null);
        handler.disconnect();
      } catch (Exception ex) {
        result.error("1", ex.getMessage(), ex.getStackTrace());
      }

    } else if (call.method.equals("status")) {
      try {
        String status = handler.getStatus();
        result.success(status);

      } catch (Exception ex) {
        result.error("1", ex.getMessage(), ex.getStackTrace());
      }

    } else if (call.method.equals("print")) {
      try {
        result.success(null);
        int width = call.argument("width");
        int height = call.argument("height");
        handler.print(width, height);

      } catch (Exception ex) {
        result.error("1", ex.getMessage(), ex.getStackTrace());
      }

    } else if (call.method.equals("printImage")) {
      try {
        String path = call.argument("path");
        int width_i = call.argument("width");
        int height_i = call.argument("height");
        boolean ok = handler.printImage(path, width_i, height_i);
        result.success(ok);

      } catch (Exception ex) {
        result.error("1", ex.getMessage(), ex.getStackTrace());
      }
      
    } else if (call.method.equals("setLabelSize")) {
      try {
        result.success(null);
        int l_width = call.argument("width");
        int l_height = call.argument("height");
        handler.setLabelSize(l_width, l_height);
      } catch (Exception ex) {
        result.error("1", ex.getMessage(), ex.getStackTrace());
      }

    } else if (call.method.equals("getLabelSize")) {
      try {
        Map<String,Number> size = handler.getLabelSize();
        result.success(size);
      } catch (Exception ex) {
        result.error("1", ex.getMessage(), ex.getStackTrace());
      }
      
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
