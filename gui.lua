local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local VirtualInput = game:GetService("VirtualInputManager")
local player = Players.LocalPlayer

-- Настройки
local settings = {
    autoFarm = false,
    autoRetry = false,
    retryYOffset = 30,
    checkDelay = 0.3,
    debug = true
}

-- Создание GUI
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
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Text = "Titan Hack v1.0"
title.Size = UDim2.new(1, 0, 0, 40)
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
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Функция для создания кнопки с индикатором
local function createToggleButton(label, yPos, settingName)
    local button = Instance.new("TextButton")
    button.Name = label
    button.Text = label
    button.Size = UDim2.new(0.8, 0, 0, 40)
    button.Position = UDim2.new(0.1, 0, 0, yPos)
    button.BackgroundColor3 = Color3.fromRGB(70, 30, 90)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.Parent = mainFrame

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

    button.MouseButton1Click:Connect(function()
        settings[settingName] = not settings[settingName]
        status.Text = settings[settingName] and "ON" or "OFF"
        status.TextColor3 = settings[settingName] and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
    end)
end

-- Кнопки
createToggleButton("Auto Farm", 50, "autoFarm")
createToggleButton("Auto Retry", 100, "autoRetry")

-- Настройки Offset
local offsetLabel = Instance.new("TextLabel")
offsetLabel.Text = "Y Offset: " .. settings.retryYOffset
offsetLabel.Size = UDim2.new(0.6, 0, 0, 20)
offsetLabel.Position = UDim2.new(0.1, 0, 0, 150)
offsetLabel.BackgroundTransparency = 1
offsetLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
offsetLabel.Font = Enum.Font.Gotham
offsetLabel.TextSize = 12
offsetLabel.Parent = mainFrame

local function updateOffsetLabel()
    offsetLabel.Text = "Y Offset: " .. settings.retryYOffset
end

local offsetPlus = Instance.new("TextButton")
offsetPlus.Text = "+"
offsetPlus.Size = UDim2.new(0, 30, 0, 20)
offsetPlus.Position = UDim2.new(0.7, 0, 0, 150)
offsetPlus.BackgroundColor3 = Color3.fromRGB(70, 30, 90)
offsetPlus.TextColor3 = Color3.fromRGB(255, 255, 255)
offsetPlus.Font = Enum.Font.GothamBold
offsetPlus.TextSize = 14
offsetPlus.Parent = mainFrame
offsetPlus.MouseButton1Click:Connect(function()
    settings.retryYOffset += 1
    updateOffsetLabel()
end)

local offsetMinus = Instance.new("TextButton")
offsetMinus.Text = "-"
offsetMinus.Size = UDim2.new(0, 30, 0, 20)
offsetMinus.Position = UDim2.new(0.85, 0, 0, 150)
offsetMinus.BackgroundColor3 = Color3.fromRGB(70, 30, 90)
offsetMinus.TextColor3 = Color3.fromRGB(255, 255, 255)
offsetMinus.Font = Enum.Font.GothamBold
offsetMinus.TextSize = 14
offsetMinus.Parent = mainFrame
offsetMinus.MouseButton1Click:Connect(function()
    settings.retryYOffset -= 1
    updateOffsetLabel()
end)
