local NapeModule = {}

-- Настройки
NapeModule.NEW_SIZE = Vector3.new(2048, 2048, 2048)
NapeModule.Enabled = false

-- Основная функция
function NapeModule.SetAllNapeSizes()
    if not NapeModule.Enabled then return end
    
    for _, titan in ipairs(workspace.Titans:GetDescendants()) do
        if titan:IsA("Model") and titan:FindFirstChild("Hitboxes") then
            local hit = titan.Hitboxes:FindFirstChild("Hit")
            if hit and hit:FindFirstChild("Nape") and hit.Nape:IsA("BasePart") then
                hit.Nape.Size = NapeModule.NEW_SIZE
            end
        end
    end
end

-- Функция для включения/выключения
function NapeModule.Toggle(state)
    NapeModule.Enabled = state
    if state then
        -- При включении сразу применяем изменения
        NapeModule.SetAllNapeSizes()
        -- И создаем цикл для постоянного обновления
        if not NapeModule.UpdateConnection then
            NapeModule.UpdateConnection = game:GetService("RunService").Heartbeat:Connect(function()
                NapeModule.SetAllNapeSizes()
            end)
        end
    else
        -- При выключении очищаем соединение
        if NapeModule.UpdateConnection then
            NapeModule.UpdateConnection:Disconnect()
            NapeModule.UpdateConnection = nil
        end
    end
end

return NapeModule
