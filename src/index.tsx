import { NativeModules } from 'react-native'

interface UXFeedbackSettings {
  globalDelayTimer?: number | undefined;
  uiBlocked?: boolean | undefined;
  closeOnSwipe?: boolean | undefined;
  reconnectTimeout?: number | undefined;
  reconnectCount?: number | undefined;
  socketTimeout?: number | undefined;
  debugEnabled?: boolean | undefined;
}

interface UXFeedbackConfig {
  appID?: {
    ios?: string | undefined;
    android?: string | undefined;
  } | undefined,
  settings?: UXFeedbackSettings | undefined;
}

type UXFeedback = {
  setup(config: UXFeedbackConfig): Promise<String>;
  setSettings(settings: UXFeedbackSettings): void;
  startCampagin(eventName: string): Promise<boolean>;
  stopCampagin(): void;
  setProperties(properties: Map<string, any>): void;
}

const { UXFeedbackModule } = NativeModules;

export const {
  setup,
  setSettings,
  startCampagin,
  stopCampagin,
  setProperties
} = UXFeedbackModule as UXFeedback;
