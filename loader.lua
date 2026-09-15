
--[[
    ============================================================
    Project Lazarus: ZOMBIES — Loader
    ============================================================
    Author: Noxis-spec
    GitHub: https://github.com/Noxis-spec/project-lazarus-script

    WHAT THIS FILE DOES:
      1. Shows an animated loading screen
      2. Fetches main.lua (the actual cheat logic)
      3. Fetches ui.lua (the WindUI menu)
      4. Runs both files in order

    USAGE:
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Noxis-spec/project-lazarus-script/main/loader.lua"))()

    WARNING:
      Using this script violates Roblox Terms of Service.
      Use on alternate accounts only.
    ============================================================
--]]

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player  = Players.LocalPlayer

local BASE = "https://raw.githubusercontent.com/Noxis-spec/project-lazarus-script/main/"

-- ============================================================
-- LOADING SCREEN
-- ============================================================
local gui = Instance.new("ScreenGui")
gui.Name = "LazarusLoader"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.Parent = player:WaitForChild("PlayerGui")

-- Background
local bg = Instance.new("Frame")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(8, 6, 10)
bg.BackgroundTransparency = 1
bg.BorderSizePixel = 0
bg.Parent = gui

-- Gradient overlay
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 0, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(8, 6, 10)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 0, 0)),
})
gradient.Rotation = 45
gradient.Parent = bg

-- Center container
local container = Instance.new("Frame")
container.Size = UDim2.new(0, 400, 0, 220)
container.Position = UDim2.new(0.5, -200, 0.5, -110)
container.BackgroundTransparency = 1
container.Parent = bg

-- Logo circle
local logoBg = Instance.new("Frame")
logoBg.Size = UDim2.new(0, 80, 0, 80)
logoBg.Position = UDim2.new(0.5, -40, 0, 0)
logoBg.BackgroundColor3 = Color3.fromRGB(180, 20, 20)
logoBg.BorderSizePixel = 0
logoBg.Parent = container

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(1, 0)
logoCorner.Parent = logoBg

local logoGradient = Instance.new("UIGradient")
logoGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 60, 60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 0, 0)),
})
logoGradient.Rotation = 90
logoGradient.Parent = logoBg

local logoText = Instance.new("TextLabel")
logoText.Size = UDim2.new(1, 0, 1, 0)
logoText.BackgroundTransparency = 1
logoText.Text = "PL"
logoText.TextColor3 = Color3.fromRGB(255, 255, 255)
logoText.TextSize = 34
logoText.Font = Enum.Font.GothamBlack
logoText.Parent = logoBg

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 36)
title.Position = UDim2.new(0, 0, 0, 100)
title.BackgroundTransparency = 1
title.Text = "PROJECT LAZARUS"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 26
title.Font = Enum.Font.GothamBlack
title.Parent = container

-- Subtitle
local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, 0, 0, 18)
subtitle.Position = UDim2.new(0, 0, 0, 136)
subtitle.BackgroundTransparency = 1
subtitle.Text = "by Noxis-spec"
subtitle.TextColor3 = Color3.fromRGB(180, 100, 100)
subtitle.TextSize = 14
subtitle.Font = Enum.Font.Gotham
subtitle.Parent = container

-- Status text
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 18)
status.Position = UDim2.new(0, 0, 0, 162)
status.BackgroundTransparency = 1
status.Text = "Initializing..."
status.TextColor3 = Color3.fromRGB(180, 180, 180)
status.TextSize = 13
status.Font = Enum.Font.Gotham
status.Parent = container

-- Progress bar background
local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(0, 320, 0, 6)
barBg.Position = UDim2.new(0.5, -160, 0, 190)
barBg.BackgroundColor3 = Color3.fromRGB(30, 25, 30)
barBg.BorderSizePixel = 0
barBg.Parent = container

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(1, 0)
barCorner.Parent = barBg

-- Progress bar fill
local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
barFill.BorderSizePixel = 0
barFill.Parent = barBg

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(1, 0)
fillCorner.Parent = barFill

local fillGradient = Instance.new("UIGradient")
fillGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 100)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 0, 0)),
})
fillGradient.Parent = barFill

-- ============================================================
-- ANIMATIONS
-- ============================================================
-- Fade in background
TweenService:Create(bg, TweenInfo.new(0.4), {
    BackgroundTransparency = 0
}):Play()

-- Pulse animation on the logo
task.spawn(function()
    while gui.Parent do
        local t1 = TweenService:Create(logoBg, TweenInfo.new(0.8, Enum.EasingStyle.Sine), {
            Size = UDim2.new(0, 88, 0, 88),
            Position = UDim2.new(0.5, -44, 0, -4),
        })
        t1:Play()
        t1.Completed:Wait()
        local t2 = TweenService:Create(logoBg, TweenInfo.new(0.8, Enum.EasingStyle.Sine), {
            Size = UDim2.new(0, 80, 0, 80),
            Position = UDim2.new(0.5, -40, 0, 0),
        })
        t2:Play()
        t2.Completed:Wait()
    end
end)

-- Smooth progress update
local function setProgress(t)
    TweenService:Create(barFill, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Size = UDim2.new(t, 0, 1, 0)
    }):Play()
end

-- ============================================================
-- FILE FETCHER
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
-- ============================================================
task.wait(0.4)

status.Text = "Fetching main.lua..."
setProgress(0.33)
local mainCode = fetch("main.lua")

task.wait(0.3)
status.Text = "Fetching ui.lua..."
setProgress(0.66)
local uiCode = fetch("ui.lua")

task.wait(0.3)
status.Text = "Launching..."
setProgress(1)
task.wait(0.6)

-- Fade out
local fadeOut = TweenService:Create(bg, TweenInfo.new(0.4), {
    BackgroundTransparency = 1
})
fadeOut:Play()
fadeOut.Completed:Wait()

gui:Destroy()

-- Run main first, then ui
if mainCode then
    local ok, err = pcall(function()
        loadstring(mainCode)()
    end)
    if not ok then warn("[Lazarus Loader] main.lua error:", err) end
end

if uiCode then
    local ok, err = pcall(function()
        loadstring(uiCode)()
    end)
    if not ok then warn("[Lazarus Loader] ui.lua error:", err) end
end

print("[Lazarus Loader] done")