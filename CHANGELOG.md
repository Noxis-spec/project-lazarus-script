## [1.2.0] — 2026-09-15

### Added
- **loader.lua** — animated loading screen with fade in/out
- **ui.lua** — WindUI menu with 5 tabs:
  - Main (Instant Kill, Infinite Ammo, No Recoil)
  - Visual (FOV Changer + slider, Rainbow Gun)
  - ESP (Zombie ESP, Mystery Box ESP, Pack-a-Punch ESP)
  - Misc (Speed, Noclip, Unload button)
  - Settings (About, Warning)
- Flag system (`_G.LazarusFlags`) — toggles in the menu control the features in real time

### Changed
- **main.lua** — rewritten to read flags instead of always-on
- Loader now shows animated progress with pulsing logo
- ESP colors moved to settings block at the top of main.lua

### Fixed
- Zombie ESP no longer applies to player characters
- Reload variables are now properly reset when Inf Ammo is enabled

---

## [1.1.0] — 2026-09-14

### Added
- Loader system — user only needs to run one link
- Separate `ui.lua` file for the menu

### Changed
- Split project into multiple files (`loader.lua`, `main.lua`, `ui.lua`)

---

## [1.0.0] — 2026-09-14

### Added
- **Instant Kill** — zombies die from a single bullet
- **Infinite Ammo** — magazine always stays full
- **No Reload** — reload animation never triggers
- **No Recoil** — camera stays stable while shooting
- **Zombie ESP** — red outline around zombies, visible through walls
- **Mystery Box ESP** — white outline around the Mystery Box
- **Pack-a-Punch ESP** — blue outline around the Pack-a-Punch machine
- Configurable settings block at the top of the script (damage, ammo, colors, refresh rates)

### Notes
- Tested on Arceus X Neo, Delta, Xeno
- Requires executor with `hookmetamethod`, `getrawmetatable`, `getreg` support
- Use on alternate accounts only