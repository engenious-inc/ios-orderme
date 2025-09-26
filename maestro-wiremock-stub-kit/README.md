# Maestro WireMock Stub Kit

Готовый к использованию набор для **record / playback** API-трафика в тестах Maestro (iOS + Android)
на базе WireMock. Поддерживает два режима:
- **record** — проксирование в реальный бэкенд с автоматической записью стаба
- **playback** — воспроизведение ранее сохранённых заглушек без выхода в сеть

## Быстрый старт (локально)
1. Установите Docker / Docker Compose.
2. Запустите запись (замените `REAL_API_BASE` своим реальным API):  
   ```bash
   REAL_API_BASE="https://api.example.com" docker compose -f compose.yaml up wiremock-record
   ```
3. Запустите эмулятор/симулятор и приложение через Maestro, **передав base URL = http://HOST:8080**:
   - iOS Simulator: можно использовать `http://127.0.0.1:8080`
   - Android Emulator: используйте `http://10.0.2.2:8080` **или** сделайте `adb reverse tcp:8080 tcp:8080` и тогда используйте `http://127.0.0.1:8080`
4. Прогоните нужные сценарии — стабы появятся в `wiremock/mappings` и `wiremock/__files`.
5. Остановите запись `Ctrl+C`.
6. Для воспроизведения:  
   ```bash
   docker compose -f compose.yaml up -d wiremock-playback
   ```
   и запустите тесты Maestro с тем же base URL, но уже **без выхода в реальный бэкенд**.

## Интеграция с Maestro
- Перед запуском теста включите контейнер **record** или **playback**.
- В `flows/*.yaml` показано, как передать base URL через `launchApp: arguments`.
- В `scripts/` есть утилиты для ADB и служебные команды WireMock (очистка, снапшоты и т.п.).

## Важные замечания
- Для iOS (DEBUG) добавьте `NSAppTransportSecurity` исключение для HTTP (см. `adapters/ios/Info.plist.snippet.xml`).
- Для Android (DEBUG) включите cleartext и, при необходимости, доверьте user CA (см. `adapters/android/network_security_config.xml`).
- Режим **record** в этом наборе стартует с флагами `--proxy-all=$REAL_API_BASE --record-mappings` — WireMock сам сохранит стабы.
- Если нужно тоньше контролировать записываемые стабы или нормализовать ответы, используйте `tools/sanitize.py` после записи.

## Структура
```
maestro-wiremock-stub-kit/
  compose.yaml
  wiremock/
    mappings/        # JSON-стабы (вход/выход)
    __files/         # тела ответов
  flows/
    record_example.yaml
    playback_example.yaml
  scripts/
    wiremock_admin.js       # HTTP-скрипты для Maestro (очистка/проверки)
    android_adb_reverse.sh  # ADB reverse для 127.0.0.1:8080
    android_clear_reverse.sh
  adapters/
    ios/
      BaseURLOverride.swift
      Info.plist.snippet.xml
    android/
      BaseUrlOverride.kt
      network_security_config.xml
  tools/
    sanitize.py      # постобработка записанных стабов (нормализация дат и т.п.)
```

