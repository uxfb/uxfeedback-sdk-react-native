# React Native UX Feedback
## Руководство по настройке и интеграции библиотеки в проект react native

Платформа UX Feedback встраивается в приложения IOS/Android и позволяет создавать и запускать формы для сбора фидбека:


Управление формами производится в личном кабинете UX Feedback в который можно зайти по [ссылке](https://app.uxfeedback.ru/)

В личном кабинете можно создавать, редактировать и запускать формы двух типов: 

Slide-in - форма появляется внизу экрана 
FullScreen - форма появляется по центру экрана


## Что стоит знать:

1. Для prod и test версий приложения используются разные App_ID (подробнее ниже).

2. Для внедрения используем последнюю версию SDK UX Feedback из Changelog, для обновления можно использовать Cocoapods.

3. Для запуска форм используются события, которые отправляются со стороны приложения. В личном кабинете можно настраивать показ форм через N секунд или N раз, после отправления Event. Также есть настройка “Показывать каждый раз” при отправлении Event. 

4. Для настройки дизайна форм, необходимо попросить дизайнера прописать стили


## Установка

Установка React Native UX Feedback требует несколько шагов: установить NPM модуль, настройка бибилиотеки для каждой платформы и пересобрать ваше приложение.

### 1. Установка через NPM

Установите React Native UX Feedback модуль в корень вашего React Native проекта с помощью NPM или Yarn:

```bash
# Используя npm
npm install --save react-native-ux-feedback

# Используя Yarn
yarn add react-native-ux-feedback
```

### 2. Настройка Android части

Перейдите в файл `/android/build.gradle` и добавьте репозиторий maven в allprojects:

```gradle
allprojects {
    repositories {
        // Другие репозитории
        maven { url "https://mymavenrepo.com/repo/u4asKGGjymjlKwPIWU0v/" }
    }
}
```

Далее перейдите в файл `/android/app/build.gradle` и добавьте зависимость UXFeedback в depencies:

```gradle
dependencies {
    //Другие зависимости
    implementation 'ru.uxfeedback:sdk:1.1.3'
}
```

Теперь перейдите в `android/src/.../MainApplication.java` и установите зависимости в верхней части файла:

```java
import ru.uxfeedback.pub.sdk.UXFbSettings;
import ru.uxfeedback.pub.sdk.UXFeedback;
```

Затем проинициализируйте бибилиотеку в onCreate:
```java
@Override
    public void onCreate() {
    super.onCreate();
    //Получить App_ID можно в панели управления UX Feedback
    UXFeedback.init(this, "App_ID", UXFbSettings.Companion.getDefault());
}
```

### 3. Настройка iOS части

Для начала перейдите в терминале в папку ios в вашем проекте и введите команду:

```bash
pod install
```

Это установит все необходимые зависимости для ios части приложения.
Далее необходимо перейти в файл `/ios/{projectName}/AppDelegate.m` и установить зависимости в верхней части файла:

```objective-c
#import <UXFeedbackSDK/UXFeedbackSDK.h>
```

А затем проинициализировать библиотеку:

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
...
//Получить App_ID можно в панели управления UX Feedback
[[UXFeedback sharedSDK] setupWithAppID: @"App_ID" window: self.window theme: nil completion: nil];
return YES;
}
```

Once successfully linked and rebuilt, your application will be connected to Firebase using the `@react-native-firebase/app` module. This module does not provide much functionality, therefore to use other Firebase services, each of the modules for the individual Firebase services need installing separately.

### 4. Конфигурирование библиотеки

Для того чтобы задавать нужные параметры работы бибилиотеки используйте метод `setSettings` импортируемый из react-native-ux-feedback:

```javascript
import { setSettings } from 'react-native-ux-feedback'

setSettings({
  globalDelayTimer: 0, // Время показа между кампаниями
  uiBlocked: true, // Блокировка прочего ui пока показывается модальное окно фидбека
  debugEnabled: true, //Включение режима логирования (про логирование поговорим ниже)
  android: { //Настройки библиотеки для android
    reconnectTimeout: 0, //Время перед повторной отправкой данных
    reconnectCount: 10, //Количество попыток повторной отправки данных
    socketTimeout: 100, //Таймаут сетевого соединения 
    slideInBlackout: { //Затемнение фона для форм Slide-in.
        color: 255, //Цвет от 0 до 255
        opacity: 255, //Прозрачность от 0 до 255
        blur: 25, //Размытие от 0 до 25
    },
    popupBlackout:  { //Затемнение фона для форм Fullscreen.
        color: 255, //Цвет от 0 до 255
        opacity: 255, //Прозрачность от 0 до 255
        blur: 25, //Размытие от 0 до 25
    },
  },
  ios: { //Настройки бибилиотеки для ios 
    closeOnSwipe: true, // включение полного закрытия slide-in формы одним смахиванием вниз
    slideInBlackout:  { //Затемнение фона для форм Slide-in.
        color: "#ffffff", //Цвет в формате hex
        opacity: 80, //Прозрачность от 0 до 100
        blur: 25, //Размытие от 0 до 100
    },
    fullscreenBlackout:  { //Затемнение фона для форм Fullscreen.
        color: "#ffffff", //Цвет в формате hex
        opacity: 80, //Прозрачность от 0 до 100
        blur: 25, //Размытие от 0 до 100
    },
  },
})
```

### 5. Дизайн форм

Для IOS можно использовать метод setThemeIOS из react-native-ux-feedback:

```javascript
import { setThemeIOS } from 'react-native-ux-feedback'

setTheme({
    text03Color: "#999999",
    inputBorderColor: "#eeeeee"
    //... Остальные стили можно посмотреть в гайдах по стилям
})
```

Для android необходимо использовать setTheme в нативной части приложения. Для этого перейдите к файлу `/android/src/.../MainApplication.java`

**Параметры цветов необходимо взять из файла, который сформируют дизайнеры по ссылке:** [Гайды по стилям](https://www.figma.com/file/zZKRpSS1zKfgr9fGkZizAv/UXFB-FORMS-TEMPLATE?node-id=0%3A1 )

### 6. Запуск форм (Events)

##### Запуск кампании

В необходимом месте приложения вы можете стартовать кампанию вызвав метод startCampaign:

```javascript
import { startCampaign } from 'react-native-ux-feedback'

// Допустимые символы для названия события event_name: “Aa-Zz, 0-9, _”. Рекомендуем не использовать пробелы. 
startCampaign('event_name')
```

##### Остановка кампании

В необходимом месте приложения вы можете остановить кампанию вызвав метод stopCampaign:
```javascript
import { stopCampaign } from 'react-native-ux-feedback'
stopCampaign()
```
Если кампания не была показана - ее показ отменится, если была показана - будет закрыта.

### 7. Отслеживание событий
При необходимости есть возможность отслеживать события как показ кампании пользователю или когда кампания пройдена/скрыта:
```javascript
import { onCampaignStart, onCampaignStop } from 'react-native-ux-feedback'
//unsubscribeOnStart - функция которую можно вызвать для отписки от события
const unsubscribeOnStart = onCampaignStart((eventName) => {
    console.log(`Кампания с событием ${eventName} показана`)
})
//unsubscribeOnStop - функция которую можно вызвать для отписки от события
const unsubscribeOnStop = onCampaignStop((eventName) => {
    console.log(`Кампания с событием ${eventName} скрыта`)
})
```

### 8. Отправление параметров (Properties)
При необходимости есть возможность отправить дополнительные данные, вместе с ответом, например User_id, Email, Регион или любые другие. Для этого вызовите функцию setParameters:
```javascript
import { setParameters } from 'react-native-ux-feedback'
setParameters({
    name: "User",
    age: 21,
    //....
})
```
### 9. Режим логгирования (Отладка приложения)

Для того чтобы включить режим логгирования вам нужно указать в настройке бибилиотеки debugEnabled: true

```javascript
import { setSettings } from 'react-native-ux-feedback'

setSettings({
  debugEnabled: true,
  //...
})
```

Затем для android и ios необходимо установить библиотеки логгирования чтобы видеть нативные логи:
```bash
npx react-native log-ios
npx react-native log-android
```

Более подробную информацию можно получить [здесь](https://reactnative.dev/docs/debugging)

### 10. Использование с expo:

К сожалению данную библиотеку нельзя использовать с expo, так как она требует написания кода для нативных частей приложения. Поэтому вам необходимо сделать expo-eject, для того чтобы иметь возможность использовать эту и подобные библиотеки. Подробнее про [expo eject](https://docs.expo.dev/expokit/eject/)

