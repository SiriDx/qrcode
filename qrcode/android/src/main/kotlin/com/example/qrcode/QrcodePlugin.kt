package com.example.qrcode

import io.flutter.plugin.common.PluginRegistry.Registrar
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

class QrcodePlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  private var channel : MethodChannel? = null
  private var flutterPluginBinding: FlutterPluginBinding? = null
  private var flutterActivityBinding: ActivityPluginBinding? = null

  override fun onAttachedToEngine(@NonNull binding: FlutterPluginBinding) {
    flutterPluginBinding = binding;
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    flutterActivityBinding = binding
    val qRCaptureViewFactory =
      flutterPluginBinding?.let { QRCaptureViewFactory(null, binding, binding.activity, it.binaryMessenger) }
    flutterPluginBinding?.platformViewRegistry?.registerViewFactory("plugins/qr_capture_view", qRCaptureViewFactory);
  }

  override fun onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity()
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    onAttachedToActivity(binding)
  }

  override fun onDetachedFromActivity() {
    channel = null
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPluginBinding) {
    this.flutterPluginBinding = null
  }

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      registrar.platformViewRegistry().registerViewFactory("plugins/qr_capture_view", QRCaptureViewFactory(registrar, null, registrar.activity(), registrar.messenger()))
    }
  }
}
