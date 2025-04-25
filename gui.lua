local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local VirtualInput = game:GetService("VirtualInputManager")
local player = Players.LocalPlayer

-- Основные настройки
local settings = {
    autoFarm = false,
    autoRetry = false,
    retryYOffset = 30,
    checkDelay = 0.3,
    debug = true
}

-- Создаем основной GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TitanHackGUI"
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 250, 0, 300)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BorderSizePixel = 0

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Text = "Titan Hack v1.0"
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(50, 0, 80)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = mainFrame

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Text = "X"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 16
closeButton.Parent = mainFrame

-- Функции для кнопок
local function createButton(name, yPosition, parent)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Text = name
    button.Size = UDim2.new(0.8, 0, 0, 40)
    button.Position = UDim2.new(0.1, 0, 0, yPosition)
    button.BackgroundColor3 = Color3.fromRGB(70, 30, 90)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.Parent = parent
    
    local status = Instance.new("TextLabel")
    status.Name = "Status"
    status.Text = "OFF"
    status.Size = UDim2.new(0, 50, 0, 20)
    status.Position = UDim2.new(1, -50, 0.5, -10)
    status.BackgroundTransparency = 1
    status.TextColor3 = Color3.fromRGB(255, 100, 100)
    status.Font = Enum.Font.GothamBold
    status.TextSize = 14
    status.Parent = button
    
    return button
end

-- Создаем кнопки функций
local autoFarmButton = createButton("Auto Farm", 50, mainFrame)
local autoRetryButton = createButton("Auto Retry", 100, mainFrame)
local addFunctionButton = createButton("Add Function", 250, mainFrame)

-- Интеграция retry.lua
local retryModule = require(game:GetService("ReplicatedStorage"):WaitForChild("retry")) -- Путь, куда помещен retry.lua

-- Функционал Auto Retry
local function toggleAutoRetry()
    settings.autoRetry = not settings.autoRetry
    autoRetryButton.Status.Text = settings.autoRetry and "ON" or "OFF"
    autoRetryButton.Status.TextColor3 = settings.autoRetry 
        and Color3.fromRGB(100, 255, 100) 
        or Color3.fromRGB(255, 100, 100)
    
    if settings.autoRetry then
        -- Запуск Auto Retry
        retryModule.autoRetry() -- Вызов функции autoRetry из retry.lua
    end
end

-- Обработчики событий
autoFarmButton.MouseButton1Click:Connect(function()
    settings.autoFarm = not settings.autoFarm
    autoFarmButton.Status.Text = settings.autoFarm and "ON" or "OFF"
    autoFarmButton.Status.TextColor3 = settings.autoFarm 
        and Color3.fromRGB(100, 255, 100) 
        or Color3.fromRGB(255, 100, 100)
    -- Здесь будет функционал Auto Farm
end)

autoRetryButton.MouseButton1Click:Connect(toggleAutoRetry)

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Делаем окно перетаскиваемым
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, 
                                 startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Добавляем возможность скрывать/показывать GUI по клавише
UIS.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.RightShift then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

mainFrame.Parent = screenGui
