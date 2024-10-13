silencer_ability_glaives_of_wisdom = class({})

function silencer_ability_glaives_of_wisdom:OnCreated()

end

function silencer_ability_glaives_of_wisdom:IntToDamage( keys )

    local ability = keys.ability
    local caster = keys.caster
    local target = keys.target
    local int_caster = caster:GetIntellect()
    local int_damage = ability:GetLevelSpecialValueFor("intellect_damage_pct", (ability:GetLevel() -1)) 
    

    local damage_table = {}

    damage_table.attacker = caster
    damage_table.damage_type = ability:GetAbilityDamageType()
    damage_table.ability = ability
    damage_table.victim = target

    damage_table.damage = int_caster * int_damage / 100

    ApplyDamage(damage_table)

end

modifier_custom_attack = class({})

function modifier_custom_attack:GetModifierProjectileName()
    return "particles/units/heroes/hero_silencer/silencer_glaives_of_wisdom.vpcf"
end

function modifier_custom_attack:IsPurgable()    return false end
function modifier_custom_attack:IsHidden()      return false end