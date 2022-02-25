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
    print("UX Feedback Settings", settings)
    let globalDelayTimer = settings["globalDelayTimer"] as? Int
    if (globalDelayTimer != nil) {
        UXFeedback.sharedSDK.globalDelayTimer = globalDelayTimer!
    }
    let uiBlocked = settings["uiBlocked"] as? Bool
    if (uiBlocked != nil) {
        UXFeedback.sharedSDK.uiBlocked = uiBlocked!
    }
    let closeOnSwipe = settings["closeOnSwipe"] as? Bool
    if (closeOnSwipe != nil) {
        UXFeedback.sharedSDK.closeOnSwipe = closeOnSwipe!
    }
    let debugEnabled = settings["debugEnabled"] as? Bool
    if (debugEnabled != nil) {
        UXFeedback.sharedSDK.setDebugEnabled(debugEnabled!)
    }
  }

  @objc(startCampaign:)
  func startCampaign(eventName: String) {
    UXFeedback.sharedSDK.delegate = self
    DispatchQueue.main.async {
        UXFeedback.sharedSDK.sendEvent(event: eventName, fromController: RCTPresentedViewController()!)
    }
    print("Campaign started", eventName)
  }

  @objc(stopCampaign)
  func stopCampaign() {
    UXFeedback.sharedSDK.stopCampaign()
  }

  @objc(setProperties:)
  func setProperties(properties: Dictionary<String, Any>) {
    UXFeedback.sharedSDK.setProperties(properties)
  }

  @objc
  override static func requiresMainQueueSetup() -> Bool {
    return true
  }
    
  @objc
  override func supportedEvents() -> [String]! {
      return ["campaign_start", "campaign_stop"]
  }
    
  @objc
  static func setup(appID: String) {
      UXFeedback.sharedSDK.setup(appID: appID)
  }
}

extension UXFeedbackModule: UXFeedbackCampaignDelegate {
    func campaignDidLoad(success: Bool) {}
    
    func campaignDidReceiveError(errorString: String) {}
    
    func campaignDidShow(eventName: String) {
        sendEvent(withName: "campaign_start", body: eventName)
    }
    
    func campaignDidClose(eventName: String) {
        sendEvent(withName: "campaign_stop", body: eventName)
    }
}

