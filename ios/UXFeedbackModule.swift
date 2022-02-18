import Foundation
import UXFeedbackSDK

@objc(UXFeedbackModule)
class UXFeedbackModule: NSObject {
  @objc
  func constantsToExport() -> [AnyHashable : Any]! {
    return ["count": "Rasul's native module"]
  }

  @objc(setup:withResolver:withRejecter:)
  func setup(config: Dictionary<String, Any>, resolve: @escaping RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
    let appID = config["appID"] as? Dictionary<String, String>
    if (appID == nil) {
      return
    }
    let iosAppID = appID!["ios"]
    if (iosAppID == nil) {
      return
    }
    DispatchQueue.main.async {
        UXFeedback.sharedSDK.setup(appID: iosAppID!, window: UIApplication.shared.windows.first!) { [weak self] success in
          let settings = config["settings"] as? Dictionary<String, Any>
          if (settings != nil) {
            self?.setSettings(settings: settings!)
          }
          resolve(String(success))
        }
    }
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
        print("UX Feedback blocked", uiBlocked)
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

  @objc
  static func requiresMainQueueSetup() -> Bool {
    return true
  }
}
