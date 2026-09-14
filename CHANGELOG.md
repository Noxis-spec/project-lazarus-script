# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

## How to read this file

- **Added** — new features
- **Changed** — changes in existing functionality
- **Fixed** — bug fixes
- **Removed** — removed features
- **Deprecated** — features that will be removed soon

---

## Version format

Versions follow `MAJOR.MINOR.PATCH`:

- **MAJOR** — big changes, may break compatibility
- **MINOR** — new features, backwards compatible
- **PATCH** — small bug fixes

Example: `1.2.3`