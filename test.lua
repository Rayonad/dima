local running = false

function start()
    running = true
    while running do
        print("Hello world")  -- Вывод в консоль
        wait(2)  -- Пауза 2 секунды
    end
end

function stop()
    running = false
end
