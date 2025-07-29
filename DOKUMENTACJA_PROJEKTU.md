# Dokumentacja Projektu - Space Lord (Space RPG Game)

## Przegląd Projektu
Projekt to gra 2D RPG w kosmosie napisana w języku Lua z wykorzystaniem frameworka LÖVE (Love2D). Gra zawiera system walki, ekwipunku, dialogów oraz eksploracji planet.

---

## 📁 Struktura Katalogów

### `/assets/`
Zasoby graficzne i audio gry:
- `map_img/` - obrazy map
- `sounds/` - pliki dźwiękowe
- `sprites/` - grafiki postaci (character.png, character2.png)
- `tilemaps/` - mapy w formacie TMX i Lua (planet_001.lua/tmx)
- `tilesets/` - zestawy kafli (basic_tileset.png, build_001.png, dirt.png, grass.png, water.png)

### `/libraries/`
Zewnętrzne biblioteki Lua:
- `anim8.lua` - biblioteka animacji
- `camera.lua` - system kamery
- `lume.lua` - narzędzia użytkowe
- `sti/` - Simple Tiled Implementation (obsługa map Tiled)

### `/src/`
Kod źródłowy gry

---

## 📜 Główne Pliki

### `main.lua`
**Opis:** Główny plik gry - punkt wejścia aplikacji
**Kluczowe funkcje:**
- `removeBody(body)` - usuwanie obiektów fizycznych
- `love.load()` - inicjalizacja gry, tworzenie świata fizyki, ładowanie scen
- `love.update(dt)` - główna pętla aktualizacji
- `love.draw()` - główna pętla renderowania
- `love.keypressed(key)` - obsługa wejścia klawiatury
- `love.mousepressed(x, y, button)` - obsługa kliknięć myszy
- `cam_limits()` - ograniczenia kamery

### `build.sh`
Skrypt budowania projektu

---

## 🏛️ Systemy Gry (`/src/systems/`)

### `settings.lua`
**Opis:** Zarządzanie ustawieniami gry
**Klasa:** `Settings`
**Funkcje:**
- `Settings:new()` - inicjalizacja ustawień, rozdzielczości
- `Settings:toggleWindow()` - przełączanie trybu okna
- `Settings:toggleFullscreen()` - przełączanie pełnego ekranu

### `pause.lua` 
**Opis:** System pauzowania gry
**Klasa:** `Pause`

### `playerUI.lua`
**Opis:** Interfejs użytkownika gracza
**Klasa:** `PlayerUI`

### `saveload.lua`
**Opis:** System zapisywania i wczytywania stanu gry
**Klasa:** `Save_load`

### `talksys.lua`
**Opis:** System dialogów z NPC
**Klasa:** `TalkSys`
**Funkcje:**
- `TalkSys:new()` - inicjalizacja systemu dialogów
- `TalkSys:update(dt)` - aktualizacja dialogów
- `TalkSys:draw()` - renderowanie okien dialogowych

### `time.lua`
**Opis:** System czasu w grze
**Klasa:** `Time`

### `shaders.lua`
**Opis:** Zarządzanie shaderami graficznymi
**Klasa:** `Shaders`

---

## 🎒 System Ekwipunku (`/src/systems/Inventory/`)

### `inventory.lua`
**Opis:** Główny system ekwipunku gracza
**Klasa:** `Inventory`
**Funkcje:**
- `Inventory:new()` - inicjalizacja ekwipunku
- `Inventory:draw()` - renderowanie interfejsu ekwipunku
- `Inventory:checkScroll()` - sprawdzanie przewijania listy
- `Inventory:OpenCloseInventory()` - otwieranie/zamykanie ekwipunku
- `Inventory:UpdateAfterChangeOfResolution()` - aktualizacja po zmianie rozdzielczości
- `Inventory:mouse(x,y)` - obsługa kliknięć myszy w ekwipunku
- `Inventory:OpenInventoryInfo()` - otwieranie informacji o przedmiocie
- `Inventory:CloseInventoryInfo()` - zamykanie informacji o przedmiocie
- `Inventory:IsOverWeight()` - sprawdzanie przeciążenia

### `ItemsDB.lua`
**Opis:** Baza danych przedmiotów
**Klasa:** `ItemsDB`
**Funkcje:**
- `ItemsDB:new()` - inicjalizacja bazy danych
- `getItem(name)` - pobieranie przedmiotu po nazwie

### `ItemPickup.lua`
**Opis:** System podnoszenia przedmiotów ze świata gry
**Klasa:** `Pickup`
**Funkcje:**
- `Pickup:new(item, x, y)` - tworzenie przedmiotu do podniesienia
- `Pickup:update(dt, i)` - aktualizacja stanu przedmiotu
- `Pickup:draw()` - renderowanie przedmiotu w świecie

### `items/Item.lua`
**Opis:** Bazowa klasa przedmiotu
**Klasa:** `Item`
**Funkcje:**
- `Item:new(name, description, type, image, value, weight, usable)` - tworzenie przedmiotu

### `items/HealthItem.lua`
**Opis:** Przedmiot leczniczy
**Klasa:** `HealthItem` (dziedziczy z `Item`)
**Funkcje:**
- `HealthItem:new(name, description, type, image, value, weight, health_amount, usable)` - tworzenie przedmiotu leczniczego

---

## 👥 Postacie (`/src/characters/`)

### `player.lua`
**Opis:** Klasa gracza - główna postać kontrolowana przez użytkownika
**Klasa:** `Player`
**Funkcje:**
- `Player:new(x,y)` - tworzenie gracza na pozycji x,y
- `Player:draw()` - renderowanie gracza z rotacją
- `Player:update(dt)` - aktualizacja ruchu, kolizji, działań gracza
- `Player:TakeDamage(damage)` - otrzymywanie obrażeń

**Właściwości:**
- Fizyka: ciało fizyczne, kolizje
- Ruch: prędkość normalna, sprint, dash
- Zdrowie: HP, maksymalne HP
- Grafika: sprite, obrót, promień światła

### `test_npc.lua`
**Opis:** NPC testowy do dialogów
**Klasa:** `Npc`
**Funkcje:**
- `Npc:new(x,y,name, dialogues)` - tworzenie NPC
- `Npc:draw()` - renderowanie NPC

---

## 👾 Wrogowie (`/src/enemy/`)

### `basicEnemy.lua`
**Opis:** Podstawowy wróg z systemem AI
**Klasa:** `Enemy`
**Funkcje:**
- `Enemy:new(x, y, patrolPoints)` - tworzenie wroga
- `Enemy:draw()` - renderowanie wroga
- `Enemy:update(dt)` - główna logika AI
- `Enemy:isPlayerInSight()` - sprawdzanie widoczności gracza
- `Enemy:normalizeAngle(angle)` - normalizacja kątów
- `Enemy:patrol(dt)` - logika patrolowania
- `Enemy:chase(dt)` - logika ścigania gracza
- `Enemy:attack(dt)` - logika ataku
- `Enemy:moveTowards(targetX, targetY, speed)` - ruch w kierunku celu
- `Enemy:distanceTo(x, y)` - obliczanie dystansu
- `Enemy:updateRotation()` - aktualizacja obrotu
- `Enemy:shoot()` - strzelanie do gracza
- `Enemy:TakeDamage(damage)` - otrzymywanie obrażeń

**Stany AI:**
- IDLE - bezczynność
- PATROL - patrolowanie
- CHASE - ściganie
- ATTACK - atak

---

## 🔫 Broń (`/src/weapons/`)

### `gun.lua`
**Opis:** System broni palnej
**Klasa:** `Gun`
**Funkcje:**
- `Gun:new(x, y)` - tworzenie broni
- `Gun:draw()` - renderowanie broni i pocisków
- `Gun:update(dt)` - aktualizacja pozycji i logiki
- `Gun:shoot()` - strzelanie pociskiem

**Właściwości:**
- Cooldown strzelania
- Pozycja względem gracza
- Kąt obrotu w kierunku myszy

---

## 💥 Logika Gry (`/src/logic/`)

### `bullet.lua`
**Opis:** System pocisków
**Klasa:** `Bullet`
**Funkcje:**
- Tworzenie pocisków
- Fizyka ruchu
- Kolizje z wrogami/środowiskiem
- Usuwanie po trafieniu/opuszczeniu ekranu

---

## 🌍 Sceny (`/src/scenes/`)

### `sceneManager.lua`
**Opis:** Zarządca scen gry
**Klasa:** `SceneManager`
**Funkcje:**
- `SceneManager:new(startScene, scenes)` - inicjalizacja menedżera
- `SceneManager:loadScene(scene)` - ładowanie nowej sceny

### `planet_001.lua`
**Opis:** Pierwsza planeta do eksploracji
**Klasa:** `Planet001`
**Funkcje:**
- `Planet001:new(x, y)` - tworzenie planety
- Ładowanie mapy z Tiled
- Tworzenie kolizji wody i budynków
- Generowanie przedmiotów do podniesienia

### `space.lua`
**Opis:** Scena kosmiczna
**Klasa:** `Space`

---

## 💬 NPC i Dialogi (`/src/npc/`)

### `scenario.lua`
**Opis:** System scenariuszy i dialogów
**Klasa:** `Scenario`
**Funkcje:**
- `Scenario:new(loc)` - tworzenie scenariusza dla lokacji
- `Scenario:ChangeScenario(loc)` - zmiana scenariusza

---

## 🎮 Sterowanie

### Klawisze:
- **WASD** - ruch gracza
- **Shift** - sprint
- **Spacja** - dash
- **I** - otwieranie/zamykanie ekwipunku
- **E** - interakcja
- **Escape** - pauza
- **F11** - pełny ekran

### Mysz:
- **LPM** - strzelanie
- **Ruch myszy** - obrót gracza i broni
- **Kliknięcia w ekwipunku** - zarządzanie przedmiotami

---

## 🔧 Techniczne Szczegóły

### Wykorzystane Biblioteki:
- **LÖVE (Love2D)** - główny framework
- **STI** - obsługa map Tiled
- **anim8** - system animacji
- **camera** - system kamery
- **lume** - funkcje użytkowe

### Systemy Fizyki:
- Love2D Physics (Box2D)
- Kolizje ciał statycznych i dynamicznych
- Raycasty dla systemu widoczności

### Grafika:
- 2D sprite'y
- System oświetlenia
- Shadery graficzne
- Mapy kafelkowe

---

## 🚀 Uruchomienie Projektu

1. Zainstaluj LÖVE (Love2D)
2. Uruchom projekt:
   ```bash
   love .
   ```
   lub użyj skryptu:
   ```bash
   ./build.sh
   ```

---

## 📝 Notatki Deweloperskie

- Projekt wykorzystuje wzorzec OOP w Lua z metatablicami
- Wszystkie klasy używają konstruktora `:new()`
- Główna pętla gry znajduje się w `main.lua`
- System fizyki jest zintegrowany z wszystkimi obiektami gry
- Mapa jest tworzona w edytorze Tiled i eksportowana do Lua

---

*Ostatnia aktualizacja: 19 lipca 2025*
