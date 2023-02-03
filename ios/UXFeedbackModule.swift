import Foundation
import UXFeedbackSDK

@objc(UXFeedbackModule)
class UXFeedbackModule: RCTEventEmitter {
  @objc
  override func constantsToExport() -> [AnyHashable : Any]! {
    return [:]
  }

  @objc(setup:withResolver:withRejecter:)
  func setup(config: Dictionary<String, Any>, resolve: @escaping RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
    if let appID = config["appID"] as? String {
        DispatchQueue.main.async {
            UXFeedback.sharedSDK.setup(appID: appID, window: UIApplication.shared.windows.first!) { [weak self] success in
                UXFeedback.sharedSDK.delegate = self
                resolve(String(success))
            }
        }
    }
  }

  @objc(setSettings:)
  func setSettings(settings: Dictionary<String, Any>) {
    DispatchQueue.main.async {
        if let globalDelayTimer = settings["globalDelayTimer"] as? Int {
            UXFeedback.sharedSDK.globalDelayTimer = globalDelayTimer
        }
        if let uiBlocked = settings["uiBlocked"] as? Bool {
            UXFeedback.sharedSDK.uiBlocked = uiBlocked
        }
        if let debugEnabled = settings["debugEnabled"] as? Bool {
            UXFeedback.sharedSDK.setDebugEnabled(debugEnabled)
        }
        guard let iosSettings = settings["ios"] as? Dictionary<String, Any> else {
          return
        }
        if let closeOnSwipe = iosSettings["closeOnSwipe"] as? Bool {
            UXFeedback.sharedSDK.closeOnSwipe = closeOnSwipe
        }
        if let slideInBlackout = iosSettings["slideInBlackout"] as? Dictionary<String, Any> {
            let color = slideInBlackout["color"] as? String ?? "FFFFFF"
            let opacity = slideInBlackout["opacity"] as? Int ?? 100
            let blur = slideInBlackout["blur"] as? Int ?? 0
            UXFeedback.sharedSDK.setSlideinBlackout(color: color, opactity: opacity, blur: blur)
        }
        if let fullscreenBlackout = iosSettings["fullscreenBlackout"] as? Dictionary<String, Any> {
            let color = fullscreenBlackout["color"] as? String ?? "FFFFFF"
            let opacity = fullscreenBlackout["opacity"] as? Int ?? 100
            let blur = fullscreenBlackout["blur"] as? Int ?? 0
            UXFeedback.sharedSDK.setFullscreenBlackout(color: color, opactity: opacity, blur: blur)
        }
    }
  }
    
  @objc(setThemeIOS:)
  func setThemeIOS(theme: Dictionary<String, Any>) {
    DispatchQueue.main.async {
        let customTheme = UXFBTheme()
        
        if let text03Color = theme["text03Color"] as? String {
            customTheme.text03Color = UIColor.init(text03Color)
        }
        if let inputBorderColor = theme["inputBorderColor"] as? String {
            customTheme.inputBorderColor = UIColor.init(inputBorderColor)
        }
        if let iconColor = theme["iconColor"] as? String {
            customTheme.iconColor = UIColor.init(iconColor)
        }
        if let btnBgColorActive = theme["btnBgColorActive"] as? String {
            customTheme.btnBgColorActive = UIColor.init(btnBgColorActive)
        }
        if let btnBorderRadius = theme["btnBorderRadius"] as? Double {
            customTheme.btnBorderRadius = CGFloat(btnBorderRadius)
        }
        if let errorColorSecondary = theme["errorColorSecondary"] as? String {
            customTheme.errorColorSecondary = UIColor.init(errorColorSecondary)
        }
        if let errorColorPrimary = theme["errorColorPrimary"] as? String {
            customTheme.errorColorPrimary = UIColor.init(errorColorPrimary)
        }
        if let mainColor = theme["mainColor"] as? String {
            customTheme.mainColor = UIColor.init(mainColor)
        }
        if let controlBgColorActive = theme["controlBgColorActive"] as? String {
            customTheme.controlBgColorActive = UIColor.init(controlBgColorActive)
        }
        if let formBorderRadius = theme["formBorderRadius"] as? Double {
            customTheme.formBorderRadius = CGFloat(formBorderRadius)
        }
        if let inputBgColor = theme["inputBgColor"] as? String {
            customTheme.inputBgColor = UIColor.init(inputBgColor)
        }
        if let text01Color = theme["text01Color"] as? String {
            customTheme.text01Color = UIColor.init(text01Color)
        }
        if let controlBgColor = theme["controlBgColor"] as? String {
            customTheme.controlBgColor = UIColor.init(controlBgColor)
        }
        if let controlIconColor = theme["controlIconColor"] as? String {
            customTheme.controlIconColor = UIColor.init(controlIconColor)
        }
        if let btnBgColor = theme["btnBgColor"] as? String {
            customTheme.btnBgColor = UIColor.init(btnBgColor)
        }
        if let text02Color = theme["text02Color"] as? String {
            customTheme.text02Color = UIColor.init(text02Color)
        }
        if let btnTextColor = theme["btnTextColor"] as? String {
            customTheme.btnTextColor = UIColor.init(btnTextColor)
        }
        if let bgColor = theme["bgColor"] as? String {
            customTheme.bgColor = UIColor.init(bgColor)
        }
        if let fontBoldName = theme["fontBoldName"] as? String {
            customTheme.fontBoldName = fontBoldName
        }
        if let fontMediumName = theme["fontMediumName"] as? String {
            customTheme.fontMediumName = fontMediumName
        }
        if let fontRegularName = theme["fontRegularName"] as? String {
            customTheme.fontRegularName = fontRegularName
        }
        UXFeedback.sharedSDK.setTheme(theme: customTheme)
    }
  }

  @objc(startCampaign:)
  func startCampaign(eventName: String) {
    DispatchQueue.main.async {
      UXFeedback.sharedSDK.sendEvent(event: eventName, fromController: RCTPresentedViewController()!)
    }
  }

  @objc(stopCampaign)
  func stopCampaign() {
    DispatchQueue.main.async {
        UXFeedback.sharedSDK.stopCampaign()
    }
  }

  @objc(setProperties:)
  func setProperties(properties: Dictionary<String, Any>) {
    DispatchQueue.main.async {
        UXFeedback.sharedSDK.setProperties(properties)
    }
  }

  @objc
  override static func requiresMainQueueSetup() -> Bool {
    return true
  }
    
  @objc
  override func supportedEvents() -> [String]! {
    return ["campaign_show", "campaign_finish", "campaign_loaded", "campaign_event_send", "campaign_terminate"]
  }
    
  func emitEvent(withName: String, body: Any) {
    DispatchQueue.main.async {
        self.sendEvent(withName: withName, body: body)
    }
  }
}

extension UXFeedbackModule: UXFeedbackCampaignDelegate {
  func campaignDidAnswered(campaignId: String, answers: [String : Any]) {
      emitEvent(withName: "campaign_event_send", body: ["campaignId": campaignId, "fieldValues": answers])
  }
    
  func campaignDidTerminate(eventName: String, terminatedPage: Int, totalPages: Int) {
      emitEvent(withName: "campaign_terminate", body: ["eventName": eventName, "terminatePage": terminatedPage, "totalPages": totalPages])
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
    
  func campaignDidSend(campaignId: String) {}

  func campaignDidSend(campaignId: String, answers: [String : Any]) {}
    
  func logDidReceive(message: String) {}

  func campaignDidReceiveError(errorString: String) {}
}

