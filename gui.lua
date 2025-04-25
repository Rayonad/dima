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

-- Настройки для Auto Retry
local offsetLabel = Instance.new("TextLabel")
offsetLabel.Name = "OffsetLabel"
offsetLabel.Text = "Y Offset: " .. settings.retryYOffset
offsetLabel.Size = UDim2.new(0.6, 0, 0, 20)
offsetLabel.Position = UDim2.new(0.1, 0, 0, 150)
offsetLabel.BackgroundTransparency = 1
offsetLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
offsetLabel.Font = Enum.Font.Gotham
offsetLabel.TextSize = 12
offsetLabel.Parent = mainFrame

local offsetPlus = Instance.new("TextButton")
offsetPlus.Name = "OffsetPlus"
offsetPlus.Text = "+"
offsetPlus.Size = UDim2.new(0, 30, 0, 20)
offsetPlus.Position = UDim2.new(0.7, 0, 0, 150)
offsetPlus.BackgroundColor3 = Color3.fromRGB(70, 30, 90)
offsetPlus.TextColor3 = Color3.fromRGB(255, 255, 255)
offsetPlus.Font = Enum.Font.GothamBold
offsetPlus.TextSize = 14
offsetPlus.Parent = mainFrame

local offsetMinus = Instance.new("TextButton")
offsetMinus.Name = "OffsetMinus"
offsetMinus.Text = "-"
offsetMinus.Size = UDim2.new(0, 30, 0, 20)
offsetMinus.Position = UDim2.new(0.85, 0, 0, 150)
offsetMinus.BackgroundColor3 = Color3.fromRGB(70, 30, 90)
offsetMinus.TextColor3 = Color3.fromRGB(255, 255, 255)
offsetMinus.Font = Enum.Font.GothamBold
offsetMinus.TextSize = 14
offsetMinus.Parent = mainFrame

-- Функционал Auto Retry
local function findRetryButton()
    local rewardsGui = player.PlayerGui:FindFirstChild("Interface")
                  and player.PlayerGui.Interface:FindFirstChild("Rewards")
    if not rewardsGui or not rewardsGui.Visible then return nil end
    
    return rewardsGui:FindFirstChild("Main")
           and rewardsGui.Main:FindFirstChild("Info")
           and rewardsGui.Main.Info:FindFirstChild("Main")
           and rewardsGui.Main.Info.Main:FindFirstChild("Buttons")
           and rewardsGui.Main.Info.Main.Buttons:FindFirstChild("Retry")
end

local function physicalClick(button)
    local pos = button.AbsolutePosition
    local size = button.AbsoluteSize
    local clickX = pos.X + size.X / 2
    local clickY = pos.Y + size.Y / 2 + settings.retryYOffset
    
    VirtualInput:SendMouseMoveEvent(clickX, clickY, game)
    task.wait(0.05)
    VirtualInput:SendMouseButtonEvent(clickX, clickY, 0, true, game, 1)
    task.wait(0.1)
    VirtualInput:SendMouseButtonEvent(clickX, clickY, 0, false, game, 1)
    
    if settings.debug then
        print(("Retry clicked at X:%.1f Y:%.1f"):format(clickX, clickY))
    end
end

local retryConnection
local function toggleAutoRetry()
    settings.autoRetry = not settings.autoRetry
    autoRetryButton.Status.Text = settings.autoRetry and "ON" or "OFF"
    autoRetryButton.Status.TextColor3 = settings.autoRetry 
        and Color3.fromRGB(100, 255, 100) 
        or Color3.fromRGB(255, 100, 100)
    
    if settings.autoRetry then
        retryConnection = game:GetService("RunService").Heartbeat:Connect(function()
            local button = findRetryButton()
            if button then
                physicalClick(button)
                task.wait(1)
            end
        end)
    elseif retryConnection then
        retryConnection:Disconnect()
        retryConnection = nil
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

offsetPlus.MouseButton1Click:Connect(function()
    settings.retryYOffset = settings.retryYOffset + 5
    offsetLabel.Text = "Y Offset: " .. settings.retryYOffset
end)

offsetMinus.MouseButton1Click:Connect(function()
    settings.retryYOffset = math.max(0, settings.retryYOffset - 5)
    offsetLabel.Text = "Y Offset: " .. settings.retryYOffset
end)

addFunctionButton.MouseButton1Click:Connect(function()
    -- Здесь будет функционал добавления новых функций
    print("Function addition coming soon!")
end)

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    if retryConnection then
        retryConnection:Disconnect()
    end
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
