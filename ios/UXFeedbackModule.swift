import Foundation
import UXFeedbackSDK

@objc(UXFeedbackModule)
class UXFeedbackModule: RCTEventEmitter {
  @objc
  override func constantsToExport() -> [AnyHashable : Any]! {
    return ["count": "Rasul's native module"]
  }

  @objc(setSettings:)
  func setSettings(settings: Dictionary<String, Any>) {
    DispatchQueue.main.async {
        let globalDelayTimer = settings["globalDelayTimer"] as? Int
        if (globalDelayTimer != nil) {
          UXFeedback.sharedSDK.globalDelayTimer = globalDelayTimer!
        }
        let uiBlocked = settings["uiBlocked"] as? Bool
        if (uiBlocked != nil) {
          UXFeedback.sharedSDK.uiBlocked = uiBlocked!
        }
        let debugEnabled = settings["debugEnabled"] as? Bool
        if (debugEnabled != nil) {
          UXFeedback.sharedSDK.setDebugEnabled(debugEnabled!)
        }
        guard let iosSettings = settings["ios"] as? Dictionary<String, Any> else {
          return
        }
        let closeOnSwipe = iosSettings["closeOnSwipe"] as? Bool
        if (closeOnSwipe != nil) {
          UXFeedback.sharedSDK.closeOnSwipe = closeOnSwipe!
        }
        let slideInBlackout = iosSettings["slideInBlackout"] as? Dictionary<String, Any>
        if (slideInBlackout != nil) {
          let color = slideInBlackout!["color"] as? String ?? "FFFFFF"
          let opacity = slideInBlackout!["opacity"] as? Int ?? 100
          let blur = slideInBlackout!["color"] as? Int ?? 0
          UXFeedback.sharedSDK.setSlideinBlackout(color: color, opactity: opacity, blur: blur)
        }
        let fullscreenBlackout = iosSettings["fullscreenBlackout"] as? Dictionary<String, Any>
        if (fullscreenBlackout != nil) {
          let color = fullscreenBlackout!["color"] as? String ?? "FFFFFF"
          let opacity = fullscreenBlackout!["opacity"] as? Int ?? 100
          let blur = fullscreenBlackout!["color"] as? Int ?? 0
          UXFeedback.sharedSDK.setFullscreenBlackout(color: color, opactity: opacity, blur: blur)
        }
    }
  }
    
  @objc(setThemeIOS:)
  func setThemeIOS(theme: Dictionary<String, Any>) {
    DispatchQueue.main.async {
        let customTheme = UXFBTheme()
        let text03Color = theme["text03Color"] as? String
        if (text03Color != nil) {
          customTheme.text03Color = UIColor.init(text03Color!)
        }
        let inputBorderColor = theme["inputBorderColor"] as? String
        if (inputBorderColor != nil) {
          customTheme.inputBorderColor = UIColor.init(inputBorderColor!)
        }
        let iconColor = theme["iconColor"] as? String
        if (iconColor != nil) {
          customTheme.iconColor = UIColor.init(iconColor!)
        }
        let btnBgColorActive = theme["btnBgColorActive"] as? String
        if (btnBgColorActive != nil) {
          customTheme.btnBgColorActive = UIColor.init(btnBgColorActive!)
        }
        let btnBorderRadius = theme["btnBorderRadius"] as? Double
        if (btnBorderRadius != nil) {
          customTheme.btnBorderRadius = CGFloat(btnBorderRadius!)
        }
        let errorColorSecondary = theme["errorColorSecondary"] as? String
        if (errorColorSecondary != nil) {
          customTheme.errorColorSecondary = UIColor.init(errorColorSecondary!)
        }
        let errorColorPrimary = theme["errorColorPrimary"] as? String
        if (errorColorPrimary != nil) {
          customTheme.errorColorPrimary = UIColor.init(errorColorPrimary!)
        }
        let mainColor = theme["mainColor"] as? String
        if (mainColor != nil) {
          customTheme.mainColor = UIColor.init(mainColor!)
        }
        let controlBgColorActive = theme["controlBgColorActive"] as? String
        if (controlBgColorActive != nil) {
          customTheme.controlBgColorActive = UIColor.init(controlBgColorActive!)
        }
        let formBorderRadius = theme["formBorderRadius"] as? Double
        if (formBorderRadius != nil) {
          customTheme.formBorderRadius = CGFloat(formBorderRadius!)
        }
        let inputBgColor = theme["inputBgColor"] as? String
        if (inputBgColor != nil) {
          customTheme.inputBgColor = UIColor.init(inputBgColor!)
        }
        let text01Color = theme["text01Color"] as? String
        if (text01Color != nil) {
          customTheme.text01Color = UIColor.init(text01Color!)
        }
        let controlBgColor = theme["controlBgColor"] as? String
        if (controlBgColor != nil) {
          customTheme.controlBgColor = UIColor.init(controlBgColor!)
        }
        let controlIconColor = theme["controlIconColor"] as? String
        if (controlIconColor != nil) {
          customTheme.controlIconColor = UIColor.init(controlIconColor!)
        }
        let btnBgColor = theme["btnBgColor"] as? String
        if (btnBgColor != nil) {
          customTheme.btnBgColor = UIColor.init(btnBgColor!)
        }
        let text02Color = theme["text02Color"] as? String
        if (text02Color != nil) {
          customTheme.text02Color = UIColor.init(text02Color!)
        }
        let btnTextColor = theme["btnTextColor"] as? String
        if (btnTextColor != nil) {
          customTheme.btnTextColor = UIColor.init(btnTextColor!)
        }
        let bgColor = theme["bgColor"] as? String
        if (bgColor != nil) {
          customTheme.bgColor = UIColor.init(bgColor!)
        }
        let fontBoldName = theme["fontBoldName"] as? String
        if (fontBoldName != nil) {
          customTheme.fontBoldName = fontBoldName!
        }
        let fontMediumName = theme["fontMediumName"] as? String
        if (fontMediumName != nil) {
          customTheme.fontMediumName = fontMediumName!
        }
        let fontRegularName = theme["fontRegularName"] as? String
        if (fontRegularName != nil) {
          customTheme.fontRegularName = fontRegularName!
        }
        UXFeedback.sharedSDK.setTheme(theme: customTheme)
    }
  }

  @objc(startCampaign:)
  func startCampaign(eventName: String) {
    UXFeedback.sharedSDK.delegate = self
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
    return ["campaign_start", "campaign_stop"]
  }
}

extension UXFeedbackModule: UXFeedbackCampaignDelegate {
  func campaignDidLoad(success: Bool) {}
  
  func campaignDidReceiveError(errorString: String) {}
  
  func campaignDidShow(eventName: String) {
    DispatchQueue.main.async {
        self.sendEvent(withName: "campaign_start", body: eventName)
    }
  }
  
  func campaignDidClose(eventName: String) {
    DispatchQueue.main.async {
        self.sendEvent(withName: "campaign_stop", body: eventName)
    }
  }
}

