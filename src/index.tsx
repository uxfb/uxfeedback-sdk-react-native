import { EmitterSubscription, NativeEventEmitter, NativeModules } from 'react-native'

interface UXFeedbackColorForAndroid {
  color?: number;
  opacity?: number;
  blur?: number;
}

interface UXFeedbackColorForIOS {
  color?: string;
  opacity?: number;
  blur?: number;
}

interface UxFeedbackIOSTheme {
  text03Color?: string;
  inputBorderColor?: string;
  iconColor?: string;
  btnBgColorActive?: string;
  btnBorderRadius?: number;
  errorColorSecondary?: string;
  errorColorPrimary?: string;
  mainColor?: string;
  controlBgColorActive?: string;
  formBorderRadius?: number;
  inputBgColor?: string;
  text01Color?: string;
  controlBgColor?: string;
  controlIconColor?: string;
  btnBgColor?: string;
  text02Color?: string;
  btnTextColor?: string;
  bgColor?: string;
  fontBoldName?: string;
  fontMediumName?: string;
  fontRegularName?: string;
}

interface UXFeedbackSettings {
  globalDelayTimer?: number | undefined;
  uiBlocked?: boolean | undefined;
  debugEnabled?: boolean | undefined;
  android?: {
    reconnectTimeout?: number | undefined;
    reconnectCount?: number | undefined;
    socketTimeout?: number | undefined;
    slideInBlackout?: UXFeedbackColorForAndroid;
    popupBlackout?: UXFeedbackColorForAndroid;
  },
  ios?: {
    closeOnSwipe?: boolean | undefined;
    slideInBlackout?: UXFeedbackColorForIOS;
    fullscreenBlackout?: UXFeedbackColorForIOS;
  }
}

type UXFeedback = {
  setSettings(settings: UXFeedbackSettings): void;
  setThemeIOS(theme: UxFeedbackIOSTheme): void;
  startCampaign(eventName: string): Promise<boolean>;
  stopCampaign(): void;
  setProperties(properties: Map<string, any>): void;
}

const { UXFeedbackModule } = NativeModules;

const eventEmiter = new NativeEventEmitter(UXFeedbackModule);

export function onCampaignStart(callback: (_: string) => void): EmitterSubscription {
  return eventEmiter.addListener('campaign_start', (data: string) => {
    callback(data)
  })
}

export function onCampaignStop(callback: (_: string) => void): EmitterSubscription {
  return eventEmiter.addListener('campaign_stop', (data: string) => {
    callback(data)
  })
}

export const {
  setSettings,
  startCampaign,
  stopCampaign,
  setProperties
} = UXFeedbackModule as UXFeedback;
