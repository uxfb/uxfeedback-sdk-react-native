//
//  UXFeedbackModule.m
//  UXFeedbackModule
//
//  Copyright © 2022 Raserad. All rights reserved.
//

#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(UXFeedbackModule, NSObject)

RCT_EXTERN_METHOD(setup:(NSDictionary)config
                 withResolver:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(setSettings:(NSDictionary)settings)

RCT_EXTERN_METHOD(startCampaign:(NSString)eventName)

RCT_EXTERN_METHOD(stopCampaign)

RCT_EXTERN_METHOD(setProperties:(NSDictionary)properties)
@end
