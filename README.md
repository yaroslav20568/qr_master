# QR Master

Приложение на Flutter для сканирования и создания QR-кодов с поддержкой различных типов контента, синхронизацией данных и системой подписок.

## Описание проекта

QR Master - это полнофункциональное приложение для работы с QR-кодами. Пользователи могут сканировать QR-коды с помощью камеры, создавать QR-коды различных типов (URL, текст, контакты, WiFi и другие), сохранять историю сканирований и созданных кодов, синхронизировать данные через облако, а также использовать подписку для получения дополнительных функций.

## Что было сделано

- Создана структура проекта с разделением на экраны, виджеты, модели, сервисы, константы и утилиты
- Реализован экран сканирования QR-кодов с использованием камеры
- Создан экран создания QR-кодов с поддержкой различных типов (URL, текст, контакты, WiFi, email, SMS, телефон)
- Реализована система истории сканирований и созданных QR-кодов
- Добавлена синхронизация данных через Firebase Firestore
- Реализована система аутентификации через Google Sign-In
- Интегрирована система подписок через AppHud с поддержкой placements и paywalls
- Добавлена аналитика через AppsFlyer, Firebase Analytics и AppMetrica
- Реализована система рекламы через Google Mobile Ads
- Настроена атрибуция между AppsFlyer и AppHud
- Добавлена поддержка App Tracking Transparency (ATT) для iOS
- Созданы переиспользуемые виджеты для всех экранов
- Настроены цвета, градиенты и шрифты в отдельных файлах констант
- Адаптирован интерфейс с поддержкой SafeArea и различных размеров экранов
- Реализована система навигации с нижней панелью вкладок
- Добавлен экран онбординга для новых пользователей
- Реализована система управления подписками с отображением продуктов и цен

## Используемые пакеты

- `flutter` - основной фреймворк
- `cupertino_icons` - иконки для iOS стиля
- `apphud` - управление подписками
- `appsflyer_sdk` - аналитика и атрибуция
- `app_tracking_transparency` - запрос разрешения на трекинг для iOS
- `google_mobile_ads` - реклама через Google AdMob
- `firebase_core`, `firebase_analytics`, `firebase_auth`, `cloud_firestore` - интеграция с Firebase
- `appmetrica_plugin` - аналитика AppMetrica
- `google_sign_in` - аутентификация через Google
- `shared_preferences` - локальное хранилище данных
- `mobile_scanner` - сканирование QR-кодов
- `qr_flutter` - генерация QR-кодов
- `path_provider` - работа с путями файловой системы
- `url_launcher` - открытие URL
- `image_picker` - выбор изображений
- `intl` - интернационализация
- `permission_handler` - управление разрешениями
- `logger` - логирование
- `google_fonts` - кастомные шрифты
- `package_info_plus` - информация о приложении
- `flutter_svg` - отображение SVG иконок
- `share_plus` - функционал шаринга
- `flutter_dotenv` - загрузка переменных окружения
- `flutter_lints` - линтеры для проверки кода
- `flutter_launcher_icons` - генерация иконок приложения (dev dependency)

## Архитектура

Проект следует принципам SOLID и KISS. Код организован в следующие директории:

- `lib/screens/` - экраны приложения (splash, onboarding, auth, home, scan, create_qr, history, my_qr_codes, subscription)
- `lib/widgets/` - переиспользуемые виджеты (разделены на виджеты для конкретных экранов и общие UI-виджеты)
- `lib/models/` - модели данных (QR-коды, история сканирований, статусы подписок)
- `lib/services/` - бизнес-логика (Firebase, аналитика, подписки, реклама, QR-коды, разрешения)
- `lib/constants/` - константы (цвета, градиенты, шрифты, маршруты, ассеты)
- `lib/utils/` - утилиты (работа с QR-кодами, историей, пользователями, приложением)

---

# QR Master

A Flutter application for scanning and creating QR codes with support for various content types, data synchronization, and subscription system.

## Project Description

QR Master is a full-featured QR code application. Users can scan QR codes using the camera, create QR codes of various types (URL, text, contacts, WiFi, and more), save scan history and created codes, synchronize data through the cloud, and use subscriptions to access additional features.

## What Was Done

- Created project structure with separation into screens, widgets, models, services, constants, and utilities
- Implemented QR code scanning screen using camera
- Created QR code creation screen with support for various types (URL, text, contacts, WiFi, email, SMS, phone)
- Implemented scan history and created QR codes system
- Added data synchronization through Firebase Firestore
- Implemented authentication system through Google Sign-In
- Integrated subscription system through AppHud with support for placements and paywalls
- Added analytics through AppsFlyer, Firebase Analytics, and AppMetrica
- Implemented advertising system through Google Mobile Ads
- Configured attribution between AppsFlyer and AppHud
- Added App Tracking Transparency (ATT) support for iOS
- Created reusable widgets for all screens
- Configured colors, gradients, and fonts in separate constants files
- Adapted interface with SafeArea support and various screen sizes
- Implemented navigation system with bottom tab bar
- Added onboarding screen for new users
- Implemented subscription management system with product and price display

## Used Packages

- `flutter` - main framework
- `cupertino_icons` - icons for iOS style
- `apphud` - subscription management
- `appsflyer_sdk` - analytics and attribution
- `app_tracking_transparency` - tracking permission request for iOS
- `google_mobile_ads` - advertising through Google AdMob
- `firebase_core`, `firebase_analytics`, `firebase_auth`, `cloud_firestore` - Firebase integration
- `appmetrica_plugin` - AppMetrica analytics
- `google_sign_in` - Google authentication
- `shared_preferences` - local data storage
- `mobile_scanner` - QR code scanning
- `qr_flutter` - QR code generation
- `path_provider` - file system path handling
- `url_launcher` - URL opening
- `image_picker` - image selection
- `intl` - internationalization
- `permission_handler` - permission management
- `logger` - logging
- `google_fonts` - custom fonts
- `package_info_plus` - application information
- `flutter_svg` - SVG icon rendering
- `share_plus` - sharing functionality
- `flutter_dotenv` - environment variables loading
- `flutter_lints` - linters for code checking
- `flutter_launcher_icons` - application icon generation (dev dependency)

## Architecture

The project follows SOLID and KISS principles. Code is organized into the following directories:

- `lib/screens/` - application screens (splash, onboarding, auth, home, scan, create_qr, history, my_qr_codes, subscription)
- `lib/widgets/` - reusable widgets (divided into screen-specific widgets and common UI widgets)
- `lib/models/` - data models (QR codes, scan history, subscription statuses)
- `lib/services/` - business logic (Firebase, analytics, subscriptions, advertising, QR codes, permissions)
- `lib/constants/` - constants (colors, gradients, fonts, routes, assets)
- `lib/utils/` - utilities (QR code handling, history, users, application)
