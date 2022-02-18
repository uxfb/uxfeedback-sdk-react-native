package com.raserad.uxfeedback

import com.facebook.react.bridge.*
import ru.uxfeedback.pub.sdk.UXFbSettings
import ru.uxfeedback.pub.sdk.UXFeedback
import java.lang.Exception

class UXFeedbackModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

    override fun getName() = "UXFeedbackModule"

    @ReactMethod
    fun setup(config: ReadableMap, promise: Promise) {
        val appID = config.getMap("appID")
        if (appID === null) {
            return
        }
        val androidAppID = appID.getString("android")
        if (androidAppID === null) {
            return
        }
        UXFeedback.init(currentActivity!!.application, androidAppID)
        val settings = config.getMap("settings")
        if (settings !== null) {
            setSettings(settings)
        }
        promise.resolve("success")
    }

    @ReactMethod
    fun setSettings(settings: ReadableMap) {
        val uxFeedbackSettings = UXFbSettings.getDefault()
        println("Current UX Feedback Settings $settings")
        val globalDelayTimer = try {
            settings.getDouble("globalDelayTimer").toInt()
        } catch (e: Exception) {
            uxFeedbackSettings.startGlobalDelayTimer
        }
        val reconnectCount = try {
            settings.getDouble("reconnectCount").toInt()
        } catch (e: Exception) {
            uxFeedbackSettings.reconnectCount
        }
        val reconnectTimeout = try {
            settings.getDouble("reconnectTimeout").toInt()
        } catch (e: Exception) {
            uxFeedbackSettings.reconnectTimeout
        }
        val uiBlocked = try {
            settings.getBoolean("uiBlocked")
        } catch (e: Exception) {
            uxFeedbackSettings.slideInUiBocked
        }
        val debugEnabled = try {
            settings.getBoolean("debugEnabled")
        } catch (e: Exception) {
            uxFeedbackSettings.debugEnabled
        }
        UXFeedback.getInstance()?.setSettings(uxFeedbackSettings.apply {
            this.startGlobalDelayTimer = globalDelayTimer
            this.reconnectCount = reconnectCount
            this.reconnectTimeout = reconnectTimeout
            this.slideInUiBocked = uiBlocked
            this.debugEnabled = debugEnabled
        })
    }

    override fun getConstants(): MutableMap<String, Any> {
        return hashMapOf("count" to 1)
    }
}
