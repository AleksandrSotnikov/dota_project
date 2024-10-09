-- modifier_summon_ancient_lords.lua
modifier_summon_ancient_lords = class({})

function modifier_summon_ancient_lords:IsHidden() return true end
function modifier_summon_ancient_lords:IsDebuff() return false end
function modifier_summon_ancient_lords:IsPurgable() return false end

function modifier_summon_ancient_lords:OnCreated()
    local parent = self:GetParent()
    local caster = self:GetCaster()
    local health_multiplier = self:GetAbility():GetSpecialValueFor("health_multiplier")
    
    -- Устанавливаем здоровье скелетов как 150% от здоровья Wraith King
    parent:SetBaseMaxHealth(caster:GetMaxHealth() * health_multiplier / 100)
    parent:SetHealth(caster:GetMaxHealth() * health_multiplier / 100)
    print(32)
end