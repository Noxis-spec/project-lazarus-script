--[[
    ============================================================
    Project Lazarus: ZOMBIES — All-in-One Script
    ============================================================
    Author: Noxis-spec
    GitHub: https://github.com/Noxis-spec/project-lazarus-script

    FUNCTIONS:
      - Instant Kill       — zombies die from a single bullet
      - Infinite Ammo      — magazine is always full
      - No Reload          — reload animation never triggers
      - No Recoil          — camera stays stable while shooting
      - Zombie ESP         — red outline around zombies (through walls)
      - Mystery Box ESP    — white outline around the Mystery Box
      - Pack-a-Punch ESP   — blue outline around the Pack-a-Punch

    USAGE:
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Noxis-spec/project-lazarus-script/main/main.lua"))()

    TESTED ON:
      Arceus X Neo, Delta, Xeno
      Requires: hookmetamethod, getrawmetatable, getreg

    WARNING:
      Using this script violates Roblox Terms of Service.
      Use only on alternate accounts. Author is not responsible
      for any bans or consequences.

    ============================================================
    SETTINGS — change these values if you want
    ============================================================
--]]

-- Damage dealt to zombies when Instant Kill is active.
-- Increase if zombies somehow survive (very rare).
local ONE_SHOT_DMG = 999999

-- Maximum ammo value written into the magazine.
-- Lower it (e.g. 100) if the game starts rejecting the value.
local MAX_AMMO = 999

-- ESP colors (RGB). Change if you want different outlines.
local ZOMBIE_ESP_COLOR = Color3.fromRGB(255, 0, 0)     -- red
local BOX_ESP_COLOR    = Color3.fromRGB(255, 255, 255) -- white
local PAP_ESP_COLOR    = Color3.fromRGB(100, 150, 255) -- blue

-- ESP refresh interval (seconds). Lower = more responsive, higher = less lag.
local ESP_REFRESH = 1

-- Ammo check interval (seconds). Lower = safer against reload, higher = less CPU.
local AMMO_REFRESH = 0.2

-- ============================================================
-- DO NOT EDIT BELOW UNLESS YOU KNOW WHAT YOU ARE DOING
-- ============================================================

if not game:IsLoaded() then game.Loaded:Wait() end

local Players    = game:GetService("Players")
local Workspace  = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local player     = Players.LocalPlayer

local hookedAmmo = {}

-- ============================================================
-- INSTANT KILL
-- Hooks the "Damage" remote and rewrites the damage value
-- before it is sent to the server.
-- ============================================================
local mt = getrawmetatable and getrawmetatable(game)
if mt then
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "FireServer" and self.Name == "Damage" then
            local args = {...}
            if type(args[1]) == "table" and args[1]["Damage"] ~= nil then
                args[1]["Damage"] = ONE_SHOT_DMG
                return oldNamecall(self, unpack(args))
            end
        end
        return oldNamecall(self, ...)
    end)
    setreadonly(mt, true)
end

-- ============================================================
-- INFINITE AMMO + NO RELOAD
-- Three methods work together:
--   1. Hooks NumberValue/IntValue with "ammo"/"mag"/"clip" names
--      and keeps them at MAX_AMMO.
--   2. Scans the Lua registry for ammo tables.
--   3. Scans Workspace as a fallback.
-- ============================================================
local function hookAmmoValue(v)
    if not v or hookedAmmo[v] then return end
    if not (v:IsA("IntValue") or v:IsA("NumberValue")) then return end
    local n = v.Name:lower()
    if n:find("ammo") or n:find("mag") or n:find("clip") then
        v.Value = MAX_AMMO
        hookedAmmo[v] = v.Changed:Connect(function()
            if v.Parent and v.Value < MAX_AMMO then
                v.Value = MAX_AMMO
            end
        end)
    end
end

-- Resets any "reload" flags found inside the weapon.
local function killReloadVars(tool)
    if not tool or not tool:IsA("Tool") then return end
    pcall(function()
        for _, v in ipairs(tool:GetDescendants()) do
            if v:IsA("BoolValue") then
                local n = v.Name:lower()
                if n:find("reload") or n:find("reloading") then
                    v.Value = false
                end
            end
            if (v:IsA("NumberValue") or v:IsA("IntValue")) then
                local n = v.Name:lower()
                if n:find("reload") and not n:find("time") then
                    v.Value = 0
                end
            end
        end
    end)
end

local function scanChar(char)
    if not char then return end
    for _, d in ipairs(char:GetDescendants()) do
        hookAmmoValue(d)
    end
    local tool = char:FindFirstChildOfClass("Tool")
    if tool then killReloadVars(tool) end
end

local hasGetreg = getreg ~= nil
local function scanReg()
    if not hasGetreg then return end
    pcall(function()
        for _, v in next, getreg() do
            if type(v) == "table" then
                pcall(function()
                    if rawget(v, "Ammo") ~= nil then rawset(v, "Ammo", MAX_AMMO) end
                    if rawget(v, "CurrentAmmo") ~= nil then rawset(v, "CurrentAmmo", MAX_AMMO) end
                    if rawget(v, "MagAmmo") ~= nil then rawset(v, "MagAmmo", MAX_AMMO) end
                    if rawget(v, "Clip") ~= nil then rawset(v, "Clip", MAX_AMMO) end
                end)
            end
        end
    end)
end

local function scanWorkspace()
    pcall(function()
        for _, v in ipairs(Workspace:GetDescendants()) do
            if (v:IsA("IntValue") or v:IsA("NumberValue")) then
                local n = v.Name:lower()
                if n:find("ammo") or n:find("mag") or n:find("clip") then
                    v.Value = MAX_AMMO
                end
            end
        end
    end)
end

-- Re-scan on respawn
player.CharacterAdded:Connect(function(char)
    for v, conn in pairs(hookedAmmo) do
        pcall(function() conn:Disconnect() end)
        hookedAmmo[v] = nil
    end
    task.wait(0.5)
    scanChar(char)
    char.ChildAdded:Connect(function(c)
        if c:IsA("Tool") then
            task.wait(0.3)
            scanChar(char)
        end
    end)
end)

if player.Character then
    scanChar(player.Character)
    player.Character.ChildAdded:Connect(function(c)
        if c:IsA("Tool") then
            task.wait(0.3)
            scanChar(player.Character)
        end
    end)
end

-- Fast loop for the currently held weapon
task.spawn(function()
    while task.wait(AMMO_REFRESH) do
        local char = player.Character
        if char then
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then
                for _, d in ipairs(tool:GetDescendants()) do
                    hookAmmoValue(d)
                end
                killReloadVars(tool)
            end
        end
    end
end)

-- Registry scan
task.spawn(function()
    while task.wait(0.5) do scanReg() end
end)

-- Slow fallback scan
task.spawn(function()
    while task.wait(1) do
        local char = player.Character
        if char then scanChar(char) end
        scanWorkspace()
    end
end)

-- ============================================================
-- ZOMBIE ESP
-- Red outline around every model inside Workspace.Baddies.
-- Skips player characters.
-- ============================================================
local zombieCache = {}

local function applyZombieESP(model)
    if zombieCache[model] then return end
    if not model:IsA("Model") then return end
    if Players:GetPlayerFromCharacter(model) then return end
    if not model:FindFirstChildOfClass("Humanoid") then return end

    local hl = Instance.new("Highlight")
    hl.FillColor = ZOMBIE_ESP_COLOR
    hl.OutlineColor = ZOMBIE_ESP_COLOR
    hl.FillTransparency = 1
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Adornee = model
    hl.Parent = game:GetService("CoreGui")
    zombieCache[model] = hl
end

task.spawn(function()
    while task.wait(ESP_REFRESH) do
        pcall(function()
            local baddies = Workspace:FindFirstChild("Baddies")
            if baddies then
                for _, m in ipairs(baddies:GetChildren()) do
                    if m:IsA("Model") then applyZombieESP(m) end
                end
            end
        end)
        for model, hl in pairs(zombieCache) do
            if not model.Parent or not hl.Parent then
                pcall(function() hl:Destroy() end)
                zombieCache[model] = nil
            end
        end
    end
end)

-- ============================================================
-- MYSTERY BOX ESP
-- White outline around the Mystery Box model.
-- ============================================================
local boxHighlight = nil

local function findActiveBox()
    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("Model") and v.Name == "MysteryBox" then
            return v
        end
    end
    return nil
end

task.spawn(function()
    while task.wait(0.5) do
        local box = findActiveBox()
        if box then
            if not boxHighlight or boxHighlight.Adornee ~= box then
                if boxHighlight then boxHighlight:Destroy() end
                boxHighlight = Instance.new("Highlight")
                boxHighlight.FillColor = BOX_ESP_COLOR
                boxHighlight.OutlineColor = BOX_ESP_COLOR
                boxHighlight.FillTransparency = 1
                boxHighlight.OutlineTransparency = 0
                boxHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                boxHighlight.Adornee = box
                boxHighlight.Parent = game:GetService("CoreGui")
            end
            boxHighlight.Enabled = true
        else
            if boxHighlight then
                boxHighlight.Enabled = false
            end
        end
    end
end)

-- ============================================================
-- PACK-A-PUNCH ESP
-- Blue outline around the Pack-a-Punch machine.
-- ============================================================
local papHighlight = nil

local function findActivePaP()
    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("Model") then
            local n = v.Name:lower()
            if n:find("packapunch") or n:find("pack-a-punch") or n:find("pack_a_punch") or n == "pap" then
                return v
            end
        end
    end
    return nil
end

task.spawn(function()
    while task.wait(ESP_REFRESH) do
        local pap = findActivePaP()
        if pap then
            if not papHighlight or papHighlight.Adornee ~= pap then
                if papHighlight then papHighlight:Destroy() end
                papHighlight = Instance.new("Highlight")
                papHighlight.FillColor = PAP_ESP_COLOR
                papHighlight.OutlineColor = PAP_ESP_COLOR
                papHighlight.FillTransparency = 1
                papHighlight.OutlineTransparency = 0
                papHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                papHighlight.Adornee = pap
                papHighlight.Parent = game:GetService("CoreGui")
            end
            papHighlight.Enabled = true
        else
            if papHighlight then
                papHighlight.Enabled = false
            end
        end
    end
end)

-- ============================================================
-- NO RECOIL
-- Blocks camera CFrame updates that are smaller than 0.01 studs
-- (that is the recoil kick). Player mouse movement is untouched.
-- ============================================================
if hookmetamethod and checkcaller then
    local old
    old = hookmetamethod(game, "__newindex", newcclosure(function(self, key, value)
        if not checkcaller() and key == "CFrame" and self == workspace.CurrentCamera then
            local cur = workspace.CurrentCamera.CFrame
            local diff = (value.Position - cur.Position).Magnitude
            if diff < 0.01 then
                return
            end
        end
        return old(self, key, value)
    end))
end

print("[Lazarus All-in-One] loaded")