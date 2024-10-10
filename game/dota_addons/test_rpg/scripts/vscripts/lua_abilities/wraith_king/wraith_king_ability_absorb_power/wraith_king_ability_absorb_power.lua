wraith_king_hellfire_blast = class({})

LinkLuaModifier("modifier_wraith_king_soul_collector", "abilities/wraith_king_hellfire_blast", LUA_MODIFIER_MOTION_NONE)

function wraith_king_hellfire_blast:GetIntrinsicModifierName()
    return "modifier_wraith_king_soul_collector"
end

-- Модификатор для накопления душ
modifier_wraith_king_soul_collector = class({})

function modifier_wraith_king_soul_collector:IsHidden() return false end
function modifier_wraith_king_soul_collector:IsPermanent() return true end
function modifier_wraith_king_soul_collector:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_wraith_king_soul_collector:OnCreated()
    self.souls_collected = 0
    self.bonus_per_soul = self:GetAbility():GetLevelSpecialValueFor("bonus_per_soul", self:GetAbility():GetLevel() - 1)
    self.max_souls = self:GetAbility():GetLevelSpecialValueFor("max_souls", 1)
end

function modifier_wraith_king_soul_collector:OnDeath(params)
    if IsServer() then
        local unit = params.unit
        local attacker = params.attacker
        
        -- Если Wraith King убил юнита, собираем душу
        if attacker == self:GetParent() then
            self.souls_collected = math.min(self.souls_collected + 1, self.max_souls)
            self:GetParent():CalculateStatBonus()
        end
    end
end

function modifier_wraith_king_soul_collector:GetModifierBonusStats_Strength()
    if self:GetAbility():GetLevel() > 0 then
        return self.souls_collected * self.bonus_per_soul
    end
    return 0
end

function modifier_wraith_king_soul_collector:GetModifierBonusStats_Agility()
    if self:GetAbility():GetLevel() > 0 then
        return self.souls_collected * self.bonus_per_soul
    end
    return 0
end

function modifier_wraith_king_soul_collector:GetModifierBonusStats_Intellect()
    if self:GetAbility():GetLevel() > 0 then
        return self.souls_collected * self.bonus_per_soul
    end
    return 0
end

function modifier_wraith_king_soul_collector:OnTooltip()
    return self.souls_collected
end

function modifier_wraith_king_soul_collector:GetModifierTooltip()
    return self.souls_collected
end
