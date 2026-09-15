--[[
    ============================================================
    Grondex Hub — UI Menu
    ============================================================
    Author: Noxis-spec
    GitHub: https://github.com/Noxis-spec/project-lazarus-script

    WHAT THIS FILE DOES:
      Creates the WindUI menu with tabs for every feature.
      Each toggle flips a flag inside _G.LazarusFlags, which
      main.lua reads every frame to decide what to do.

    TABS:
      Main      — combat features
      Visual    — FOV, Rainbow Gun
      ESP       — zombie / box / pack-a-punch outlines
      Misc      — speed, noclip, unload
      Credits   — people who helped
      About     — project info

    USAGE:
      Loaded automatically by loader.lua.
    ============================================================
--]]

if not game:IsLoaded() then game.Loaded:Wait() end

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

local WindUI = loadstring(game:HttpGet(
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

local Window = WindUI:CreateWindow({
    Title       = "Grondex Hub",
    Icon        = "skull",
    Author      = "By Noxis",
    Folder      = "GrondexHub",
    Size        = UDim2.fromOffset(500, 520),
    Transparent = true,
    Theme       = "Dark",
    Resizable   = true,
})

local MainTab = Window:Tab({ Title = "Main", Icon = "home" })

MainTab:Toggle({
    Title    = "Instant Kill",
    Desc     = "Zombies die from one bullet",
    Icon     = "sword",
    Value    = false,
    Callback = function(state) Flags.InstantKill = state end,
})

MainTab:Toggle({
    Title    = "Infinite Ammo",
    Desc     = "Magazine always full, no reload",
    Icon     = "package",
    Value    = false,
    Callback = function(state) Flags.InfAmmo = state end,
})

MainTab:Toggle({
    Title    = "No Recoil",
    Desc     = "Camera stays stable while shooting",
    Icon     = "crosshair",
    Value    = false,
    Callback = function(state) Flags.NoRecoil = state end,
})

local VisualTab = Window:Tab({ Title = "Visual", Icon = "eye" })

VisualTab:Toggle({
    Title    = "FOV Changer",
    Desc     = "Change your field of view",
    Icon     = "maximize",
    Value    = false,
    Callback = function(state) Flags.FOVEnabled = state end,
})

VisualTab:Slider({
    Title    = "FOV Value",
    Desc     = "Field of view (60 - 120)",
    Icon     = "move",
    Value    = { Min = 60, Max = 120, Default = 70 },
    Callback = function(value) Flags.FOVValue = value end,
})

VisualTab:Divider()

VisualTab:Toggle({
    Title    = "Rainbow Gun",
    Desc     = "Weapon changes colors (visual only)",
    Icon     = "sparkles",
    Value    = false,
    Callback = function(state) Flags.RainbowGun = state end,
})

local EspTab = Window:Tab({ Title = "ESP", Icon = "scan" })

EspTab:Toggle({
    Title    = "Zombie ESP",
    Desc     = "Red outline around zombies",
    Icon     = "skull",
    Value    = false,
    Callback = function(state) Flags.ZombieESP = state end,
})

EspTab:Toggle({
    Title    = "Mystery Box ESP",
    Desc     = "White outline around the Mystery Box",
    Icon     = "box",
    Value    = false,
    Callback = function(state) Flags.BoxESP = state end,
})

EspTab:Toggle({
    Title    = "Pack-a-Punch ESP",
    Desc     = "Blue outline around Pack-a-Punch",
    Icon     = "zap",
    Value    = false,
    Callback = function(state) Flags.PaPESP = state end,
})

local MiscTab = Window:Tab({ Title = "Misc", Icon = "settings-2" })

MiscTab:Toggle({
    Title    = "Speed",
    Desc     = "Move faster than normal",
    Icon     = "wind",
    Value    = false,
    Callback = function(state) Flags.Speed = state end,
})

MiscTab:Toggle({
    Title    = "Noclip",
    Desc     = "Walk through walls",
    Icon     = "ghost",
    Value    = false,
    Callback = function(state) Flags.Noclip = state end,
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

local CreditsTab = Window:Tab({ Title = "Credits", Icon = "users" })

CreditsTab:Paragraph({
    Title = "Grondex Hub",
    Desc  = "A Project Lazarus: ZOMBIES script built for mobile and PC.",
})

CreditsTab:Divider()

CreditsTab:Paragraph({
    Title = "Creator",
    Desc  = "Noxis-spec\nGitHub: github.com/Noxis-spec",
})

CreditsTab:Divider()

CreditsTab:Paragraph({
    Title = "Script Logic",
    Desc  = "Noxis-spec",
})

CreditsTab:Paragraph({
    Title = "UI Design",
    Desc  = "Noxis-spec\nPowered by WindUI (Footagesus)",
})

CreditsTab:Paragraph({
    Title = "Testing",
    Desc  = "Noxis-spec",
})

CreditsTab:Divider()

CreditsTab:Paragraph({
    Title = "Special Thanks",
    Desc  = "WindUI by Footagesus\nRoblox Lua community",
})

local AboutTab = Window:Tab({ Title = "About", Icon = "info" })

AboutTab:Paragraph({
    Title = "About Grondex Hub",
    Desc  = "All-in-one script for Project Lazarus: ZOMBIES. Built to make the game more fun and less grindy. Works on mobile and PC.",
})

AboutTab:Divider()

AboutTab:Paragraph({
    Title = "Version",
    Desc  = "1.2.0",
})

AboutTab:Paragraph({
    Title = "Author",
    Desc  = "Noxis-spec",
})

AboutTab:Paragraph({
    Title = "Repository",
    Desc  = "github.com/Noxis-spec/project-lazarus-script",
})

AboutTab:Paragraph({
    Title = "Tested On",
    Desc  = "Arceus X Neo, Delta, Xeno",
})

AboutTab:Paragraph({
    Title = "Requirements",
    Desc  = "Executor with hookmetamethod, getrawmetatable, getreg support.",
})

AboutTab:Divider()

AboutTab:Paragraph({
    Title = "Features",
    Desc  = "Instant Kill, Infinite Ammo, No Recoil, FOV Changer, Rainbow Gun, Zombie ESP, Mystery Box ESP, Pack-a-Punch ESP, Speed, Noclip",
})

AboutTab:Divider()

AboutTab:Paragraph({
    Title = "Warning",
    Desc  = "Using this script violates Roblox Terms of Service. Use on alternate accounts only. The author is not responsible for any bans.",
})

AboutTab:Divider()

AboutTab:Paragraph({
    Title = "License",
    Desc  = "Free to use, modify and redistribute. Attribution appreciated but not required.",
})

print("[Grondex Hub] loaded")