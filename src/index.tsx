import { EmitterSubscription, EventEmitter, EventSubscription, NativeEventEmitter, NativeModules } from 'react-native'

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
    fieldsEnabled?: boolean | undefined;
  },
  ios?: {
    closeOnSwipe?: boolean | undefined;
    slideInBlackout?: UXFeedbackColorForIOS;
    fullscreenBlackout?: UXFeedbackColorForIOS;
  }
}

interface UXFeedbackSetupConfig {
  appID?: string | undefined
}

interface OnCampaignTerminateData {
  eventName: string;
  terminatePage: number;
  totalPages: number;
}

interface OnCampaignSendData {
  campaignId: string;
  fieldValues: Record<string, any>;
}

type UXFeedback = {
  setup(config: UXFeedbackSetupConfig): Promise<String>;
  setSettings(settings: UXFeedbackSettings): void;
  setThemeIOS(theme: UxFeedbackIOSTheme): void;
  startCampaign(eventName: string): Promise<boolean>;
  stopCampaign(): void;
  setProperties(properties: Map<string, any>): void;
}

const { UXFeedbackModule } = NativeModules;

const eventEmiter = new NativeEventEmitter(UXFeedbackModule);

const eventListenerPlugs: Record<string, EventSubscription> = {
  capmaign_terminate: eventEmiter.addListener('campaign_terminate', () => {}),
  campaign_event_send: eventEmiter.addListener('campaign_event_send', () => {}),
  campaign_loaded: eventEmiter.addListener('campaign_loaded', () => {}),
  campaign_show: eventEmiter.addListener('campaign_show', () => {}),
  campaign_finish: eventEmiter.addListener('campaign_finish', () => {}),
};

function addEventListener(event: string, callback: (data: any) => void): EmitterSubscription {
  eventListenerPlugs[event]?.remove()
  return eventEmiter.addListener(event, callback);
}

export function onCampaignTerminate(callback: (_: OnCampaignTerminateData) => void): EmitterSubscription {
  return addEventListener('campaign_terminate', (data: OnCampaignTerminateData) => {
    callback(data);
  });
}

export function onCampaignEventSend(callback: (_: OnCampaignSendData) => void): EmitterSubscription {
  return addEventListener('campaign_event_send', (data: OnCampaignSendData) => {
    callback(data);
  });
}

export function onCampaignLoaded(callback: (_: boolean) => void): EmitterSubscription {
  return addEventListener('campaign_loaded', (data: boolean) => {
    callback(data);
  });
}

export function onCampaignShow(callback: (_: string) => void): EmitterSubscription {
  return addEventListener('campaign_show', (data: string) => {
    callback(data);
  });
}

export function onCampaignFinish(callback: (_: string) => void): EmitterSubscription {
  return addEventListener('campaign_finish', (data: string) => {
    callback(data);
  });
}

export const {
  setup,
  setSettings,
  startCampaign,
  stopCampaign,
  setProperties
} = UXFeedbackModule as UXFeedback;
