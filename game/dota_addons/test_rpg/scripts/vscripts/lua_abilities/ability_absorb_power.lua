-- Инициализация переменной для накопления душ (если не инициализировано)
if caster.soul_count == nil then
    caster.soul_count = 0
end

-- Функция для выполнения при убийстве крипа
function AbsorbPower_OnKill(keys)
    local caster = keys.caster
    local ability = keys.ability
    local max_souls = ability:GetSpecialValueFor("max_souls")
    local bonus_per_soul = ability:GetSpecialValueFor("bonus_per_soul")

    -- Проверка на максимальное количество зарядов (душ)
    if caster.soul_count < max_souls then
        -- Увеличиваем количество зарядов
        caster.soul_count = caster.soul_count + 1

        -- Применяем бонусы атрибутов за каждый заряд
        local modifier = caster:FindModifierByName("modifier_absorb_power")
        if modifier then
            caster:SetModifierStackCount("modifier_absorb_power", caster, caster.soul_count)
        else
            caster:AddNewModifier(caster, ability, "modifier_absorb_power", {})
            caster:SetModifierStackCount("modifier_absorb_power", caster, caster.soul_count)
        end
    end
end