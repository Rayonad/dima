local running = false
local thread

local function start()
    if running then return end
    running = true
    thread = coroutine.create(function()
        while running do
            print("Hello world")
            wait(1)
        end
    end)
    coroutine.resume(thread)
end

local function stop()
    running = false
end

return {
    start = start,
    stop = stop
}&#8203;:contentReference[oaicite:2]{index=2}
