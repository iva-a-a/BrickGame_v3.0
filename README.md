# BrickGames v3.0

Клиент-серверный проект BrickGame на Swift: игровая логика **Race** (Swift), REST API (Vapor), веб-интерфейс, клиент для C API, а также [**Tetris** (C) и **Snake** (C++)](https://github.com/iva-a-a/BrickGame_v2.0) из предыдущих версий.

## Структура

```text
src/
├── brick_game/          # Swift Package (Package.swift)
│   ├── race/            # Логика Race + unit-тесты
│   ├── server/          # Vapor-сервер и GameCore
│   ├── client/          # HTTP-клиент и ClientBridge (C API → REST)
│   ├── web_gui/         # Статический веб-UI
│   ├── tetris/          # Tetris (C)
│   └── snake/           # Snake (C++)
├── gui/
│   ├── cli/             # Консольный UI (ncurses)
│   └── desktop/         # Десктопный UI (Qt)
├── diagrams/            # Диаграммы КА (FSM.md)
└── scripts/             # run_server.sh, run_console.sh, run_desktop.sh
```

## Игра Race

- Поле **10×20** клеток.
- Игрок меняет полосу (← / →); противники спавнятся сверху и едут вниз.
- Столкновение → состояние `end`; перезапуск — действие `start`.
- Удержание **↑** ускоряет противников (интервал тика делится на 3).
- Очки: +1 за каждую машину, ушедшую за нижний край (обгон).
- Уровень: +1 каждые **5** очков, максимум **10**; скорость растёт с уровнем.
- Рекорд хранится в `highScoreRace.txt` в каталоге Documents (macOS).

### Состояния КА (Race)

`begin` → `running` → (`movingLeft` / `movingRight`) → `break` (пауза) → `end` → `exit`.

Диаграмма: [src/diagrams/FSM.md](src/diagrams/FSM.md).

## REST API

Сервер отдаёт статику из `web_gui` и обрабатывает запросы (модели в `api_models/BrickGameAPI`):

| Метод | Путь | Назначение |
|-------|------|------------|
| GET | `/api/games` | Список игр |
| POST | `/api/games/:gameId` | Выбор игры (1 — Tetris, 2 — Snake, 3 — Race) |
| POST | `/api/actions` | Действие игрока (`UserAction`) |
| GET | `/api/state` | Текущее состояние поля и статистики |

Клиентская библиотека (`client/`) используется через **ClientBridge** — консоль и десктоп ходят на сервер по URL из переменной `GAME_SERVER_URL` (по умолчанию `http://localhost:8080`).

## Запуск

Требования: **macOS 13+**, Swift 6, для CLI/Desktop — ncurses/Qt и сборка через `Makefile` в `src/` (см. Xcode workspace).

**Сервер** (из каталога пакета):

```bash
cd src/brick_game
swift run Server
```

Сервер слушает порт **8080**; в браузере — `http://localhost:8080`.

**Тесты Race:**

```bash
cd src/brick_game
swift test
```

**Скрипты**:

```bash
./src/scripts/run_server.sh
./src/scripts/run_console.sh
./src/scripts/run_desktop.sh
```

**Docker** (опционально): `src/brick_game/server/docker-compose.yml`.

## Управление (веб)

| Действие | Клавиша |
|----------|---------|
| Старт | Enter |
| Пауза | P |
| Выход / завершение | Escape |
| Влево / вправо | ← / → |
| Ускорение (удерживать) | ↑ |

## Стек технологий

- **Swift 6.0** (`swift-tools-version: 6.0`), целевая платформа **macOS 13+**
- **Swift Package Manager** — сборка сервера, клиента, Race и тестов (`src/brick_game/Package.swift`)
- **XCTest** — unit-тесты логики Race (`RaceTests`)
- **Foundation** — модели API (`Codable`, `Sendable`), файловое хранение рекорда, `FileManager`
- **Concurrency** — `async`/`await` на сервере (Vapor) и в HTTP-клиенте; `Sendable`, `@preconcurrency`; синхронизация в мосте C API — `os.lock` (`OSAllocatedUnfairLock`)
- **Dispatch** — игровой таймер и тики в `RaceController`
- **URLSession** + **JSONEncoder** / **JSONDecoder** — REST-клиент (`client/`)
- **Межъязыковая связка** — Swift ↔ C (`TetrisCLib`, `BrickGameCAPI`) и Swift ↔ C++17 (`SnakeCPPLib`);
- **Vapor 4** — HTTP API, middleware, `Content` для JSON, раздача статики (`FileMiddleware`)
- **C** — Tetris, общий C API (`api/`), консольный UI
- **C++17** — Snake;
- **Qt** (Core, Gui, Widgets) — десктопный UI (`gui/desktop/`)
- **ncurses** — консольный UI (`gui/cli/`)
- **HTML / CSS / JavaScript** (ES-модули, без фреймворка)
- **Xcode workspace** — обзор `src/` (`BrickGame.xcworkspace`)
- **qmake** + **Makefile** (в `src/`) — сборка CLI/Desktop и линковка с `ClientBridge`
- Клиент–сервер по **REST JSON**
- Игровая логика Race — **конечный автомат** (см. `src/diagrams/`)
