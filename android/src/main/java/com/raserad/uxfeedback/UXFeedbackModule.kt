package com.raserad.uxfeedback

import com.facebook.react.bridge.*
import com.facebook.react.modules.core.DeviceEventManagerModule
import ru.uxfeedback.pub.sdk.UXFbOnStateCampaignListener
import ru.uxfeedback.pub.sdk.UXFbProperties
import ru.uxfeedback.pub.sdk.UXFbSettings
import ru.uxfeedback.pub.sdk.UXFeedback
import java.lang.Exception

class UXFeedbackModule(private val reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext), UXFbOnStateCampaignListener {

    override fun getName() = "UXFeedbackModule"

    @ReactMethod
    fun setSettings(settings: ReadableMap) {
        reactContext.runOnUiQueueThread {
            val feedbackSettings = UXFbSettings.getDefault().apply {
                startGlobalDelayTimer = try {
                    settings.getDouble("globalDelayTimer").toInt()
                } catch (e: Exception) {
                    startGlobalDelayTimer
                }
                slideInUiBocked = try {
                    settings.getBoolean("uiBlocked")
                } catch (e: Exception) {
                    slideInUiBocked
                }
                debugEnabled = try {
                    settings.getBoolean("debugEnabled")
                } catch (e: Exception) {
                    debugEnabled
                }
                val androidSettings = settings.getMap("android")
                if (androidSettings != null) {
                    reconnectCount = try {
                        androidSettings.getDouble("reconnectCount").toInt()
                    } catch (e: Exception) {
                        reconnectCount
                    }
                    reconnectTimeout = try {
                        androidSettings.getDouble("reconnectTimeout").toInt()
                    } catch (e: Exception) {
                        reconnectTimeout
                    }
                    val slideInBlackout = androidSettings.getMap("slideInBlackout")
                    if (slideInBlackout != null) {
                        slideInUiBlackoutColor = try {
                            slideInBlackout.getDouble("color").toInt()
                        } catch (e: Exception) {
                            slideInUiBlackoutColor
                        }
                        slideInUiBlackoutOpacity = try {
                            slideInBlackout.getDouble("opacity").toInt()
                        } catch (e: Exception) {
                            slideInUiBlackoutBlur
                        }
                        slideInUiBlackoutBlur = try {
                            slideInBlackout.getDouble("blur").toInt()
                        } catch (e: Exception) {
                            slideInUiBlackoutBlur
                        }
                    }
                    val popupBlackout = androidSettings.getMap("popupBlackout")
                    if (popupBlackout != null) {
                        popupUiBlackoutColor = try {
                            popupBlackout.getDouble("color").toInt()
                        } catch (e: Exception) {
                            popupUiBlackoutColor
                        }
                        popupUiBlackoutOpacity = try {
                            popupBlackout.getDouble("opacity").toInt()
                        } catch (e: Exception) {
                            popupUiBlackoutOpacity
                        }
                        popupUiBlackoutBlur = try {
                            popupBlackout.getDouble("blur").toInt()
                        } catch (e: Exception) {
                            popupUiBlackoutBlur
                        }
                    }
                }
            }
            UXFeedback.getInstance()?.setSettings(feedbackSettings)
        }
    }

    @ReactMethod
    fun startCampaign(eventName: String) {
        reactContext.runOnUiQueueThread {
            UXFeedback.getInstance()?.setCampaignEventsListener(this)
            UXFeedback.getInstance()?.startCampaign(eventName)
        }
    }

    @ReactMethod
    fun stopCampaign() {
        reactContext.runOnUiQueueThread {
            UXFeedback.getInstance()?.stopCampaign()
        }
    }

    @ReactMethod
    fun setProperties(properties: ReadableMap) {
        reactContext.runOnUiQueueThread {
            UXFeedback.getInstance()?.setProperties(UXFbProperties.getEmpty().apply {
                properties.entryIterator.forEach {
                    this.add(it.key, it.value.toString())
                }
            })
        }
    }

    @ReactMethod
    fun setThemeIOS() {}

    @ReactMethod
    fun addListener(eventName: String) {}

    @ReactMethod
    fun removeListeners(count: Integer) {}

    override fun getConstants(): MutableMap<String, Any> {
        return hashMapOf("count" to 1)
    }

    private fun emitEvent(event: String, data: Any) {
        reactContext.runOnUiQueueThread {
            reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java).emit(event, data)
        }
    }

    override fun uxFbOnStartCampaign(eventName: String) {
        emitEvent("campaign_start", eventName)
    }

    override fun uxFbOnStopCampaign(eventName: String) {
        emitEvent("campaign_stop", eventName)
    }
}
