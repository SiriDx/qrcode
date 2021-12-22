package com.example.qrcode

import android.app.Activity
import android.content.Context
import android.view.View
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class QRCaptureViewFactory internal constructor(
    private val registrar: PluginRegistry.Registrar?,
    private val binding: ActivityPluginBinding?,
    private val activity: Activity,
    private val messenger: BinaryMessenger
) :
    PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, id: Int, args: Any?): PlatformView {
        return QRCaptureView(registrar, binding, activity, messenger, id)
    }
}
