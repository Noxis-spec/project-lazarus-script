# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.3.0] — 2026-09-15

### Added
- **Grondex Hub rebrand** — new name, author label, and logo
- **Credits tab** — creator, script logic, UI design, testing, special thanks
- **About tab** — version, author, repo link, tested platforms, requirements, feature list, warning, license
- **Circular progress bar** in the loader (replaces the flat bar)
- **Version display** in the bottom-right corner of the loader
- **Animated logo pulse** on the loading screen
- **FOV Changer** with slider (60–120)
- **Rainbow Gun** toggle
- **Speed** and **Noclip** toggles under Misc

### Changed
- `loader.lua` — fully redesigned loading screen with gradient background, fade in/out, and status messages
- `ui.lua` — reorganized into 6 tabs: Main, Visual, ESP, Misc, Credits, About
- `main.lua` — rewritten to read flags from `_G.LazarusFlags` instead of always-on
- `README.md` — updated with new name, logo, features, and instructions

### Fixed
- Zombie ESP no longer applies to player characters
- Reload variables are reset properly when Infinite Ammo is active
- FOV returns to default when the toggle is turned off

---

## [1.2.0] — 2026-09-15

### Added
- **loader.lua** — animated loading screen with fade in/out
- **ui.lua** — WindUI menu with 5 tabs (Main, Visual, ESP, Misc, Settings)
- Flag system (`_G.LazarusFlags`) — toggles control features in real time

### Changed
- `main.lua` — rewritten to read flags instead of always-on
- Split project into multiple files: `loader.lua`, `main.lua`, `ui.lua`

### Fixed
- Zombie ESP no longer applies to players
- Reload vars reset when Infinite Ammo is enabled

---

## [1.1.0] — 2026-09-14

### Added
- Loader system — user only needs to run one link
- Separate `ui.lua` file for the menu

### Changed
- Project split into multiple files

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

---

## Version Format

Versions follow `MAJOR.MINOR.PATCH`:

- **MAJOR** — big changes, may break compatibility
- **MINOR** — new features, backwards compatible
- **PATCH** — small bug fixes

Example: `1.3.0`

## Types of Changes

- **Added** — new features
- **Changed** — changes in existing functionality
- **Fixed** — bug fixes
- **Removed** — removed features
- **Deprecated** — features that will be removed soon
- **Security** — security-related fixes