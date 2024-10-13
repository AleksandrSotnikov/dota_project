modifier_custom_glaives_of_wisdom = class({})

function modifier_custom_glaives_of_wisdom:IsHidden() return true end
function modifier_custom_glaives_of_wisdom:IsPurgable() return false end
function modifier_custom_glaives_of_wisdom:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,  -- Для нанесения чистого урона
        MODIFIER_EVENT_ON_DEATH,          -- Для получения интеллекта при убийстве
        MODIFIER_PROPERTY_PROJECTILE_NAME,  -- Для изменения снаряда
    }
end

-- Изменение снаряда при атаке
function modifier_custom_glaives_of_wisdom:GetModifierProjectileName()
    if self:GetAbility():GetToggleState() then
        return "particles/units/heroes/hero_silencer/silencer_glaives_of_wisdom.vpcf"
    end
    return nil
end

-- Наносим чистый урон при попадании атаки
function modifier_custom_glaives_of_wisdom:OnAttackLanded(params)
    if params.attacker == self:GetParent() and self:GetAbility():GetToggleState() then
        local intellect = self:GetParent():GetIntellect()
        local damage_percent = self:GetAbility():GetSpecialValueFor("int_damage_percent") / 100
        local pure_damage = intellect * damage_percent

        -- Наносим чистый урон
        ApplyDamage({
            victim = params.target,
            attacker = self:GetParent(),
            damage = pure_damage,
            damage_type = DAMAGE_TYPE_PURE,
            ability = self:GetAbility(),
        })

        -- Эффект
        params.target:EmitSound("Hero_Silencer.GlaivesOfWisdom.Damage")
        local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_silencer/silencer_glaives_of_wisdom_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.target)
        ParticleManager:ReleaseParticleIndex(particle)
    end
end

-- Получаем интеллект за убийство
function modifier_custom_glaives_of_wisdom:OnDeath(params)
    if params.unit:IsRealHero() and params.attacker == self:GetParent() then
        local int_gain = self:GetAbility():GetSpecialValueFor("int_gain")

        -- Увеличиваем интеллект
        self:GetParent():ModifyIntellect(int_gain)

        -- Эффект получения интеллекта
        self:GetParent():EmitSound("Hero_Silencer.GlaivesOfWisdom.Kill")
        local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_silencer/silencer_glaives_of_wisdom_int_gain.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
        ParticleManager:ReleaseParticleIndex(particle)
    end
end
