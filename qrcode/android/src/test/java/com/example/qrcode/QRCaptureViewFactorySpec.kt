package com.example.qrcode

import android.app.Activity
import org.hamcrest.MatcherAssert.assertThat
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.mockk.*
import org.hamcrest.CoreMatchers
import org.spekframework.spek2.Spek
import org.spekframework.spek2.style.specification.describe

class QRCaptureViewFactorySpec: Spek({
    describe("QRCaptureViewFactory") {
        val mockActivityPluginBinding = mockk<ActivityPluginBinding>(relaxed = true)
        val mockActivity = mockk<Activity>(relaxed = true)
        val mockBinaryMessenger = mockk<BinaryMessenger>(relaxed = true)

        describe("Create") {
            assertThat(QRCaptureViewFactory(null, mockActivityPluginBinding, mockActivity, mockBinaryMessenger), CoreMatchers.instanceOf(QRCaptureViewFactory::class.java))
        }
    }
})