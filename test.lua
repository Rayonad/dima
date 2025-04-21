-- test.lua
local running = true

spawn(function()
    while running do
        print("Hello world")
        wait(1)
    end
end)

return function(enabled)
    running = enabled
end
