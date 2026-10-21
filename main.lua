-- [[ PROJECT: Classic Retro Craftwars - Elite Customizable Hub (v14.0) ]]
-- [[ PART 1: GUI, Configuration, Anti-AFK & Core Screen Spammers ]]

if _G.CraftwarsEliteLoaded then
    local oldGui = game:GetService("CoreGui"):FindFirstChild("CraftwarsEliteGui") or game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("CraftwarsEliteGui")
    if oldGui then oldGui:Destroy() end
end
_G.CraftwarsEliteLoaded = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer

_G.CheatConfig = {
    TargetX = 0.1986846923828125,
    TargetY = 6.0255889892578125 - 5,
    TargetZ = -0.2799992561340332,
    SpinSpeed = 25,
    
    GreataxeTime = 14,       
    HeartbanisherTime = 1.5, 
    PickaxeTime = 5,        
    
    AntiAfkDelay = 60,
    TriggerDelay = 0.01,    
    ClickDelay = 0.01,      
    MineFolders = {"Mine", "Mine2", "Mine3"},
    
    MainFarmActive = true,
    SpinActive = true,
    MagnetOres = true,
    MagnetMobs = true,
    AutoClickTools = true,
    AutoClickPrompts = true,
    AntiAfkActive = true,
    AntiSitActive = true,
    SpamKeysActive = true,   
    ScreenClickActive = true 
}

_G.FarmState = {
    CurrentPhase = "Greataxe", 
    LastMode = nil,
    IsFlyingToButtons = false
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CraftwarsEliteGui"
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = player:WaitForChild("PlayerGui") end

local ToggleMenuBtn = Instance.new("TextButton")
ToggleMenuBtn.Size = UDim2.new(0, 160, 0, 32)
ToggleMenuBtn.Position = UDim2.new(0.5, -80, 0, 0) 
ToggleMenuBtn.Text = "🔴 СКРЫТЬ МЕНЮ"
ToggleMenuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleMenuBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleMenuBtn.Font = Enum.Font.SourceSansBold
ToggleMenuBtn.TextSize = 14
ToggleMenuBtn.Parent = ScreenGui

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 4)
BtnCorner.Parent = ToggleMenuBtn

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 420, 0, 380)
MainFrame.Position = UDim2.new(0.5, -210, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local Header = Instance.new("TextLabel")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.Text = "CRAFTWARS ELITE HUB v14.0"
Header.TextColor3 = Color3.fromRGB(255, 255, 255)
Header.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Header.Font = Enum.Font.SourceSansBold
Header.TextSize = 16
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

ToggleMenuBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    if MainFrame.Visible then
        ToggleMenuBtn.Text = "🔴 СКРЫТЬ МЕНЮ"
        ToggleMenuBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    else
        ToggleMenuBtn.Text = "🟢 ОТКРЫТЬ МЕНЮ"
        ToggleMenuBtn.BackgroundColor3 = Color3.fromRGB(0, 140, 0)
    end
end)

local ScrollPage = Instance.new("ScrollingFrame")
ScrollPage.Size = UDim2.new(1, -20, 1, -50)
ScrollPage.Position = UDim2.new(0, 10, 0, 45)
ScrollPage.BackgroundTransparency = 1
ScrollPage.CanvasSize = UDim2.new(0, 0, 0, 800)
ScrollPage.ScrollBarThickness = 6
ScrollPage.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.Parent = ScrollPage

local function CreateToggle(text, configKey)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 35)
    Frame.BackgroundTransparency = 1
    Frame.Parent = ScrollPage

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Text = "  " .. text
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.SourceSans
    Label.TextSize = 16
    Label.BackgroundTransparency = 1
    Label.Parent = Frame

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.25, 0, 0.8, 0)
    Button.Position = UDim2.new(0.72, 0, 0.1, 0)
    Button.Font = Enum.Font.SourceSansBold
    Button.TextSize = 14
    Button.Parent = Frame
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Button

    local function updateBtn()
        if _G.CheatConfig[configKey] then
            Button.Text = "ВКЛ"
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.BackgroundColor3 = Color3.fromRGB(0, 140, 0)
        else
            Button.Text = "ВЫКЛ"
            Button.TextColor3 = Color3.fromRGB(150, 150, 150)
            Button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
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
    Frame.Size = UDim2.new(1, -10, 0, 35)
    Frame.BackgroundTransparency = 1
    Frame.Parent = ScrollPage

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.Text = "  " .. text
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.SourceSans
    Label.TextSize = 16
    Label.BackgroundTransparency = 1
    Label.Parent = Frame

    local Box = Instance.new("TextBox")
    Box.Size = UDim2.new(0.35, 0, 0.8, 0)
    Box.Position = UDim2.new(0.62, 0, 0.1, 0)
    Box.Text = tostring(_G.CheatConfig[configKey])
    Box.TextColor3 = Color3.fromRGB(255, 255, 255)
    Box.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Box.Font = Enum.Font.SourceSans
    Box.TextSize = 14
    Box.Parent = Frame
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
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

CreateToggle("ГЛАВНЫЙ ФАРМ (Телепорт в точку)", "MainFarmActive")
CreateToggle("Вращение персонажа (Крутилка)", "SpinActive")
CreateToggle("Магнит Ископаемых (Шахта)", "MagnetOres")
CreateToggle("Магнит всех Монстров к лицу", "MagnetMobs")
CreateToggle("Прямой автоудар предметами в руке", "AutoClickTools")
CreateToggle("Прямой сбор всплывающих кнопок (E)", "AutoClickPrompts")
CreateToggle("Автоматически ВСТАВАТЬ со стульев", "AntiSitActive")
CreateToggle("Высокоскоростной спам букв (E,Q,R,Z,X,C,F)", "SpamKeysActive")
CreateToggle("Автоматический клик по экрану", "ScreenClickActive")
CreateToggle("Анти-АФК защита", "AntiAfkActive")

CreateInput("Время удержания Greataxe (сек)", "GreataxeTime", true)
CreateInput("Время удержания Heartbanisher (сек)", "HeartbanisherTime", true)
CreateInput("Время удержания Кирки (сек)", "PickaxeTime", true)
CreateInput("Задержка автокликов экрана (сек)", "ClickDelay", true)
CreateInput("Задержка магнита/триггеров (сек)", "TriggerDelay", true)
CreateInput("Скорость вращения персонажа", "SpinSpeed", true)
CreateInput("Интервал Анти-АФК кликов (сек)", "AntiAfkDelay", true)

local inputKeys = {Enum.KeyCode.E, Enum.KeyCode.Q, Enum.KeyCode.R, Enum.KeyCode.Z, Enum.KeyCode.X, Enum.KeyCode.C, Enum.KeyCode.F}
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
-- [[ PART 2: 3-Phase Inventory, Ore Magnet & Fixed Screen UI Ability Clicker ]]

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

local function ExecuteInventoryManagement()
    local backpack = player:FindFirstChild("Backpack")
    local character = player.Character
    if not backpack or not character then return end

    local currentTool = character:FindFirstChildOfClass("Tool")
    local targetToolName = nil

    if _G.FarmState.CurrentPhase == "Greataxe" then
        targetToolName = "Greataxe of Love"
    elseif _G.FarmState.CurrentPhase == "Heartbanisher" then
        targetToolName = "Heartbanisher"
    elseif _G.FarmState.CurrentPhase == "Pickaxe" then
        targetToolName = "Ultimate Pickaxe"
    end

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

-- ИСПРАВЛЕННЫЙ МЕТОД ОБХОДА МЕТАТАБЛИЦ: Нажатие физических кнопок UI способностей на экране
local function ClickScreenAbilityButtons()
    local playerGui = player:FindFirstChild("PlayerGui")
    if not playerGui then return end

    -- Сканируем весь графический интерфейс игрока на мобильном экране
    for _, guiObj in ipairs(playerGui:GetDescendants()) do
        if guiObj:IsA("TextButton") or guiObj:IsA("ImageButton") then
            local nameLower = string.lower(guiObj.Name)
            local textLower = guiObj:IsA("TextButton") and string.lower(guiObj.Text) or ""
            
            -- Проверяем любые совпадения с кнопками способностей (Hearthbleed, Barrage, X, Skill)
            if string.find(nameLower, "heart") or string.find(nameLower, "bleed") or string.find(nameLower, "skill") or string.find(nameLower, "ability") or string.find(textLower, "heart") or nameLower == "x" then
                pcall(function()
                    -- Имитируем реальное нажатие на кнопку интерфейса в обход античита
                    guiObj:Activate()
                    local events = guiObj:FindFirstChildOfClass("RemoteEvent") or guiObj:FindFirstChildOfClass("BindableEvent")
                    if events then events:FireServer() end
                end)
            end
        end
    end
end

local function ExecuteScheduledFly()
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

local function ProcessWorldTriggers()
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local rootPart = character.HumanoidRootPart

    if _G.CheatConfig.AntiSitActive then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.Sit then
            pcall(function()
                humanoid.Sit = false
                rootPart.CFrame = rootPart.CFrame * CFrame.new(0, 5, 0) 
            end)
        end
    end

    if _G.CheatConfig.AutoClickTools then
        local tool = character:FindFirstChildOfClass("Tool")
        if tool then 
            pcall(function() tool:Activate() end)
            -- Вызываем клик по экранным кнопкам способностей всегда, когда в руке боевое оружие
            if tool.Name == "Heartbanisher" or tool.Name == "Greataxe of Love" then
                ClickScreenAbilityButtons()
            end
        end
    end

    -- МОДЕРНИЗИРОВАННЫЙ МОДУЛЬ РУДЫ: ФИКСАЦИЯ ПЕРЕД ЛИЦОМ ИГРОКА
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
                                    -- Руда прибивается на уровень груди перед игроком
                                    orePart.CFrame = rootPart.CFrame * CFrame.new(0, 0, -2)
                                end)
                            end
                        end
                    end
                end
            end
        end
    end

    if _G.CheatConfig.MagnetMobs then
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

RunService.RenderStepped:Connect(function()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        Workspace.CurrentCamera.CameraSubject = character.HumanoidRootPart
    end
end)

task.spawn(function()
    while true do
        _G.FarmState.CurrentPhase = "Greataxe"
        task.wait(_G.CheatConfig.GreataxeTime)
        
        _G.FarmState.CurrentPhase = "Heartbanisher"
        task.wait(_G.CheatConfig.HeartbanisherTime)
        
        _G.FarmState.CurrentPhase = "Pickaxe"
        task.wait(_G.CheatConfig.PickaxeTime)
    end
end)

task.spawn(function()
    while true do
        ProcessWorldTriggers()
        task.wait(_G.CheatConfig.TriggerDelay)
    end
end)

task.spawn(function()
    while true do
        task.wait(60)
        ExecuteScheduledFly() 
    end
end)

print("[Elite Hub v14.0]: Физическая эмуляция кликов способностей на экране активирована!")
