--[[
    ============================================================
    Grondex Hub — Loader
    ============================================================
    Author: Noxis-spec
    GitHub: https://github.com/Noxis-spec/project-lazarus-script
    Version: 1.2.0

    WHAT THIS FILE DOES:
      1. Shows an animated loading screen
      2. Fetches main.lua (cheat logic)
      3. Fetches ui.lua (WindUI menu)
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

local VERSION = "1.2.0"
local BASE = "https://raw.githubusercontent.com/Noxis-spec/project-lazarus-script/main/"

-- ============================================================
-- LOADING SCREEN
-- ============================================================
local gui = Instance.new("ScreenGui")
gui.Name = "GrondexLoader"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.Parent = player:WaitForChild("PlayerGui")

-- Background with gradient
local bg = Instance.new("Frame")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(8, 6, 10)
bg.BackgroundTransparency = 1
bg.BorderSizePixel = 0
bg.Parent = gui

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 0, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(8, 6, 10)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 0, 0)),
})
gradient.Rotation = 45
gradient.Parent = bg

-- Container
local container = Instance.new("Frame")
container.Size = UDim2.new(0, 360, 0, 320)
container.Position = UDim2.new(0.5, -180, 0.5, -160)
container.BackgroundTransparency = 1
container.Parent = bg

-- Logo circle
local logoBg = Instance.new("Frame")
logoBg.Size = UDim2.new(0, 70, 0, 70)
logoBg.Position = UDim2.new(0.5, -35, 0, 0)
logoBg.BackgroundColor3 = Color3.fromRGB(180, 20, 20)
logoBg.BorderSizePixel = 0
logoBg.Parent = container

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(1, 0)
logoCorner.Parent = logoBg

local logoGradient = Instance.new("UIGradient")
logoGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 70, 70)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 0, 0)),
})
logoGradient.Rotation = 90
logoGradient.Parent = logoBg

local logoText = Instance.new("TextLabel")
logoText.Size = UDim2.new(1, 0, 1, 0)
logoText.BackgroundTransparency = 1
logoText.Text = "G"
logoText.TextColor3 = Color3.fromRGB(255, 255, 255)
logoText.TextSize = 38
logoText.Font = Enum.Font.GothamBlack
logoText.Parent = logoBg

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 88)
title.BackgroundTransparency = 1
title.Text = "GRONDEX HUB"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 24
title.Font = Enum.Font.GothamBlack
title.Parent = container

-- Subtitle
local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, 0, 0, 16)
subtitle.Position = UDim2.new(0, 0, 0, 118)
subtitle.BackgroundTransparency = 1
subtitle.Text = "By Noxis"
subtitle.TextColor3 = Color3.fromRGB(180, 100, 100)
subtitle.TextSize = 13
subtitle.Font = Enum.Font.Gotham
subtitle.Parent = container

-- Circular progress — background ring
local ringContainer = Instance.new("Frame")
ringContainer.Size = UDim2.new(0, 120, 0, 120)
ringContainer.Position = UDim2.new(0.5, -60, 0, 160)
ringContainer.BackgroundTransparency = 1
ringContainer.Parent = container

local ringBg = Instance.new("ImageLabel")
ringBg.Size = UDim2.new(1, 0, 1, 0)
ringBg.BackgroundTransparency = 1
ringBg.Image = "rbxassetid://996834403" -- ring texture
ringBg.ImageColor3 = Color3.fromRGB(40, 35, 40)
ringBg.Parent = ringContainer

-- Circular progress — fill
local ringFill = Instance.new("ImageLabel")
ringFill.Size = UDim2.new(1, 0, 1, 0)
ringFill.BackgroundTransparency = 1
ringFill.Image = "rbxassetid://996834403"
ringFill.ImageColor3 = Color3.fromRGB(255, 60, 60)
ringFill.Parent = ringContainer

-- Percent text inside ring
local percentText = Instance.new("TextLabel")
percentText.Size = UDim2.new(1, 0, 1, 0)
percentText.BackgroundTransparency = 1
percentText.Text = "0%"
percentText.TextColor3 = Color3.fromRGB(255, 255, 255)
percentText.TextSize = 22
percentText.Font = Enum.Font.GothamBold
percentText.Parent = ringContainer

-- Status text
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 18)
status.Position = UDim2.new(0, 0, 0, 292)
status.BackgroundTransparency = 1
status.Text = "Initializing..."
status.TextColor3 = Color3.fromRGB(180, 180, 180)
status.TextSize = 13
status.Font = Enum.Font.Gotham
status.Parent = container

-- Version in bottom-right corner
local versionLabel = Instance.new("TextLabel")
versionLabel.Size = UDim2.new(0, 200, 0, 20)
versionLabel.Position = UDim2.new(1, -210, 1, -30)
versionLabel.BackgroundTransparency = 1
versionLabel.Text = "v" .. VERSION
versionLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
versionLabel.TextSize = 12
versionLabel.Font = Enum.Font.Gotham
versionLabel.TextXAlignment = Enum.TextXAlignment.Right
versionLabel.Parent = bg

-- ============================================================
-- ANIMATIONS
-- ============================================================
TweenService:Create(bg, TweenInfo.new(0.4), {
    BackgroundTransparency = 0
}):Play()

-- Pulse logo
task.spawn(function()
    while gui.Parent do
        local t1 = TweenService:Create(logoBg, TweenInfo.new(0.9, Enum.EasingStyle.Sine), {
            Size = UDim2.new(0, 78, 0, 78),
            Position = UDim2.new(0.5, -39, 0, -4),
        })
        t1:Play()
        t1.Completed:Wait()
        local t2 = TweenService:Create(logoBg, TweenInfo.new(0.9, Enum.EasingStyle.Sine), {
            Size = UDim2.new(0, 70, 0, 70),
            Position = UDim2.new(0.5, -35, 0, 0),
        })
        t2:Play()
        t2.Completed:Wait()
    end
end)

-- Rotate ring slightly for a subtle effect
task.spawn(function()
    while gui.Parent do
        for i = 0, 360, 2 do
            if not gui.Parent then return end
            ringContainer.Rotation = i
            task.wait(0.02)
        end
    end
end)

-- Circular progress helper
-- t = 0..1
local function setProgress(t)
    local angle = t * 360
    ringFill.ImageRectSize = Vector2.new(math.floor(100 * t), 100)
    percentText.Text = math.floor(t * 100) .. "%"
end

-- ============================================================
-- FETCHER
-- ============================================================
local function fetch(name)
    local url = BASE .. name
    local ok, result = pcall(function()
        return game:HttpGet(url)
    end)
    if not ok or not result or #result < 10 then
        warn("[Grondex Loader] Failed to fetch:", name)
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
task.wait(0.3)
local mainCode = fetch("main.lua")

status.Text = "Fetching ui.lua..."
setProgress(0.66)
task.wait(0.3)
local uiCode = fetch("ui.lua")

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

if mainCode then
    local ok, err = pcall(function()
        loadstring(mainCode)()
    end)
    if not ok then warn("[Grondex Loader] main.lua error:", err) end
end

if uiCode then
    local ok, err = pcall(function()
        loadstring(uiCode)()
    end)
    if not ok then warn("[Grondex Loader] ui.lua error:", err) end
end

print("[Grondex Loader] done — v" .. VERSION)