-- modifier_summon_ancient_lords.lua
modifier_wraith_king_hellfire_blast_lua = class({})

function modifier_wraith_king_hellfire_blast_lua:IsHidden() return true end
function modifier_wraith_king_hellfire_blast_lua:IsDebuff() return false end
function modifier_wraith_king_hellfire_blast_lua:IsPurgable() return false end

function modifier_wraith_king_hellfire_blast_lua:OnCreated(kv)
    local parent = self:GetParent()
    local caster = self:GetCaster()
    local health_multiplier = self:GetAbility():GetSpecialValueFor("health_multiplier")
    print("health_multiplier ".. self:GetAbility():GetSpecialValueFor("health_multiplier"))
    -- Устанавливаем здоровье скелетов как 150% от здоровья Wraith King
    parent:SetBaseMaxHealth(caster:GetMaxHealth() * health_multiplier / 100)
    parent:SetHealth(caster:GetMaxHealth() * health_multiplier / 100)
    
end