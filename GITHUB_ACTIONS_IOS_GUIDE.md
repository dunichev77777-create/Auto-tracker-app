# GitHub Actions - Автоматическая сборка iOS IPA

Этот файл настраивает автоматическую сборку iOS IPA через GitHub Actions. Это позволяет собирать iOS приложение без Mac.

## Как это работает

GitHub Actions предоставляет бесплатные macOS runners, которые могут собирать iOS приложения. При каждом push в репозиторий или вручную через интерфейс GitHub, будет собираться IPA файл.

## Настройка

### 1. Создайте репозиторий на GitHub

Если у вас еще нет репозитория:

```bash
# Инициализируйте git (если еще не)
git init

# Добавьте все файлы
git add .

# Сделайте первый коммит
git commit -m "Initial commit"

# Создайте репозиторий на GitHub и добавьте remote
git remote add origin https://github.com/YOUR_USERNAME/mycar.git

# Отправьте на GitHub
git branch -M main
git push -u origin main
```

### 2. Включите GitHub Actions

1. Откройте ваш репозиторий на GitHub
2. Перейдите в **Actions** tab
3. GitHub предложит включить Actions - нажмите **Enable GitHub Actions**

### 3. Запустите сборку

**Автоматически:**
- Просто сделайте push в репозиторий:
  ```bash
  git add .
  git commit -m "Update app"
  git push
  ```
- Сборка начнется автоматически

**Вручную:**
1. Откройте **Actions** tab на GitHub
2. Выберите **Build iOS IPA**
3. Нажмите **Run workflow**
4. Выберите ветку и тип сборки (release/debug)
5. Нажмите **Run workflow**

### 4. Скачайте IPA файл

1. После завершения сборки откройте нужный run в Actions
2. Прокрутите вниз до раздела **Artifacts**
3. Скачайте `mycar-ios-release` (или `mycar-ios-debug`)

## Использование IPA файла

После скачивания IPA файла:

### Для TestFlight (Apple Developer Account)

1. Откройте **Transporter** на Mac
2. Войдите в Apple Developer account
3. Перетащите IPA файл в Transporter
4. Выберите **TestFlight**
5. Нажмите **Deliver**
6. Добавьте тестировщиков в App Store Connect

### Для AltStore (Без Apple Developer)

1. Установите AltStore на iPhone
2. Установите AltServer на Mac
3. Подключите iPhone к Mac
4. Откройте AltStore на iPhone
5. Нажмите "+" и выберите IPA файл
6. Введите Apple ID и пароль

### Для Ad-hoc (Apple Developer + зарегистрированные устройства)

1. Убедитесь что устройства зарегистрированы в Apple Developer Portal
2. Установите через Xcode или ios-deploy:
   ```bash
   ios-deploy --bundle mycar-ios-release.ipa
   ```

## Настройка workflow

Файл workflow находится в `.github/workflows/ios-build.yml`

### Изменить версию Flutter

Отредактируйте строку:
```yaml
flutter-version: '3.44.5'
```

### Изменить ветки для автосборки

Отредактируйте секцию `on`:
```yaml
on:
  push:
    branches: [ main, develop, feature/* ]  # Добавьте нужные ветки
```

### Изменить время хранения артефактов

По умолчанию 30 дней. Измените:
```yaml
retention-days: 30  # Максимально 90 дней для бесплатных аккаунтов
```

## Ограничения бесплатного плана GitHub

- **2000 минут** macOS в месяц для бесплатных аккаунтов
- Одна сборка iOS занимает ~5-10 минут
- Хранение артефактов до 90 дней
- Неограниченное количество сборок

## Troubleshooting

### Сборка не запускается автоматически
- Убедитесь что workflow файл находится в `.github/workflows/`
- Проверьте что Actions включены в настройках репозитория
- Убедитесь что вы push в правильную ветку

### Ошибка при сборке
- Откройте failed run в Actions
- Раскройте шаг с ошибкой для деталей
- Проверьте версию Flutter в workflow

### IPA файл не скачивается
- Убедитесь что сборка завершилась успешно (зеленая галочка)
- Проверьте раздел Artifacts внизу страницы
- Попробуйте скачать через несколько секунд после завершения

### Превышен лимит минут
- GitHub Actions покажет ошибку о превышении лимита
- Подождите до следующего месяца или обновите план
- Оптимизируйте workflow для уменьшения времени сборки

## Альтернатива: GitHub Actions для Android

Если хотите автоматическую сборку и Android APK, создайте файл `.github/workflows/android-build.yml`:

```yaml
name: Build Android APK

on:
  push:
    branches: [ main ]
  workflow_dispatch:

jobs:
  build-android:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v4
    
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.44.5'
        channel: 'stable'
        cache: true
        
    - run: flutter pub get
    
    - run: flutter build apk --release
    
    - uses: actions/upload-artifact@v4
      with:
        name: mycar-android-release
        path: build/app/outputs/flutter-apk/app-release.apa
```

## Быстрая проверка

После настройки проверьте что все работает:

```bash
# Сделайте тестовый push
git add .github/workflows/ios-build.yml
git commit -m "Add iOS build workflow"
git push
```

Затем откройте Actions tab на GitHub и убедитесь что сборка запустилась.
