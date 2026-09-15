--[[
    ============================================================
    Project Lazarus: ZOMBIES — Loader
    ============================================================
    Author: Noxis-spec
    GitHub: https://github.com/Noxis-spec/project-lazarus-script

    WHAT THIS FILE DOES:
      1. Shows a loading screen to the player
      2. Fetches main.lua (the actual cheat logic)
      3. Fetches ui.lua (the WindUI menu)
      4. Runs both files in order

    WHY A LOADER:
      - User only needs to run ONE link
      - If main.lua or ui.lua is updated, users get the new version
        automatically without changing their loadstring
      - Loading screen gives visual feedback while files download

    USAGE:
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Noxis-spec/project-lazarus-script/main/loader.lua"))()

    WARNING:
      Using this script violates Roblox Terms of Service.
      Use on alternate accounts only.
    ============================================================
--]]

-- Wait for the game to fully load before doing anything
if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local player  = Players.LocalPlayer

-- ============================================================
-- BASE URL — all files are fetched from this folder
-- If you fork this repo, change BASE to your own GitHub link
-- ============================================================
local BASE = "https://raw.githubusercontent.com/Noxis-spec/project-lazarus-script/main/"

-- ============================================================
-- LOADING SCREEN
-- Simple black screen with a progress bar.
-- Gets destroyed after both files are loaded.
-- ============================================================
local gui = Instance.new("ScreenGui")
gui.Name = "LazarusLoader"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

-- Full-screen black background
local bg = Instance.new("Frame")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
bg.BackgroundTransparency = 0
bg.BorderSizePixel = 0
bg.Parent = gui

-- Main title text
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0.4, 0)
title.BackgroundTransparency = 1
title.Text = "PROJECT LAZARUS"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 28
title.Font = Enum.Font.GothamBold
title.Parent = bg

-- Status text (changes while loading)
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 20)
status.Position = UDim2.new(0, 0, 0.4, 45)
status.BackgroundTransparency = 1
status.Text = "Loading..."
status.TextColor3 = Color3.fromRGB(180, 180, 180)
status.TextSize = 16
status.Font = Enum.Font.Gotham
status.Parent = bg

-- Progress bar background
local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(0, 300, 0, 6)
barBg.Position = UDim2.new(0.5, -150, 0.4, 80)
barBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
barBg.BorderSizePixel = 0
barBg.Parent = bg

-- Progress bar fill (grows from 0 to 1)
local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
barFill.BorderSizePixel = 0
barFill.Parent = barBg

-- Helper: update progress bar
-- t = number from 0 to 1 (0% to 100%)
local function setProgress(t)
    barFill.Size = UDim2.new(t, 0, 1, 0)
end

-- ============================================================
-- FILE FETCHER
-- Downloads a file from BASE URL.
-- Returns the file content as a string, or nil on failure.
-- ============================================================
local function fetch(name)
    local url = BASE .. name
    local ok, result = pcall(function()
        return game:HttpGet(url)
    end)
    if not ok or not result or #result < 10 then
        warn("[Lazarus Loader] Failed to fetch:", name)
        return nil
    end
    return result
end

-- ============================================================
-- LOAD SEQUENCE
-- 1. Fetch main.lua
-- 2. Fetch ui.lua
-- 3. Destroy loading screen
-- 4. Run main.lua
-- 5. Run ui.lua
-- ============================================================

status.Text = "Fetching main.lua..."
setProgress(0.33)
task.wait(0.3)
local mainCode = fetch("main.lua")

status.Text = "Fetching ui.lua..."
setProgress(0.66)
task.wait(0.3)
local uiCode = fetch("ui.lua")

status.Text = "Launching..."
setProgress(1)
task.wait(0.5)

-- Remove loading screen before showing the menu
gui:Destroy()

-- Run main.lua first (loads cheat logic and globals)
if mainCode then
    local ok, err = pcall(function()
        loadstring(mainCode)()
    end)
    if not ok then warn("[Lazarus Loader] main.lua error:", err) end
end

-- Then run ui.lua (creates WindUI menu that controls main.lua)
if uiCode then
    local ok, err = pcall(function()
        loadstring(uiCode)()
    end)
    if not ok then warn("[Lazarus Loader] ui.lua error:", err) end
end

print("[Lazarus Loader] done")