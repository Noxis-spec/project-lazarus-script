--[[
    ============================================================
    Project Lazarus: ZOMBIES — UI Menu
    ============================================================
    Author: Noxis-spec
    GitHub: https://github.com/Noxis-spec/project-lazarus-script

    WHAT THIS FILE DOES:
      Creates the WindUI menu with toggles for every feature.
      Each toggle flips a flag inside _G.LazarusFlags, which
      main.lua reads every frame to decide what to do.

    FLAGS (set by toggles, read by main.lua):
      _G.LazarusFlags.InstantKill
      _G.LazarusFlags.InfAmmo
      _G.LazarusFlags.NoRecoil
      _G.LazarusFlags.FOVEnabled
      _G.LazarusFlags.FOVValue
      _G.LazarusFlags.ZombieESP
      _G.LazarusFlags.BoxESP
      _G.LazarusFlags.PaPESP
      _G.LazarusFlags.Noclip
      _G.LazarusFlags.Speed
      _G.LazarusFlags.RainbowGun

    USAGE:
      This file is loaded automatically by loader.lua.
      Do not run it directly unless you also loaded main.lua.
    ============================================================
--]]

if not game:IsLoaded() then game.Loaded:Wait() end

-- ============================================================
-- FLAGS — main.lua reads these to know what to enable
-- ============================================================
_G.LazarusFlags = _G.LazarusFlags or {
    InstantKill = false,
    InfAmmo     = false,
    NoRecoil    = false,
    FOVEnabled  = false,
    FOVValue    = 70,
    ZombieESP   = false,
    BoxESP      = false,
    PaPESP      = false,
    Noclip      = false,
    Speed       = false,
    RainbowGun  = false,
}

local Flags = _G.LazarusFlags

-- ============================================================
-- LOAD WINDUI LIBRARY
-- ============================================================
local WindUI = loadstring(game:HttpGet(
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

-- ============================================================
-- CREATE WINDOW
-- ============================================================
local Window = WindUI:CreateWindow({
    Title       = "Project Lazarus",
    Icon        = "skull",
    Author      = "Noxis-spec",
    Folder      = "LazarusScript",
    Size        = UDim2.fromOffset(500, 520),
    Transparent = true,
    Theme       = "Dark",
    Resizable   = true,
})

-- ============================================================
-- MAIN TAB — combat features
-- ============================================================
local MainTab = Window:Tab({ Title = "Main", Icon = "home" })

MainTab:Toggle({
    Title    = "Instant Kill",
    Desc     = "Zombies die from one bullet",
    Icon     = "sword",
    Value    = false,
    Callback = function(state)
        Flags.InstantKill = state
    end,
})

MainTab:Toggle({
    Title    = "Infinite Ammo",
    Desc     = "Magazine always full, no reload",
    Icon     = "package",
    Value    = false,
    Callback = function(state)
        Flags.InfAmmo = state
    end,
})

MainTab:Toggle({
    Title    = "No Recoil",
    Desc     = "Camera stays stable while shooting",
    Icon     = "crosshair",
    Value    = false,
    Callback = function(state)
        Flags.NoRecoil = state
    end,
})

-- ============================================================
-- VISUAL TAB — camera and graphics
-- ============================================================
local VisualTab = Window:Tab({ Title = "Visual", Icon = "eye" })

VisualTab:Toggle({
    Title    = "FOV Changer",
    Desc     = "Change your field of view",
    Icon     = "maximize",
    Value    = false,
    Callback = function(state)
        Flags.FOVEnabled = state
    end,
})

VisualTab:Slider({
    Title    = "FOV Value",
    Desc     = "Field of view (60 - 120)",
    Icon     = "move",
    Value    = { Min = 60, Max = 120, Default = 70 },
    Callback = function(value)
        Flags.FOVValue = value
    end,
})

VisualTab:Divider()

VisualTab:Toggle({
    Title    = "Rainbow Gun",
    Desc     = "Weapon changes colors (visual only)",
    Icon     = "sparkles",
    Value    = false,
    Callback = function(state)
        Flags.RainbowGun = state
    end,
})

-- ============================================================
-- ESP TAB — highlight features
-- ============================================================
local EspTab = Window:Tab({ Title = "ESP", Icon = "scan" })

EspTab:Toggle({
    Title    = "Zombie ESP",
    Desc     = "Red outline around zombies",
    Icon     = "skull",
    Value    = false,
    Callback = function(state)
        Flags.ZombieESP = state
    end,
})

EspTab:Toggle({
    Title    = "Mystery Box ESP",
    Desc     = "White outline around the Mystery Box",
    Icon     = "box",
    Value    = false,
    Callback = function(state)
        Flags.BoxESP = state
    end,
})

EspTab:Toggle({
    Title    = "Pack-a-Punch ESP",
    Desc     = "Blue outline around Pack-a-Punch",
    Icon     = "zap",
    Value    = false,
    Callback = function(state)
        Flags.PaPESP = state
    end,
})

-- ============================================================
-- MISC TAB — movement and other
-- ============================================================
local MiscTab = Window:Tab({ Title = "Misc", Icon = "settings-2" })

MiscTab:Toggle({
    Title    = "Speed",
    Desc     = "Move faster than normal",
    Icon     = "wind",
    Value    = false,
    Callback = function(state)
        Flags.Speed = state
    end,
})

MiscTab:Toggle({
    Title    = "Noclip",
    Desc     = "Walk through walls",
    Icon     = "ghost",
    Value    = false,
    Callback = function(state)
        Flags.Noclip = state
    end,
})

MiscTab:Divider()

MiscTab:Button({
    Title    = "Unload Script",
    Desc     = "Turns off everything and closes the menu",
    Icon     = "power",
    Callback = function()
        Flags.InstantKill = false
        Flags.InfAmmo     = false
        Flags.NoRecoil    = false
        Flags.FOVEnabled  = false
        Flags.ZombieESP   = false
        Flags.BoxESP      = false
        Flags.PaPESP      = false
        Flags.Noclip      = false
        Flags.Speed       = false
        Flags.RainbowGun  = false
        pcall(function() Window:Destroy() end)
    end,
})

-- ============================================================
-- SETTINGS TAB — info
-- ============================================================
local SettingsTab = Window:Tab({ Title = "Settings", Icon = "settings" })

SettingsTab:Paragraph({
    Title = "About",
    Desc  = "Project Lazarus All-in-One by Noxis-spec.\nGitHub: github.com/Noxis-spec/project-lazarus-script",
})

SettingsTab:Divider()

SettingsTab:Paragraph({
    Title = "Warning",
    Desc  = "Use on alternate accounts only. Exploiting violates Roblox ToS.",
})

print("[Lazarus UI] loaded")