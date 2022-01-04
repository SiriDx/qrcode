package com.example.qrcode

import android.app.Activity
import android.content.Context
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.mockk.every
import io.mockk.mockk
import io.mockk.mockkConstructor
import org.hamcrest.CoreMatchers
import org.hamcrest.MatcherAssert
import org.spekframework.spek2.Spek
import org.spekframework.spek2.style.specification.describe

class QRCaptureViewFactorySpec: Spek({
    describe("QRCaptureViewFactory") {
        val mockQrCaptureView = mockk<QRCaptureView>(relaxed = true)
        val mockContext = mockk<Context>(relaxed = true)
        val mockActivityPluginBinding = mockk<ActivityPluginBinding>(relaxed = true)
        val mockActivity = mockk<Activity>(relaxed = true)
        val mockBinaryMessenger = mockk<BinaryMessenger>(relaxed = true)
        mockkConstructor(QRCaptureView::class)

        describe("Create") {
            var qRCaptureViewFactory = QRCaptureViewFactory(null, mockActivityPluginBinding, mockActivity, mockBinaryMessenger)
        }
    }
})