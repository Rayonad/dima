local GUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Rayonad/dima/refs/heads/master/gui.lua"))()
local TestModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/Rayonad/dima/refs/heads/master/test.lua"))()

GUI:AddModule("Test", function(enabled)
    if enabled then
        TestModule.start()
    else
        TestModule.stop()
    end
end)&#8203;:contentReference[oaicite:7]{index=7}
