package com.raserad.uxfeedback

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.Arguments
import com.facebook.react.modules.core.DeviceEventManagerModule
import ru.uxfeedback.pub.sdk.UxFeedback
import ru.uxfeedback.pub.sdk.UxFbOnEventsListener
import ru.uxfeedback.pub.sdk.UxFbOnLogListener
import ru.uxfeedback.pub.sdk.UxFbColor
import ru.uxfeedback.pub.sdk.UxFbDimen
import ru.uxfeedback.pub.sdk.UxFbFont
import kotlin.Exception

class UXFeedbackModule(private val reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext), UxFbOnEventsListener, UxFbOnLogListener {

    override fun getName() = "UXFeedbackModule"

    @ReactMethod
    fun setup(config: ReadableMap, promise: Promise) {
        UxFeedback.sdk?.campaignListener = this
        UxFeedback.sdk?.logListener = this
        val settings = config.getMap("settings")
        if (settings !== null) {
            setSettings(settings)
        }
        val theme = config.getMap("theme")
        if (theme !== null) {
            setTheme(theme)
        }
        val properties = config.getMap("properties")
        if (properties !== null) {
            setProperties(properties)
        }
    }

    @ReactMethod
    fun setSettings(settings: ReadableMap) {
        reactContext.runOnUiQueueThread {
            UxFeedback.sdk?.settings?.apply {
                apiUrlDedicated = try {
                    settings.getString("endpointURL")!!
                } catch (e: Exception) {
                    apiUrlDedicated
                }
                startGlobalDelayTimer = try {
                    settings.getDouble("globalDelayTimer").toInt()
                } catch (e: Exception) {
                    startGlobalDelayTimer
                }
                slideInUiBlocked = try {
                    settings.getBoolean("slideInUiBlocked")
                } catch (e: Exception) {
                    slideInUiBlocked
                }
                debugEnabled = try {
                    settings.getBoolean("debugEnabled")
                } catch (e: Exception) {
                    debugEnabled
                }
                fieldsEventEnabled = try {
                    settings.getBoolean("fieldsEventEnabled")
                } catch (e: Exception) {
                    fieldsEventEnabled
                }
                val slideInUiBlackout = settings.getMap("slideInUiBlackout")
                if (slideInUiBlackout != null) {
                    slideInUiBlackoutColor = try {
                        UxFbColor.fromHex(slideInUiBlackout.getString("color")!!)
                    } catch (e: Exception) {
                        slideInUiBlackoutColor
                    }
                    slideInUiBlackoutOpacity = try {
                        slideInUiBlackout.getDouble("opacity").toInt()
                    } catch (e: Exception) {
                        slideInUiBlackoutBlur
                    }
                    slideInUiBlackoutBlur = try {
                        slideInUiBlackout.getDouble("blur").toInt()
                    } catch (e: Exception) {
                        slideInUiBlackoutBlur
                    }
                }
                val popupUiBlackout = settings.getMap("popupUiBlackout")
                if (popupUiBlackout != null) {
                    popupUiBlackoutColor = try {
                        UxFbColor.fromHex(popupUiBlackout.getString("color")!!)
                    } catch (e: Exception) {
                        popupUiBlackoutColor
                    }
                    popupUiBlackoutOpacity = try {
                        popupUiBlackout.getDouble("opacity").toInt()
                    } catch (e: Exception) {
                        popupUiBlackoutOpacity
                    }
                    popupUiBlackoutBlur = try {
                        popupUiBlackout.getDouble("blur").toInt()
                    } catch (e: Exception) {
                        popupUiBlackoutBlur
                    }
                }
                retryCount = try {
                    settings.getDouble("retryCount").toInt()
                } catch (e: Exception) {
                    retryCount
                }
                retryTimeout = try {
                    settings.getDouble("retryTimeout").toInt()
                } catch (e: Exception) {
                    retryTimeout
                }
                socketTimeout = try {
                    settings.getDouble("socketTimeout").toInt()
                } catch (e: Exception) {
                    socketTimeout
                }
            }
        }
    }

    @ReactMethod
    fun startCampaign(eventName: String) {
        reactContext.runOnUiQueueThread {
            UxFeedback.sdk?.startCampaign(eventName)
        }
    }

    @ReactMethod
    fun stopCampaign() {
        reactContext.runOnUiQueueThread {
            UxFeedback.sdk?.stopCampaign()
        }
    }

    @ReactMethod
    fun setProperties(properties: ReadableMap) {
        reactContext.runOnUiQueueThread {
            UxFeedback.sdk?.properties.apply {
                properties.entryIterator.forEach {
                    this?.put(it.key, it.value.toString())
                }
            }
        }
    }

    @ReactMethod
    fun setTheme(theme: ReadableMap) {
        UxFeedback.sdk?.theme?.apply {
            bgColor = try {
                UxFbColor.fromHex(theme.getString("bgColor")!!)
            } catch (e: Exception) {
                bgColor
            }
            iconColor = try {
                UxFbColor.fromHex(theme.getString("iconColor")!!)
            } catch (e: Exception) {
                iconColor
            }
            text01Color = try {
                UxFbColor.fromHex(theme.getString("text01Color")!!)
            } catch (e: Exception) {
                text01Color
            }
            text02Color = try {
                UxFbColor.fromHex(theme.getString("text02Color")!!)
            } catch (e: Exception) {
                text02Color
            }
            text03Color = try {
                UxFbColor.fromHex(theme.getString("text03Color")!!)
            } catch (e: Exception) {
                text03Color
            }
            mainColor = try {
                UxFbColor.fromHex(theme.getString("mainColor")!!)
            } catch (e: Exception) {
                mainColor
            }
            errorColorPrimary = try {
                UxFbColor.fromHex(theme.getString("errorColorPrimary")!!)
            } catch (e: Exception) {
                errorColorPrimary
            }
            errorColorSecondary = try {
                UxFbColor.fromHex(theme.getString("errorColorSecondary")!!)
            } catch (e: Exception) {
                errorColorSecondary
            }
            btnBgColor = try {
                UxFbColor.fromHex(theme.getString("btnBgColor")!!)
            } catch (e: Exception) {
                btnBgColor
            }
            btnBgColorActive = try {
                UxFbColor.fromHex(theme.getString("btnBgColorActive")!!)
            } catch (e: Exception) {
                btnBgColorActive
            }
            btnTextColor = try {
                UxFbColor.fromHex(theme.getString("btnTextColor")!!)
            } catch (e: Exception) {
                btnTextColor
            }
            inputBgColor = try {
                UxFbColor.fromHex(theme.getString("inputBgColor")!!)
            } catch (e: Exception) {
                inputBgColor
            }
            inputBorderColor = try {
                UxFbColor.fromHex(theme.getString("inputBorderColor")!!)
            } catch (e: Exception) {
                inputBorderColor
            }
            controlBgColor = try {
                UxFbColor.fromHex(theme.getString("controlBgColor")!!)
            } catch (e: Exception) {
                controlBgColor
            }
            controlBgColorActive = try {
                UxFbColor.fromHex(theme.getString("controlBgColorActive")!!)
            } catch (e: Exception) {
                controlBgColorActive
            }
            controlIconColor = try {
                UxFbColor.fromHex(theme.getString("controlIconColor")!!)
            } catch (e: Exception) {
                controlIconColor
            }
            formBorderRadius = try {
                UxFbDimen.fromDp(theme.getDouble("formBorderRadius").toInt())
            } catch (e: Exception) {
                formBorderRadius
            }
            btnBorderRadius = try {
                UxFbDimen.fromDp(theme.getDouble("btnBorderRadius").toInt())
            } catch (e: Exception) {
                formBorderRadius
            }
            lightNavigationBar = try {
                theme.getBoolean("lightNavigationBar")
            } catch (e: Exception) {
                lightNavigationBar
            }
            fontBtn = getFontFromData(theme.getMap("fontBtn"), fontBtn)
            fontH1 = getFontFromData(theme.getMap("fontH1"), fontH1)
            fontH2 = getFontFromData(theme.getMap("fontH2"), fontH2)
            fontP1 = getFontFromData(theme.getMap("fontP1"), fontP1)
            fontP2 = getFontFromData(theme.getMap("fontP2"), fontP2)
        }
    }

    @ReactMethod
    fun addListener(eventName: String) {}

    @ReactMethod
    fun removeListeners(count: Int) {}

    override fun getConstants(): MutableMap<String, Any> {
        return hashMapOf("count" to 1)
    }

    private fun getFontFromData(data: ReadableMap?, defaultFont: UxFbFont): UxFbFont {
        if (data === null) {
            return defaultFont
        }
        return try {
            var family = data.getString("family")!!
            val fonts = currentActivity!!.resources.assets.list("fonts")!!
            if (fonts.contains("$family.otf")) {
                family = "$family.otf"
            } else if (fonts.contains("$family.ttf")) {
                family = "$family.ttf"
            } else if (fonts.contains("$family.woff")) {
                family = "$family.woff"
            }
            UxFbFont.fromAssets(
                    assetsPatch = "fonts/$family",
                    weight = data.getDouble("weight").toInt(),
                    sizeSp = data.getDouble("size").toInt(),
                    italic = data.getBoolean("italic")
            )
        } catch (e: Exception) {
            defaultFont
        }
    }

    private fun emitEvent(event: String, data: Any) {
        reactContext.runOnUiQueueThread {
            R.style.UXFBLightTheme
            reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java).emit(event, data)
        }
    }

    override fun uxFbNoCampaignToStart(eventName: String) {
        emitEvent("campaign_not_found", eventName)
    }

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

    override fun uxFbOnLog(message: String) {
        emitEvent("log", message)
    }
}
