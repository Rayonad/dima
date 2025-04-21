-- Загружаем модули
local GUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Rayonad/dima/refs/heads/master/gui.lua"))()
local NapeModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/Rayonad/dima/refs/heads/master/nape.lua"))()

-- Вручную добавляем переключатель для Nape (альтернатива AddModule)
GUI.toggles["Nape"] = {
    enabled = false,
    callback = function(enabled)
        NapeModule.Toggle(enabled)
    end
}

-- Если есть другие модули, добавляем их так же
-- GUI.toggles["Aim"] = { ... }
