# Как передать приложение другу (iOS)

iOS не позволяет напрямую передавать установочные файлы как на Android. Вот доступные варианты:

## Вариант 1: TestFlight (Рекомендуется)

**Требуется:** Apple Developer Account ($99/год)

**Плюсы:**
- Официальный способ от Apple
- Приложение не истекает
- Автоматические обновления
- Друг просто устанавливает через TestFlight

**Инструкция для вас:**
```bash
# 1. Соберите IPA
flutter build ipa --release

# 2. Загрузите через Transporter
# - Откройте Transporter (Mac App Store)
# - Войдите в Apple Developer account
# - Перетащите build/ios/ipa/mycar.ipa
# - Выберите "TestFlight"
# - Нажмите "Deliver"
```

**Инструкция для друга:**
1. Скачайте TestFlight из App Store
2. Пришлите ему приглашение из App Store Connect
3. Друг примет приглашение в TestFlight
4. Нажмет "Установить" в TestFlight

---

## Вариант 2: AltStore (Без Apple Developer)

**Требуется:** Компьютер (Mac/PC) для установки

**Плюсы:**
- Бесплатно
- Не нужен Apple Developer account

**Минусы:**
- Приложение истекает через 7 дней (нужно переустанавливать)
- Другу нужен компьютер с AltServer
- Сложнее в установке

**Инструкция для друга:**

### Шаг 1: Подготовка на вашем компьютере

```bash
# Соберите IPA
flutter build ipa --release

# Передайте файл build/ios/ipa/mycar.ipa другу
# (через Google Drive, Dropbox, Telegram и т.д.)
```

### Шаг 2: Друг устанавливает AltStore

**На iPhone друга:**
1. Откройте Safari и перейдите на https://altstore.io
2. Нажмите "Download" → "Install AltStore"
3. Следуйте инструкциям на экране

**На компьютере друга (Mac):**
1. Скачайте AltServer с https://altstore.io
2. Установите AltServer
3. Запустите AltServer (значок в меню баре)

**На компьютере друга (Windows):**
1. Скачайте AltServer с https://altstore.io
2. Установите AltServer
3. Запустите AltServer (в трее)

### Шаг 3: Установка приложения

1. Друг подключает iPhone к компьютеру через USB
2. На iPhone открывает AltStore
3. Нажимает кнопку "+" в левом верхнем углу
4. Выбирает файл `mycar.ipa` который вы ему передали
5. Вводит свои Apple ID и пароль
6. Ждет завершения установки

**Важно:**
- Приложение будет работать 7 дней
- Через 7 дней нужно повторить установку
- Apple ID используется только для подписи, данные в безопасности

---

## Вариант 3: Регистрация устройства друга (Ad-hoc)

**Требуется:** Apple Developer Account + UDID устройства друга

**Плюсы:**
- Приложение не истекает
- Официальный способ

**Минусы:**
- Нужен UDID устройства друга
- Нужно регистрировать каждое устройство
- Максимум 100 устройств в год

**Инструкция:**

### Шаг 1: Получите UDID устройства друга

**Способ 1 - через сайт:**
1. Друг заходит на https://whatsmyudid.com на iPhone
2. Нажимает "Get your UDID"
3. Отправляет вам UDID

**Способ 2 - через Mac (если у друга есть Mac):**
1. Подключить iPhone к Mac
2. Открыть Xcode → Window → Devices and Simulators
3. Выбрать устройство → скопировать Identifier

### Шаг 2: Зарегистрируйте устройство

1. Зайдите в Apple Developer Portal
2. Certificates, Identifiers & Profiles → Devices → All
3. Нажмите "+" → Register Device
4. Введите UDID и имя устройства друга
5. Нажмите Register

### Шаг 3: Обновите provisioning profile

1. В Apple Developer Portal → Provisioning Profiles
2. Откройте ваш Ad-hoc profile
3. Нажмите Edit
4. Добавьте новое устройство
5. Сохраните и скачайте обновленный profile

### Шаг 4: Соберите и передайте IPA

```bash
flutter build ipa --release --export-options-plist ad-hoc-export.plist
```

Передайте `build/ios/ipa/mycar.ipa` другу.

### Шаг 5: Друг устанавливает

**Через Xcode (если у друга есть Mac):**
1. Друг открывает Xcode
2. Window → Devices and Simulators
3. Подключает iPhone
4. Нажимает "+" под Installed Apps
5. Выбирает ваш IPA файл

**Через ios-deploy:**
```bash
# Друг устанавливает ios-deploy
npm install -g ios-deploy

# Устанавливает приложение
ios-deploy --bundle mycar.ipa
```

---

## Рекомендация

**Для простоты:** Используйте **TestFlight** (если есть Apple Developer account)

**Для бесплатного способа:** Используйте **AltStore** (другу понадобится компьютер для установки)

**Для постоянной установки без подписки:** Используйте **Ad-hoc** с регистрацией устройства (нужен Apple Developer account)

---

## Быстрый скрипт для сборки и подготовки

```bash
#!/bin/bash
# build_for_friend.sh

echo "📱 Сборка MyCar для друга..."
flutter build ipa --release

echo "📦 IPA файл готов: build/ios/ipa/mycar.ipa"
echo ""
echo "📤 Как передать другу:"
echo "1. Загрузите файл на Google Drive / Dropbox / Telegram"
echo "2. Отправьте ссылку другу"
echo ""
echo "📲 Друг установит через:"
echo "- TestFlight (если у вас есть Apple Developer account)"
echo "- AltStore (бесплатно, но нужно переустанавливать каждые 7 дней)"
echo "- Ad-hoc (нужна регистрация устройства в Apple Developer Portal)"
```

Создайте файл `build_for_friend.sh` и выполните:
```bash
chmod +x build_for_friend.sh
./build_for_friend.sh
```
