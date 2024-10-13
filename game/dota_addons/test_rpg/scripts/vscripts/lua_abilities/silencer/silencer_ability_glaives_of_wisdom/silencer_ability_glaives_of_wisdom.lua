custom_glaives_of_wisdom = class({})
LinkLuaModifier("modifier_custom_glaives_of_wisdom", "lua_abilities/silencer/silencer_ability_glaives_of_wisdom/modifier_custom_glaives_of_wisdom", LUA_MODIFIER_MOTION_NONE)

-- Функция при активации способности
function custom_glaives_of_wisdom:GetIntrinsicModifierName()
    return "modifier_custom_glaives_of_wisdom"
end

-- Когда способность включается или выключается
function custom_glaives_of_wisdom:OnToggle()
    local caster = self:GetCaster()

    if self:GetToggleState() then
        caster:EmitSound("Hero_Silencer.GlaivesOfWisdom.ToggleOn")
    else
        caster:EmitSound("Hero_Silencer.GlaivesOfWisdom.ToggleOff")
    end
end
