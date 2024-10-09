-- Generated from template
require("connect_lib")
require("wave_manager")

if CAddonRRPGGameMode == nil then
	CAddonRRPGGameMode = class({})
end

function Precache( context )

end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = CAddonRRPGGameMode()
	GameRules.AddonTemplate:InitGameMode()
end

local maxLevel = 300
local xpTable = {}


local totalXP = 0
for level = 1, maxLevel do
    local xpRequired = 100 * (level * level)
    totalXP = totalXP + xpRequired
    xpTable[level] = totalXP
end


function CAddonRRPGGameMode:InitGameMode()
	print( "Template addon is loaded." )	
	GameRules:GetGameModeEntity():SetUnseenFogOfWarEnabled( true )
	GameRules:GetGameModeEntity():SetFixedRespawnTime(10)
	GameRules:SetPreGameTime(10) --- Время до старта игры после появления героя
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
	ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(self, "OnGameStateChanged"), self)

	GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, 0)

	GameRules:GetGameModeEntity():SetUseCustomHeroLevels(true) -- установка кастомной системы уровней
	GameRules:GetGameModeEntity():SetCustomHeroMaxLevel(300)

	GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel(xpTable)
end

-- Evaluate the state of the game
function CAddonRRPGGameMode:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		-- print( "Template addon script is running." )
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end

function CAddonRRPGGameMode:OnGameStateChanged()
	print("CAddonRRPGGameMode:OnGameStateChanged()")
    local state = GameRules:State_Get()
	print("OnGameStateChanged()  - " .. state)
	

	-- Find entities by name. Pass 'null' to start an iteration, or reference to a previously found entity to continue a search
    if state == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        WaveManager:Init()
    	WallRemover("wall_")
    	
		print("Игра началась. Запускаем таймер!")

        --Timers:CreateTimer("myTimer", {
        --    endTime = 1, -- Запуск через 1 секунду после начала игры
        --    callback = function()
        --        print("Таймер выполнен! Спавним крипов...")
        --        -- Здесь добавь логику спавна крипов
--
        --        return 30 -- Повторяем каждые 30 секунд
        --    end
        --})
    end
end

--  point_simple_obstruction
function WallRemover(name)
    local wallIndex = 1
    while true do
        local wallPoint = Entities:FindByName(nil, name .. wallIndex)
        if not wallPoint then break end

        wallPoint:RemoveSelf()
        print("Стена ".. name .. wallIndex .. "удалена")
        wallIndex = wallIndex + 1
    end
end