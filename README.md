# React Native UX Feedback
## Руководство по настройке и интеграции библиотеки в проект react native

Платформа UX Feedback встраивается в приложения IOS/Android и позволяет создавать и запускать формы для сбора фидбека:


Управление формами производится в личном кабинете UX Feedback в который можно зайти по [ссылке](https://app.uxfeedback.ru/)

В личном кабинете можно создавать, редактировать и запускать формы двух типов: 

Slide-in - форма появляется внизу экрана

FullScreen - форма появляется по центру экрана

## Оглавление

| Оглавление |
| ------------- |
| [Сhangelog](#changelog) |
| [Версии](#версии) |
| [Что стоит знать](#что-стоит-знать) |
| [Установка](#установка) |
| [1. Использование с expo:](#1-использование-с-expo) |
| [2. Установка через NPM](#2-установка-через-npm) |
| [3. Настройка Android части](#3-настройка-android-части) |
| [4. Настройка iOS части](#4-настройка-ios-части) |
| [5. Запуск библиотеки](#5-запуск-библиотеки) |
| [6. Конфигурирование библиотеки](#6-конфигурирование-библиотеки) |
| [7. Дизайн форм](#7-дизайн-форм) |
| [8. Запуск форм (Events)](#8-запуск-форм-events) |
| [9. Отслеживание событий](#9-отслеживание-событий) |
| [10. Отправка параметров (Properties)](#10-отправка-параметров-properties) |
| [11. Режим логгирования (Отладка приложения)](#11-режим-логгирования-отладка-приложения) |
| [12. Запуск библиотеки с предварительно заданными настройками, темой и параметрами](#12-запуск-библиотеки-с-предварительно-заданными-настройками-темой-и-параметрами) |
| [13. Обновление библиотеки](#13-обновление-библиотеки) |

## Changelog

| Версия SDK  | Дата | Изменения |
| ------------- | ------------- | ------------- |
| 1.0.7  | 02.2023  | Исходная версия |
| 1.0.8  | 26.06.2023  | Актуализированы версии нативных библиотек IOS и Android  |
| 2.0.1  | 10.08.2023  | Переход на версию 2.0. Обновлены и унифицированны методы для ios и android.  |
| 2.0.2  | 04.09.2023  | Мелкие исправления  |
| 2.1.0  | 08.10.2023  | Обновление нативных библиотек до версии 2.2  |


## Версии

Актуальная версия библиотеки для react-native - `2.1.0`

Актуальная версия библиотеки для ios - `2.2.0`

Актуальная версия библиотеки для android - `2.2.0`


## Что стоит знать:

1. Для prod и test версий приложения используются разные App_ID (подробнее ниже).

2. Для внедрения используем последнюю версию SDK UX Feedback из Changelog, для обновления можно использовать Cocoapods.

3. Для запуска форм используются события, которые отправляются со стороны приложения. В личном кабинете можно настраивать показ форм через N секунд или N раз, после отправления Event. Также есть настройка “Показывать каждый раз” при отправлении Event. 

4. Для настройки дизайна форм, необходимо попросить дизайнера прописать стили


## Установка

Установка React Native UX Feedback требует несколько шагов: установить NPM модуль, настройка библиотеки для каждой платформы и пересобрать ваше приложение.

### 1. Использование с expo:

К сожалению данную библиотеку нельзя использовать с expo, так как она требует написания кода для нативных частей приложения. Поэтому, перед установкой, вам необходимо сделать expo prebuild, для того чтобы иметь возможность использовать эту и подобные ей нативные библиотеки. Подробнее про [expo prebuild](https://docs.expo.dev/workflow/prebuild/)

### 2. Установка через NPM

Установите React Native UX Feedback модуль с помощью NPM или Yarn:

```bash
# Используя npm
npm install --save uxfeedback

# Используя Yarn
yarn add uxfeedback
```

### 3. Настройка Android части

Перейдите в `android/src/.../MainApplication.java` и установите зависимости в верхней части файла:

```java
import com.raserad.uxfeedback.UXFeedback;
```

Затем проинициализируйте библиотеку в onCreate:
```java
@Override
public void onCreate() {
    super.onCreate();
    //Получить App_ID можно в панели управления UX Feedback
    UXFeedback.setup(this, "App_ID");
}
```

### 4. Настройка iOS части

Перейдите в терминале в папку ios в вашем проекте и введите команду:

```bash
pod install
```

Это установит все необходимые зависимости для ios части приложения.

Так же не забудьте добавить в info.plist в папке ios следующие строки
```
<key>NSPhotoLibraryUsageDescription</key>
<string>Здесь укажите причину доступа к галерее (нужно для загрузки скриншотов)</string>
```
Это необходимая мера для предотвращения падений приложения, когда пользователь хочет выбрать скриншоты из галереи.

Для IOS App ID нужно указать в методе setup, предоставленном ниже в [пункте 5](#5-запуск-библиотеки).

### 5. Запуск библиотеки

Добавьте метод setup в index.js файл (находится в корне проекта):
```javascript
import { setup } from 'uxfeedback'

//Получить App_ID можно в панели управления UX Feedback
setup({ iosAppID: "App_ID" })
```

### 6. Конфигурирование библиотеки

Для того чтобы задавать нужные параметры работы библиотеки используйте метод `setSettings` импортируемый из uxfeedback:

```javascript
import { setSettings } from 'uxfeedback'

setSettings({
    debugEnabled: true, //Включение режима логирования (про логирование поговорим ниже)
    fieldsEventEnabled: true,//Активация срабатывания события onCampaignEventSend 
    globalDelayTimer: 0, // Время показа между кампаниями
    retryTimeout: 1000, //Время перед повторной отправкой данных
    retryCount: 10, //Количество попыток повторной отправки данных
    socketTimeout: 1000, //Таймаут сетевого соединения 
    slideInUiBlocked: false, // Блокировка прочего ui пока показывается модальное окно фидбека
    slideInUiBlackout: { //Затемнение фона для форм Slide-in.
        color: "#000000", //Цвет в формате hex
        blur: 50, //Прозрачность от 0 до 100
        opacity: 50, //Размытие от 0 до 100
    },
    popupUiBlackout: {
        color: "#000000", //Цвет в формате hex
        blur: 50, //Прозрачность от 0 до 100
        opacity: 50, //Размытие от 0 до 100
    },
    ios: { //Настройки библиотеки для ios 
        closeOnSwipe: true, // включение полного закрытия slide-in формы одним смахиванием вниз
        rotateToggle: true, // будет ли автоматически поворачивать форма при повороте устройства
    }
  },
})
```

### 7. Дизайн форм

Чтобы задать стили дизайна можно использовать метод setTheme:

```javascript
import { setTheme } from 'uxfeedback'

setTheme({
    bgColor: '#FFFFFF', //Цвет фона формы
    iconColor: '#B5B8C2', //Цвет иконки "Закрыть форму", чекбоксов, радиокнопок в нормальном состоянии
    text01Color: '#232735', //Цвет заголовков блока header и заголовков всех блоков ввода информации (comment, textarea, email)
    text02Color: '#505565', //Цвет блока text
    text03Color: '#8B90A0', //Цвет текста счетчика страниц, плейсхолдера, инпутов (comment textarea, comment input, email)
    mainColor: '#0076C2', //Цвет курсора в интупе и внутренней обводки инпута в фокусе (comment textarea, comment input, email)
    errorColorPrimary: '#E84047', //Цвет звезды в заголовках обязательных вопросов и сообщений о незаполненных обязательных полях
    errorColorSecondary: '#7FE84047', //Цвет внутренней обводки у невыбранного смайла (rating smile), звезд, чекбоксов и радиокнопок
    btnBgColor: '#0076C2', //Фон кнопки (button)
    btnBgColorActive: '#1983C8', //Фон кнопки при нажатии (button)
    btnTextColor: '#FFFFFF', //Цвет текста кнопки (button)
    inputBgColor: '#F3F3F3', //Фон инпутов (comment textarea, comment input, email)
    inputBorderColor: '#D3D4D8', //Внутренняя обводка инпутов (comment textarea, comment input, email)
    controlBgColor: '#F3F3F3', //Фон в (radio button, checkbox)
    controlBgColorActive: '#DBF1FF', //Фон активных вариантов (radio button, checkbox)
    controlIconColor: '#FFFFFF', //Цвет центрального элемента в иконке блока (radio button) и галки в иконке блока (checkbox)
    formBorderRadius: 8, //Закругления верхних углов формы в slidein и закругления всех четырех углов в popup
    btnBorderRadius: 12, //Закругления кнопки "Продолжить"
    lightNavigationBar: true, //Стиль NavigationBar/StatusBar
    fontH1: { //Шрифт заголовка кампании
        family: 'sans-serif', //Название шрифта
        size: 24, //Размер
        italic: false, //Наклоненный или нет
        weight: 500 //Вес шрифта
    },
    fontH2: { //Шрифт заголовка поля (field)
        family: 'sans-serif',
        size: 20,
        italic: false,
        weight: 500
    },
    fontP1: { //Основной шрифт
        family: 'sans-serif',
        size: 16,
        italic: false,
        weight: 400
    },
    fontP2: { //Шрифт подсказок
        family: 'sans-serif',
        size: 14,
        italic: false,
        weight: 400
    },
    fontBtn: { //Шрифт кнопок
        family: 'sans-serif',
        size: 14,
        italic: false,
        weight: 500
    }
})
```

Заметьте, что кастомные шрифты подключаются отдельно (например с помощью npx react-native-asset)

**Параметры цветов необходимо взять из файла, который сформируют дизайнеры по ссылке:** [Гайды по стилям](https://www.figma.com/file/zZKRpSS1zKfgr9fGkZizAv/UXFB-FORMS-TEMPLATE?node-id=0%3A1 )


### 8. Запуск форм (Events)

##### Запуск кампании

В необходимом месте приложения вы можете стартовать кампанию вызвав метод startCampaign:

```javascript
import { startCampaign } from 'uxfeedback'

// Допустимые символы для названия события event_name: “Aa-Zz, 0-9, _”. Рекомендуем не использовать пробелы. 
startCampaign('event_name')
```

##### Остановка кампании

В необходимом месте приложения вы можете остановить кампанию вызвав метод stopCampaign:
```javascript
import { stopCampaign } from 'uxfeedback'
stopCampaign()
```
Если кампания не была показана - ее показ отменится, если была показана - будет закрыта.

### 9. Отслеживание событий
При необходимости есть возможность отслеживать события как показ кампании пользователю или когда кампания пройдена/скрыта:
```javascript
import { onCampaignEventSend, onCampaignFinish, onCampaignLoaded, onCampaignNotFound, onCampaignShow, onCampaignTerminate, onLog } from 'uxfeedback'

//Событие при показе кампании
const onCompaignShowSubscription = onCampaignShow((eventName) => {
    console.log(`Кампания с событием ${eventName} показана`)
})

//Событие при скрытии кампании
const onCampaignFinishSubscription = onCampaignFinish((eventName) => {
    console.log(`Кампания с событием ${eventName} скрыта`)
})

//Событие при загрузке кампании (инициализация)
const onCampaignLoadedSubscription = onCampaignLoaded((success) => {
    console.log(`Кампания загружена ${success}`)
})

//Событие при отправке данных (для работы в android не забудьте указать fieldsEnabled: true в настройках)
const onCampaignEventSendSubscription = onCampaignEventSend(({ campaignId, fieldValues }) => {
    console.log(`В кампанию с id ${campaignId} отправлены данные ${fieldValues}`)
})

//Событие при прерывании кампании
const onCampaignTerminateSubscription = onCampaignTerminate(({ eventName, terminatePage, totalPages }) => {
    console.log(`Кампания с событием ${eventName} прекращена на странице ${terminatePage}. Всего страниц ${totalPages}`)
})

//Событие если запускаемая кампания не найдена
const onCampaignNotFoundSubscription = onCampaignNotFound((name) => {
    console.log(`Кампания с именем ${name} не была найдена`)
})

//Событие логирования библиотеки
const onLogSubscription = onLog((message) => {
    console.log(`Новое запись в логах библиотеки: ${message}`)
})
```

onCompaignShowSubscription и другие являются экземплярами класса EmitterSubscription и могут быть удалены вызовом метода remove
```javascript
//Удаление слушателей событий
onCompaignShowSubscription.remove()
onCampaignFinishSubscription.remove()
onCampaignLoadedSubscription.remove()
onCampaignEventSendSubscription.remove()
onCampaignTerminateSubscription.remove()
onCampaignNotFoundSubscription.remove()
onLogSubscription.remove()
```

### 10. Отправка параметров (Properties)
При необходимости есть возможность отправить дополнительные данные, вместе с ответом, например User_id, Email, Регион или любые другие. Для этого вызовите функцию setProperties:
```javascript
import { setProperties } from 'uxfeedback'
setProperties({
    name: "User",
    age: '21',
    //....
})
```
### 11. Режим логгирования (Отладка приложения)

Для того чтобы включить режим логгирования вам нужно указать в настройке библиотеки debugEnabled: true

```javascript
import { setSettings } from 'uxfeedback'

setSettings({
  debugEnabled: true,
  //...
})
```

### 12. Запуск библиотеки с предварительно заданными настройками, темой и параметрами

Вы можете запустить библиотеку с заранее заданными настройками, стилями и т.д, не вызывая отдельные методы. Для этого вызовите метод setup передав в него соответствующие данные:

```javascript
setup({
    iosAppID: 'App_ID',
    settings: {
         debugEnabled: true,
        // Настройки библиотеки
    },
    theme: {
        bgColor: '#FFFFFF',
        // Стили бибилиотеки
    },
    properties: {
        name: "User",
        // Параметры библиотеки
    }
})
```

Затем для android и ios необходимо установить библиотеки логгирования чтобы видеть нативные логи:
```bash
npx react-native log-ios
npx react-native log-android
```

Более подробную информацию можно получить [здесь](https://reactnative.dev/docs/debugging)

## 13. Обновление библиотеки

Чтобы обновить версию библиотеки для react-native и нативных частей приложения необходимо проделать ряд шагов:

1. Обновите версию библиотеки в `package.json` вашего react-native проекта на актуальную:
```package.json
"dependencies": {
    // Другие библиотеки
    "uxfeedback": "^2.1.0"
}
```

2. Запустите команду в терминале и подождите пока менеджер пакетов не подтянет последнюю версию библиотеки:

```bash
# Используя npm
npm install

# Используя Yarn
yarn install
```

3. Далее введите в терминале следующую команду, чтобы обновить зависимости ios версии:

```bash
cd ios && pod install --repo-update && cd ..
```

4. Готово! Можете продолжать работу с обновленной библиотекой
