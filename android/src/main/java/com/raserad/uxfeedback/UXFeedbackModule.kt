package com.raserad.uxfeedback

import com.facebook.react.bridge.*
import com.facebook.react.modules.core.DeviceEventManagerModule
import ru.uxfeedback.pub.sdk.*
import java.lang.Exception

class UXFeedbackModule(private val reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext), UXFbOnEventsListener {

    override fun getName() = "UXFeedbackModule"

    @ReactMethod
    fun setup(config: ReadableMap, promise: Promise) {
        UXFeedback.getInstance()?.setUxFbEventsListener(this)
    }

    @ReactMethod
    fun setSettings(settings: ReadableMap) {
        reactContext.runOnUiQueueThread {
            val feedbackSettings = UXFbSettings.getDefault().apply {
                startGlobalDelayTimer = try {
                    settings.getDouble("globalDelayTimer").toInt()
                } catch (e: Exception) {
                    startGlobalDelayTimer
                }
                slideInUiBlocked = try {
                    settings.getBoolean("uiBlocked")
                } catch (e: Exception) {
                    slideInUiBlocked
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
                    fieldsEventEnabled = try {
                        androidSettings.getBoolean("fieldsEnabled")
                    } catch (e: Exception) {
                        fieldsEventEnabled
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
    fun removeListeners(count: Int) {}

    override fun getConstants(): MutableMap<String, Any> {
        return hashMapOf("count" to 1)
    }

    private fun emitEvent(event: String, data: Any) {
        reactContext.runOnUiQueueThread {
            reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java).emit(event, data)
        }
    }

    override fun uxFbNoCampaignToStart(eventName: String) {}

    override fun uxFbOnFieldsEvent(campaignId: Int, eventName: String, fieldValues: Map<String, Array<String>>) {
        val params = Arguments.createMap()
        params.putString("campaignId", campaignId.toString())
        params.putMap("fieldValues", Arguments.createMap().apply {
            fieldValues.forEach {
                this.putString(it.key, it.value.joinToString(","))
            }
        })
        emitEvent("campaign_event_send", params)
    }

    override fun uxFbOnFinishCampaign(campaignId: Int, eventName: String) {
        emitEvent("campaign_finish", eventName)
    }

    override fun uxFbOnReady() {
        emitEvent("campaign_loaded", true)
    }

    override fun uxFbOnStartCampaign(campaignId: Int, eventName: String) {
        emitEvent("campaign_show", eventName)
    }

    override fun uxFbOnTerminateCampaign(campaignId: Int, eventName: String, terminatedPage: Int, totalPages: Int) {
        val params = Arguments.createMap()
        params.putString("eventName", eventName)
        params.putInt("terminatePage", terminatedPage)
        params.putInt("totalPages", totalPages)
        emitEvent("campaign_terminate", params)
    }
}
