package com.raserad.uxfeedback

import android.app.Application
import ru.uxfeedback.pub.sdk.UxFeedback
import ru.uxfeedback.pub.sdk.UxFbSettings

object UXFeedback {
    @JvmStatic
    fun setup(application: Application, appId: String) {
        UxFeedback.setup(application, appId, UxFbSettings.getDefault())
    }
}