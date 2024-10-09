-- Функция активации предмета
function MagicalMonometre_Activate(keys)
    local caster = keys.caster
    local radius = keys.ability:GetSpecialValueFor("restore_radius")  -- Радиус восстановления
    local max_mana_restore_percent = 100

    -- Получаем текущий заряд предмета
    local current_mana_restore_percent = caster:GetModifierStackCount("modifier_magical_monometre_charge", caster)
    
    -- Поиск союзников в радиусе
    local allies = FindUnitsInRadius(
        caster:GetTeamNumber(),
        caster:GetAbsOrigin(),
        nil,
        radius,
        DOTA_UNIT_TARGET_TEAM_FRIENDLY,
        DOTA_UNIT_TARGET_HERO,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false
    )
    
    -- Восстанавливаем ману союзникам на процент накопленной энергии
    for _,ally in pairs(allies) do
        local mana_to_restore = ally:GetMaxMana() * (current_mana_restore_percent / max_mana_restore_percent)
        ally:GiveMana(mana_to_restore)
        
        -- Показываем эффект восстановления маны
        SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, ally, mana_to_restore, nil)
    end

    -- Сбросить заряд предмета после активации
    caster:SetModifierStackCount("modifier_magical_monometre_charge", caster, 0)
end

-- Функция накопления заряда магии
function MagicalMonometre_ChargeUp(keys)
    local caster = keys.caster
    local max_charge = 100

    -- Получаем текущий заряд
    local current_charge = caster:GetModifierStackCount("modifier_magical_monometre_charge", caster)

    -- Увеличиваем заряд на 5% при использовании любой способности
    local new_charge = math.min(current_charge + 5, max_charge)
    caster:SetModifierStackCount("modifier_magical_monometre_charge", caster, new_charge)
end