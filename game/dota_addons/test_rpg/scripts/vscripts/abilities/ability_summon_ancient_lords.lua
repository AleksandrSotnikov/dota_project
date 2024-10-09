-- ability_summon_ancient_lords.lua
ability_summon_ancient_lords = class({})

LinkLuaModifier("modifier_summon_ancient_lords","abilities/modifier_summon_ancient_lords", LUA_MODIFIER_MOTION_NONE)

function ability_summon_ancient_lords:OnSpellStart()
    self.caster = self:GetCaster()
    
    -- Получаем значения специальных параметров способности
    self.health_multiplier = self:GetSpecialValueFor("health_multiplier")
    self.duration = self:GetSpecialValueFor("skeleton_duration")
    self.skeleton_damage_percent = self:GetSpecialValueFor("skeleton_damage_percent")
    
    -- Для отладки: выводим значения в консоль
    print("Health Multiplier: " .. self.health_multiplier)
    print("Duration: " .. self.duration)
    print("Skeleton Damage Percent: " .. self.skeleton_damage_percent)

    -- Призыв двух скелетов
    for i = 1, 2 do
        local skeleton = CreateUnitByName("npc_dota_wraith_king_skeleton_lord", self:GetCaster():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster():GetOwner(), self:GetCaster():GetTeamNumber())
        
        -- Даем контроль над скелетами игроку
        skeleton:SetControllableByPlayer(self:GetCaster():GetPlayerID(), false)
        skeleton:SetOwner(self:GetCaster())

        -- Устанавливаем здоровье скелетов (150% от текущего здоровья Wraith King)
        skeleton:SetBaseMaxHealth(self:GetCaster():GetHealth() * self.health_multiplier / 100)
        skeleton:SetHealth(self:GetCaster():GetHealth() * self.health_multiplier / 100)

        -- Устанавливаем урон скелетов (70% от урона Wraith King)
        skeleton:SetBaseDamageMin(self:GetCaster():GetBaseDamageMin() * self.skeleton_damage_percent / 100)
        skeleton:SetBaseDamageMax(self:GetCaster():GetBaseDamageMax() * self.skeleton_damage_percent / 100)

        -- Устанавливаем продолжительность существования скелетов
        skeleton:AddNewModifier(self:GetCaster(), self, "modifier_kill", {duration = self.duration})

    end
end
