modifier_absorb_power = class({})

-- Настройки модификатора
function modifier_absorb_power:IsHidden() return false end
function modifier_absorb_power:IsPurgable() return false end
function modifier_absorb_power:RemoveOnDeath() return false end

-- Инициализация переменных
function modifier_absorb_power:OnCreated()
    if IsServer() then
        self.kill_count = 0 -- Счетчик убийств крипов
        self.soul_bonus = 0 -- Текущий бонус к атрибутам
        self.soul_count = 0 -- Общее количество накопленных душ
        self:SetStackCount(self.soul_count) -- Устанавливаем начальное значение для отображения

        self:StartIntervalThink(0.1) -- Запускаем периодический вызов
    end
end

function modifier_absorb_power:OnRefresh()
    if IsServer() then
        self.kill_count = self.kill_count or 0
        self.soul_bonus = self.soul_bonus or 0
        self.soul_count = self.soul_count or 0
        self:SetStackCount(self.soul_count) -- Обновляем количество душ        
    end
end

-- Слушаем событие смерти юнита
function modifier_absorb_power:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_DEATH
    }
end

-- Функция обработки смерти юнита
function modifier_absorb_power:OnDeath(params)
    if IsServer() then
        local dead_unit = params.unit      -- Юнит, который умер
        local killer = params.attacker     -- Юнит, который убил

        -- Проверяем, что убийцей является наш герой (не иллюзия)
        if killer == self:GetParent() and killer:IsRealHero() then
            -- Проверяем, что убитый юнит — крип
            if dead_unit:IsCreep() and not dead_unit:IsBuilding() and not dead_unit:IsOther() then
                -- Увеличиваем счетчик убийств
                self.kill_count = self.kill_count + 1
                
                -- Если убито достаточно крипов для получения одной души (4 убийства)
                local creeps_to_kill = self:GetAbility():GetSpecialValueFor("creeps_to_kill")
                if self.kill_count >= creeps_to_kill then
                    self:GrantSoulBonus()
                    self.kill_count = 0 -- Сброс счетчика
                end
            end
        end
    end
end

-- Функция для начисления бонусов за души
function modifier_absorb_power:GrantSoulBonus()
    if IsServer() then
        local ability = self:GetAbility()
        local current_level = ability:GetLevel() - 1

        -- Получаем значение бонуса за каждую душу на текущем уровне способности
        local bonus_per_soul = ability:GetLevelSpecialValueFor("bonus_per_soul", current_level)
        self.soul_bonus = self.soul_bonus + bonus_per_soul

        -- Применяем бонус к атрибутам героя
        local parent = self:GetParent()
        parent:ModifyStrength(bonus_per_soul)
        parent:ModifyAgility(bonus_per_soul)
        parent:ModifyIntellect(bonus_per_soul)

        -- Увеличиваем счетчик душ и обновляем отображение стека на модификаторе
        self.soul_count = self.soul_count + 1 -- Увеличиваем количество душ
        self:SetStackCount(self.soul_count) -- Обновляем количество душ для отображения

    end
end

-- Периодически обновляем текст на экране, если нужно
function modifier_absorb_power:OnIntervalThink()
    if IsServer() then
        -- Обновление стека модификатора для отображения количества душ
        self:SetStackCount(self.soul_count)
    end
end
