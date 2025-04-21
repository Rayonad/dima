-- Titan Hack Menu for Roblox
-- Инжектится через executor

--[[
    Структура скрипта:
    1. Настройки стиля и цвета
    2. Создание главного окна
    3. Добавление функций (чекбоксов)
    4. Логика включения/выключения функций
    5. Вспомогательные функции
]]

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ========== НАСТРОЙКИ СТИЛЯ ==========
local Settings = {
    MainColor = Color3.fromRGB(40, 40, 40),     -- Основной цвет фона
    SecondaryColor = Color3.fromRGB(30, 30, 30), -- Вторичный цвет
    AccentColor = Color3.fromRGB(138, 43, 226),  -- Фиолетовый акцент (Purple)
    TextColor = Color3.fromRGB(255, 255, 255),   -- Белый текст
    TextSize = 14,                               -- Размер текста
    Font = Enum.Font.Gotham,                     -- Шрифт
    ToggleColor = Color3.fromRGB(76, 209, 55),   -- Зелёный для включенного состояния
    WindowSize = Vector2.new(300, 400),          -- Размер окна
    Padding = 10                                 -- Отступы
}

-- ========== СОЗДАНИЕ ГЛАВНОГО ОКНА ==========
local library = {
    toggles = {}
}

local ScreenGui = Instance.new("ScreenGui")
if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
end
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "TitanHackMenu"

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, Settings.WindowSize.X, 0, Settings.WindowSize.Y)
MainFrame.Position = UDim2.new(0.5, -Settings.WindowSize.X/2, 0.5, -Settings.WindowSize.Y/2)
MainFrame.BackgroundColor3 = Settings.MainColor
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 6)
Corner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Text = "Titan Hack"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Settings.SecondaryColor
Title.TextColor3 = Settings.AccentColor
Title.TextSize = 20
Title.Font = Settings.Font
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 6)
TitleCorner.Parent = Title

local FunctionsFrame = Instance.new("Frame")
FunctionsFrame.Name = "FunctionsFrame"
FunctionsFrame.Size = UDim2.new(1, -Settings.Padding*2, 1, -60 - Settings.Padding)
FunctionsFrame.Position = UDim2.new(0, Settings.Padding, 0, 50)
FunctionsFrame.BackgroundTransparency = 1
FunctionsFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.Parent = FunctionsFrame

-- ========== ФУНКЦИИ МЕНЮ ==========
local function CreateToggle(name, description)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = name .. "Toggle"
    ToggleFrame.Size = UDim2.new(1, 0, 0, 30)
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Parent = FunctionsFrame
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Size = UDim2.new(1, 0, 1, 0)
    ToggleButton.BackgroundTransparency = 1
    ToggleButton.Text = ""
    ToggleButton.Parent = ToggleFrame
    
    local ToggleText = Instance.new("TextLabel")
    ToggleText.Name = "ToggleText"
    ToggleText.Size = UDim2.new(0.7, 0, 1, 0)
    ToggleText.Position = UDim2.new(0, 0, 0, 0)
    ToggleText.BackgroundTransparency = 1
    ToggleText.Text = name
    ToggleText.TextColor3 = Settings.TextColor
    ToggleText.TextSize = Settings.TextSize
    ToggleText.TextXAlignment = Enum.TextXAlignment.Left
    ToggleText.Font = Settings.Font
    ToggleText.Parent = ToggleFrame
    
    if description then
        ToggleText.Text = name .. " (" .. description .. ")"
    end
    
    local ToggleBox = Instance.new("Frame")
    ToggleBox.Name = "ToggleBox"
    ToggleBox.Size = UDim2.new(0, 20, 0, 20)
    ToggleBox.Position = UDim2.new(1, -25, 0.5, -10)
    ToggleBox.BackgroundColor3 = Settings.SecondaryColor
    ToggleBox.BorderSizePixel = 0
    ToggleBox.Parent = ToggleFrame
    
    local ToggleBoxCorner = Instance.new("UICorner")
    ToggleBoxCorner.CornerRadius = UDim.new(0, 4)
    ToggleBoxCorner.Parent = ToggleBox
    
    local ToggleState = Instance.new("Frame")
    ToggleState.Name = "ToggleState"
    ToggleState.Size = UDim2.new(0, 16, 0, 16)
    ToggleState.Position = UDim2.new(0.5, -8, 0.5, -8)
    ToggleState.BackgroundColor3 = Settings.SecondaryColor
    ToggleState.BorderSizePixel = 0
    ToggleState.Parent = ToggleBox
    
    local ToggleStateCorner = Instance.new("UICorner")
    ToggleStateCorner.CornerRadius = UDim.new(0, 4)
    ToggleStateCorner.Parent = ToggleState
    
    local toggle = {
        enabled = false,
        frame = ToggleFrame,
        box = ToggleBox,
        state = ToggleState,
        callback = nil
    }
    
    library.toggles[name] = toggle
    
    local function UpdateToggle()
        if toggle.enabled then
            toggle.state.BackgroundColor3 = Settings.ToggleColor
            -- Фиолетовая подсветка текста при включении
            ToggleText.TextColor3 = Settings.AccentColor
        else
            toggle.state.BackgroundColor3 = Settings.SecondaryColor
            ToggleText.TextColor3 = Settings.TextColor
        end
    end
    
    ToggleButton.MouseButton1Click:Connect(function()
        toggle.enabled = not toggle.enabled
        UpdateToggle()
        if toggle.callback then
            toggle.callback(toggle.enabled)
        end
    end)
    
    UpdateToggle()
    return toggle
end

-- ========== ДОБАВЛЕНИЕ ФУНКЦИЙ ==========
-- Здесь добавляем функции (чекбоксы) в меню
CreateToggle("Nape") -- Автоматический удар в шею
CreateToggle("Aim") -- Автоматическое прицеливание
CreateToggle("Safe") -- Меньше детектится античитом
CreateToggle("ESP") -- Показывает игроков через стены

-- ========== ЗАКРЫТИЕ МЕНЮ ==========
-- Закрытие меню по клавише (например, RightControl)
local closed = false
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightShift then
        closed = not closed
        MainFrame.Visible = not closed
    end
end)

return library
