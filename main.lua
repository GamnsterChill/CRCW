-- [[ PROJECT: Classic Retro Craftwars - Elite Customizable Hub ]]
-- [[ ЧАСТЬ 1 ИЗ 5: Конфигурация и Таблицы ]]

if _G.CraftwarsEliteLoaded then
    local oldGui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("CraftwarsEliteGui")
    if oldGui then oldGui:Destroy() end
end
_G.CraftwarsEliteLoaded = true

_G.CheatConfig = {
    TargetX = 0.1986846923828125,
    TargetY = 1.0255889892578125, 
    TargetZ = -0.2799992561340332,
    PistolHeight = 70,       -- Высота полета игрока над мобами (в студах)
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
    
    -- Состояние функций (Изначально выключены)
    MainFarmActive = false,
    PistolModeActive = false, -- Новый режим "Пистолет"
    SpinActive = false,
    MagnetOres = false,
    MagnetMobs = false,
    AutoClickTools = false,
    AutoClickPrompts = false,
    AntiAfkActive = false,
    AntiSitActive = false,
    SpamKeysActive = false,   
    ScreenClickActive = false,
    AutoRotationActive = false,       
    AutoAbilitiesActive = false,      
    ScheduledFlyActive = false,       
    ForceCameraActive = false,        
    UseRemoteAbilities = false,       
    UseVirtualClickAbilities = false, 
    UseKeyPressAbilities = false,

    -- Предметы для ротации
    CustomTool1 = "Greataxe of Love",
    CustomTool2 = "Heartbanisher",
    CustomTool3 = "Ultimate Pickaxe" -- Предмет 3 (Условная кирка)
}

_G.FarmState = {
    CurrentPhaseIndex = 1,
    LastMode = nil,
    IsFlyingToButtons = false,
    CurrentEquippedToolName = ""
}

_G.CustomRotationSequence = {
    {ConfigNameKey = "CustomTool1", DurationKey = "GreataxeTime"},
    {ConfigNameKey = "CustomTool2", DurationKey = "HeartbanisherTime"},
    {ConfigNameKey = "CustomTool3", DurationKey = "PickaxeTime"} -- Индекс 3
}

-- Функция сканирования инвентаря для выпадающего списка
function _G.GetAvailableTools()
    local tools = {}
    local added = {}
    local p = game:GetService("Players").LocalPlayer
    
    local function scan(dir)
        if dir then
            for _, item in ipairs(dir:GetChildren()) do
                if item:IsA("Tool") and not added[item.Name] then
                    added[item.Name] = true
                    table.insert(tools, item.Name)
                end
            end
        end
    end
    
    if p then
        scan(p:FindFirstChild("Backpack"))
        scan(p.Character)
    end
    
    if #tools == 0 then
        return {"Greataxe of Love", "Heartbanisher", "Ultimate Pickaxe"}
    end
    return tools
end

print("[Elite Hub]: Часть 1 успешно инициализирована!")
-- [[ PROJECT: Classic Retro Craftwars - Elite Customizable Hub ]]
-- [[ ЧАСТЬ 2 ИЗ 5: Отрисовка Меню ]]

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CraftwarsEliteGui"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

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
MainFrame.Size = UDim2.new(0, 420, 0, 390)
MainFrame.Position = UDim2.new(0.5, -210, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Header = Instance.new("TextLabel")
Header.Size = UDim2.new(1, 0, 0, 32)
Header.Text = "⚙️ CRAFTWARS ELITE v16.1 (Pistol Fix)"
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
ScrollPage.CanvasSize = UDim2.new(0, 0, 0, 1400)
ScrollPage.ScrollBarThickness = 4
ScrollPage.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.Parent = ScrollPage

function CreateToggle(text, configKey)
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

function CreateInput(text, configKey, isNumber)
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

function CreateDropdown(text, configKey)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 32)
    Frame.BackgroundTransparency = 1
    Frame.Parent = ScrollPage

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.5, 0, 1, 0)
    Label.Text = "  " .. text
    Label.TextColor3 = Color3.fromRGB(220, 220, 190)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.SourceSans
    Label.TextSize = 13
    Label.BackgroundTransparency = 1
    Label.Parent = Frame

    local MainBtn = Instance.new("TextButton")
    MainBtn.Size = UDim2.new(0, 160, 0, 24)
    MainBtn.Position = UDim2.new(0.55, 0, 0.1, 0)
    MainBtn.Text = _G.CheatConfig[configKey] or "Нажми для выбора"
    MainBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    MainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MainBtn.Font = Enum.Font.SourceSans
    MainBtn.TextSize = 12
    MainBtn.Parent = Frame

    local ListFrame = Instance.new("Frame")
    ListFrame.Size = UDim2.new(0, 160, 0, 100)
    ListFrame.Position = UDim2.new(0.55, 0, 0.9, 0)
    ListFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ListFrame.ZIndex = 10
    ListFrame.Visible = false
    ListFrame.Parent = Frame

    local ListScroll = Instance.new("ScrollingFrame")
    ListScroll.Size = UDim2.new(1, 0, 1, 0)
    ListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    ListScroll.ScrollBarThickness = 3
    ListScroll.ZIndex = 10
    ListScroll.Parent = ListFrame

    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Parent = ListScroll

    MainBtn.MouseButton1Click:Connect(function()
        ListFrame.Visible = not ListFrame.Visible
        if ListFrame.Visible then
            for _, c in ipairs(ListScroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
            local currentItems = _G.GetAvailableTools()
            ListScroll.CanvasSize = UDim2.new(0, 0, 0, #currentItems * 22)
            for _, itemName in ipairs(currentItems) do
                local ItemBtn = Instance.new("TextButton")
                ItemBtn.Size = UDim2.new(1, 0, 0, 20)
                ItemBtn.Text = itemName
                ItemBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                ItemBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
                ItemBtn.Font = Enum.Font.SourceSans
                ItemBtn.TextSize = 11
                ItemBtn.ZIndex = 10
                ItemBtn.Parent = ListScroll
                
                ItemBtn.MouseButton1Click:Connect(function()
                    _G.CheatConfig[configKey] = itemName
                    MainBtn.Text = itemName
                    ListFrame.Visible = false
                end)
            end
        end
    end)
end

print("[Elite Hub]: Часть 2 успешно загружена!")
-- [[ PROJECT: Classic Retro Craftwars - Elite Customizable Hub ]]
-- [[ ЧАСТЬ 3 ИЗ 5: Элементы Интерфейса ]]

-- Основные переключатели
CreateToggle("🔫 РЕЖИМ ПИСТОЛЕТ (Мобы на месте фарма)", "PistolModeActive")
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

-- Ввод координат и задержек
CreateInput("Координата Телепорта X", "TargetX", true)
CreateInput("Координата Телепорта Y", "TargetY", true)
CreateInput("Координата Телепорта Z", "TargetZ", true)
CreateInput("Высота над мобами (Пистолет)", "PistolHeight", true)
CreateInput("Запасное оружие (Fallback)", "MainFallbackTool", false)
CreateInput("Время удержания Предмета 1 (сек)", "GreataxeTime", true)
CreateInput("Время удержания Предмета 2 (сек)", "HeartbanisherTime", true)
CreateInput("Время удержания Предмета 3 (сек)", "PickaxeTime", true)
CreateInput("Задержка автокликов экрана (сек)", "ClickDelay", true)
CreateInput("Задержка магнита/триггеров (сек)", "TriggerDelay", true)
CreateInput("Скорость вращения персонажа", "SpinSpeed", true)
CreateInput("Интервал Анти-АФК кликов (сек)", "AntiAfkDelay", true)
CreateInput("Интервал облета кнопок (сек)", "ScheduledFlyInterval", true)

-- Выпадающие списки выбора предметов
CreateDropdown("⚔️ Выбрать Предмет 1:", "CustomTool1")
CreateDropdown("⚔️ Выбрать Предмет 2:", "CustomTool2")
CreateDropdown("⛏️ Выбрать Предмет 3 (Кирка):", "CustomTool3")

print("[Elite Hub]: Часть 3 успешно загружена!")
-- [[ PROJECT: Classic Retro Craftwars - Elite Customizable Hub ]]
-- [[ ЧАСТЬ 4 ИЗ 5: Автоклики и Сверх-прожим Способностей ]]

local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local player = game:GetService("Players").LocalPlayer

local inputKeys = {Enum.KeyCode.E, Enum.KeyCode.Q, Enum.KeyCode.R, Enum.KeyCode.Z, Enum.KeyCode.X, Enum.KeyCode.C, Enum.KeyCode.F}
local abilityKeys = {"Z", "X", "C", "V", "F", "E", "Q"}

task.spawn(function()
    while true do
        if (_G.CheatConfig.MainFarmActive or _G.CheatConfig.PistolModeActive) and not _G.FarmState.IsFlyingToButtons then
            if _G.CheatConfig.SpamKeysActive then
                for _, key in ipairs(inputKeys) do
                    pcall(function() VirtualUser:SetKeyDown(key) task.wait(0.01) VirtualUser:SetKeyUp(key) end)
                end
            end
            if _G.CheatConfig.ScreenClickActive then
                pcall(function() VirtualUser:Button1Down(Vector2.new(100, 100)) task.wait(0.01) VirtualUser:Button1Up(Vector2.new(100, 100)) end)
            end
        end
        local d = tonumber(_G.CheatConfig.ClickDelay) or 0.01
        task.wait(math.max(d, 0.001)) 
    end
end)

task.spawn(function()
    while true do
        if _G.CheatConfig.AntiAfkActive then pcall(function() VirtualUser:CaptureController() VirtualUser:ClickButton2(Vector2.new(0,0)) end) end
        local d = tonumber(_G.CheatConfig.AntiAfkDelay) or 60
        task.wait(math.max(d, 1))
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

print("[Elite Hub]: Часть 4 успешно загружена!")
-- [[ PROJECT: Classic Retro Craftwars - Elite Customizable Hub ]]
-- [[ ЧАСТЬ 5 ИЗ 5: Магниты, Полет, Ротация и Финал ]]

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
    if phase then
        local toolName = _G.CheatConfig[phase.ConfigNameKey]
        if toolName and toolName ~= "" and _G.FarmState.LastMode ~= toolName then
            if not currentTool or currentTool.Name ~= toolName then
                local t = backpack:FindFirstChild(toolName)
                if t then 
                    _G.FarmState.LastMode = toolName 
                    if currentTool then currentTool.Parent = backpack end 
                    t.Parent = character 
                end
            end
        end
    end
    if currentTool then _G.FarmState.CurrentEquippedToolName = currentTool.Name else _G.FarmState.CurrentEquippedToolName = "" end
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
                            if part then pcall(function() part.CanCollide = true part.Anchored = true part.AssemblyLinearVelocity = Vector3.new(0,0,0) part.CFrame = root.CFrame * CFrame.new(0, 0, -2) end) end
                        end
                    end
                end
            end
        end
    end

    if _G.CheatConfig.AutoClickPrompts and not _G.FarmState.IsFlyingToButtons then
        for _, o in ipairs(Workspace:GetDescendants()) do if o:IsA("ProximityPrompt") then pcall(function() if fireproximityprompt then fireproximityprompt(o) else o:InputHoldBegin() task.wait(0.01) o:InputHoldEnd() end end) end end
    end
end

-- Основной цикл обработки позиций мира и физики
RunService.Heartbeat:Connect(function()
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local root = character.HumanoidRootPart

    local farmPos = Vector3.new(_G.CheatConfig.TargetX, _G.CheatConfig.TargetY, _G.CheatConfig.TargetZ)

    -- Жесткое стягивание мобов в точку фарма без срывов физики
    if _G.CheatConfig.MagnetMobs or _G.CheatConfig.PistolModeActive then
        for _, obj in ipairs(Workspace:GetChildren()) do
            if obj:IsA("Model") and obj ~= character and obj:FindFirstChildOfClass("Humanoid") then
                local mRoot = obj:FindFirstChild("HumanoidRootPart")
                local mHum = obj:FindFirstChildOfClass("Humanoid")
                if mRoot and mHum and mHum.Health > 0 then
                    pcall(function()
                        if _G.CheatConfig.PistolModeActive then
                            mRoot.CFrame = CFrame.new(farmPos) -- Мобы стягиваются ровно на точку обычного фарма
                        else
                            mRoot.CFrame = root.CFrame * CFrame.new(0, 0, -((mRoot.Size.Z / 2) + 2))
                        end
                        mRoot.Anchored = true
                        mRoot.AssemblyLinearVelocity = Vector3.new(0,0,0) -- Полный сброс импульсов
                        mRoot.AssemblyAngularVelocity = Vector3.new(0,0,0)
                        mHum.PlatformStand = true
                    end)
                end
            end
        end
    end

    -- Управление позицией и вращением игрока
    if _G.CheatConfig.PistolModeActive and not _G.FarmState.IsFlyingToButtons then
        local height = tonumber(_G.CheatConfig.PistolHeight) or 70
        local playerPos = Vector3.new(farmPos.X, farmPos.Y + height, farmPos.Z)
        local baseCFrame = CFrame.new(playerPos) * CFrame.Angles(math.rad(-90), 0, 0) -- Лицом вниз
        
        -- Проверка: Активен ли сейчас Предмет 3 (Условная Кирка)
        local isPhase3 = (_G.FarmState.CurrentPhaseIndex == 3)
        
        -- Умная крутилка: Если Предмет 3 - крутится ВСЕГДА. Иначе - во время пистолета не крутится.
        if isPhase3 or (_G.CheatConfig.SpinActive and not _G.CheatConfig.PistolModeActive) then
            root.CFrame = baseCFrame * CFrame.Angles(0, 0, math.rad(tick() * _G.CheatConfig.SpinSpeed * 100) % 360)
        else
            root.CFrame = baseCFrame
        end
    elseif _G.CheatConfig.MainFarmActive and not _G.FarmState.IsFlyingToButtons then
        local cf = CFrame.new(farmPos)
        root.CFrame = _G.CheatConfig.SpinActive and cf * CFrame.Angles(0, math.rad(tick() * _G.CheatConfig.SpinSpeed * 100) % 360, 0) or cf
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
print("[Elite Hub v16.1]: Последняя 5-я часть загружена. Баг исправлен, скрипт запущен!")
