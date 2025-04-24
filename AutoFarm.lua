game:GetService("UserInputService").MouseIconEnabled = true
local v = {
    player = game.Players.LocalPlayer,
    char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait(),
    UIP = game:GetService("UserInputService"),
    RunService = game:GetService("RunService")
}

-- Ждем загрузки персонажа, если он еще не загружен
if not v.char then
    v.char = v.player.CharacterAdded:Wait()
end

v.humanoid = v.char:WaitForChild("Humanoid")
v.root = v.char:WaitForChild("HumanoidRootPart")
v.titans = game.Workspace:FindFirstChild("Titans")

-- Настройки для полета
local isFlying = false
local currentNape = nil
local BP = nil

-- Настройки для удара
local BV = v.root:FindFirstChild("BV")
if not BV then
    BV = Instance.new("BodyVelocity", v.root)
    BV.Name = "BV"
    BV.Velocity = Vector3.new(0, 0, 0)
    BV.MaxForce = Vector3.new(0, 0, 0)
end

local BASE_VELOCITY = BV.Velocity
local BASE_MAX_FORCE = BV.MaxForce

local PUNCH_VELOCITY = Vector3.new(1000, 1000, 1000)
local PUNCH_MAX_FORCE = Vector3.new(15000, 15000, 15000)

-- 🧱 Увеличение твоего хитбокса
local myHitbox = v.char:FindFirstChild("Hitbox")
if myHitbox then
    myHitbox.Size = Vector3.new(30, 500, 30)  -- Увеличиваем хитбокс игрока для лучшего взаимодействия
end

-- 🔍 Получение ближайшего нейпа (шейного хитбокса титана)
local function GetClosestTitanNape()
    if not v.titans then return nil end
    
    local closestNape = nil
    local shortestDist = math.huge  -- Изначально находим наибольшую возможную дистанцию

    for _, titan in pairs(v.titans:GetChildren()) do
        local hitboxes = titan:FindFirstChild("Hitboxes")
        if hitboxes then
            local hit = hitboxes:FindFirstChild("Hit")
            if hit and hit:FindFirstChild("Nape") then
                local nape = hit.Nape
                if nape.CanTouch then  -- Проверяем, можно ли столкнуться с шейкой
                    local dist = (v.root.Position - nape.Position).Magnitude  -- Вычисляем дистанцию
                    if dist < shortestDist then  -- Находим ближайший Nape
                        shortestDist = dist
                        closestNape = nape
                    end
                end
            end
        end
    end

    return closestNape
end

-- 🧹 Удаление всех частей тела кроме Nape у ВСЕХ титанов
local function CleanAllTitanHitboxes()
    if not v.titans then return end
    
    for _, titan in pairs(v.titans:GetChildren()) do
        local hitboxes = titan:FindFirstChild("Hitboxes")
        if hitboxes then
            local hit = hitboxes:FindFirstChild("Hit")
            if hit then
                for _, part in pairs(hit:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "Nape" then
                        part:Destroy()  -- Удаляем все части кроме Nape
                    end
                end
            end
        end
    end
end

-- 🚀 Запуск полёта
local function StartFlight()
    v.humanoid.PlatformStand = true  -- Включаем PlatformStand для предотвращения падения

    if not BP then
        BP = Instance.new("BodyPosition", v.root)  -- Создаём BodyPosition для контроля полёта
        BP.Name = "BP"
    end

    BP.MaxForce = Vector3.new(1e6, 1e6, 1e6)  -- Максимальная сила для полёта
    BP.D = 400  -- Сила демпфирования (плавность движения)
    BP.P = 800  -- Сила пропорциональная скорости (ускорение)
end

-- 🛑 Остановка полёта
local function StopFlight()
    isFlying = false
    v.humanoid.PlatformStand = false  -- Отключаем PlatformStand
    if BP then BP:Destroy() BP = nil end  -- Удаляем BodyPosition
    currentNape = nil
    
    -- Сброс настроек удара
    if BV and BV.Parent then
        BV.Velocity = BASE_VELOCITY
        BV.MaxForce = BASE_MAX_FORCE
    end
end

-- ESP
local highlight = Instance.new("Highlight")
highlight.FillColor = Color3.new(1, 0, 0) -- Красный
highlight.OutlineColor = Color3.new(1, 1, 1) -- Белый
highlight.FillTransparency = 0.8 -- Полупрозрачный


local function MarkTarget(nape)
    if not nape or not nape.Parent then 
        highlight.Adornee = nil
        return
    end
    highlight.Adornee = nape
    highlight.Parent = nape
end

-- В цикле полёта:
if currentNape then
    MarkTarget(currentNape)
else
    MarkTarget(nil)
end

-- Функция удара с PlatformStand
local function Punch()
    if not isFlying then return end  -- Удар работает только в режиме полета
    if not BV or not BV.Parent then return end

    local lookDirection = v.root.CFrame.LookVector
    local punchDirection = Vector3.new(
        lookDirection.X * PUNCH_VELOCITY.Z,
        PUNCH_VELOCITY.Y,
        lookDirection.Z * PUNCH_VELOCITY.Z
    )

    -- Включаем PlatformStand и ускорение
    v.humanoid.PlatformStand = true
    BV.Velocity = punchDirection
    BV.MaxForce = PUNCH_MAX_FORCE

    -- Автоматически отключаем PlatformStand через 0.3 сек
    task.delay(0.3, function()
        if v.humanoid and v.humanoid.Parent then
            v.humanoid.PlatformStand = true  -- Оставляем PlatformStand включенным, так как мы в режиме полета
        end
        if BV and BV.Parent then
            BV.Velocity = BASE_VELOCITY
            BV.MaxForce = BASE_MAX_FORCE
        end
    end)
end

-- 🔄 Цикл очистки всех титанов
task.spawn(function()
    while true do
        task.wait(2)  -- Очистка каждые 2 секунды
        CleanAllTitanHitboxes()
    end
end)



-- 🔁 Главный цикл полета и ударов
task.spawn(function()
    while true do
        task.wait(0.1)  -- Задержка, чтобы избежать слишком частых обновлений

        if isFlying then
            -- Находим ближайший Nape
            if not currentNape or not currentNape:IsDescendantOf(game) or currentNape.CanTouch == false then
                currentNape = GetClosestTitanNape()  -- Обновляем ближайший Nape
            end

            if currentNape and currentNape.CanTouch then
                -- Лететь к шейке титана
                BP.Position = currentNape.Position + Vector3.new(0, 150, 0)  -- Летим над титаном

                -- Отправляем удар
                local VirtualInputManager = game:GetService("VirtualInputManager")
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                task.wait(0.1)  -- Пауза между ударами
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            end
        end
    end
end)

-- ⌨️ Тоггл полета по F1
v.UIP.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.F1 then
        isFlying = not isFlying  -- Включаем или выключаем полет
        if isFlying then
            currentNape = GetClosestTitanNape()  -- Найти ближайший Nape
            StartFlight()  -- Начинаем полет
        else
            StopFlight()  -- Останавливаем полет
        end
    end
end)


-- Обработка клика мыши (удар) - работает только в режиме полета
v.UIP.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if not isFlying then return end  -- Удар работает только в режиме полета

    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        Punch()
    end
end)

-- Подстраховка при смерти
v.humanoid.Died:Connect(function()
    StopFlight()
end)

-- Обработка изменения персонажа
v.player.CharacterAdded:Connect(function(character)
    v.char = character
    v.humanoid = character:WaitForChild("Humanoid")
    v.root = character:WaitForChild("HumanoidRootPart")
    
    -- Пересоздаем BV для нового персонажа
    BV = v.root:FindFirstChild("BV")
    if not BV then
        BV = Instance.new("BodyVelocity", v.root)
        BV.Name = "BV"
        BV.Velocity = Vector3.new(0, 0, 0)
        BV.MaxForce = Vector3.new(0, 0, 0)
    end
    
    BASE_VELOCITY = BV.Velocity
    BASE_MAX_FORCE = BV.MaxForce
    
    -- Увеличиваем хитбокс для нового персонажа
    local myHitbox = v.char:FindFirstChild("Hitbox")
    if myHitbox then
        myHitbox.Size = Vector3.new(30, 500, 30)
    end
end)

