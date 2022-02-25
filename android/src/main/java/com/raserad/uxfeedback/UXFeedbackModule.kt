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
        val feedbackSettings = UXFbSettings.getDefault().apply {
            startGlobalDelayTimer = try {
                settings.getDouble("globalDelayTimer").toInt()
            } catch (e: Exception) {
                startGlobalDelayTimer
            }
            reconnectCount = try {
                settings.getDouble("reconnectCount").toInt()
            } catch (e: Exception) {
                reconnectCount
            }
            reconnectTimeout = try {
                settings.getDouble("reconnectTimeout").toInt()
            } catch (e: Exception) {
                reconnectTimeout
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
            val slideInBlackout = settings.getMap("slideInBlackout")
            if (slideInBlackout != null) {
                slideInUiBlackoutOpacity = try {
                    255 / 100 * slideInBlackout.getDouble("opacity").toInt()
                } catch (e: Exception) {
                    slideInUiBlackoutBlur
                }
                slideInUiBlackoutBlur = try {
                    25 / 100 * slideInBlackout.getDouble("blur").toInt()
                } catch (e: Exception) {
                    slideInUiBlackoutBlur
                }
            }
            val fullscreenBlackout = settings.getMap("fullscreenBlackout")
            if (fullscreenBlackout != null) {
                slideInUiBlackoutOpacity = try {
                    255 / 100 * fullscreenBlackout.getDouble("opacity").toInt()
                } catch (e: Exception) {
                    slideInUiBlackoutBlur
                }
                slideInUiBlackoutBlur = try {
                    25 / 100 * fullscreenBlackout.getDouble("blur").toInt()
                } catch (e: Exception) {
                    slideInUiBlackoutBlur
                }
            }
        }
        UXFeedback.getInstance()?.setSettings(feedbackSettings)
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

    private fun emitEvent(event: String, data: Any) {
        reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java).emit(event, data)
    }

    override fun uxFbOnStartCampaign(eventName: String) {
        emitEvent("campaign_start", eventName)
    }

    override fun uxFbOnStopCampaign(eventName: String) {
        emitEvent("campaign_stop", eventName)
    }
}
