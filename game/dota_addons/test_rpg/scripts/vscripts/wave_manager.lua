if WaveManager == nil then
    WaveManager = class({})
end

function PrintTable(t, indent)
    indent = indent or 0
    if type(t) ~= "table" then
        print(string.rep("  ", indent) .. tostring(t))
        return
    end
    for k, v in pairs(t) do
        local key = tostring(k)
        if type(v) == "table" then
            print(string.rep("  ", indent) .. key .. ":")
            PrintTable(v, indent + 1)
        else
            print(string.rep("  ", indent) .. key .. ": " .. tostring(v))
        end
    end
end

-- Использование


function WaveManager:Init()
    local waveDataRaw = LoadKeyValues("scripts/kv/wave_config.txt")
    
    if waveDataRaw == nil then
        print("Ошибка загрузки wave_config.txt!")
        return
    end
    
    
    print(waveDataRaw)
    PrintTable(waveDataRaw)
    --self.waveData = waveDataRaw["WaveConfig"]
    --
    --if self.waveData == nil then
    --    print("Ошибка: 'WaveConfig' не найдена в wave_config.txt!")
    --    return
    --end
    
    self.waveData = waveDataRaw["Waves"]
    
    if self.waveData == nil then
        print("Ошибка: 'Waves' не найдены в wave_config.txt!")
        return
    end

    self.currentWave = 1
    self.spawnInterval = 30 -- Интервал между волнами (в секундах)
    self:StartWaveSpawn()
end

-- Вызов обновления волны в UI
function WaveManager:UpdateWaveDisplay(waveNumber)
    CustomGameEventManager:Send_ServerToAllClients("wave_update", { wave = waveNumber })
end


function WaveManager:StartWaveSpawn()
    Timers:CreateTimer("wave_timer", {
        endTime = 0, -- Начинаем сразу
        callback = function()
            self:SpawnWave(self.currentWave)
            WaveManager:UpdateWaveDisplay(self.currentWave-1) -- Вызов обновления волны в UI
            
            return self.spawnInterval
        end
    })
end

function WaveManager:SpawnWave(waveNumber)
    local waveInfo = self.waveData[tostring(waveNumber)]
    if not waveInfo then
        -- Если волн больше нет, возвращаемся к первой волне
        self.currentWave = 1
        waveInfo = self.waveData[tostring(self.currentWave)]
    end

    -- Увеличиваем текущую волну и усиливаем крипов
    self.currentWave = self.currentWave + 1
    local healthMultiplier = 1 + (self.currentWave - 1) * 0.1 -- Увеличиваем здоровье на 10% за каждую волну
    local damageMultiplier = 1 + (self.currentWave - 1) * 0.1 -- Увеличиваем урон на 10% за каждую волну

    -- Спавним крипов первого типа
    local creepType1 = waveInfo["CreepType1"]
    local creepCount1 = tonumber(waveInfo["CreepCount1"])
    for i = 1, creepCount1 do
        self:SpawnCreep(creepType1, healthMultiplier, damageMultiplier)
    end

    -- Спавним крипов второго типа
    local creepType2 = waveInfo["CreepType2"]
    local creepCount2 = tonumber(waveInfo["CreepCount2"])
    for i = 1, creepCount2 do
        self:SpawnCreep(creepType2, healthMultiplier, damageMultiplier)
    end

    print("Wave " .. tostring(waveNumber) .. " spawned.")
end

function WaveManager:SpawnCreep(creepName, healthMultiplier, damageMultiplier)
    local creep = CreateUnitByName(creepName, Vector(-384, 384, 128), true, nil, nil, DOTA_TEAM_BADGUYS)
    if creep then
        -- Усиливаем здоровье и урон
        creep:SetBaseMaxHealth(creep:GetBaseMaxHealth() * healthMultiplier)
        creep:SetHealth(creep:GetBaseMaxHealth())
        creep:SetBaseDamageMin(creep:GetBaseDamageMin() * damageMultiplier)
        creep:SetBaseDamageMax(creep:GetBaseDamageMax() * damageMultiplier)
        WaveManager:MoveCreepAlongPath(creep)  
    end
end

-- wave_manager.lua

function WaveManager:MoveCreepAlongPath(creep)
    local pathPoints = {}

    -- Собираем все точки path_corner
    local pointIndex = 1
    while true do
        local nextPoint = Entities:FindByName(nil, "path_" .. pointIndex)
        if not nextPoint then break end
        table.insert(pathPoints, nextPoint:GetAbsOrigin())
        pointIndex = pointIndex + 1
    end

    if #pathPoints < 2 then return end -- Если недостаточно точек пути, выходим

    local nextPointIndex = 2 -- Начинаем со второго пункта (первый уже является стартовой позицией)
    Timers:CreateTimer(function()
        if not IsValidEntity(creep) or not creep:IsAlive() then return end

        -- Поиск ближайшей цели в радиусе атаки крипа
        local enemies = FindUnitsInRadius(
            creep:GetTeamNumber(),
            creep:GetAbsOrigin(),
            nil,
            creep:Script_GetAttackRange()+100,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_NONE,
            FIND_CLOSEST,
            false
        )

        -- Если есть враги поблизости, атакуем
        if #enemies > 0 then
            creep:MoveToTargetToAttack(enemies[1])
            return 0.1 -- Проверяем каждые 0.1 секунды
        end

        -- Если нет врагов, продолжаем движение по траектории
        local nextPoint = pathPoints[nextPointIndex]
        creep:MoveToPosition(nextPoint)
        

        local distance = (creep:GetAbsOrigin() - nextPoint):Length2D()
        if distance < 100 then
            nextPointIndex = nextPointIndex + 1
            if nextPointIndex > #pathPoints then
                -- Заставляем крипа оставаться на последней позиции
                creep:Stop()
                return
            end
        end

        return 0.1 -- Проверяем каждые 0.1 секунды
    end)
end
