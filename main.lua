-- Загружаем GUI
local GUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Rayonad/dima/refs/heads/master/gui.lua"))()

-- Загружаем модуль Nape
local Nape = loadstring(game:HttpGet("https://raw.githubusercontent.com/Rayonad/dima/refs/heads/master/nape.lua"))()

-- Добавляем модуль в GUI
GUI:AddModule("Nape", Nape)

print("Nape модуль успешно интегрирован в меню!")
