import { NativeEventEmitter, NativeModules } from 'react-native'

interface UXFeedbackColor {
  color?: string;
  opacity?: number;
  blur?: number;
}

interface UXFeedbackSettings {
  globalDelayTimer?: number | undefined;
  uiBlocked?: boolean | undefined;
  closeOnSwipe?: boolean | undefined;
  reconnectTimeout?: number | undefined;
  reconnectCount?: number | undefined;
  socketTimeout?: number | undefined;
  debugEnabled?: boolean | undefined;
  slideInBlackout?: UXFeedbackColor;
  fullscreenBlackout?: UXFeedbackColor;
}

type UXFeedback = {
  setSettings(settings: UXFeedbackSettings): void;
  startCampaign(eventName: string): Promise<boolean>;
  stopCampaign(): void;
  setProperties(properties: Map<string, any>): void;
}

const { UXFeedbackModule } = NativeModules;

const eventEmiter = new NativeEventEmitter(UXFeedbackModule);

export function onCampaignStart(callback: (_: string) => void): Function {
  const subscription = eventEmiter.addListener('campaign_start', (data: string) => {
    callback(data)
  })
  return () => {
    eventEmiter.removeSubscription(subscription)
  }
}

export function onCampaignStop(callback: (_: string) => void): Function {
  const subscription = eventEmiter.addListener('campaign_start', (data: string) => {
    callback(data)
  })
  return () => {
    eventEmiter.removeSubscription(subscription)
  }
}

export const {
  setSettings,
  startCampaign,
  stopCampaign,
  setProperties
} = UXFeedbackModule as UXFeedback;
