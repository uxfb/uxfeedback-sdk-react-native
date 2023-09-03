import { EmitterSubscription, NativeEventEmitter, NativeModules } from 'react-native'

export interface UXFeedbackColor {
  color?: string;
  opacity?: number;
  blur?: number;
}

export interface UXFeedbackFont {
  family?: string;
  weight?: number;
  size?: number;
  italic?: boolean;
}

export interface UxFeedbackTheme {
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
  lightNavigationBar?: boolean;
  fontH1?: UXFeedbackFont;
  fontH2?: UXFeedbackFont;
  fontP1?: UXFeedbackFont;
  fontP2?: UXFeedbackFont;
  fontBtn?: UXFeedbackFont;
}

export interface UXFeedbackSettings {
  globalDelayTimer?: number | undefined;
  slideInUiBlocked?: boolean | undefined;
  debugEnabled?: boolean | undefined;
  fieldsEventEnabled?: boolean | undefined;
  slideInUiBlackout?: UXFeedbackColor;
  popupUiBlackout?: UXFeedbackColor;
  retryTimeout?: number | undefined;
  retryCount?: number | undefined;
  socketTimeout?: number | undefined;
  ios?: {
    closeOnSwipe?: boolean | undefined;
  }
}

export interface UXFeedbackSetupConfig {
  iosAppID?: string;
  theme?: UxFeedbackTheme;
  settings?: UXFeedbackSettings;
  properties?: Record<string, string>;
}

export interface OnCampaignTerminateData {
  eventName: string;
  terminatePage: number;
  totalPages: number;
}

export interface OnCampaignSendData {
  campaignId: string;
  fieldValues: Record<string, any>;
}

type UXFeedback = {
  setup(config: UXFeedbackSetupConfig): void;
  setSettings(settings: UXFeedbackSettings): void;
  setTheme(theme: UxFeedbackTheme): void;
  startCampaign(eventName: string): Promise<boolean>;
  stopCampaign(): void;
  setProperties(properties: Map<string, string>): void;
  changeServer(url: string): void;
}

const { UXFeedbackModule } = NativeModules;

const eventEmiter = new NativeEventEmitter(UXFeedbackModule);

function setupListenerStubs() {
  const stubs = [
    'campaign_terminate',
    'campaign_event_send',
    'campaign_loaded',
    'campaign_not_found',
    'log',
    'campaign_show',
    'campaign_finish',
  ];
  stubs.forEach((stub) => {
    eventEmiter.addListener(stub, () => {});
  });
}

function addEventListener(event: string, callback: (data: any) => void): EmitterSubscription {
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

export function onCampaignNotFound(callback: (_: string) => void): EmitterSubscription {
  return addEventListener('campaign_not_found', (data: string) => {
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

export function onLog(callback: (_: string) => void): EmitterSubscription {
  return addEventListener('log', (data: string) => {
    callback(data);
  });
}

setupListenerStubs();

export const {
  setup,
  setSettings,
  startCampaign,
  setTheme,
  stopCampaign,
  setProperties,
  changeServer
} = UXFeedbackModule as UXFeedback;
