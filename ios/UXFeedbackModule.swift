import Foundation
import UXFeedbackSDK

@objc(UXFeedbackModule)
class UXFeedbackModule: RCTEventEmitter {
    
  var currentAppID = ""
  var currentSettings = UXFBSettings()

  @objc
  override func constantsToExport() -> [AnyHashable : Any]! {
    return [:]
  }

  @objc(setup:withResolver:withRejecter:)
  func setup(config: Dictionary<String, Any>, resolve: @escaping RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
      DispatchQueue.main.async {
          if let appID = config["iosAppID"] as? String {
              self.currentAppID = appID
              UXFeedback.setup(appID: appID, settings: self.currentSettings, campaignDelegate: self, logDelegate: self)
          }
          if let settings = config["settings"] as? Dictionary<String, Any> {
              self.setSettings(settings: settings)
          }
          if let theme = config["theme"] as? Dictionary<String, Any> {
              self.setTheme(theme: theme)
          }
          if let properties = config["properties"] as? Dictionary<String, Any> {
              self.setProperties(properties: properties)
          }
      }
  }

  @objc(setSettings:)
  func setSettings(settings: Dictionary<String, Any>) {
    DispatchQueue.main.async {
        let sdkSettings = UXFeedback.sdk.settings
        if let globalDelayTimer = settings["globalDelayTimer"] as? Int {
            sdkSettings.globalDelayTimer = globalDelayTimer
        }
        if let slideInUiBlocked = settings["slideInUiBlocked"] as? Bool {
            sdkSettings.slideInUiBlocked = slideInUiBlocked
        }
        if let debugEnabled = settings["debugEnabled"] as? Bool {
            sdkSettings.debugEnabled = debugEnabled
        }
        if let fieldsEventEnabled = settings["fieldsEventEnabled"] as? Bool {
            sdkSettings.fieldsEventEnabled = fieldsEventEnabled
        }
        if let retryTimout = settings["retryTimout"] as? Double {
            sdkSettings.retryTimeout = retryTimout
        }
        if let retryCount = settings["retryCount"] as? Int {
            sdkSettings.retryCount = retryCount
        }
        if let socketTimeout = settings["socketTimeout"] as? Double {
            sdkSettings.socketTimeout = socketTimeout
        }
        if let slideInUiBlackout = settings["slideInUiBlackout"] as? Dictionary<String, Any> {
            sdkSettings.slideInUiBlackoutColor = slideInUiBlackout["color"] as? String ?? sdkSettings.slideInUiBlackoutColor
            sdkSettings.slideInUiBlackoutBlur = slideInUiBlackout["blur"] as? Int ?? sdkSettings.slideInUiBlackoutBlur
            sdkSettings.slideInUiBlackoutOpacity = slideInUiBlackout["opacity"] as? Int ?? sdkSettings.slideInUiBlackoutOpacity
        }
        if let popupUiBlackout = settings["popupUiBlackout"] as? Dictionary<String, Any> {
            sdkSettings.popupUiBlackoutColor = popupUiBlackout["color"] as? String ?? sdkSettings.popupUiBlackoutColor
            sdkSettings.popupUiBlackoutBlur = popupUiBlackout["blur"] as? Int ?? sdkSettings.popupUiBlackoutBlur
            sdkSettings.popupUiBlackoutOpacity = popupUiBlackout["opacity"] as? Int ?? sdkSettings.popupUiBlackoutOpacity
        }
        guard let iosSettings = settings["ios"] as? Dictionary<String, Any> else {
          return
        }
        if let closeOnSwipe = iosSettings["closeOnSwipe"] as? Bool {
            sdkSettings.closeOnSwipe = closeOnSwipe
        }
    }
  }
    
  @objc(setTheme:)
  func setTheme(theme: Dictionary<String, Any>) {
    DispatchQueue.main.async {
        let sdkTheme = UXFeedback.sdk.theme
        
        if let text03Color = theme["text03Color"] as? String {
            sdkTheme.text03Color = UIColor.init(text03Color)
        }
        if let inputBorderColor = theme["inputBorderColor"] as? String {
            sdkTheme.inputBorderColor = UIColor.init(inputBorderColor)
        }
        if let iconColor = theme["iconColor"] as? String {
            sdkTheme.iconColor = UIColor.init(iconColor)
        }
        if let btnBgColorActive = theme["btnBgColorActive"] as? String {
            sdkTheme.btnBgColorActive = UIColor.init(btnBgColorActive)
        }
        if let btnBorderRadius = theme["btnBorderRadius"] as? Double {
            sdkTheme.btnBorderRadius = CGFloat(btnBorderRadius)
        }
        if let errorColorSecondary = theme["errorColorSecondary"] as? String {
            sdkTheme.errorColorSecondary = UIColor.init(errorColorSecondary)
        }
        if let errorColorPrimary = theme["errorColorPrimary"] as? String {
            sdkTheme.errorColorPrimary = UIColor.init(errorColorPrimary)
        }
        if let mainColor = theme["mainColor"] as? String {
            sdkTheme.mainColor = UIColor.init(mainColor)
        }
        if let controlBgColorActive = theme["controlBgColorActive"] as? String {
            sdkTheme.controlBgColorActive = UIColor.init(controlBgColorActive)
        }
        if let formBorderRadius = theme["formBorderRadius"] as? Double {
            sdkTheme.formBorderRadius = CGFloat(formBorderRadius)
        }
        if let inputBgColor = theme["inputBgColor"] as? String {
            sdkTheme.inputBgColor = UIColor.init(inputBgColor)
        }
        if let text01Color = theme["text01Color"] as? String {
            sdkTheme.text01Color = UIColor.init(text01Color)
        }
        if let controlBgColor = theme["controlBgColor"] as? String {
            sdkTheme.controlBgColor = UIColor.init(controlBgColor)
        }
        if let controlIconColor = theme["controlIconColor"] as? String {
            sdkTheme.controlIconColor = UIColor.init(controlIconColor)
        }
        if let btnBgColor = theme["btnBgColor"] as? String {
            sdkTheme.btnBgColor = UIColor.init(btnBgColor)
        }
        if let text02Color = theme["text02Color"] as? String {
            sdkTheme.text02Color = UIColor.init(text02Color)
        }
        if let btnTextColor = theme["btnTextColor"] as? String {
            sdkTheme.btnTextColor = UIColor.init(btnTextColor)
        }
        if let bgColor = theme["bgColor"] as? String {
            sdkTheme.bgColor = UIColor.init(bgColor)
        }
        if let fontH1 = theme["fontH1"] as? Dictionary<String, Any> {
            sdkTheme.fontH1 = self.getFont(fontH1, sdkTheme.fontH1)
        }
        if let fontH2 = theme["fontH2"] as? Dictionary<String, Any> {
            sdkTheme.fontH2 = self.getFont(fontH2, sdkTheme.fontH2)
        }
        if let fontP1 = theme["fontP1"] as? Dictionary<String, Any> {
            sdkTheme.fontP1 = self.getFont(fontP1, sdkTheme.fontP1)
        }
        if let fontP2 = theme["fontP2"] as? Dictionary<String, Any> {
            sdkTheme.fontP2 = self.getFont(fontP2, sdkTheme.fontP2)
        }
        if let fontBtn = theme["fontBtn"] as? Dictionary<String, Any> {
            sdkTheme.fontBtn = self.getFont(fontBtn, sdkTheme.fontBtn)
        }
    }
  }
    
    @objc(changeServer:)
    func changeServer(url: String) {
        DispatchQueue.main.async {
            let settings = self.currentSettings
            if (url == "") {
                settings.endpoint = nil
            } else {
                settings.endpoint = url
            }
            UXFeedback.setup(appID: self.currentAppID, settings: settings, campaignDelegate: self, logDelegate: self)
        }
    }

  @objc(startCampaign:)
  func startCampaign(eventName: String) {
    DispatchQueue.main.async {
        UXFeedback.sdk.startCampaign(eventName: eventName)
    }
  }

  @objc(stopCampaign)
  func stopCampaign() {
    DispatchQueue.main.async {
        UXFeedback.sdk.stopCampaign()
    }
  }

  @objc(setProperties:)
  func setProperties(properties: Dictionary<String, Any>) {
    DispatchQueue.main.async {
        properties.forEach { (key: String, value: Any) in
            UXFeedback.sdk.properties[key] = value
        }
    }
  }

  @objc
  override static func requiresMainQueueSetup() -> Bool {
    return true
  }
    
  @objc
  override func supportedEvents() -> [String]! {
    return ["campaign_show", "campaign_finish", "campaign_loaded", "campaign_event_send", "campaign_terminate", "log", "campaign_not_found"]
  }
    
  func emitEvent(withName: String, body: Any) {
    DispatchQueue.main.async {
        self.sendEvent(withName: withName, body: body)
    }
  }
}

extension UXFeedbackModule: UXFeedbackLogDelegate {
    func logDidReceive(message: String) {
        emitEvent(withName: "log", body: message)
    }
}

extension UXFeedbackModule: UXFeedbackCampaignDelegate {
    func campaignDidReceiveError(errorString: String) {
        emitEvent(withName: "campaign_not_found", body: errorString)
    }

    func campaignDidSend(campaignId: String) {}
    
    func campaignDidAnswered(campaignId: String, answers: [String : Any]) {
        emitEvent(withName: "campaign_event_send", body: ["campaignId": campaignId, "fieldValues": answers] as [String : Any])
    }

    func campaignDidTerminate(eventName: String, terminatedPage: Int, totalPages: Int) {
        emitEvent(withName: "campaign_terminate", body: ["eventName": eventName, "terminatePage": terminatedPage, "totalPages": totalPages] as [String : Any])
    }

    func campaignDidLoad(success: Bool) {
        emitEvent(withName: "campaign_loaded", body: success)
    }

    func campaignDidShow(eventName: String) {
        emitEvent(withName: "campaign_show", body: eventName)
    }

    func campaignDidClose(eventName: String) {
        emitEvent(withName: "campaign_finish", body: eventName)
    }
}

extension UXFeedbackModule {
    func getFontDescriptor(_ data: Dictionary<String, Any>, _ defaultFont: UIFont) -> UIFontDescriptor {
        return UIFontDescriptor(fontAttributes:
            [
                UIFontDescriptor.AttributeName.family: data["family"] as? String ?? defaultFont.familyName,
                UIFontDescriptor.AttributeName.traits: [
                    UIFontDescriptor.TraitKey.weight: self.getFontWeight(weight: data["weight"] as? String ?? ""),
                    UIFontDescriptor.TraitKey.slant: data["italic"] as? Bool ?? false ? 1.0 : 0.0
                ] as [UIFontDescriptor.TraitKey : Any]
            ]
        )
    }
    
    func getFont(_ data: Dictionary<String, Any>, _ defaultFont: UIFont) -> UIFont {
        return UIFont(
            descriptor: self.getFontDescriptor(data, defaultFont),
            size: CGFloat(data["size"] as? Int ?? Int(defaultFont.pointSize))
        )
    }
    
    func getFontWeight(weight: String) -> UIFont.Weight {
        switch (weight) {
            case "100": return .thin
            case "200": return .ultraLight
            case "300": return .light
            case "400": return .regular
            case "500": return .medium
            case "600": return .semibold
            case "700": return .bold
            case "800": return .heavy
            case "900": return .black
            default: return .regular
        }
    }
}

