print("timer created")
-- Создание таймера, который выполняется каждую секунду
Timers:CreateTimer("myTimer", {
    endTime = 1, -- запуск через 1 секунду
    callback = function()
        print("Таймер выполнен!")
        return 30 -- повторять каждую секунду
    end
})
