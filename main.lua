--[[
    ========================================================================
    CREATOR: [Ваше Имя / Название проекта]
    PROJECT: Classic Retro Craftwars - Ultimate Farm Edition (v5.0)
    ========================================================================
]]

-- Проверка повторного запуска (чтобы скрипт не запускался дважды и не лагал)
if _G.CraftwarsUltimateLoaded then
    warn("[System]: Скрипт уже запущен на этом сервере!")
    return
end
_G.CraftwarsUltimateLoaded = true

-- [СЕРВИСЫ ROBLOX]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")

-- [ПЕРЕМЕННЫЕ ИГРОКА]
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- [КОНФИГУРАЦИЯ И НАСТРОЙКИ]
local Config = {
    TargetPosition = Vector3.new(0.1986846923828125, 6.0255889892578125 - 5, -0.2799992561340332),
    SpinSpeed = 25,
    MineFolders = {"Mine", "Mine2", "Mine3"},
    WeaponHoldTime = 5,   -- Время удержания оружия (сек)
    PickaxeHoldTime = 2,  -- Время удержания кирки (сек)
    LoopDelay = 0.1       -- Задержка основного цикла обработки (сек)
}

-- [СОСТОЯНИЕ СИСТЕМЫ]
local State = {
    ForcePickaxe = false,
    LastInventoryMode = nil,
    IsFlyingToButtons = false,
    OriginalCFrame = CFrame.new(Config.TargetPosition)
}

-- ========================================================================
-- МОДУЛЬ 1: АНТИ-АФК СИСТЕМА
-- ========================================================================
local function InitializeAntiAfk()
    pcall(function()
        LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(0, 0))
        end)
    end)
    print("[Module Loaded]: Anti-AFK protection is active.")
end

-- ========================================================================
-- МОДУЛЬ 2: СИСТЕМА ИНВЕНТАРЯ И СМЕНЫ ПРЕДМЕТОВ
-- ========================================================================
local function ManageInventory()
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local character = LocalPlayer.Character
    if not backpack or not character then return end

    if State.ForcePickaxe and State.LastInventoryMode ~= "pickaxe" then
        local pickaxe = backpack:FindFirstChild("Ultimate Pickaxe")
        if pickaxe then
            State.LastInventoryMode = "pickaxe"
            pickaxe.Parent = character
        end
    elseif not State.ForcePickaxe and State.LastInventoryMode ~= "weapon" then
        local currentTool = character:FindFirstChildOfClass("Tool")
        if not currentTool or currentTool.Name == "Ultimate Pickaxe" then
            for _, item in ipairs(backpack:GetChildren()) do
                if item:IsA("Tool") and item.Name ~= "Ultimate Pickaxe" then
                    State.LastInventoryMode = "weapon"
                    if currentTool then currentTool.Parent = backpack end
                    item.Parent = character
                    break
                end
            end
        end
    end
end

-- ========================================================================
-- МОДУЛЬ 3: МАГНИТ ДЛЯ РУДЫ И МОБОВ
-- ========================================================================
local function TeleportMapResources()
    if State.IsFlyingToButtons then return end
    
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local rootPart = character.HumanoidRootPart

    -- Магнит руды из папок Mine, Mine2, Mine3
    for _, mineName in ipairs(Config.MineFolders) do
        local mineFolder = Workspace:FindFirstChild(mineName)
        if mineFolder then
            for _, child in ipairs(mineFolder:GetDescendants()) do
                if child:IsA("Model") and (child:FindFirstChild("Ore") or child:FindFirstChild("Block")) then
                    local orePart = child:FindFirstChildOfClass("Part") or child:FindFirstChildOfClass("MeshPart") or child:FindFirstChild("Ore")
                    if orePart then
                        pcall(function()
                            orePart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                            orePart.CFrame = rootPart.CFrame * CFrame.new(0, -3, 0)
                        end)
                    end
                end
            end
        end
    end

    -- Телепорт всех живых мобов перед лицо игрока
    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj:IsA("Model") and obj ~= character and obj:FindFirstChildOfClass("Humanoid") then
            local mobRoot = obj:FindFirstChild("HumanoidRootPart")
            local mobHumanoid = obj:FindFirstChildOfClass("Humanoid")
            
            if mobRoot and mobHumanoid and mobHumanoid.Health > 0 then
                pcall(function()
                    mobRoot.CFrame = rootPart.CFrame * CFrame.new(0, 0, -4)
                end)
            end
        end
    end
end

-- ========================================================================
-- МОДУЛЬ 4: УЛЬТИМАТИВНАЯ АКТИВАЦИЯ КНОПОК И ПРЕДМЕТОВ
-- ========================================================================
local function ActivateTriggers()
    local character = LocalPlayer.Character
    if not character then return end

    -- Авто-удар / Активация зажатого в руках предмета
    local tool = character:FindFirstChildOfClass("Tool")
    if tool then
        pcall(function() tool:Activate() end)
    end

    -- Прямой вызов всех ProximityPrompt на карте
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            pcall(function()
                if fireproximityprompt then
                    fireproximityprompt(obj)
                else
                    obj:DoNow()
                end
            end)
        end
    end
end

-- ========================================================================
-- МОДУЛЬ 5: СТАБИЛЬНЫЙ ЦИКЛИЧЕСКИЙ ОБЛЕТ КНОПОК "Е" (Раз в минуту)
-- ========================================================================
local function ExecuteScheduledFly()
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local rootPart = character.HumanoidRootPart

    local prompts = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            table.insert(prompts, obj)
        end
    end

    if #prompts == 0 then return end

    State.IsFlyingToButtons = true
    
    for _, prompt in ipairs(prompts) do
        if prompt and prompt.Parent then
            pcall(function()
                local parentPart = prompt.Parent:IsA("BasePart") and prompt.Parent or prompt.Parent:FindFirstChildOfClass("BasePart")
                if parentPart then
                    rootPart.CFrame = parentPart.CFrame * CFrame.new(0, 2, 0)
                    task.wait(0.15)
                    if fireproximityprompt then fireproximityprompt(prompt) end
                    task.wait(0.15)
                end
            end)
        end
    end

    rootPart.CFrame = State.OriginalCFrame
    State.IsFlyingToButtons = false
end

-- ========================================================================
-- ЗАПУСК ВСЕХ ИГРОВЫХ ПОТОКОВ (КОРНЕВАЯ ЛОГИКА)
-- ========================================================================

-- Фиксация позиции персонажа и вращение (Каждый кадр)
RunService.Heartbeat:Connect(function()
    if not State.IsFlyingToButtons then
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = State.OriginalCFrame * CFrame.Angles(0, math.rad(tick() * Config.SpinSpeed * 100) % 360, 0)
        end
    end
    ManageInventory()
end)

-- Фиксация камеры в центре хитбокса
RunService.RenderStepped:Connect(function()
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        Camera.CameraSubject = character.HumanoidRootPart
    end
end)

-- Поток циклического таймера смены инвентаря (5 сек / 2 сек)
task.spawn(function()
    while true do
        task.wait(Config.WeaponHoldTime)
        if not State.IsFlyingToButtons then State.ForcePickaxe = true end
        task.wait(Config.PickaxeHoldTime)
        State.ForcePickaxe = false
    end
end)

-- Фоновый высокоскоростной поток обработки ресурсов и активаций
task.spawn(function()
    InitializeAntiAfk()
    while true do
        TeleportMapResources()
        ActivateTriggers()
        task.wait(Config.LoopDelay)
    end
end)

-- Ежеминутный таймер для облета кнопок взаимодействия
task.spawn(function()
    while true do
        task.wait(60)
        teleportAndClickAllButtons()
    end
end)

print([[
    ========================================================================
    [SUCCESS]: МАСШТАБНЫЙ СКРИПТ CRAFTWARS УСПЕШНО ИНИЦИАЛИЗИРОВАН!
    ========================================================================
]])
