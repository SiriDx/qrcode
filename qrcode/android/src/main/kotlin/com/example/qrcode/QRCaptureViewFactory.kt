package com.example.qrcode

import android.content.Context
import android.view.View
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class QRCaptureViewFactory internal constructor(
    private val messenger: BinaryMessenger,
    private val containerView: View?
) :
    PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, id: Int, args: Any?): PlatformView {
        val params = args?.let { args as Map<String, Any> }
        return QRCaptureView(context, messenger, id, params, containerView)
    }
}
