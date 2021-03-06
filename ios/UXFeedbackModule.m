#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface RCT_EXTERN_MODULE(UXFeedbackModule, RCTEventEmitter)

RCT_EXTERN_METHOD(setup:(NSDictionary)config
                 withResolver:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(setSettings:(NSDictionary)settings)

RCT_EXTERN_METHOD(setThemeIOS:(NSDictionary)theme)

RCT_EXTERN_METHOD(startCampaign:(NSString)eventName)

RCT_EXTERN_METHOD(stopCampaign)

RCT_EXTERN_METHOD(setProperties:(NSDictionary)properties)
@end
