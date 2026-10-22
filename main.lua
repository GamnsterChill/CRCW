-- [[ PROJECT: Classic Retro Craftwars - Elite Customizable Hub ]]
-- [[ ЧАСТЬ 1 ИЗ 4: Конфигурация и Таблицы ]]

if _G.CraftwarsEliteLoaded then
    local oldGui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("CraftwarsEliteGui")
    if oldGui then oldGui:Destroy() end
end
_G.CraftwarsEliteLoaded = true

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
    AutoRotationActive = true,       
    AutoAbilitiesActive = true,      
    ScheduledFlyActive = true,       
    ForceCameraActive = true,        
    UseRemoteAbilities = true,       
    UseVirtualClickAbilities = true, 
    UseKeyPressAbilities = true      
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
print("[Elite Hub]: Часть 1 успешно инициализирована!")
-- [[ PROJECT: Classic Retro Craftwars - Elite Customizable Hub ]]
-- [[ ЧАСТЬ 2 ИЗ 4: Отрисовка Меню ]]

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CraftwarsEliteGui"
-- Безопасно крепим к PlayerGui, чтобы обойти блокировки Delta
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local ToggleMenuBtn = Instance.new("TextButton")
ToggleMenuBtn.Size = UDim2.new(0, 140, 0, 28)
ToggleMenuBtn.Position = UDim2.new(0.5, -70, 0, 5) 
ToggleMenuBtn.Text = "❌ Скрыть Меню"
ToggleMenuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleMenuBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ToggleMenuBtn.Font = Enum.Font.SourceSansBold
ToggleMenuBtn.TextSize = 12
ToggleMenuBtn.Parent = ScreenGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 420, 0, 380)
MainFrame.Position = UDim2.new(0.5, -210, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Header = Instance.new("TextLabel")
Header.Size = UDim2.new(1, 0, 0, 32)
Header.Text = "⚙️ CRAFTWARS ELITE v15.5"
Header.TextColor3 = Color3.fromRGB(255, 255, 255)
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Header.Font = Enum.Font.SourceSansBold
Header.TextSize = 13
Header.Parent = MainFrame

ToggleMenuBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    ToggleMenuBtn.Text = MainFrame.Visible and "❌ Скрыть Меню" or "👑 Открыть Меню"
    ToggleMenuBtn.BackgroundColor3 = MainFrame.Visible and Color3.fromRGB(45, 45, 45) or Color3.fromRGB(35, 155, 85)
end)

local ScrollPage = Instance.new("ScrollingFrame")
ScrollPage.Size = UDim2.new(1, -12, 1, -40)
ScrollPage.Position = UDim2.new(0, 6, 0, 36)
ScrollPage.BackgroundTransparency = 1
ScrollPage.CanvasSize = UDim2.new(0, 0, 0, 1150)
ScrollPage.ScrollBarThickness = 4
ScrollPage.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.Parent = ScrollPage

local function CreateToggle(text, configKey)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 30)
    Frame.BackgroundTransparency = 1
    Frame.Parent = ScrollPage

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.75, 0, 1, 0)
    Label.Text = "  " .. text
    Label.TextColor3 = Color3.fromRGB(210, 210, 210)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.SourceSans
    Label.TextSize = 13
    Label.BackgroundTransparency = 1
    Label.Parent = Frame

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 70, 0, 24)
    Button.Position = UDim2.new(0.78, 0, 0.1, 0)
    Button.Font = Enum.Font.SourceSansBold
    Button.TextSize = 12
    Button.Parent = Frame

    local function updateBtn()
        Button.Text = _G.CheatConfig[configKey] and "ВКЛ" or "ВЫКЛ"
        Button.TextColor3 = _G.CheatConfig[configKey] and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 160)
        Button.BackgroundColor3 = _G.CheatConfig[configKey] and Color3.fromRGB(39, 174, 96) or Color3.fromRGB(60, 60, 60)
    end
    Button.MouseButton1Click:Connect(function() _G.CheatConfig[configKey] = not _G.CheatConfig[configKey] updateBtn() end)
    updateBtn()
end

local function CreateInput(text, configKey, isNumber)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 30)
    Frame.BackgroundTransparency = 1
    Frame.Parent = ScrollPage

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.65, 0, 1, 0)
    Label.Text = "  " .. text
    Label.TextColor3 = Color3.fromRGB(210, 210, 210)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.SourceSans
    Label.TextSize = 13
    Label.BackgroundTransparency = 1
    Label.Parent = Frame

    local Box = Instance.new("TextBox")
    Box.Size = UDim2.new(0, 100, 0, 24)
    Box.Position = UDim2.new(0.7, 0, 0.1, 0)
    Box.Text = tostring(_G.CheatConfig[configKey])
    Box.TextColor3 = Color3.fromRGB(255, 255, 255)
    Box.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Box.Font = Enum.Font.SourceSans
    Box.TextSize = 12
    Box.Parent = Frame

    Box.FocusLost:Connect(function()
        if isNumber then
            local val = tonumber(Box.Text)
            if val then _G.CheatConfig[configKey] = val else Box.Text = tostring(_G.CheatConfig[configKey]) end
        else
            _G.CheatConfig[configKey] = Box.Text
        end
    end)
end

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
print("[Elite Hub]: Часть 2 успешно загружена!")

-- [[ ЧАСТЬ 3 ИЗ 4: Автоклики и Сверх-прожим Способностей ]]

local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local player = game:GetService("Players").LocalPlayer

local inputKeys = {Enum.KeyCode.E, Enum.KeyCode.Q, Enum.KeyCode.R, Enum.KeyCode.Z, Enum.KeyCode.X, Enum.KeyCode.C, Enum.KeyCode.F}
local abilityKeys = {"Z", "X", "C", "V", "F", "E", "Q"}

task.spawn(function()
    while true do
        if _G.CheatConfig.MainFarmActive and not _G.FarmState.IsFlyingToButtons then
            if _G.CheatConfig.SpamKeysActive then
                for _, key in ipairs(inputKeys) do
                    pcall(function() VirtualUser:SetKeyDown(key) task.wait(0.01) VirtualUser:SetKeyUp(key) end)
                end
            end
            if _G.CheatConfig.ScreenClickActive then
                pcall(function() VirtualUser:Button1Down(Vector2.new(100, 100)) task.wait(0.01) VirtualUser:Button1Up(Vector2.new(100, 100)) end)
            end
        end
        task.wait(_G.CheatConfig.ClickDelay) 
    end
end)

task.spawn(function()
    while true do
        if _G.CheatConfig.AntiAfkActive then pcall(function() VirtualUser:CaptureController() VirtualUser:ClickButton2(Vector2.new(0,0)) end) end
        task.wait(_G.CheatConfig.AntiAfkDelay)
    end
end)

local function ClickScreenAbilityButtons()
    if not _G.CheatConfig.AutoAbilitiesActive then return end
    local playerGui = player:FindFirstChild("PlayerGui")
    if not playerGui then return end

    for _, guiObj in ipairs(playerGui:GetDescendants()) do
        if guiObj:IsA("TextButton") or guiObj:IsA("ImageButton") then
            local nameLower = string.lower(guiObj.Name)
            local textLower = guiObj:IsA("TextButton") and string.lower(guiObj.Text) or ""
            
            if string.find(nameLower, "heart") or string.find(nameLower, "bleed") or 
               string.find(nameLower, "skill") or string.find(nameLower, "ability") or 
               string.find(textLower, "heart") or string.find(nameLower, "spell") or
               nameLower == "x" or nameLower == "z" or nameLower == "c" then
                
                if _G.CheatConfig.UseVirtualClickAbilities then pcall(function() guiObj:Activate() end) end
                if _G.CheatConfig.UseRemoteAbilities then
                    pcall(function()
                        local events = guiObj:FindFirstChildOfClass("RemoteEvent") or guiObj:FindFirstChildOfClass("BindableEvent")
                        if events then events:FireServer() end
                    end)
                end
            end
        end
    end
    if _G.CheatConfig.UseKeyPressAbilities then
        pcall(function() for _, keyStr in ipairs(abilityKeys) do VirtualUser:TypeKey(keyStr) end end)
    end
end

task.spawn(function()
    while true do
        if _G.CheatConfig.AutoAbilitiesActive then ClickScreenAbilityButtons() end
        task.wait(0.05)
    end
end)
print("[Elite Hub]: Часть 3 успешно загружена!")
-- [[ ЧАСТЬ 4 ИЗ 4: Магниты с Заморозкой, Ротация, Полет и Финал ]]

local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local player = game:GetService("Players").LocalPlayer

local ComprehensiveOresList = {"Iron", "Gold", "Diamond", "Bluesteel", "Amberstone", "Crystal", "Viridis", "Vermite", "Ore Clump", "Ultimus", "Optimum", "Unobtanium", "Dankite", "Dark Matter", "Destinium", "Dankinite", "Uranium", "Plutonium", "Green Vermite", "Purple Vermite", "Regite", "Devumite", "Demonite", "Enchanted Iron", "Salt", "Hellstone", "Rainbonite", "Rolite", "Pure Vermite", "Pure Amberstone", "Chaotrum", "Black Vermite", "Black Iron", "Azure", "Uldragunn", "Onyx", "Serendibite", "Vantablack", "Voidite", "Uru", "Tanzanite", "Originite", "Pitcholamadamantinite"}

local function ExecuteInventoryManagement()
    if not _G.CheatConfig.AutoRotationActive then return end
    local backpack, character = player:FindFirstChild("Backpack"), player.Character
    if not backpack or not character then return end
    local currentTool = character:FindFirstChildOfClass("Tool")
    if not currentTool then
        local fb = backpack:FindFirstChild(_G.CheatConfig.MainFallbackTool)
        if fb then fb.Parent = character _G.FarmState.LastMode = _G.CheatConfig.MainFallbackTool return end
    end
    local phase = _G.CustomRotationSequence[_G.FarmState.CurrentPhaseIndex]
    if phase and _G.FarmState.LastMode ~= phase.Name then
        if not currentTool or currentTool.Name ~= phase.Name then
            local t = backpack:FindFirstChild(phase.Name)
            if t then _G.FarmState.LastMode = phase.Name if currentTool then currentTool.Parent = backpack end t.Parent = character end
        end
    end
end

local function ExecuteScheduledFly()
    if not _G.CheatConfig.ScheduledFlyActive then return end
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local root = character.HumanoidRootPart
    local prompts = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do if obj:IsA("ProximityPrompt") then table.insert(prompts, obj) end end
    if #prompts == 0 then return end
    _G.FarmState.IsFlyingToButtons = true
    for _, p in ipairs(prompts) do
        if not _G.CheatConfig.ScheduledFlyActive then break end
        if p and p.Parent then
            pcall(function()
                local part = p.Parent:IsA("BasePart") and p.Parent or p.Parent:FindFirstChildOfClass("BasePart")
                if part then
                    root.CFrame = part.CFrame * CFrame.new(0, 2, 0)
                    task.wait(0.2)
                    if fireproximityprompt then fireproximityprompt(p) else p:InputHoldBegin() task.wait(p.HoldDuration + 0.05) p:InputHoldEnd() end
                    task.wait(0.15)
                end
            end)
        end
    end
    _G.FarmState.IsFlyingToButtons = false
end

local function ProcessWorldTriggers()
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local root = character.HumanoidRootPart

    if _G.CheatConfig.AntiSitActive then
        local hum = character:FindFirstChildOfClass("Humanoid")
        if hum and hum.Sit then hum.Sit = false root.CFrame = root.CFrame * CFrame.new(0, 5, 0) end
    end
    if _G.CheatConfig.AutoClickTools then local tool = character:FindFirstChildOfClass("Tool") if tool then pcall(function() tool:Activate() end) end end

    if _G.CheatConfig.MagnetOres then
        for _, mine in ipairs(_G.CheatConfig.MineFolders) do
            local folder = Workspace:FindFirstChild(mine)
            if folder then
                for _, c in ipairs(folder:GetDescendants()) do
                    if c:IsA("Model") then
                        local match = false
                        for _, o in ipairs(ComprehensiveOresList) do if string.find(string.lower(c.Name), string.lower(o)) then match = true break end end
                        if c:FindFirstChild("Ore") or c:FindFirstChild("Block") or string.find(string.lower(c.Name), "ore") then match = true end
                        if match then
                            local part = c:FindFirstChildOfClass("Part") or c:FindFirstChildOfClass("MeshPart") or c:FindFirstChild("Ore") or c.PrimaryPart
                            if part then pcall(function() part.CanCollide = true part.Anchored = true part.Velocity = Vector3.new(0,0,0) part.CFrame = root.CFrame * CFrame.new(0, 0, -2) end) end
                        end
                    end
                end
            end
        end
    end

    if _G.CheatConfig.MagnetMobs then
        for _, obj in ipairs(Workspace:GetChildren()) do
            if obj:IsA("Model") and obj ~= character and obj:FindFirstChildOfClass("Humanoid") then
                local mRoot = obj:FindFirstChild("HumanoidRootPart")
                local mHum = obj:FindFirstChildOfClass("Humanoid")
                if mRoot and mHum and mHum.Health > 0 then
                    pcall(function()
                        mRoot.CFrame = root.CFrame * CFrame.new(0, 0, -((mRoot.Size.Z / 2) + 2))
                        mRoot.Anchored = true
                        mRoot.Velocity = Vector3.new(0,0,0)
                        mRoot.RotVelocity = Vector3.new(0,0,0)
                        mHum.PlatformStand = true
                    end)
                end
            end
        end
    end

    if _G.CheatConfig.AutoClickPrompts and not _G.FarmState.IsFlyingToButtons then
        for _, o in ipairs(Workspace:GetDescendants()) do if o:IsA("ProximityPrompt") then pcall(function() if fireproximityprompt then fireproximityprompt(o) else o:InputHoldBegin() task.wait(0.01) o:InputHoldEnd() end
    end
end

RunService.Heartbeat:Connect(function()
    if _G.CheatConfig.MainFarmActive and not _G.FarmState.IsFlyingToButtons and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local cf = CFrame.new(_G.CheatConfig.TargetX, _G.CheatConfig.TargetY, _G.CheatConfig.TargetZ)
        player.Character.HumanoidRootPart.CFrame = _G.CheatConfig.SpinActive and cf * CFrame.Angles(0, math.rad(tick() * _G.CheatConfig.SpinSpeed * 100) % 360, 0) or cf
    end
    ExecuteInventoryManagement()
end)

RunService.RenderStepped:Connect(function() if _G.CheatConfig.ForceCameraActive and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then Workspace.CurrentCamera.CameraSubject = player.Character.HumanoidRootPart end end)

task.spawn(function()
    while true do
        if _G.CheatConfig.AutoRotationActive then
            local p = _G.CustomRotationSequence[_G.FarmState.CurrentPhaseIndex]
            task.wait(p and _G.CheatConfig[p.DurationKey] or 2)
            _G.FarmState.CurrentPhaseIndex = _G.FarmState.CurrentPhaseIndex + 1
            if _G.FarmState.CurrentPhaseIndex > #_G.CustomRotationSequence then _G.FarmState.CurrentPhaseIndex = 1 end
        else task.wait(1) end
    end
end)

task.spawn(function() while true do ProcessWorldTriggers() task.wait(_G.CheatConfig.TriggerDelay) end end)
task.spawn(function() while true do task.wait(_G.CheatConfig.ScheduledFlyInterval) if _G.CheatConfig.ScheduledFlyActive then ExecuteScheduledFly() end end end)
print("[Elite Hub v15.5]: Последняя 4-я часть успешно загружена. Всё готово к фарму!")
    
