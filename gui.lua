local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInput = game:GetService("UserInputService")

--== НАСТРОЙКИ ==--
local SETTINGS = {
    ESP = true,
    FreezeTitans = false,
    LongSword = false,  -- Увеличенная дальность атаки
    NapeSize = false,   -- Увеличение хитбоксов шеи
    TextColor = Color3.fromRGB(255, 255, 255),
    TextSize = 18,
    MenuKey = Enum.KeyCode.RightShift  -- Только открытие/закрытие меню
}

--== 3D ESP ==--
local ESPObjects = {}

local function Create3DESP(titan)
    if not titan:FindFirstChild("HumanoidRootPart") then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_"..titan.Name
    billboard.Adornee = titan.HumanoidRootPart
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.LightInfluence = 0
    billboard.MaxDistance = 500
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Text = titan.Name
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextColor3 = SETTINGS.TextColor
    textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    textLabel.TextStrokeTransparency = 0
    textLabel.BackgroundTransparency = 1
    textLabel.Parent = billboard
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.FillTransparency = 0.8
    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineTransparency = 0
    highlight.Adornee = titan
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    
    billboard.Parent = titan.HumanoidRootPart
    highlight.Parent = titan
    
    return {Billboard = billboard, Highlight = highlight}
end

local function ToggleESP(state)
    SETTINGS.ESP = state
    
    if state then
        for _, titan in ipairs(workspace.Titans:GetDescendants()) do
            if titan:IsA("Model") and titan:FindFirstChild("HumanoidRootPart") then
                ESPObjects[titan] = Create3DESP(titan)
            end
        end
    else
        for titan, esp in pairs(ESPObjects) do
            if esp.Billboard then esp.Billboard:Destroy() end
            if esp.Highlight then esp.Highlight:Destroy() end
        end
        ESPObjects = {}
    end
end

--== Freeze Titans ==--
local function ToggleFreeze(state)
    for _, titan in ipairs(workspace.Titans:GetDescendants()) do
        if titan:IsA("Model") and titan:FindFirstChild("HumanoidRootPart") then
            titan.HumanoidRootPart.Massless = state
        end
    end
end


--== Nape Size (Увеличение хитбоксов шеи) ==--
local function ToggleNapeSize(state)
    SETTINGS.NapeSize = state
    
    for _, titan in ipairs(workspace.Titans:GetDescendants()) do
        if titan:IsA("Model") and titan:FindFirstChild("HitBoxes") then
            local nape = titan.HitBoxes.Hit:FindFirstChild("Nape")
            if nape then
                nape.Size = state and Vector3.new(2048, 2048, 2048) or Vector3.new(15, 15, 15)  -- Стандартный размер (15)
            end
        end
    end
end

--== GUI МЕНЮ ==--
local menuVisible = false
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TitanHackMenu"
ScreenGui.Parent = game:GetService("CoreGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0.2, 0, 0.35, 0)
Frame.Position = UDim2.new(0.05, 0, 0.6, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BackgroundTransparency = 0.5
Frame.BorderSizePixel = 0
Frame.Visible = false
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Text = "Titan Hacks v3.0"
Title.Size = UDim2.new(1, 0, 0.1, 0)
Title.Font = Enum.Font.SourceSansBold
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Parent = Frame

local ESPToggle = Instance.new("TextButton")
ESPToggle.Text = "ESP: " .. (SETTINGS.ESP and "ON" or "OFF")
ESPToggle.Size = UDim2.new(0.9, 0, 0.12, 0)
ESPToggle.Position = UDim2.new(0.05, 0, 0.15, 0)
ESPToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
ESPToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPToggle.Parent = Frame

local FreezeToggle = Instance.new("TextButton")
FreezeToggle.Text = "Freeze Titans: " .. (SETTINGS.FreezeTitans and "ON" or "OFF")
FreezeToggle.Size = UDim2.new(0.9, 0, 0.12, 0)
FreezeToggle.Position = UDim2.new(0.05, 0, 0.3, 0)
FreezeToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
FreezeToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
FreezeToggle.Parent = Frame


local NapeSizeToggle = Instance.new("TextButton")
NapeSizeToggle.Text = "Nape Size: " .. (SETTINGS.NapeSize and "ON" or "OFF")
NapeSizeToggle.Size = UDim2.new(0.9, 0, 0.12, 0)
NapeSizeToggle.Position = UDim2.new(0.05, 0, 0.6, 0)
NapeSizeToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
NapeSizeToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
NapeSizeToggle.Parent = Frame

--== Обработчики кнопок ==--
ESPToggle.MouseButton1Click:Connect(function()
    SETTINGS.ESP = not SETTINGS.ESP
    ESPToggle.Text = "ESP: " .. (SETTINGS.ESP and "ON" or "OFF")
    ToggleESP(SETTINGS.ESP)
end)

FreezeToggle.MouseButton1Click:Connect(function()
    SETTINGS.FreezeTitans = not SETTINGS.FreezeTitans
    FreezeToggle.Text = "Freeze Titans: " .. (SETTINGS.FreezeTitans and "ON" or "OFF")
    ToggleFreeze(SETTINGS.FreezeTitans)
end)

NapeSizeToggle.MouseButton1Click:Connect(function()
    SETTINGS.NapeSize = not SETTINGS.NapeSize
    NapeSizeToggle.Text = "Nape Size: " .. (SETTINGS.NapeSize and "ON" or "OFF")
    ToggleNapeSize(SETTINGS.NapeSize)
end)

--== Открытие/закрытие меню ==--
UserInput.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == SETTINGS.MenuKey then
        menuVisible = not menuVisible
        Frame.Visible = menuVisible
    end
end)

--== Автоматическое обновление ESP и хитбоксов ==--
workspace.Titans.DescendantAdded:Connect(function(titan)
    if titan:IsA("Model") and titan:FindFirstChild("HumanoidRootPart") then
        if SETTINGS.ESP then
            ESPObjects[titan] = Create3DESP(titan)
        end
        if SETTINGS.FreezeTitans then
            titan.HumanoidRootPart.Massless = true
        end
        if SETTINGS.NapeSize and titan:FindFirstChild("HitBoxes") then
            local nape = titan.HitBoxes.Hit:FindFirstChild("Nape")
            if nape then
                nape.Size = Vector3.new(2048, 2048, 2048)
            end
        end
    end
end)

--== Инициализация ==--
ToggleESP(SETTINGS.ESP)
ToggleFreeze(SETTINGS.FreezeTitans)
ToggleNapeSize(SETTINGS.NapeSize)
