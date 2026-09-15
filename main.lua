--[[
    ============================================================
    Grondex Hub — Main Logic
    ============================================================
    Author: Noxis-spec
    GitHub: https://github.com/Noxis-spec/project-lazarus-script
    Version: 1.2.0

    WHAT THIS FILE DOES:
      Reads flags from _G.LazarusFlags (set by ui.lua) and
      enables/disables cheat features accordingly.

    FLAGS READ FROM _G.LazarusFlags:
      InstantKill, InfAmmo, NoRecoil, FOVEnabled, FOVValue,
      ZombieESP, BoxESP, PaPESP, Noclip, Speed, RainbowGun

    This file is loaded by loader.lua. Do not run it directly.
    ============================================================
--]]

if not game:IsLoaded() then game.Loaded:Wait() end

local Players    = game:GetService("Players")
local Workspace  = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local player     = Players.LocalPlayer

local ONE_SHOT_DMG = 999999
local MAX_AMMO     = 999

local ZOMBIE_ESP_COLOR = Color3.fromRGB(255, 0, 0)
local BOX_ESP_COLOR    = Color3.fromRGB(255, 255, 255)
local PAP_ESP_COLOR    = Color3.fromRGB(100, 150, 255)

local ESP_REFRESH  = 1
local AMMO_REFRESH = 0.2

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

local hookedAmmo = {}

local mt = getrawmetatable and getrawmetatable(game)
if mt then
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "FireServer" and self.Name == "Damage" and Flags.InstantKill then
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

local function hookAmmoValue(v)
    if not v or hookedAmmo[v] then return end
    if not (v:IsA("IntValue") or v:IsA("NumberValue")) then return end
    local n = v.Name:lower()
    if n:find("ammo") or n:find("mag") or n:find("clip") then
        v.Value = MAX_AMMO
        hookedAmmo[v] = v.Changed:Connect(function()
            if Flags.InfAmmo and v.Parent and v.Value < MAX_AMMO then
                v.Value = MAX_AMMO
            end
        end)
    end
end

local function killReloadVars(tool)
    if not Flags.InfAmmo then return end
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
    if not char or not Flags.InfAmmo then return end
    for _, d in ipairs(char:GetDescendants()) do
        hookAmmoValue(d)
    end
    local tool = char:FindFirstChildOfClass("Tool")
    if tool then killReloadVars(tool) end
end

local hasGetreg = getreg ~= nil
local function scanReg()
    if not hasGetreg or not Flags.InfAmmo then return end
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
    if not Flags.InfAmmo then return end
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

task.spawn(function()
    while task.wait(AMMO_REFRESH) do
        if not Flags.InfAmmo then continue end
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

task.spawn(function()
    while task.wait(0.5) do scanReg() end
end)

task.spawn(function()
    while task.wait(1) do
        local char = player.Character
        if char then scanChar(char) end
        scanWorkspace()
    end
end)

local originalFOV = Workspace.CurrentCamera.FieldOfView

RunService.RenderStepped:Connect(function()
    local cam = Workspace.CurrentCamera
    if not cam then return end
    if Flags.FOVEnabled then
        pcall(function() cam.FieldOfView = Flags.FOVValue end)
    else
        pcall(function() cam.FieldOfView = originalFOV end)
    end
end)

RunService.RenderStepped:Connect(function()
    local char = player.Character
    if not char then return end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        if Flags.Speed and hum.WalkSpeed ~= 60 then
            hum.WalkSpeed = 60
        elseif not Flags.Speed and hum.WalkSpeed ~= 16 then
            hum.WalkSpeed = 16
        end
    end

    if Flags.Noclip then
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
end)

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
        if Flags.ZombieESP then
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
        else
            for model, hl in pairs(zombieCache) do
                pcall(function() hl:Destroy() end)
                zombieCache[model] = nil
            end
        end
    end
end)

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
        if not Flags.BoxESP then
            if boxHighlight then boxHighlight:Destroy(); boxHighlight = nil end
            continue
        end
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
            if boxHighlight then boxHighlight.Enabled = false end
        end
    end
end)

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
        if not Flags.PaPESP then
            if papHighlight then papHighlight:Destroy(); papHighlight = nil end
            continue
        end
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
            if papHighlight then papHighlight.Enabled = false end
        end
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if Flags.RainbowGun then
            local char = player.Character
            if char then
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then
                    local hue = tick() % 5 / 5
                    local color = Color3.fromHSV(hue, 1, 1)
                    pcall(function()
                        for _, d in ipairs(tool:GetDescendants()) do
                            if d:IsA("BasePart") then
                                d.Color = color
                            end
                        end
                    end)
                end
            end
        end
    end
end)

if hookmetamethod and checkcaller then
    local old
    old = hookmetamethod(game, "__newindex", newcclosure(function(self, key, value)
        if not checkcaller() and key == "CFrame" and self == workspace.CurrentCamera and Flags.NoRecoil then
            local cur = workspace.CurrentCamera.CFrame
            local diff = (value.Position - cur.Position).Magnitude
            if diff < 0.01 then
                return
            end
        end
        return old(self, key, value)
    end))
end

print("[Grondex Hub] main loaded")