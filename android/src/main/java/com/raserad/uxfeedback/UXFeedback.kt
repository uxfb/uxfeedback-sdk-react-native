package com.raserad.uxfeedback

import android.app.Application
import android.hardware.usb.UsbEndpoint
import ru.uxfeedback.pub.sdk.UxFeedback
import ru.uxfeedback.pub.sdk.UxFbSettings

object UXFeedback {
    @JvmStatic
    fun setup(application: Application, appId: String) {
        UxFeedback.setup(application, appId, UxFbSettings.getDefault())
    }

    @JvmStatic
    fun setup(application: Application, appId: String, endpoint: String) {
        val settings = UxFbSettings.getDefault()
        settings.apiUrlDedicated = endpoint
        UxFeedback.setup(application, appId, settings)
    }
}