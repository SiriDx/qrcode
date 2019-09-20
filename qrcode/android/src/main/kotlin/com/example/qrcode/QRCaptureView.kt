package com.example.qrcode

import android.Manifest
import android.app.Activity
import android.app.Application
import android.content.Context
import android.content.pm.PackageManager
import android.content.pm.PackageManager.PERMISSION_GRANTED
import android.os.Build
import android.os.Bundle
import android.view.View
import com.google.zxing.ResultPoint
import android.hardware.Camera.CameraInfo
import com.journeyapps.barcodescanner.BarcodeCallback
import com.journeyapps.barcodescanner.BarcodeResult
import com.journeyapps.barcodescanner.BarcodeView
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.platform.PlatformView

class QRCaptureView(private val registrar: PluginRegistry.Registrar, id: Int) :
        PlatformView, MethodCallHandler {
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when(call?.method){
            "checkAndRequestPermission" -> {
                checkAndRequestPermission(result)
            }
        }

        when(call?.method){
            "resume" -> {
                resume()
            }
        }

        when(call?.method){
            "pause" -> {
                pause()
            }
        }

        when(call?.method){
            "setTorchMode" -> {
                val isOn = call.arguments as Boolean
                barcodeView?.setTorch(isOn);
            }
        }
    }

    private fun resume() {
        barcodeView?.resume()
    }

    private fun pause() {
        barcodeView?.pause()
    }

    private fun checkAndRequestPermission(result: MethodChannel.Result?) {
        if (cameraPermissionContinuation != null) {
            result?.error("cameraPermission", "Camera permission request ongoing", null);
        }

        cameraPermissionContinuation = Runnable {
            cameraPermissionContinuation = null
            if (!hasCameraPermission()) {
                result?.error(
                        "cameraPermission", "MediaRecorderCamera permission not granted", null)
                return@Runnable
            }
        }

        requestingPermission = false
        if (hasCameraPermission()) {
            cameraPermissionContinuation?.run()
        } else {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                requestingPermission = true
                registrar
                        .activity()
                        .requestPermissions(
                                arrayOf(Manifest.permission.CAMERA),
                                CAMERA_REQUEST_ID)
            }
        }
    }

    private fun hasCameraPermission(): Boolean {
        return Build.VERSION.SDK_INT < Build.VERSION_CODES.M ||
                activity.checkSelfPermission(Manifest.permission.CAMERA) == PackageManager.PERMISSION_GRANTED
    }


    companion object {
        const val CAMERA_REQUEST_ID = 513469796
    }

    var barcodeView: BarcodeView? = null
    private val activity = registrar.activity()
    var cameraPermissionContinuation: Runnable? = null
    var requestingPermission = false
    val channel: MethodChannel

    init {
        registrar.addRequestPermissionsResultListener(CameraRequestPermissionsListener())
        channel = MethodChannel(registrar.messenger(), "plugins/qr_capture/method_$id")
        channel.setMethodCallHandler(this)
        checkAndRequestPermission(null)

        val barcode = BarcodeView(registrar.activity())
        this.barcodeView = barcode
        barcode.decodeContinuous(
                object : BarcodeCallback {
                    override fun barcodeResult(result: BarcodeResult) {
                        channel.invokeMethod("onCaptured", result.text)
                    }

                    override fun possibleResultPoints(resultPoints: List<ResultPoint>) {}
                }
        )

        barcode.resume()

        registrar.activity().application.registerActivityLifecycleCallbacks(
         object : Application.ActivityLifecycleCallbacks {
             override fun onActivityPaused(p0: Activity?) {
                 if (p0 == registrar.activity()) {
                     barcodeView?.pause()
                 }
             }

             override fun onActivityResumed(p0: Activity?) {
                 if (p0 == registrar.activity()) {
                     barcodeView?.resume()
                 }
             }

             override fun onActivityStarted(p0: Activity?) {
             }

             override fun onActivityDestroyed(p0: Activity?) {
             }

             override fun onActivitySaveInstanceState(p0: Activity?, p1: Bundle?) {
             }

             override fun onActivityStopped(p0: Activity?) {
             }

             override fun onActivityCreated(p0: Activity?, p1: Bundle?) {
             }

         }
        )
    }

    override fun getView(): View {
        return this.barcodeView!!;
    }

    override fun dispose() {
        barcodeView?.pause()
        barcodeView = null
    }

    private inner class CameraRequestPermissionsListener : PluginRegistry.RequestPermissionsResultListener {
        override fun onRequestPermissionsResult(id: Int, permissions: Array<String>, grantResults: IntArray): Boolean {
            if (id == CAMERA_REQUEST_ID && grantResults[0] == PERMISSION_GRANTED) {
                cameraPermissionContinuation?.run()
                return true
            }
            return false
        }
    }

}
