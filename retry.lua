local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local VirtualInput = game:GetService("VirtualInputManager")
local player = Players.LocalPlayer

-- Настройки (можно менять)
local settings = {
    active = false, -- Включено ли автонажатие
    keybind = Enum.KeyCode.F2, -- Клавиша активации
    yOffset = 40, -- Насколько ниже кликать (пиксели)
    checkDelay = 0.3, -- Проверка каждые 0.3 сек
    debug = true -- Вывод отладочной информации
}

-- Поиск кнопки Retry
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

-- Физический клик с регулируемым смещением
local function physicalClick(button)
    local pos = button.AbsolutePosition
    local size = button.AbsoluteSize
    
    -- Центр кнопки с учетом смещения
    local clickX = pos.X + size.X / 2
    local clickY = pos.Y + size.Y / 2 + settings.yOffset
    
    -- 1. Перемещаем курсор
    VirtualInput:SendMouseMoveEvent(clickX, clickY, game)
    task.wait(0.05)
    
    -- 2. Нажимаем ЛКМ
    VirtualInput:SendMouseButtonEvent(clickX, clickY, 0, true, game, 1)
    task.wait(0.1)
    
    -- 3. Отпускаем ЛКМ
    VirtualInput:SendMouseButtonEvent(clickX, clickY, 0, false, game, 1)
    
    if settings.debug then
        print(("Физический клик: X=%.1f, Y=%.1f (смещение Y+%d)"):format(
            clickX, clickY, settings.yOffset))
    end
end

-- Основной цикл
local function checkLoop()
    while settings.active do
        local button = findRetryButton()
        if button then
            physicalClick(button)
            task.wait(1) -- Задержка после клика
        end
        task.wait(settings.checkDelay)
    end
end

-- Переключение по F2
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == settings.keybind then
        settings.active = not settings.active
        print("Автокликер Retry:", settings.active and "ВКЛ" or "ВЫКЛ")
        
        if settings.active then
            task.spawn(checkLoop)
        end
    end
end)

print("Скрипт готов. Нажмите F2 для активации.")