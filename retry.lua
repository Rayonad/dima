-- retry.lua

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Функция для выполнения клика на кнопку retry
local function physicalClick(button)
    local VirtualInput = game:GetService("VirtualInputManager")
    local pos = button.AbsolutePosition
    local size = button.AbsoluteSize
    local clickX = pos.X + size.X / 2
    local clickY = pos.Y + size.Y / 2

    VirtualInput:SendMouseMoveEvent(clickX, clickY, game)
    task.wait(0.05)
    VirtualInput:SendMouseButtonEvent(clickX, clickY, 0, true, game, 1)
    task.wait(0.1)
    VirtualInput:SendMouseButtonEvent(clickX, clickY, 0, false, game, 1)
end

-- Найти кнопку Retry в интерфейсе
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

-- Выполнение авто-клика для Retry
local function autoRetry()
    local retryButton = findRetryButton()
    if retryButton then
        physicalClick(retryButton)
    end
end

return {
    autoRetry = autoRetry,
}
