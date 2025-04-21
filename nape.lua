-- Roblox services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Размер, который будет устанавливаться
local NEW_SIZE = Vector3.new(2048, 2048, 2048)

-- Функция для увеличения шеек
local function SetAllNapeSizes()
    for _, titan in ipairs(workspace.Titans:GetDescendants()) do
        if titan:IsA("Model") and titan:FindFirstChild("Hitboxes") then
            local hit = titan.Hitboxes:FindFirstChild("Hit")
            if hit and hit:FindFirstChild("Nape") and hit.Nape:IsA("BasePart") then
                hit.Nape.Size = NEW_SIZE
            end
        end
    end
end

-- Постоянно проверяем и изменяем размеры
while true do
    SetAllNapeSizes()
    RunService.Heartbeat:Wait()
end
