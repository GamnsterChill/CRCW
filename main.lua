-- [[ PROJECT: Classic Retro Craftwars - Elite Customizable Hub (v15.5) ]]
-- [[ ЧАСТЬ 1 ИЗ 3: Создание GUI и расширенная конфигурация ]]

if _G.CraftwarsEliteLoaded then
    local oldGui = game:GetService("CoreGui"):FindFirstChild("CraftwarsEliteGui") or game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("CraftwarsEliteGui")
    if oldGui then oldGui:Destroy() end
end
_G.CraftwarsEliteLoaded = true

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Расширенная конфигурация: теперь ВСЕ скрытые функции имеют настройки в меню
_G.CheatConfig = {
    TargetX = 0.1986846923828125,
    TargetY = 1.0255889892578125, 
    TargetZ = -0.2799992561340332,
    SpinSpeed = 25,
    
    GreataxeTime = 14,       
    HeartbanisherTime = 1.5, 
    PickaxeTime = 5,        
    
    MainFallbackTool = "Greataxe of Love",
    
    AntiAfkDelay = 60,
    TriggerDelay = 0.01,    
    ClickDelay = 0.01,      
    MineFolders = {"Mine", "Mine2", "Mine3"},
    ScheduledFlyInterval = 60, 
    
    -- Старые тумблеры
    MainFarmActive = true,
    SpinActive = true,
    MagnetOres = true,
    MagnetMobs = true,
    AutoClickTools = true,
    AutoClickPrompts = true,
    AntiAfkActive = true,
    AntiSitActive = true,
    SpamKeysActive = true,   
    ScreenClickActive = true,
    
    -- НОВЫЕ ТУМБЛЕРЫ (То, чего раньше не было в GUI)
    AutoRotationActive = true,       -- Включение/выключение авто-ротации оружия
    AutoAbilitiesActive = true,      -- Автоматическое прожимание всех скиллов
    ScheduledFlyActive = true,       -- Периодический полет по кнопкам на карте
    ForceCameraActive = true,        -- Принудительный фокус камеры на персонаже
    UseRemoteAbilities = true,       -- Способности: Прямой вызов сетевых RemoteEvent
    UseVirtualClickAbilities = true, -- Способности: Виртуальный клик по кнопкам GUI
    UseKeyPressAbilities = true      -- Способности: Эмуляция клавиш клавиатуры (Z, X, C, V, F)
}

_G.FarmState = {
    CurrentPhaseIndex = 1,
    LastMode = nil,
    IsFlyingToButtons = false
}

_G.CustomRotationSequence = {
    {Name = "Greataxe of Love", DurationKey = "GreataxeTime"},
    {Name = "Heartbanisher", DurationKey = "HeartbanisherTime"},
    {Name = "Ultimate Pickaxe", DurationKey = "PickaxeTime"}
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CraftwarsEliteGui"
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = player:WaitForChild("PlayerGui") end

local ToggleMenuBtn = Instance.new("TextButton")
ToggleMenuBtn.Size = UDim2.new(0, 150, 0, 30)
ToggleMenuBtn.Position = UDim2.new(0.5, -75, 0, 5) 
ToggleMenuBtn.Text = "❌ Скрыть Меню"
ToggleMenuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleMenuBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ToggleMenuBtn.Font = Enum.Font.SourceSansBold
ToggleMenuBtn.TextSize = 13
ToggleMenuBtn.Parent = ScreenGui

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 5)
BtnCorner.Parent = ToggleMenuBtn

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 440, 0, 400)
MainFrame.Position = UDim2.new(0.5, -220, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local Header = Instance.new("TextLabel")
Header.Size = UDim2.new(1, 0, 0, 35)
Header.Text = "⚙️ CRAFTWARS ELITE HUB v15.5 [COMPACT]"
Header.TextColor3 = Color3.fromRGB(255, 255, 255)
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Header.Font = Enum.Font.SourceSansBold
Header.TextSize = 14
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 10)
HeaderCorner.Parent = Header

ToggleMenuBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    if MainFrame.Visible then
        ToggleMenuBtn.Text = "❌ Скрыть Меню"
        ToggleMenuBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    else
        ToggleMenuBtn.Text = "👑 Открыть Меню"
        ToggleMenuBtn.BackgroundColor3 = Color3.fromRGB(35, 155, 85)
    end
end)

local ScrollPage = Instance.new("ScrollingFrame")
ScrollPage.Size = UDim2.new(1, -15, 1, -45)
ScrollPage.Position = UDim2.new(0, 8, 0, 40)
ScrollPage.BackgroundTransparency = 1
ScrollPage.CanvasSize = UDim2.new(0, 0, 0, 1250) -- Место под все новые переключатели
ScrollPage.ScrollBarThickness = 5
ScrollPage.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.Parent = ScrollPage

local function CreateToggle(text, configKey)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 32)
    Frame.BackgroundTransparency = 1
    Frame.Parent = ScrollPage

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.72, 0, 1, 0)
    Label.Text = "  " .. text
    Label.TextColor3 = Color3.fromRGB(215, 215, 215)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.SourceSans
    Label.TextSize = 14
    Label.BackgroundTransparency = 1
    Label.Parent = Frame

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.22, 0, 0.85, 0)
    Button.Position = UDim2.new(0.75, 0, 0.075, 0)
    Button.Font = Enum.Font.SourceSansBold
    Button.TextSize = 12
    Button.Parent = Frame
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 5)
    Corner.Parent = Button

    local function updateBtn()
        if _G.CheatConfig[configKey] then
            Button.Text = "ВКЛ"
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.BackgroundColor3 = Color3.fromRGB(39, 174, 96)
        else
            Button.Text = "ВЫКЛ"
            Button.TextColor3 = Color3.fromRGB(170, 170, 170)
            Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        end
    end

    Button.MouseButton1Click:Connect(function()
        _G.CheatConfig[configKey] = not _G.CheatConfig[configKey]
        updateBtn()
    end)
    updateBtn()
end

local function CreateInput(text, configKey, isNumber)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 32)
    Frame.BackgroundTransparency = 1
    Frame.Parent = ScrollPage

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.62, 0, 1, 0)
    Label.Text = "  " .. text
    Label.TextColor3 = Color3.fromRGB(215, 215, 215)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.SourceSans
    Label.TextSize = 14
    Label.BackgroundTransparency = 1
    Label.Parent = Frame

    local Box = Instance.new("TextBox")
    Box.Size = UDim2.new(0.32, 0, 0.85, 0)
    Box.Position = UDim2.new(0.65, 0, 0.075, 0)
    Box.Text = tostring(_G.CheatConfig[configKey])
    Box.TextColor3 = Color3.fromRGB(255, 255, 255)
    Box.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Box.Font = Enum.Font.SourceSans
    Box.TextSize = 12
    Box.Parent = Frame
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 5)
    Corner.Parent = Box

    Box.FocusLost:Connect(function()
        if isNumber then
            local val = tonumber(Box.Text)
            if val then _G.CheatConfig[configKey] = val else Box.Text = tostring(_G.CheatConfig[configKey]) end
        else
            _G.CheatConfig[configKey] = Box.Text
        end
    end)
end

-- Рендеринг элементов управления в GUI
CreateToggle("ГЛАВНЫЙ ФАРМ (Телепорт в точку)", "MainFarmActive")
CreateToggle("Вращение персонажа (Крутилка)", "SpinActive")
CreateToggle("Магнит Ископаемых (Шахта)", "MagnetOres")
CreateToggle("Магнит всех Монстров к лицу", "MagnetMobs")
CreateToggle("Прямой автоудар предметами в руке", "AutoClickTools")
CreateToggle("Прямой сбор всплывающих кнопок (E)", "AutoClickPrompts")
CreateToggle("Автоматически ВСТАВАТЬ со стульев", "AntiSitActive")
CreateToggle("Высокоскоростной спам букв", "SpamKeysActive")
CreateToggle("Автоматический клик по экрану", "ScreenClickActive")
CreateToggle("Анти-АФК защита", "AntiAfkActive")

-- Новые добавленные тумблеры:
CreateToggle("Авто-смена инвентаря (Ротация)", "AutoRotationActive")
CreateToggle("Авто-Активация Способностей", "AutoAbilitiesActive")
CreateToggle("Периодический облет кнопок на карте", "ScheduledFlyActive")
CreateToggle("Принудительная фиксация камеры", "ForceCameraActive")
CreateToggle("  -> Способности: Вызов через Remote", "UseRemoteAbilities")
CreateToggle("  -> Способности: Клики по кнопкам GUI", "UseVirtualClickAbilities")
CreateToggle("  -> Способности: Эмуляция клавиш", "UseKeyPressAbilities")

CreateInput("Координата Телепорта X", "TargetX", true)
CreateInput("Координата Телепорта Y", "TargetY", true)
CreateInput("Координата Телепорта Z", "TargetZ", true)
CreateInput("Запасное оружие (Fallback)", "MainFallbackTool", false)
CreateInput("Время удержания Greataxe (сек)", "GreataxeTime", true)
CreateInput("Время удержания Heartbanisher (сек)", "HeartbanisherTime", true)
CreateInput("Время удержания Кирки (сек)", "PickaxeTime", true)
CreateInput("Задержка автокликов экрана (сек)", "ClickDelay", true)
CreateInput("Задержка магнита/триггеров (сек)", "TriggerDelay", true)
CreateInput("Скорость вращения персонажа", "SpinSpeed", true)
CreateInput("Интервал Анти-АФК кликов (сек)", "AntiAfkDelay", true)
CreateInput("Интервал облета кнопок (сек)", "ScheduledFlyInterval", true)
print("[Elite Hub]: Часть 1 успешно загружена!")
-- [[ PROJECT: Classic Retro Craftwars - Elite Customizable Hub (v15.5) ]]
-- [[ ЧАСТЬ 2 ИЗ 3: Потоки ввода, Сбор способностей и Защита ]]

local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local inputKeys = {Enum.KeyCode.E, Enum.KeyCode.Q, Enum.KeyCode.R, Enum.KeyCode.Z, Enum.KeyCode.X, Enum.KeyCode.C, Enum.KeyCode.F}
local abilityKeys = {"Z", "X", "C", "V", "F", "E", "Q"}

-- Высокоскоростной спам кнопок и клики по экрану
task.spawn(function()
    while true do
        if _G.CheatConfig.MainFarmActive and not _G.FarmState.IsFlyingToButtons then
            if _G.CheatConfig.SpamKeysActive then
                for _, key in ipairs(inputKeys) do
                    pcall(function()
                        VirtualUser:SetKeyDown(key)
                        RunService.Heartbeat:Wait()
                        VirtualUser:SetKeyUp(key)
                    end)
                end
            end
            if _G.CheatConfig.ScreenClickActive then
                pcall(function()
                    VirtualUser:Button1Down(Vector2.new(100, 100))
                    RunService.Heartbeat:Wait()
                    VirtualUser:Button1Up(Vector2.new(100, 100))
                end)
            end
        end
        task.wait(_G.CheatConfig.ClickDelay) 
    end
end)

-- Анти-АФК Защита
task.spawn(function()
    while true do
        if _G.CheatConfig.AntiAfkActive then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new(0,0))
            end)
        end
        task.wait(_G.CheatConfig.AntiAfkDelay)
    end
end)

-- МНОГОПОТОЧНАЯ СИСТЕМА ПРОЖИМА СПОСОБНОСТЕЙ (3 Метода параллельно)
local function ClickScreenAbilityButtons()
    if not _G.CheatConfig.AutoAbilitiesActive then return end
    
    local playerGui = player:FindFirstChild("PlayerGui")
    if not playerGui then return end

    -- Метод 1 и 2: Сканирование интерфейса и удаленный вызов / симуляция клика
    for _, guiObj in ipairs(playerGui:GetDescendants()) do
        if guiObj:IsA("TextButton") or guiObj:IsA("ImageButton") then
            local nameLower = string.lower(guiObj.Name)
            local textLower = guiObj:IsA("TextButton") and string.lower(guiObj.Text) or ""
            
            -- Проверяем ключевые слова скиллов
            if string.find(nameLower, "heart") or string.find(nameLower, "bleed") or 
               string.find(nameLower, "skill") or string.find(nameLower, "ability") or 
               string.find(textLower, "heart") or string.find(nameLower, "spell") or
               nameLower == "x" or nameLower == "z" or nameLower == "c" then
                
                -- Метод 1: Виртуальный клик по GUI элементу
                if _G.CheatConfig.UseVirtualClickAbilities then
                    pcall(function() guiObj:Activate() end)
                end
                
                -- Метод 2: Принудительный сетевой вызов привязанных RemoteEvent/BindableEvent
                if _G.CheatConfig.UseRemoteAbilities then
                    pcall(function()
                        local events = guiObj:FindFirstChildOfClass("RemoteEvent") or guiObj:FindFirstChildOfClass("BindableEvent")
                        if events then events:FireServer() end
                    end)
                end
            end
        end
    end
    
    -- Метод 3: Эмуляция физического нажатия клавиш клавиатуры (для биндов игры)
    if _G.CheatConfig.UseKeyPressAbilities then
        pcall(function()
            for _, keyStr in ipairs(abilityKeys) do
                VirtualUser:TypeKey(keyStr)
            end
        end)
    end
end

-- Отдельный быстрый поток для непрерывной отправки способностей
task.spawn(function()
    while true do
        if _G.CheatConfig.AutoAbilitiesActive then
            ClickScreenAbilityButtons()
        end
        task.wait(0.05) -- Высокая частота спама способностей
    end
end)

print("[Elite Hub]: Часть 2 успешно загружена!")
-- [[ PROJECT: Classic Retro Craftwars - Elite Customizable Hub (v15.5) ]]
-- [[ ЧАСТЬ 3 ИЗ 3: Магниты, Авто-ротация, Полет и Камера ]]

local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local ComprehensiveOresList = {
    "Iron", "Gold", "Diamond", "Bluesteel", "Amberstone", "Crystal", 
    "Viridis", "Vermite", "Ore Clump", "Ultimus", "Optimum", "Unobtanium", 
    "Dankite", "Dark Matter", "Destinium", "Dankinite", "Uranium", "Plutonium", 
    "Green Vermite", "Purple Vermite", "Regite", "Devumite", "Demonite", 
    "Enchanted Iron", "Salt", "Hellstone", "Rainbonite", "Rolite", "Pure Vermite",
    "Pure Amberstone", "Chaotrum", "Black Vermite", "Black Iron", "Azure", 
    "Uldragunn", "Onyx", "Serendibite", "Vantablack", "Voidite", "Uru", 
    "Tanzanite", "Originite", "Pitcholamadamantinite"
}

-- Управление быстрой сменой оружия (Ротация)
local function ExecuteInventoryManagement()
    if not _G.CheatConfig.AutoRotationActive then return end

    local backpack = player:FindFirstChild("Backpack")
    local character = player.Character
    if not backpack or not character then return end

    local currentTool = character:FindFirstChildOfClass("Tool")
    
    if not currentTool then
        local fallbackTool = backpack:FindFirstChild(_G.CheatConfig.MainFallbackTool)
        if fallbackTool then
            fallbackTool.Parent = character
            _G.FarmState.LastMode = _G.CheatConfig.MainFallbackTool
            return
        end
    end

    local currentPhaseData = _G.CustomRotationSequence[_G.FarmState.CurrentPhaseIndex]
    if not currentPhaseData then return end
    
    local targetToolName = currentPhaseData.Name

    if targetToolName and _G.FarmState.LastMode ~= targetToolName then
        if not currentTool or currentTool.Name ~= targetToolName then
            local targetTool = backpack:FindFirstChild(targetToolName)
            if targetTool then
                _G.FarmState.LastMode = targetToolName
                if currentTool then currentTool.Parent = backpack end 
                targetTool.Parent = character 
            end
        end
    end
end

-- Автоматический облет кнопок (ProximityPrompts) по таймеру
local function ExecuteScheduledFly()
    if not _G.CheatConfig.ScheduledFlyActive then return end
    
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local rootPart = character.HumanoidRootPart

    local prompts = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then table.insert(prompts, obj) end
    end

    if #prompts == 0 then return end
    _G.FarmState.IsFlyingToButtons = true
    
    for _, prompt in ipairs(prompts) do
        if not _G.CheatConfig.ScheduledFlyActive then break end
        if prompt and prompt.Parent then
            pcall(function()
                local parentPart = prompt.Parent:IsA("BasePart") and prompt.Parent or prompt.Parent:FindFirstChildOfClass("BasePart")
                if parentPart then
                    rootPart.CFrame = parentPart.CFrame * CFrame.new(0, 2, 0)
                    task.wait(0.2)
                    if fireproximityprompt then 
                        fireproximityprompt(prompt) 
                    else
                        prompt:InputHoldBegin()
                        task.wait(prompt.HoldDuration + 0.05)
                        prompt:InputHoldEnd()
                    end
                    task.wait(0.15)
                end
            end)
        end
    end
    _G.FarmState.IsFlyingToButtons = false
end

-- Обработка магнитов, монстров и триггеров мира
local function ProcessWorldTriggers()
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local rootPart = character.HumanoidRootPart

    -- Анти-стул
    if _G.CheatConfig.AntiSitActive then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.Sit then
            pcall(function()
                humanoid.Sit = false
                rootPart.CFrame = rootPart.CFrame * CFrame.new(0, 5, 0) 
            end)
        end
    end

    -- Автоудар
    if _G.CheatConfig.AutoClickTools then
        local tool = character:FindFirstChildOfClass("Tool")
        if tool then pcall(function() tool:Activate() end) end
    end

    -- Магнит руды
    if _G.CheatConfig.MagnetOres then
        for _, mineName in ipairs(_G.CheatConfig.MineFolders) do
            local mineFolder = Workspace:FindFirstChild(mineName)
            if mineFolder then
                for _, child in ipairs(mineFolder:GetDescendants()) do
                    if child:IsA("Model") then
                        local isTargetOre = false
                        for _, oreName in ipairs(ComprehensiveOresList) do
                            if string.find(string.lower(child.Name), string.lower(oreName)) then
                                isTargetOre = true
                                break
                            end
                        end
                        if child:FindFirstChild("Ore") or child:FindFirstChild("Block") or string.find(string.lower(child.Name), "ore") then
                            isTargetOre = true
                        end
                        if isTargetOre then
                            local orePart = child:FindFirstChildOfClass("Part") or child:FindFirstChildOfClass("MeshPart") or child:FindFirstChild("Ore") or child.PrimaryPart
                            if orePart then
                                pcall(function()
                                    orePart.CanCollide = true
                                    orePart.Anchored = true 
                                    orePart.Velocity = Vector3.new(0, 0, 0)
                                    orePart.RotVelocity = Vector3.new(0, 0, 0)
                                    orePart.CFrame = rootPart.CFrame * CFrame.new(0, 0, -2) 
                                end)
                            end
                        end
                    end
                end
            end
        end
    end

    -- Магнит монстров (Расчет по хитбоксу торса)
    if _G.CheatConfig.MagnetMobs then
        for _, obj in ipairs(Workspace:GetChildren()) do
            if obj:IsA("Model") and obj ~= character and obj:FindFirstChildOfClass("Humanoid") then
                local mobRoot = obj:FindFirstChild("HumanoidRootPart")
                local mobHumanoid = obj:FindFirstChildOfClass("Humanoid")
                if mobRoot and mobHumanoid and mobHumanoid.Health > 0 then
                    pcall(function()
                        local enemyTorsoSize = mobRoot.Size.Z
                        local calculatedDistance = (enemyTorsoSize / 2) + 2
                        mobRoot.CFrame = rootPart.CFrame * CFrame.new(0, 0, -calculatedDistance)
                    end)
                end
            end
        end
    end

    -- Сбор мгновенных кнопок
    if _G.CheatConfig.AutoClickPrompts and not _G.FarmState.IsFlyingToButtons then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                pcall(function()
                    if fireproximityprompt then fireproximityprompt(obj) else obj:DoNow() end
                end)
            end
        end
    end
end

-- Основной цикл рендеринга и удержания позиции
RunService.Heartbeat:Connect(function()
    if _G.CheatConfig.MainFarmActive and not _G.FarmState.IsFlyingToButtons then
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local currentCFrame = CFrame.new(_G.CheatConfig.TargetX, _G.CheatConfig.TargetY, _G.CheatConfig.TargetZ)
            if _G.CheatConfig.SpinActive then
                character.HumanoidRootPart.CFrame = currentCFrame * CFrame.Angles(0, math.rad(tick() * _G.CheatConfig.SpinSpeed * 100) % 360, 0)
            else
                character.HumanoidRootPart.CFrame = currentCFrame
            end
        end
    end
    ExecuteInventoryManagement()
end)

-- Фиксация игровой камеры
RunService.RenderStepped:Connect(function()
    if _G.CheatConfig.ForceCameraActive then
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            Workspace.CurrentCamera.CameraSubject = character.HumanoidRootPart
        end
    end
end)

-- Поток изменения фаз оружия
task.spawn(function()
    while true do
        if _G.CheatConfig.AutoRotationActive then
            local currentPhaseData = _G.CustomRotationSequence[_G.FarmState.CurrentPhaseIndex]
            if currentPhaseData then
                local delayTime = _G.CheatConfig[currentPhaseData.DurationKey] or 2
                task.wait(delayTime)
            else
                task.wait(2)
            end
            
            _G.FarmState.CurrentPhaseIndex = _G.FarmState.CurrentPhaseIndex + 1
            if _G.FarmState.CurrentPhaseIndex > #_G.CustomRotationSequence then
                _G.FarmState.CurrentPhaseIndex = 1
            end
        else
            task.wait(1)
        end
    end
end)

-- Поток триггеров
task.spawn(function()
    while true do
        ProcessWorldTriggers()
        task.wait(_G.CheatConfig.TriggerDelay)
    end
end)

-- Поток циклического полета по кнопкам
task.spawn(function()
    while true do
        task.wait(_G.CheatConfig.ScheduledFlyInterval)
        if _G.CheatConfig.ScheduledFlyActive then
            ExecuteScheduledFly()
        end
    end
end)

print("[Elite Hub v15.5]: Полная сборка успешно завершена и готова к работе!")
