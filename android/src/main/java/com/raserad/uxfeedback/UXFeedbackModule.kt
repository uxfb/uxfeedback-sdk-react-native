package com.raserad.uxfeedback

import com.facebook.react.bridge.*
import ru.uxfeedback.pub.sdk.UXFbOnStateCampaignListener
import ru.uxfeedback.pub.sdk.UXFbProperties
import ru.uxfeedback.pub.sdk.UXFbSettings
import ru.uxfeedback.pub.sdk.UXFeedback
import java.lang.Exception

class UXFeedbackModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext), UXFbOnStateCampaignListener {

    override fun getName() = "UXFeedbackModule"

    @ReactMethod
    fun setup(config: ReadableMap, promise: Promise) {
        val appID = config.getMap("appID") ?: return
        val androidAppID = try {
            appID.getString("android")!!
        } catch (e: Exception) {
            return
        }
        UXFeedback.init(currentActivity!!.application, androidAppID)
        val settings = config.getMap("settings")
        if (settings !== null) {
            setSettings(settings)
        }
    }

    @ReactMethod
    fun setSettings(settings: ReadableMap) {
        val uxFeedbackSettings = UXFbSettings.getDefault()
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

    @ReactMethod
    fun startCampaign(eventName: String) {
        UXFeedback.getInstance()?.setCampaignEventsListener(this)
        UXFeedback.getInstance()?.startCampaign(eventName)
    }

    @ReactMethod
    fun stopCampaign() {
        UXFeedback.getInstance()?.stopCampaign()
    }

    @ReactMethod
    fun setProperties(properties: ReadableMap) {
        UXFeedback.getInstance()?.setProperties(UXFbProperties.getEmpty().apply {
            properties.entryIterator.forEach { 
                this.add(it.key, it.value.toString())
            }
        })
    }

    override fun getConstants(): MutableMap<String, Any> {
        return hashMapOf("count" to 1)
    }

    override fun uxFbOnStartCampaign(eventName: String) {

    }

    override fun uxFbOnStopCampaign(eventName: String) {

    }
}
