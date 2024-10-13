wraith_king_ability_absorb_power = class({})

LinkLuaModifier("modifier_absorb_power", "lua_abilities/wraith_king/wraith_king_ability_absorb_power/modifier_absorb_power", LUA_MODIFIER_MOTION_NONE)

function wraith_king_ability_absorb_power:GetIntrinsicModifierName()
    return "modifier_absorb_power"
end