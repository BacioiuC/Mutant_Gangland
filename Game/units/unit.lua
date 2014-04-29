unit = {}

--[[
TO DO: FIX MULTIPLE UNIT ATTACKSSSS!! FFS, FIX IT DAMN IT



]]

function unit:init(_mapFile)
	self._turn = 1 
---------------------------------------
------ TABLES -------------------------
---------------------------------------
	self._teamTexture = { }
	self._teamTexture[1] = { } -- textures for team one
	self._teamTexture[1][1] = { } -- textures for team one, mutants 1
	self._teamTexture[1][1][1] = wanim:newDeck("media/units/team/spottah.png", 32, g_ActionPhaseLayer)
	self._teamTexture[1][1][2] = wanim:newDeck("media/units/team/panza_spottah.png", 32, g_ActionPhaseLayer)
	self._teamTexture[1][1][3] = wanim:newDeck("media/units/team/attacka.png", 32, g_ActionPhaseLayer)
	self._teamTexture[1][1][4] = wanim:newDeck("media/units/team/rockit.png", 32, g_ActionPhaseLayer)
	self._teamTexture[1][1][5] = wanim:newDeck("media/units/team/tank.png", 32, g_ActionPhaseLayer)

	self._teamTexture[1][2] = { } -- textures for team one, robots 1
	self._teamTexture[1][2][1] = wanim:newDeck("media/units/team/scout_robo.png", 32, g_ActionPhaseLayer)
	self._teamTexture[1][2][2] = wanim:newDeck("media/units/team/scout_robo2.png", 32, g_ActionPhaseLayer)
	self._teamTexture[1][2][3] = wanim:newDeck("media/units/team/punchy2.png", 32, g_ActionPhaseLayer)
	self._teamTexture[1][2][4] = wanim:newDeck("media/units/team/robo_rokkit2.png", 32, g_ActionPhaseLayer)
	self._teamTexture[1][2][5] = wanim:newDeck("media/units/team/mecha_robo2.png", 32, g_ActionPhaseLayer)

	self._teamTexture[2] = { } -- textures for team one
	self._teamTexture[2][1] = { } -- textures for team one, mutants 1
	self._teamTexture[2][1][1] = wanim:newDeck("media/units/team/scout_robo_t2.png", 32, g_ActionPhaseLayer)
	self._teamTexture[2][1][2] = wanim:newDeck("media/units/team/scout_robo2_t2.png", 32, g_ActionPhaseLayer)
	self._teamTexture[2][1][3] = wanim:newDeck("media/units/team/punchy.png", 32, g_ActionPhaseLayer)
	self._teamTexture[2][1][4] = wanim:newDeck("media/units/team/robo_rokkit.png", 32, g_ActionPhaseLayer)
	self._teamTexture[2][1][5] = wanim:newDeck("media/units/team/mecha_robo.png", 32, g_ActionPhaseLayer)

	self._teamTexture[2][2] = { } -- textures for team one, robots 1
	self._teamTexture[2][2][1] = wanim:newDeck("media/units/team/spottah2.png", 32, g_ActionPhaseLayer)
	self._teamTexture[2][2][2] = wanim:newDeck("media/units/team/panza_spottah2.png", 32, g_ActionPhaseLayer)
	self._teamTexture[2][2][3] = wanim:newDeck("media/units/team/attacka2.png", 32, g_ActionPhaseLayer)
	self._teamTexture[2][2][4] = wanim:newDeck("media/units/team/rockit2.png", 32, g_ActionPhaseLayer)
	self._teamTexture[2][2][5] = wanim:newDeck("media/units/team/tank2.png", 32, g_ActionPhaseLayer)

	self._commanderTexture = { }
	self._commanderTexture[1] = { }
	self._commanderTexture[1][1] = wanim:newDeck("media/units/team/gangbosses.png", 48, g_ActionPhaseLayer)

	self._commanderTexture[2] = { }
	self._commanderTexture[2][1] = wanim:newDeck("media/units/team/gangbosses.png", 48, g_ActionPhaseLayer)	

	self._unitTable = {}
	self._compUnits = {} -- used to store and handle NPC's
	self._plUnits = {} -- used to store and handle Player Units



	self._selectedUnits = {}
	self._selectedColor = {}
	self._selectedColor[1] = {}
	self._selectedColor[2] = {}
	self._teamTex = {}

	self._rangeTable = {} -- holds the images used to draw a unit's range of attack.
	self._internalRangeTable = { } -- holds no images, just locations
	self._pathTable = { } -- keeps track of all the images used to draw the unit's path
	self._movableAreas = { }

	self._targetTable = {}
	self._targetRetTable = {}

	self._objectiveState = 1
	self._objectiveSet = false
	self._debugTpX = nil
	self._debugTpY = nil

	self._destPath = { x = nil, y = nil }

	self._teamToPlayer = {} -- basically, calls player1 or 2 based on turn
	self._teamToPlayer[1] = player1
	self._teamToPlayer[2] = player2

	self._conditionTable = {}


	self._teamUnitList = {}
	self._pIDX = 1


	self._unitBuildList = { }
	self._unitBuildList = { p1 = 0, p2 = 0 }
	self._debugSelectedUnit = nil -- used when two units are overlapping

	self._unitsLost = { p1 = 0, p2 = 0}

	self._damageDealt = { p1 = 0, p2 = 0 }
	self._damageDealthTable = { }
	self._damageDealthTable[1] = self._damageDealt.p1
	self._damageDealthTable[2] = self._damageDealt.p2

	step = {} -- handles Game steps: - Build! Move! Attack! 
	step[1] = "Build"
	step[2] = "Move"
	step[3] = "Attack"

	self._acceptMove = false	
	currentStep = 1
---------------------------------------
------ TEXTURES -----------------------
---------------------------------------
	self._teamTex[1] = wanim:newDeck("media/units/bomb_unit_1.png", 32, g_ActionPhaseLayer)--image:newDeckTexture("media/team_1_units.png", 1, "un_tex", 32, "NotNill")
	self._teamTex[2] = wanim:newDeck("media/units/chainsaw_unit_1.png", 32, g_ActionPhaseLayer)--image:newDeckTexture("media/team_2_units.png", 1, "un_tex_2", 32, "NotNill")
	self._teamTex[3] = wanim:newDeck("media/units/skull_unit_1.png", 32, g_ActionPhaseLayer)
	self._teamTex[4] = wanim:newDeck("media/units/rocket_unit_1.png", 32, g_ActionPhaseLayer)
	self._teamTex[5] = wanim:newDeck("media/units/tank_unit_1.png", 32, g_ActionPhaseLayer)

	self._teamTex[6] = wanim:newDeck("media/units/bomb_unit_2.png", 32, g_ActionPhaseLayer)--image:newDeckTexture("media/team_1_units.png", 1, "un_tex", 32, "NotNill")
	self._teamTex[7] = wanim:newDeck("media/units/chainsaw_unit_2.png", 32, g_ActionPhaseLayer)--image:newDeckTexture("media/team_2_units.png", 1, "un_tex_2", 32, "NotNill")
	self._teamTex[8] = wanim:newDeck("media/units/skull_unit_2.png", 32, g_ActionPhaseLayer)
	self._teamTex[9] = wanim:newDeck("media/units/rocket_unit_2.png", 32, g_ActionPhaseLayer)
	self._teamTex[10] = wanim:newDeck("media/units/mech_unit_2.png", 32, g_ActionPhaseLayer)

	--self._damageAnim_Tex = wanim:newDeck("media/damage_anim.png", 32, g_ActionPhase_UI_Layer)
	--damage_anim = anim:newAnim(self._damageAnim_Tex, 6, -500, 5000, 1)
	--ephraim_anim_set -- ephraim_anim_set2


	self._movementRange_tex = wanim:newDeck("media/_range.png", 32, g_RangeLayer) --image:newTexture("media/_range.png", g_RangeLayer, "range_tex")
	self._mvRangeBad_tex = wanim:newDeck("media/_range_bad.png", 32, g_RangeLayer)--image:newTexture("media/_range_bad.png", g_RangeLayer, "range_bad_tex")
	self._path_tex = wanim:newDeck("media/_path.png", 32, g_GroundLayer)--image:newDeckTexture("media/_path.png", g_RangeLayer, "path_tex", 32, "NotNill")

	self._captureHouse_tex = wanim:newDeck("media/capture_house.png", 32, g_ActionPhase_UI_Layer) -- top most

	self._touchRipple_tex = wanim:newDeck("media/confirmMoveAnimation.png", 32, g_ActionPhase_UI_Layer)

	self._touchRipple = anim:newAnim(self._touchRipple_tex, 10, -20000, 0, 10 )
	--anim:addToPool(self._touchRipple)
	self._rippleX = -2000
	self._rippleY = -2000
	self._ripX = 0
	self._ripY = 0
	self._healthBar_base = wimage:newTexture("media/hb_front.png", g_ActionPhase_UI_Layer, "hb_base_tex")
	self._healthBar_cover = wimage:newTexture("media/hb_background.png", g_ActionPhase_UI_Layer, "hb_cov_tex")
	self._healthbar_bg_anim = wanim:newDeck("media/hb_background_anim.png", 32, g_ActionPhase_UI_Layer)
	self._healthBar_base2 = wimage:newTexture("media/hb_front2.png", g_ActionPhase_UI_Layer, "hb_base2_tex")

	self._hbTable = {}
	self._hbTable[1] = self._healthBar_base
	self._hbTable[2] = self._healthBar_base2
	self._crossHair_tex = wimage:newTexture("media/crosshair_tex.png", g_RangeLayer, "cross_hair_tex")

	self._ssjAnim_tex = wanim:newDeck("media/MGL_Sayan01.png", 64, g_ActionPhaseLayer )

	anim:createState("SSJ_OFF", 1, 1, 10)
	anim:createState("SSJ_POWER", 2, 5, 0.08)
	anim:createState("SSJ_ON", 7, 10, 0.1)
	--self._ssjAnim = anim:newAnim(self._ssjAnim_tex, 4, -20000, 0, 1)

	self._aiPointerAnim = wanim:newDeck("media/ai_char_pointer.png", 32, g_RangeLayer)
	self._aiPointer = anim:newAnim(self._aiPointerAnim, 2, -320, -320, 1)

	self._explosionAnimEffect = wanim:newDeck("media/MGL_Explosion.png", 64, g_ActionPhaseLayer)
	self._healthAnimEffect = wanim:newDeck("media/MGL_PlusHealth.png", 64, g_ActionPhaseLayer)
	self._auraEffect = wanim:newDeck("media/aura_effect.png", 64,  g_RangeLayer)

	self._attackTextTable = {}
	self._inRangeUnitHpTable = {}
---------------------------------------
------ VARIABLES ----------------------
---------------------------------------
	self._tileSize = 32
	self._offsetX = 0
	self._offsetY = 0
	self.___msx = 0 -- mouse y coord
	self.___msy = 0 -- mouse y coord
	self._msx = 0 -- mouseWorld x coord
	self._msy = 0 -- mouseWorld y coord

	self._movableAreas[1] = 1073741825
	self._movableAreas[2] = 1073741826

	self._cpIDX = 1 -- index used to move computer units during their turn

	

	self._turns = 0 -- counts numbr of turns passed

	self._target = nil

	self._attackMode = false


	self._touchEventType = nil

	self._turnCounter = 1

	self._entityOnReleased = nil

	self._canMouseBeTrusted = true

	self._globalUnitAction = false

	self._onUi = false

	self._awatingCommand = false

	
	self._selectState = 1
	self._actionState = 2
	self._selectAttackState = 3
	self._confirmAction = 4

	self._actionState = self._selectState
------ SELECTION COLORS ---------------

	self._selectedColor[1].r = 240
	self._selectedColor[1].g = 15	
	self._selectedColor[1].b = 240
	self._selectedColor[1].a = 1

	self._selectedColor[2].r = 1
	self._selectedColor[2].g = 1	
	self._selectedColor[2].b = 1
	self._selectedColor[2].a = 1
---------------------------------------
------ FUNCTIONS-----------------------
---------------------------------------
	--unit:new(1,4,3, 1)


	--unit:new(2,15,9, 1)
	--unit:new(2,14,7, 2)

---------------------------------------
------ ANIMATION-----------------------
---------------------------------------



	anim:createState("HURT", 17, 23, 0.1)
	anim:createState("HEALED", 25, 36, 0.08)

	anim:createState("HB_BG", 1, 2, 0.2)
	anim:createState("HB_FLASH", 3, 6, 0.3)

	anim:createState("POINTER_T1", 1, 1, 5)
	anim:createState("POINTER_T2", 2, 2, 5)

	self._animString = {}
	self._animString[1] = ""
	self._animString[2] = "F2"

	self:_createStatesForUnits( )

	unit:addUnitsToMap(_mapFile)

	dave:init( )
	elenoir:init( )
	francois:init( )
	gharcea:init( )
	harrold:init( )
	irene:init( )
	juliette:init( )

	self:_setWinCondition(Game.winCondition)
	sound:playFromCategory(SOUND_BGMUSIC)

	--self._turn = 2
	self._turnDelay = 1
	self._changingTurns = 4

	self._falseTurn = 1 -- not actual turn.... Ya'll see


	-----------------------------
	---
	-- MESSY STUFF STARTING HERE! Pls fix :(

	self._scrollCameraToPlayerOnTurnOne = false -- deliberately huge name, so I'll feel ashamed and FIX this hack later
	self._lastDirtyHack = false
	---
	---
	----------------------
end

function unit:_createStatesForUnits( )
	local attack_speed = 0.06

	self._animStates = { }
	self._animStates[1] = { } -- for Mutants
	self._animStates[2] = { } -- for robots
	self._animStates[3] = { } -- for commanders

	anim:createState("SPOTTAH_IDLE", 1, 4, 0.13)
	anim:createState("SPOTTAH_IDLE_LEFT", 5, 8, 0.13)
	anim:createState("SPOTTAH_ATTACK", 10, 18, attack_speed)
	anim:createState("SPOTTAH_ATTACK_LEFT", 19, 27, attack_speed)

	
	
	anim:createState("PANZASPOTTAH_IDLE", 1, 4, 0.13)
	anim:createState("PANZASPOTTAH_IDLE_LEFT", 5, 8, 0.13)
	anim:createState("PANZASPOTTAH_ATTACK", 12, 22, attack_speed)
	anim:createState("PANZASPOTTAH_ATTACK_LEFT", 23, 33, attack_speed)

	anim:createState("ATTACKA_IDLE", 1, 4, 0.13)
	anim:createState("ATTACKA_IDLE_LEFT", 5, 8, 0.13)
	anim:createState("ATTACKA_ATTACK", 11, 20, attack_speed)
	anim:createState("ATTACKA_ATTACK_LEFT", 21, 30, attack_speed)

	anim:createState("ROKKIT_IDLE", 1, 4, 0.13)
	anim:createState("ROKKIT_IDLE_LEFT", 5, 8, 0.13)
	anim:createState("ROKKIT_ATTACK", 12, 22, attack_speed)
	anim:createState("ROKKIT_ATTACK_LEFT", 22, 32, attack_speed)

	anim:createState("TANK_IDLE", 1, 4, 0.13)
	anim:createState("TANK_IDLE_LEFT", 5, 8, 0.13)
	anim:createState("TANK_ATTACK", 12, 22, attack_speed)
	anim:createState("TANK_ATTACK_LEFT", 22, 32, attack_speed)

	anim:createState("ROBO_IDLE", 1, 4, 0.13)
	anim:createState("ROBO_IDLE_LEFT", 5, 8, 0.13)
	anim:createState("ROBO_ATTACK", 15, 28, attack_speed)
	anim:createState("ROBO_ATTACK_LEFT", 29, 42, attack_speed)

	anim:createState("ROBO2_IDLE", 1, 4, 0.13)
	anim:createState("ROBO2_IDLE_LEFT", 5, 8, 0.13)
	anim:createState("ROBO2_ATTACK", 11, 19, attack_speed)
	anim:createState("ROBO2_ATTACK_LEFT", 21, 29, attack_speed)

	anim:createState("PUNCHY_IDLE", 1, 4, 0.13)
	anim:createState("PUNCHY_IDLE_LEFT", 5, 8, 0.13)
	anim:createState("PUNCHY_ATTACK", 13, 24, attack_speed)
	anim:createState("PUNCHY_ATTACK_LEFT", 25, 36, attack_speed)

	anim:createState("ROBO_ROKKIT_IDLE", 1, 4, 0.13)
	anim:createState("ROBO_ROKKIT_IDLE_LEFT", 5, 8, 0.13)
	anim:createState("ROBO_ROKKIT_ATTACK", 12, 21, attack_speed)
	anim:createState("ROBO_ROKKIT_ATTACK_LEFT", 22, 31, attack_speed)

	anim:createState("MECHA_IDLE", 1, 4, 0.13)
	anim:createState("MECHA_IDLE_LEFT", 5, 8, 0.13)
	anim:createState("MECHA_ATTACK", 11, 22, attack_speed)
	anim:createState("MECHA_ATTACK_LEFT", 23, 34, attack_speed)


	anim:createState("PRIMA_IDLE", 1, 2, 0.13)
	anim:createState("PRIMA_IDLE_LEFT", 1, 2, 0.13)
	anim:createState("PRIMA_ATTACK_RIGHT", 3, 4, attack_speed)
	anim:createState("PRIMA_ATTACK_LEFT", 3, 4, attack_speed)

	anim:createState("SIGNAL_IDLE", 5, 6, 0.13)
	anim:createState("SIGNAL_IDLE_LEFT", 5, 6, 0.13)
	anim:createState("SIGNAL_ATTACK_RIGHT", 7, 8, attack_speed)
	anim:createState("SIGNAL_ATTACK_LEFT", 7, 8, attack_speed)

	anim:createState("THUNDERBYTE_IDLE", 9, 10, 0.13)
	anim:createState("THUNDERBYTE_IDLE_LEFT", 9, 10, 0.13)
	anim:createState("THUNDERBYTE_ATTACK_RIGHT", 11, 12, attack_speed)
	anim:createState("THUNDERBYTE_ATTACK_LEFT", 11, 12, attack_speed)

	anim:createState("TWINNINGS_IDLE", 13, 14, 0.13)
	anim:createState("TWINNINGS_IDLE_LEFT", 13, 14, 0.13)
	anim:createState("TWINNINGS_ATTACK_RIGHT", 15, 16, attack_speed)
	anim:createState("TWINNINGS_ATTACK_LEFT", 15, 16, attack_speed)

	self._animStates[1][1] = { idle = "SPOTTAH_IDLE", attack = "SPOTTAH_ATTACK", left = "SPOTTAH_IDLE_LEFT", aleft = "SPOTTAH_ATTACK_LEFT"  } -- spottah 
	self._animStates[1][2] = { idle = "SPOTTAH_IDLE", attack = "PANZASPOTTAH_ATTACK", left = "SPOTTAH_IDLE_LEFT", aleft = "PANZASPOTTAH_ATTACK_LEFT"} -- spottah 
	self._animStates[1][3] = { idle = "ATTACKA_IDLE", attack = "ATTACKA_ATTACK", left = "SPOTTAH_IDLE_LEFT", aleft = "ATTACKA_ATTACK_LEFT" } -- spottah 
	self._animStates[1][4] = { idle = "ROKKIT_IDLE", attack = "ROKKIT_ATTACK", left = "SPOTTAH_IDLE_LEFT", aleft = "ROKKIT_ATTACK_LEFT" } -- spottah 
	self._animStates[1][5] = { idle = "TANK_IDLE", attack = "TANK_ATTACK", left = "SPOTTAH_IDLE_LEFT", aleft = "TANK_ATTACK_LEFT" } -- spottah 

	self._animStates[2][1] = { idle = "ROBO_IDLE", attack = "ROBO_ATTACK", left = "SPOTTAH_IDLE_LEFT", aleft = "ROBO_ATTACK_LEFT" } 
	self._animStates[2][2] = { idle = "ROBO2_IDLE", attack = "ROBO2_ATTACK", left = "SPOTTAH_IDLE_LEFT", aleft = "ROBO2_ATTACK_LEFT" } 
	self._animStates[2][3] = { idle = "PUNCHY_IDLE", attack = "PUNCHY_ATTACK", left = "SPOTTAH_IDLE_LEFT", aleft = "PUNCHY_ATTACK_LEFT" }
	self._animStates[2][4] = { idle = "ROBO_ROKKIT_IDLE", attack = "ROBO_ROKKIT_ATTACK", left = "SPOTTAH_IDLE_LEFT", aleft = "ROBO_ROKKIT_ATTACK_LEFT" }  
	self._animStates[2][5] = { idle = "MECHA_IDLE", attack = "MECHA_ATTACK", left = "SPOTTAH_IDLE_LEFT", aleft = "MECHA_ATTACK_LEFT" } 

	self._animStates[3][1] = { idle = "PRIMA_IDLE", attack = "PRIMA_ATTACK_RIGHT", left = "PRIMA_IDLE_LEFT", aleft = "PRIMA_ATTACK_LEFT"  } -- spottah 
	self._animStates[3][2] = { idle = "SIGNAL_IDLE", attack = "SIGNAL_ATTACK_RIGHT", left = "SIGNAL_IDLE_LEFT", aleft = "SIGNAL_ATTACK_LEFT"  } -- spottah 
	self._animStates[3][3] = { idle = "THUNDERBYTE_IDLE", attack = "THUNDERBYTE_ATTACK_RIGHT", left = "THUNDERBYTE_IDLE_LEFT", aleft = "THUNDERBYTE_ATTACK_LEFT"  } -- spottah 
	self._animStates[3][4] = { idle = "TWINNINGS_IDLE", attack = "TWINNINGS_ATTACK_RIGHT", left = "TWINNINGS_IDLE_LEFT", aleft = "TWINNINGS_ATTACK_LEFT"  } -- spottah 

	
end

function unit:setOnUi(_bool)
	self._onUi = _bool
end

function unit:getOnUi( )
	return self._onUi
end

function unit:_setPointerAt(_x, _y, _team)
	anim:setState(self._aiPointer, "POINTER_T".._team.."")
	anim:updateAnim(self._aiPointer, _x, _y)
end

function unit:addUnitsToMap(_mapFile)
	_T1BombUnit = 1073741825
	_T1ChainUnit = 1073741826
	_T1SkullUnit = 1073741827
	_T1RocketUnit = 1073741828
	_T1Tank = 1073741829

	_T2BombUnit = 1073741830
	_T2ChainUnit = 1073741831
	_T2SkullUnit = 1073741832
	_T2RocketUnit = 1073741833
	_T2MechUnit = 1073741834


	local tb3
	if _mapFile == "temp_test_map022701227" then 
		tb3 = table.load(pathToWrite.."player_map/".._mapFile..".mie")
	else
		local pathCat = interface:_returnPathCategory( )

		tb3 = table.load(""..pathCat.map.."/".._mapFile..".mie")
	end	
	
	for x = 1, #tb3 do
		for y = 1, #tb3[x] do
			local _tbVal = tb3[x][y]
			if _tbVal == _T1BombUnit then
				unit:new(1, x, y, 1, false)
			elseif _tbVal == _T1ChainUnit then
				unit:new(1, x, y, 2, false)
			elseif _tbVal == _T1SkullUnit then
				unit:new(1, x, y, 3, false)
			elseif _tbVal == _T1RocketUnit then
				unit:new(1, x, y, 4, false)
			elseif _tbVal == _T1Tank then
				unit:new(1, x, y, 5, false)
			elseif _tbVal == _T2BombUnit then
				unit:new(2, x, y, 1, false)
			elseif _tbVal == _T2ChainUnit then
				unit:new(2, x, y, 2, false)
			elseif _tbVal == _T2SkullUnit then
				unit:new(2, x, y, 3, false)
			elseif _tbVal == _T2RocketUnit then	
				unit:new(2, x, y, 4, false)	
			elseif _tbVal == _T2MechUnit then
				unit:new(2, x, y, 5, false)	
			end	
		end
	end

	unit:newCommander(1, 1, 1, 1)
	unit:newCommander(1, 2, 1, 2)
	unit:newCommander(1, 1, 2, 3)
	unit:newCommander(1, 2, 2, 4)

	unit:newCommander(2, 7, 5, 1)
	unit:newCommander(2, 7, 6, 2)
	unit:newCommander(2, 7, 7, 3)
	unit:newCommander(2, 6, 5, 4)
end

---------------------------------------
------ SPAWNING/CREATION/GENERATION----
---------------------------------------
function unit:new(_team,_x, _y, _type, _doneFlagOptional)
	local untTeam = self._teamToPlayer[_team].team
	local temp = {
		id = #self._unitTable + 1,
		x = math.floor(_x),
		y = math.floor(_y),
		tp = _type,
		team = _team,
		--img = anim:newAnim(self._teamTex[unit_type[_team][_type].tex], 16, -300-9000, 0, 1),--image:newDeckImage(self._teamTex[_team], 0, 0, unit_type[_type].tex),
		img = anim:newAnim(self._teamTexture[_team][untTeam][_type], 16, -300-9000, 0, 1),--image:newDeckImage(self._teamTex[_team], 0, 0, unit_type[_type].tex),
		damage = unit_type[untTeam][_type].damage,
		path = {},
		length = 0, -- how many steps the path has
		cur = 1,
		isThere = false,
		isMoving = false,
		goal_x = 0,
		goal_y = 0,
		act_x = _x,
		act_y = _y,
		isSelected = false,
		speed = 1.25, -- Timer difference actually
		move_speed = 0.25,
		moveTimer = Game.worldTimer, 
		initital_hp = unit_type[untTeam][_type].health,
		hp = unit_type[untTeam][_type].health,
		displayHP = unit_type[untTeam][_type].health,
	--	hb_c = anim:newAnim(self._healthbar_bg_anim, 6, _x*32-9000, _y*32-9000, 1 ),--image:newImage(self._healthBar_cover, _x*32, _y*32),
	--	hb_b = image:newImage(self._hbTable[_team], _x*32-9000, _y*32-9000),
		issuedOrder = false,
		done = false,
		can_attack = false,
		has_attacked = false,
		targeted = false,
		moveted = false, -- hehe, movemeted
		attack_range = 2,
		min_attack_range = 2,
		old_x = _x,
		old_y = _y,
		__debugDispRange = false,
		objectiveSet = false,
		rival = nil,
		disabled = false,
		hasGoal = false,
		name = ""..math.random(1, 400).."",
		ap = 10,
		prepareDeath = false,
		--type_tex = font:newWord(_x*32-9000, _y*32-9000, "S", "media/MGL_font_Smallest2.png", 16, true, 7),
		hb_text = font:newWord(_x*32-9000, _y*32-9000, "10       ", "media/MGL_font_Smallest2.png", 16, true, 7),
		faction = untTeam,
		retreat = false,
		isCommander = false,
	--	healthGrid = mGrid:new(, _height, _tileSize, _image, _optionalGridTile, _string, _optionalLayer)
	--[[
font:newWord(_x*32, _y*32, "10 ", "media/MGL_font_Smallest2.png", 16, true, 2),
font:setText(v.hb_text, ""..fontHP.."", v.act_x+2, v.act_y-8)
	]]

		
	}


	if temp.team == 1 then
		temp.range = unit_type[untTeam][temp.tp].mobility
		temp.attack_range = unit_type[untTeam][temp.tp].max_range
		temp.min_attack_range = unit_type[untTeam][temp.tp].min_range

		temp.player = "player"
		self._unitBuildList.p1 = self._unitBuildList.p1 + 1
	else
		temp.range = unit_type[untTeam][temp.tp].mobility
		temp.attack_range = unit_type[untTeam][temp.tp].max_range
		temp.min_attack_range = unit_type[untTeam][temp.tp].min_range
		temp.player = "computer"

		self._unitBuildList.p2 = self._unitBuildList.p2 + 1

		if temp.faction == 1 then
			temp.faction = 2
		elseif temp.faction == 2 then
			temp.faction = 1
		end
	end

	--[[

healthGrid = mGrid:new(, _height, _tileSize, _image, _optionalGridTile, _string, _optionalLayer)
	]]

	local hbWidth = math.ceil(temp.hp/2)
	local hbHeight = 2
	local hbTileSize = 4
	--healthbar_new.png
	local tileIndex = temp.team+1
	temp.healthGrid = mGrid:new(hbWidth, hbHeight, hbTileSize, "Game/media/healthbar_new.png", tileIndex, "HBGrid"..math.random(1, 90000).."", g_ActionPhase_UI_Layer)
	--mGrid:setIndex(temp.healthGrid, 2)

	temp.eff = nil
	temp.canConquer = unit_type[untTeam][temp.tp].canCapture
	table.insert(self._unitTable, temp)

	anim:setState(temp.img, self._animStates[temp.faction][temp.tp].idle)
	--anim:setState(temp.hb_c, "HB_BG")

	anim:flip(temp.img, true)

	map:_updateFogOfWar( )

	if  _doneFlagOptional ~= nil then
		temp.done =  _doneFlagOptional
	else
		temp.done = true
	end
end

function unit:newCommander(_team, _x, _y, _type, _doneFlagOptional)
	local untTeam = self._teamToPlayer[_team].team
	local temp = {
		id = #self._unitTable + 1,
		x = math.floor(_x),
		y = math.floor(_y),
		tp = _type,
		team = _team,
		--img = anim:newAnim(self._teamTex[unit_type[_team][_type].tex], 16, -300-9000, 0, 1),--image:newDeckImage(self._teamTex[_team], 0, 0, unit_type[_type].tex),
		--image:newDeckImage(self._teamTex[_team], 0, 0, unit_type[_type].tex),
		damage = unit_type[untTeam][_type].damage,
		path = {},
		length = 0, -- how many steps the path has
		cur = 1,
		isThere = false,
		isMoving = false,
		goal_x = 0,
		goal_y = 0,
		act_x = _x,
		act_y = _y,
		isSelected = false,
		speed = 1.25, -- Timer difference actually
		move_speed = 0.25,
		moveTimer = Game.worldTimer, 
		initital_hp = commander_type[untTeam][_type].health,
		hp = commander_type[untTeam][_type].health,
		displayHP = commander_type[untTeam][_type].health,
		hb_c = anim:newAnim(self._healthbar_bg_anim, 6, _x*32-9000, _y*32-9000, 1 ),--image:newImage(self._healthBar_cover, _x*32, _y*32),
		hb_b = image:newImage(self._hbTable[_team], _x*32-9000, _y*32-9000),
		issuedOrder = false,
		done = false,
		can_attack = false,
		has_attacked = false,
		targeted = false,
		moveted = false, -- hehe, movemeted
		attack_range = 2,
		min_attack_range = 2,
		old_x = _x,
		old_y = _y,
		__debugDispRange = false,
		objectiveSet = false,
		rival = nil,
		disabled = false,
		hasGoal = false,
		name = ""..math.random(1, 400).."",
		ap = 10,
		prepareDeath = false,
		--type_tex = font:newWord(_x*32-9000, _y*32-9000, "S", "media/MGL_font_Smallest2.png", 16, true, 7),
		hb_text = font:newWord(_x*32-9000, _y*32-9000, "10       ", "media/MGL_font_Smallest2.png", 16, true, 7),
		faction = untTeam,
		retreat = false,
		isCommander = true,

	--[[
font:newWord(_x*32, _y*32, "10 ", "media/MGL_font_Smallest2.png", 16, true, 2),
font:setText(v.hb_text, ""..fontHP.."", v.act_x+2, v.act_y-8)
	]]

		
	}
	--[[
		-- TEMPORARY TEX FILE:
		frame/tiles got from 1 file: Offset is 2 for team.
		1-2 frames: idle
		3-4 attack

		That's type*4 for individual images.

		-- TODO: Anim states going from type/team



	]]
--[[


 

]]
	 
	local cTex = commander_type[_team][_type].tex*4
	local stateStart, stateEnd = commander_type[_team][_type].start, commander_type[_team][_type].send
	temp.stateName = "".._type.."_".._team..""
	anim:createState(""..temp.stateName.."", stateStart, stateStart+1, 0.14)
	temp.img = anim:newAnim(self._commanderTexture[1][1], 28, -300-9000, 0, cTex)

	anim:setState(temp.img, temp.stateName)

	if temp.team == 1 then
		--[[temp.range = 8--unit_type[untTeam][temp.tp].mobility
		temp.attack_range = unit_type[untTeam][temp.tp].max_range
		temp.min_attack_range = unit_type[untTeam][temp.tp].min_range
--]]
		temp.player = "player"
		self._unitBuildList.p1 = self._unitBuildList.p1 + 1
	else
		--[[temp.range = 8--unit_type[untTeam][temp.tp].mobility
		temp.attack_range = unit_type[untTeam][temp.tp].max_range
		temp.min_attack_range = unit_type[untTeam][temp.tp].min_range
		--]]
		temp.player = "computer"
		self._unitBuildList.p2 = self._unitBuildList.p2 + 1

		if temp.faction == 1 then
			temp.faction = 2
		elseif temp.faction == 2 then
			temp.faction = 1
		end
	end
	temp.range = commander_type[untTeam][temp.tp].mobility--unit_type[untTeam][temp.tp].mobility
	temp.attack_range = commander_type[untTeam][temp.tp].max_range
	temp.min_attack_range = commander_type[untTeam][temp.tp].min_range
	--commander_type

	local hbWidth = math.ceil(temp.hp/2)
	local hbHeight = 2
	local hbTileSize = 4
	--healthbar_new.png
	local tileIndex = temp.team+1
	temp.healthGrid = mGrid:new(hbWidth, hbHeight, hbTileSize, "Game/media/healthbar_new.png", tileIndex, "HBGrid"..math.random(1, 90000).."", g_ActionPhase_UI_Layer)
	--mGrid:setIndex(temp.healthGrid, 2)


	temp.eff = nil
	temp.canConquer = commander_type[untTeam][temp.tp].canCapture
	table.insert(self._unitTable, temp)

	--anim:setState(temp.img, self._animStates[temp.faction][temp.tp].idle)
	anim:setState(temp.hb_c, "HB_BG")

	anim:flip(temp.img, true)

	map:_updateFogOfWar( )

	if  _doneFlagOptional ~= nil then
		temp.done =  _doneFlagOptional
	else
		temp.done = true
	end
end

function unit:_getNrUnitsBuilt( )
	return self._unitBuildList
end

function unit:_getNrUnitsLost( )
	return self._unitsLost
end

function unit:_getTotalDamagedDealt( )
	return self._damageDealt 
end

--------

function unit:_getNrOfUnitsLeftToMove( )
	local unitCounter = 0
	local turn = self._turn

	for i,v in ipairs(self._unitTable) do
		if v.team == turn and v.done == false then
			unitCounter = unitCounter + 1
		end
	end

	return unitCounter
end
----------------------------------------
------ DRAWING FUNCTIONS ---------------
----------------------------------------

function unit:_getOffset( )
	return self._offsetX, self._offsetY
end

function unit:_getTileSize( )
	return self._tileSize
end

function unit:draw(_id)
	local v = self._unitTable[_id]
	local offsetX = 0
	local offsetY = 0
	if v.isCommander == false then
		v.act_x = v.x * self._tileSize - self._tileSize+self._offsetX
		v.act_y = v.y * self._tileSize - self._tileSize+self._offsetY-5
	else
		v.act_x = v.x * self._tileSize - self._tileSize+self._offsetX
		v.act_y = v.y * self._tileSize - self._tileSize+self._offsetY-5

		offsetX = 8
		offsetY = 11
	end
	if v.done == true then
		image:setColor(v.img.img, 120, 120, 120, 1)
	end
	--image:updateImage(v.img, v.act_x, v.act_y)
	
	local _bool = true
	if Game.globalFogOfWar == true then
		if mGrid:getTile(3, v.x, v.y) == 3 then
			anim:updateAnim(v.img, v.act_x - offsetX , v.act_y - offsetY)
			_bool = true

		else
			_bool = false
		end
	else
		anim:updateAnim(v.img, v.act_x - offsetX , v.act_y - offsetY)

	end
		image:setVisible(v.img.img, _bool)
		
		unit:_drawHealthbar(_id, _bool)
	
	local fontHP
	if math.floor(v.displayHP) ~= math.floor(v.hp) then
		--print("DISPLAY: "..v.displayHP.." ACTUAL: "..v.hp.."")
		fontHP = ""..math.floor(v.displayHP*10).."/"..math.floor(v.hp*10)..""
		font:setText(v.hb_text, ""..fontHP.."", v.act_x-9, v.act_y-13, _bool)
	else
		fontHP = ""..math.floor(v.displayHP*10)..""
		font:setText(v.hb_text, ""..fontHP.."", v.act_x+2, v.act_y-13, _bool)
	end

	--[[if v.tp == 1 or v.tp == 2 then
		font:setText(v.type_tex, "S", v.act_x + 16, v.act_y + 10)
	else
		font:setText(v.type_tex, "B", v.act_x + 16, v.act_y + 10)
	end--]]
	
--[[
font:newWord(_x*32, _y*32, "10 ", "media/MGL_font_Smallest2.png", 16, true, 2),

]]


end

function unit:_drawHealthbar(_id, _bool)
	local v = self._unitTable[_id]
	local scaleFactor = 1 - ( (100 - ( (100 * v.displayHP) / v.initital_hp ) ) / 100 )

	--commander_type[
	local checkTable = unit_type
	if v.isCommander == true then
		checkTable = commander_type
	end

	if v.hp < 0 then
		v.hp = 0
	elseif v.hp > checkTable[v.team][v.tp].health then
		v.hp = checkTable[v.team][v.tp].health
	end

	if v.displayHP < 0 then
		v.displayHP = 0
	elseif v.displayHP > checkTable[v.team][v.tp].health then
		v.displayHP = checkTable[v.team][v.tp].health
	end
	--image:_setScale(v.hb_b, scaleFactor, 1)
	--image:updateImage(v.hb_b, v.act_x, v.act_y-3 )
	--image:updateImage(v.hb_b, v.act_x, v.act_y-8)
	--anim:updateAnim(v.hb_c, v.act_x, v.act_y-8 )
	--if _bool == true then
	--image:setVisible(v.hb_b, _bool)
	--image:setVisible(v.hb_c.img, _bool)


	--if v.healthGrid ~= nil then
	--	print("HEALTH GRID IS ON:")
	--end
	if v.healthGrid ~= nil then
		
		local mfHp = math.floor(v.displayHP)
	--	print("HEALTH FOR UNIT: "..mfHp.." Team: "..v.team.."")
		mGrid:setTilesExtra(v.healthGrid, mfHp, v.team+1, 1)
		mGrid:setPos(v.healthGrid, v.act_x, v.act_y-10)
	end
	--else

	--end
end

function unit:_updateHBIndex(_id)
	local v = self._unitTable[_id]

end



function unit:_endTurnForPlayer( )
	self:_resetStats(2)
	self._turn = 2
end

function unit:_setCollisionAtCord(_x, _y, _value)
	Game.grid[_x][_y] = _value
end

----------------------------------------
------ SELECTION/LOCATION --------------
----------------------------------------


-- returns the INDEX FOR THE SELECTED UNIT in self._unitTable
function unit:getSelectedUnit( )
	local v = self:_getSelectedUnit( )
	if v ~= nil then
		local _unit = self._unitTable[v]
		return _unit
	end
end


function unit:selectUnit(_x, _y)
	if self._onUi == false then
		self:_flushInternalRange( )
		local unitPos = self:_getAtPos(_x, _y)
		local selNum = self:_getNumSelections( )
		interface:_setDockState(false)
		if unitPos ~= nil then -- there's a unit there
			local v = self._unitTable[unitPos]
			if v.team == self._turn and v.done == false then
				self:_addSelected(unitPos)
				self:_addRange(unitPos)
				interface:setTargetAtLoc(-200, 0)
				interface:_setDockState(true, unitPos)
				self._actionState = 2
			elseif v.team ~= self._turn then
				interface:_setDockState(true, unitPos, false)
				local seledUnit = self:_getSelectedUnit( )
				if seledUnit == unitPos then
					self:_removeRange( )
					self:_clearSelections( )
					interface:_setDockState(false)
				else
					self:_addSelected(unitPos)
					self:_addRange(unitPos)
				end
			end
		else
			interface:_setDockState(false)
			self:_removeRange( )
			self:_clearSelections( )	
			self:_selectBuild( )
		end
	end
end

function unit:_addAttackPositions(_target, _selected)
	local _tx = _target.x
	local _ty = _target.y 
	local _sRange = _selected.attack_range
	local _mRange = _selected.min_attack_range
	--print("ENEMY X: ".._tx.." AND Y: ".._ty.."")

	for x = -_sRange, _sRange do
		for y = - _sRange, _sRange do
			local distCheck = math.dist(_tx+x, _ty+y, _tx, _ty)
			if self:isLocEmpty(_tx+x, _ty+y) == nil and self:_isWalkable(_tx+x, _ty+y) and distCheck <= _sRange then
				for i = 1, #self._internalRangeTable do
					local irt = self._internalRangeTable
					if irt[i]._x == _tx+x and irt[i]._y == _ty+y then
						local temp = {
							_x = _tx+x,
							_y = _ty+y,
							_ax = _tx,
							_ay = _ty,
							img = anim:newAnim(self._mvRangeBad_tex, 4, _tx, _ty, 1),
							touchAnim = anim:newAnim(self._touchRipple_tex, 10, -1000, - 1000, 1),
						}
						table.insert(self._rangeTable, temp)
					end
				end
			end
		end
	end
	_selected.rival = _target

end

function unit:_tapInAttackRange(_x, _y)
	local bool = false
	for i,v in ipairs(self._rangeTable) do
		if v._x == _x and v._y == _y then
			bool = true
		end
	end
	return bool
end

function unit:selectedUnitMoveTo(_x, _y)
	local unitPos = self:_getAtPos(_x, _y)
	local selNum = self:_getNumSelections( )
	if self._destPath.x == _x and self._destPath.y == _y then
		local v = self._unitTable[self:_getSelectedUnit( )] -- our selected unit
		--sound:playFromCategory(SOUND_WALKING)

		self:g_getTargetLocation(v, _x, _y)	
	else
		unit:_clearSelections( )
		unit:_clearPathTable( )
		self._actionState = 1
		self:__resetRipple( )
		--print("CAN'T MOVE THERE - STATE 4")
	end
end

function unit:_clearAllInput( )
	unit:_clearSelections( )
	unit:_clearPathTable( )
	self._actionState = 1
	self:__resetRipple( )
	self:_removeRange( )
	interface:_setDockState(false)
end

function unit:selectedUnitGetAction(_x, _y)
	local unitPos = self:_getAtPos(_x, _y)
	local selNum = self:_getNumSelections( )

	if self:_inRange(_x, _y) == true then
		if unitPos ~= nil then
			local v = self._unitTable[unitPos]
			local mv = self._unitTable[self:_getSelectedUnit( )] -- our selected unit
			if v.team == self._turn then -- selected a unit of my own team
				if unitPos == self:_getSelectedUnit( ) then -- selected the same unit! Deselecting it
					self:_clearSelections( )
					self:_clearPathTable( )

				else
					self._actionState = 1
					self:selectUnit(_x, _y)
				end
				self:__resetRipple( )
			else -- enemy team! That means we want to attack him
				
				self:_clearPathTable( )
				self:_removeRange( )
				--if math.dist(v.x, v.y, mv.x, mv.y) > v.attack_range then
				local distAtandTarg = math.dist(v.x, v.y, mv.x, mv.y)
				print("DISTANCE BETWEEN 'EM: "..distAtandTarg.." attack range: "..v.attack_range.."")



				if distAtandTarg <= mv.attack_range then
					interface:setTargetAtLoc(_x, _y, 1) -- set target to green
				else
					interface:setTargetAtLoc(_x, _y, 2) -- set target to green
				end
				--else
				--	interface:setTargetAtLoc(_x, _y, 1)
				--end
				self:_addAttackPositions(v, mv)
				self._actionState = 3
				--if math.dist(v.x, v.y, mv.x, mv.y) <= 1 then
				--	self:_removeRange( )
				--end
				if #self._rangeTable == 0 and math.dist(v.x, v.y, mv.x, mv.y) > mv.attack_range then
					self:_clearSelections( )
					self:_clearPathTable( )
					v.rival = nil
					mv.rival = nil
					self:_removeRange( )
					self:selectUnit(_x, _y)
					self._actionState = 1

				end
				self:__resetRipple( )
			end
		else
			local v = self._unitTable[self:_getSelectedUnit( )] 
			self:_clearPathTable( )
			self:_removeRange( )
			self._destPath.x = _x
			self._destPath.y = _y
			--print("SHAIT, THIS IS HAPPENING")
			--print("X IS: ".._x.." Y IS: ".._y.."")
			self:_drawMovementPath(v.x, v.y, _x, _y)
			--anim:updateAnim(self._touchRipple, v.x, v.y)
			self:__setRipple(_x, _y)
			self._actionState = 4
		end
	else
		if unitPos ~= nil then
			local v = self._unitTable[unitPos]
			if v.team == self._turn then
				if v.done == false then
					self._actionState = 1
					self:selectUnit(_x, _y)
					self:__resetRipple( )
				else
					unit:_clearSelections( )
					unit:_clearPathTable( )
					self._actionState = 1
					self:__resetRipple( )
				end
			else
				interface:_setDockState(false)
				unit:_clearSelections( )
				unit:_clearPathTable( )	
				self:_removeRange( )	
				self._actionState = 1	
				self:__resetRipple( )	
			end
		else
			interface:_setDockState(false)
			self:__resetRipple( )
			unit:_clearSelections( )
			unit:_clearPathTable( )
			self._actionState = 1
		end
		--print("OUTSIDE OF RANGE")
	end

end

function unit:__resetRipple( )
	self._rippleX = - 50000
	self._rippleY = - 200
end

function unit:__setRipple(_x, _y)
	self._rippleX = _x
	self._rippleY = _y
end

function unit:_confirmAttackAction(_x, _y)
	--_tapInAttackRange
	local unitPos = self:_getAtPos(_x, _y)
	local selNum = self:_getNumSelections( )
	local mv = self._unitTable[unitPos]
	local v = self._unitTable[self:_getSelectedUnit()]
	if self:_tapInAttackRange(_x, _y) == true then
		
		--if math.dist(v.x, v.y, v.rival.x, v.rival.y) > 1 then
			self:_drawMovementPath(v.x, v.y, _x, _y)
			self:g_getTargetLocation(v, _x, _y)
		--end
	elseif mv == v.rival  and math.dist(v.x, v.y, v.rival.x, v.rival.y) <= v.attack_range  then
		self:_do_attack(v, v.rival)
		interface:setTargetAtLoc(-2000, 200, 1)
		unit:_clearSelections( )
		unit:_clearPathTable( )
		self:_removeRange( )
		self._actionState = 1		
		v.done = true
	else
		unit:_clearPathTable( )
		self:_removeRange( )
		local v = self._unitTable[self:_getSelectedUnit()]
		v.rival = nil -- reset our attack target
		self._actionState = 1
		unit:_clearSelections( )
	end

end


function unit:_calculateAttack(_attacker, _target)
	local v = _attacker
	local t = _target

	local p1 = self._teamToPlayer[v.team]
	local p2 = self._teamToPlayer[t.team]
	print("TEAM FOR ATTACK: "..v.team.." TEAM FOR DEFENDER: "..t.team.."")
	print("CAB FOR ATTACK: "..self._teamToPlayer[t.team].attackBonus.." ")
	local defenseValue = map:getDefenseValue(t.x, t.y)
	local attack_percent = ( v.damage*(p1.attackBonus/1.7)/100+1 ) *(v.hp/10)* ( (200 - ( (p2.defenseBonus/1.2 + defenseValue )+1*t.hp ))/100)
	print("P1 DEFENSE: "..player1.defenseBonus.."")
	print("P2 DEFENSE: "..player2.defenseBonus.."")



	return attack_percent
end

function unit:_do_attack_2(_attacker, _target)

end

function unit:_do_attack(_attacker, _target)

	--[[
D%=[B*ACO/100+R]*(AHP/10)*[(200-(DCO+DTR*DHP))/100]

D = Actual damage expressed as a percentage

B = Base damage (in damage chart)

ACO = Attacking CO attack value (example:130 for Kanbei)

R = Random number 0-9

AHP = HP of attacker

DCO = Defending CO defense value (example:80 for Grimm)

DTR = Defending Terrain Stars (IE plain = 1, wood = 2)

DHP = HP of defender 


	]]
	----print("DO ATTACK")
	local v = _attacker
	local t = _target

	if t == nil then
		----print("TARGET IS NIL")
	elseif v == nil then
		----print("ATTACKER IS NIL")
	end

	if v ~= nil and t ~= nil then
		local dmg_tar = self:_calculateAttack(v, t)
		
		--local damage_target = ( v.damage*100/100+math.random(0, 9) ) *(v.hp/10)* ( (200 - ( 100+1*t.hp ))/100)
		if v.isCommander == true then
			anim:setState(v.img, self._animStates[3][v.tp].attack, v.stateName )
		else
			if v.x < t.x then
				anim:setState(v.img, self._animStates[v.faction][v.tp].attack, self._animStates[v.faction][v.tp].idle)
			else
				anim:setState(v.img, self._animStates[v.faction][v.tp].aleft, self._animStates[v.faction][v.tp].left)
			end
		end

		t.hp = t.hp - dmg_tar
		t.displayHP = t.hp
		-- damage done attacking 
		if self._turn == 1 then
			self._damageDealt.p1 = self._damageDealt.p1 + dmg_tar * 10
		else
			self._damageDealt.p2 = self._damageDealt.p2 + dmg_tar * 10
		end
		--print("TEAM: "..t.team.." AND HP: "..t.hp.."")
		map:updateTile(t.x, t.y, 10)
		--sound:playFromCategory(SOUND_GUNS)
		--[[if v.tp == 3 and v.action == 1 then
			sound:play(sound.chainSaw)
		else
			sound:play(sound.gun)
		end--]]
		if t.img ~= nil then
			--anim:setState(t.img, "HURT", "MOVE_LEFT")
			local currentFrame = anim:getCurrentFrame(v.img)
			local lastFrame = anim:getLastFrame(v.img)
			interface:setTargetAtLoc(t.x, t.y)
			--if currentFrame == lastFrame then
				if v.tp == 4 or (v.tp == 5 and v.faction == 1 ) then
					weffect:new("DAMAGE_EFFECT", t.x, t.y, self._explosionAnimEffect, 7 )
				end
			--end
		end
		--[[if v.team == 1 then
			if v.faction == 1 and v.tp == 3 then
				sound:play(sound.chainSaw)
			elseif v.faction == 2 and v.tp == 3 then
				sound:play(sound.punch)
			else
				sound:play(sound.gun)
			end
		else
			if v.faction == 2 and v.tp == 3 then
				sound:play(sound.chainSaw)
			else
				sound:play(sound.gun)
			end
		end--]]

		if v.faction == 1 then
			if v.tp == 1 then
				sound:play(sound.club)
			elseif v.tp == 2 then
				sound:play(sound.club)
			elseif v.tp == 3 then
				sound:play(sound.chainSaw)
			elseif v.tp == 4 then
				sound:play(sound.gun)
			else
				sound:play(sound.bigGun)
			end

		else
			if v.tp == 1 then
				sound:play(sound.knife)
			elseif v.tp == 2 then
				sound:play(sound.knife)
			elseif v.tp == 3 then
				sound:play(sound.punch)
			elseif v.tp == 4 then
				sound:play(sound.gun)
			else
				sound:play(sound.bigGun)
			end
		end

		local distCheck = math.dist(v.x, v.y, t.x, t.y)
		if t.hp > 0.1 and distCheck <= t.attack_range  then
			local dmg_attk = self:_calculateAttack(t, v)
			if t.isCommander == true then
				anim:setState(t.img, self._animStates[3][t.tp].attack, t.stateName )
			else			
				if v.x > t.x then
					anim:setState(t.img, self._animStates[t.faction][t.tp].attack, self._animStates[t.faction][t.tp].idle)
				else
					anim:setState(t.img, self._animStates[t.faction][t.tp].aleft, self._animStates[t.faction][t.tp].left)
				end		
			end	


			v.hp = v.hp - dmg_attk
			if self._turn == 1 then
				self._damageDealt.p2 = self._damageDealt.p2 + dmg_attk * 10
			else
				self._damageDealt.p1 = self._damageDealt.p1 + dmg_attk * 10
			end
			v.displayHP = v.hp
			map:updateTile(v.x, v.y, 10)
			if v.img ~= nil then
				if t.tp == 4 or (t.tp == 5 and t.faction == 1 ) then
					weffect:new("DAMAGE_EFFECT", v.x, v.y, self._explosionAnimEffect, 7 )
				end
			end

			if t.faction == 1 then
				if t.tp == 1 then
					sound:play(sound.club)
				elseif t.tp == 2 then
					sound:play(sound.club)
				elseif t.tp == 3 then
					sound:play(sound.chainSaw)
				elseif t.tp == 4 then
					sound:play(sound.gun)
				else
					sound:play(sound.bigGun)
				end

			else
				if t.tp == 1 then
					sound:play(sound.knife)
				elseif t.tp == 2 then
					sound:play(sound.knife)
				elseif t.tp == 3 then
					sound:play(sound.punch)
				elseif t.tp == 4 then
					sound:play(sound.gun)
				else
					sound:play(sound.bigGun)
				end
			end
		end
		v.can_attack = false

		map:shake(4, 4)


	else
		----print("MEH NILL IN ATTACKER AND TARGET")
	end

end

function unit:removeSelected( )
	for i,v in ipairs(self._unitTable) do
		v.isSelected = false
	end
	self:_removeRange( )
end

---------------------------------------
----- PATHFINDING RELATED -------------
---------------------------------------

function unit:_resetStats(_team)
	effect:dropAll( )
	for i,v in ipairs(self._unitTable) do
		--if v.team == self._turn then
			image:setColor(v.img.img, 1, 1, 1, 1)
			------print("TEAM: ".._team.." JACOB!!!!")
			v.isThere = true
			v.isMoving = false
			v.isSelected = false
			v.issuedOrder = false
			v.done = false
			v.can_attack = false
			v.has_attacked = false
			v.hasGoal = false

			v.objectiveSet = false
			v.rival = nil
			v.mustMove = nil


			if v.isCommander == false then
				v.damage = unit_type[v.faction][v.tp].damage
				v.range = unit_type[v.faction][v.tp].mobility
				v.attack_range = unit_type[v.faction][v.tp].max_range
				v.min_attack_range = unit_type[v.faction][v.tp].min_range
			else -- TEMP! Don't be hating on me.
				--[_team][_type]
				v.damage = commander_type[v.faction][v.tp].damage
				v.range = commander_type[v.faction][v.tp].mobility
				v.attack_range = commander_type[v.faction][v.tp].max_range
				v.min_attack_range = commander_type[v.faction][v.tp].min_range
			end

			self._cpIDX = 1
			v.cur = 1
			--[[if v.eff ~= nil then
				print("V EFF IS: "..v.eff.." FOR UNIT: "..i.."")
				effect:deleteEffect(v.eff)
				v.eff = nil
			end--]]
			
			v.eff = nil
			--unit:removeFromTeam(_team)
			unit:_dropTargetList( )
			unit:_dropListOfPlUnits( )
			unit:_dropListOfPcUnits( )
			self:_clearSelections( )
			unit:_dropSSJ( )

			
		--end
	end
end
----------------------------------------
------ UPDATE/REMOVE/DROP --------------
----------------------------------------


function unit:_handleCurrentStep( )
	local _st = step[currentStep]

	if self._turn == 1 then
		if Game.player1 == "Human" then
			self:_handleMove_player( )
		else
			juliette:think()
		end
		--juliette:think()
		--irene:think( )--harrold:think( )--irene:think( )--
		--gharcea:think( )
		--francois:think( )
	else
		--self:_handleMove_player( )
		--gharcea:think( )--harrold:think( )--francois:think( )--elenoir:think( ) --dave:think( )
		--self:_handleMove_player( )--juliette:think()--irene:think( )--harrold:think( )--
		if Game.player2 == "Human" then
			self:_handleMove_player( )
		else
			juliette:think()
		end
		--self:_handleMove_player( )
		--dave:think( )
		--dave:think( )
		--[[if _st == "Build" then
			self:_handleBuild_ai( )
		elseif _st == "Move" then
				self:_handleMove_ai( )
		elseif _st == "Attack" then
			self:_handleAttacK_ai( )
		end--]]
	end
end

function unit:_handleBuild_player( )
	self:_selectBuild( )
end

function unit:_selectBuild( )
	local _building 
	if Game.cursorEnabled == true then
		_building  = building:selectBuilding(Game.cursorX, Game.cursorY)
	else
		_building  = building:selectBuilding(self._msx, self._msy)
	end
	print("HERE")
	if _building == nil then
		building:clearSelected( )
	end
end

function unit:_handleMove_player( )
	for i,v in ipairs(self._unitTable) do
		self:_moveUnit(v)
	end
	--unit:_handleAttacK_player()
	--[[self:_moveUnit( )
	for i,v in ipairs(self._unitTable) do
		if v.team == self._turn then
			if v.can_attack == false then
				unit:_moveOnPath(i)
			end

		end
	end--]]
end

function unit:_moveUnit(_u)
	local v = _u 
	if v.issuedOrder == true then
		self:g_moveTowardsTarget(v)
	end
	--[[if self:returnEventType( ) == true then
		local selNum = self:_getNumSelections()

		if selNum > 0 then
			_unit = self:_getSelectedUnit( )
			v = self._unitTable[_unit]
			if v.team == self._turn then

				if v.done == false then
					unit:_confirmMoveSelection(v)
				elseif v.can_attack == true then
					----print("Can attack")
				end
			end--]]
		--[[	_unit = self:_getSelectedUnit( )
			v = self._unitTable[_unit]
			v.old_x = v.x
			v.old_y = v.y
			if v.team == self._turn then
				if v.done == false then
					unit:_handle_move_to_pos(v, _unit)

				elseif v.done == true and v.can_attack == true then
					unit:_handleAttacK_player(v)
				end
			end
		end

		self:selectUnit(self._msx, self._msy)
		self:setEventType(false)
	end]]

	--unit:_moveOnPath()
end

function unit:_confirmMoveSelection(_v)
	local v = _v
	local destX = self._msx
	local destY = self._msy

	local posUnit = self:_getAtPos(destX, destY)
	if  posUnit == nil then
		self:_removeRange( )
		self:_drawMovementPath(v.x, v.y, destX, destY)
		self:_setGlobalMovement(v, destX, destY)
	else
		local _unit = self._unitTable[posUnit]
		if _unit.team ~= self._turn then
			self:_removeRange( )
			local freeX, freeY = self:_findNearestEmptySpot(destX, destY, 1)
			self:_drawMovementPath(v.x, v.y, freeX, freeY)
			self:_setGlobalMovement(v, freeX, freeY)
			interface:setTargetAtLoc(destX, destY)
		end
	end
end

function unit:_setGlobalMovement(_unit, _destX, _destY, _target)
	self.g_selUnit = _unit
	self.g_x = _destX
	self.g_y = _destY
	self.g_target = _target
end

function unit:_returnGlobalMovement( )
	return self.g_selUnit, self.g_x, self.g_y, self.g_target
end

function unit:_resetGlobalMovement( )
	self.g_selUnit = nil
	self.g_x = nil
	self.g_y = nil
	self.g_target = nil
end

function unit:_resetOtherTargets(_target)
	for i,v in ipairs(self._unitTable) do
		if i ~= _target then
			v.targeted = false
		end
	end
end

function unit:_handle_move_to_pos(_v, _targX, _targY)
	local _selUnit = self:_getNumSelections( )
	local unCheckpos = unit:_getAtPos(self._msx, self._msy)
	if unCheckpos == nil then
		--[[if unit:_inRange(self._msx, self._msy) then
			v.x = self._msx
			v.y = self._msy
			--self:selectUnitJustForCheck(v.x, v.y)
			

		end--]]

		self:_getTargetLocation(_targX, _targY, _v)
	else
		local v = self._unitTable[unCheckpos]
		if unit:_inAttackRange(v.x, v.y) then
			if v.team ~= self._turn then
				--unit:_removeRange( )
				unit:_clearPathTable( )
				unit:_clearSelections( )
				_v.done = true 
				_v.can_attack = true
				self:selectUnit_attack(_v.x,_v.y)
			end
		end
	end
end

function unit:_handleAttacK_player(__v)
			_unit = self:_getSelectedUnit( )
			v = __v
			interface:setTargetAtLoc(5000, 5000)
			if v.can_attack == true then
				if unit:_getAtPos(self._msx, self._msy) ~= nil then
					local _tarID = unit:_getAtPos(self._msx, self._msy)
					local _target = self._unitTable[_tarID]

					if _target.team ~= self._turn and math.dist(v.x, v.y, _target.x, _target.y) <= v.attack_range then
						interface:setTargetAtLoc(_target.x, _target.y)
					end

					unit:_resetOtherTargets(_tarID)
					------print("TARGET SET")
					if _target.targeted == true then

						-- THIS SHOULD BE MOVED SOMEWHERE ELSE AFTER CONFIRMATION IS RECEIVED
						local distCheck = math.dist(v.x, v.y, _target.x, _target.y)
						if distCheck <= v.attack_range then
							if _target.team ~= self._turn then

								_target.hp = _target.hp - v.damage
								anim:setPosition(damage_anim, _target.act_x, _target.act_y)
								----print("DAMAGE DEALT: "..v.damage.." by unit ID: ".._unit.."")
								if _target.hp > 0 and distCheck <= _target.attack_range then
									v.hp = v.hp - _target.damage-- they both battle
								end
								
								----print("REMOVED TARGET")
								_target.targeted = false
								--unit:_resetOtherTargets(999999)
								interface:setTargetAtLoc(5000, 5000)
								_target.__debugDispRange = true
								v.done = true
								self:_dropTargetList( )
								self:_clearSelections( )
								self:_removeRange( )
							end
						end
					else
						if math.dist(v.x, v.y, _target.x, _target.y) <= v.attack_range then
							_target.targeted = true	
							----print("TARGET IN SIGHT")
							self:setEventType(false)

						end
					end
					

				end

			end
		--end

		--self:selectUnit_attack(__v.x, __v.y)
		--self:setEventType(false)

	--end
end

function unit:_attackWithUnit(_id)

end

function unit:_renderGame( )
	for i,v in ipairs(self._unitTable) do

		self:draw(i)

		unit:remove(i)


		

	end
	--anim:updateAnim(damage_anim)
	self:_drawRange( )
		
	self:_drawPath( )

	self:_updateTargetList( )
	self:_updateRippleAnim( )
	self:_drawAndUpdatePowerupSSj( )
	effect:update( )
	unit:turn_loop( )
end

function unit:_updateRippleAnim( )
	self._ripX = self._rippleX * self._tileSize - self._tileSize + self._offsetX
	self._ripY = self._rippleY * self._tileSize - self._tileSize + self._offsetY
	anim:updateAnim(self._touchRipple, self._ripX, self._ripY )
end

function unit:update( )
	------print("TURN: "..self._turn.."")
	self._offsetX, self._offsetY = map:returnOffset( )
	unit:_MouseToWorld( )


	unit:_renderGame( )
	 -- reset unit stats at turn start

	

	unit:_handleCurrentStep( )

	------print("TURN: "..self._turn.."")
	--[[if self._turn == 1 then
		for i,v in ipairs(self._unitTable) do
			unit:remove(i)
			if v.team == 1 then
				unit:_moveOnPath(i)
			end
		end
		unit:_drawRange( )
		unit:_drawPath( )
	else
		unit:_handlePcUnits()
		unit:_drawRange( )
		unit:_drawPath( )
	end

	for i,v in ipairs(self._unitTable) do
		self:draw(i)
		unit:_loopInAttack(v, i)

	end
	unit:_updateTargetList( )
--	local dist = math.dist(self._msx, self._msy, self._unitTable[2].x, self._unitTable[2].y )
	------print("math dist: "..dist.."")--]]
end


function unit:remove(_id)
	local v = self._unitTable[_id]
	if v.hp <= 0.3 then

		if v.prepareDeath == false then
			--anim:setState(v.img, "HURT")
			--[[if v.faction == 1 then
				if v.team == 1 then
					sound:play(sound.orgDying)

			else
				sound:play(sound.mechDying)
			end--]]
			if v.team == 1 then
				if v.faction == 1 then
					sound:play(sound.orgDying)
				else
					sound:play(sound.mechDying)
				end
				self._unitsLost.p1 = self._unitsLost.p1 + 1
			elseif v.team == 2 then
				if v.faction == 1 then
					sound:play(sound.mechDying)	
				else
					sound:play(sound.orgDying)
				end
				self._unitsLost.p2 = self._unitsLost.p2 + 1
			end
			if v.faction == 1 then
				sound:play(sound.orgDying)
			else
				sound:play(sound.mechDying)
			end

			weffect:new("DAMAGE_EFFECT", v.x, v.y, self._explosionAnimEffect, 7 )--anim:setState(v.img, "HURT", "MOVE_LEFT")

			v.prepareDeath = true
		else
			--if anim:getCurrentFrame(v.img) == 20 then
				anim:delete(v.img, g_ActionPhaseLayer)
				--image:removeProp(v.hb_b, g_ActionPhase_UI_Layer)
				--anim:delete(v.hb_c, g_ActionPhase_UI_Layer)
				font:delete(v.hb_text)
				mGrid:destroy(v.healthGrid)
				--font:delete(v.type_tex)
				table.remove(self._unitTable, _id)
				self:_unitDeadCallback(_id)
				if v.turn == 1 then 
					--gharcea:getListOfUnits( )
					juliette:getListOfUnits(  ) 
					--harrold:getListOfUnits(  )
				else
					juliette:getListOfUnits(  ) 
					--harrold:getListOfUnits(  )
					--gharcea:getListOfUnits( )
				 end
				----print("destroyed is : ".._id.." from team: "..v.team.."")
			--end
		end
		map:_updateFogOfWar( )
	end
	

end

function unit:drop(_id)
	local v = self._unitTable[_id]
	--if v.hp <= 0.9 then
	anim:delete(v.img, g_ActionPhaseLayer)
	image:removeProp(v.hb_b, g_ActionPhase_UI_Layer)
	image:removeProp(v.hb_c, g_ActionPhase_UI_Layer)
		--table.remove(self._unitTable, _id)
	------print("REMOVING UNIT WITH ID: ".._id.."")
	------print("ID IS: ".._id.."")
	--end
	

end

function unit:removeFromTeam(_team)
	for i,v in ipairs(self._unitTable) do
		if v.team == _team then
			if v.hp < 0.5 then
				--unit:remove(i)
			end
		end
	end
end


function unit:dropAll( )
	for i,v in ipairs(self._unitTable) do
		unit:drop(i)
	end
end
----------------------------------------
-------- CONTROLS/KEYS/MOUSE -----------
----------------------------------------

function unit:keypressed(key)

	if self._onUi == true then
		interface:_AUNavigation(key)
	end
	if key == 122 then
		----print("KEY 122")
		Game:initPathfinding( Game.grid )

	elseif key == 32 then
		--local v = self._unitTable[math.random(1, #self._unitTable)]
		--v.hp = 0
		unit:_cursorSelectPressed( )
	elseif key == 101 then
		interface:_setEndScreen(false)
	elseif key == 116 then --T KEY
		--building:setVictory(self._turn)--self._acceptMove = true
		--interface:_setEndScreen(true)
		self:_applyPowerupHealAll( )
	end
	----print(""..key.."")
end

function unit:_cursorSelectPressed( )

	if self._onUi == false and self._awatingCommand == false and self._teamToPlayer[self._turn].name == "Human" then
		--print("CURSOR SELECT PRESSED")
		if self._actionState == 1 then
			--print("ARE WE IN 1?")
			--Game:setCollisionAt(self._msx, self._msy, true)
			self:selectUnit(Game.cursorX, Game.cursorY)
			--print("CURSOR X: "..Game.cursorX.." CURSOR Y: "..Game.cursorY.."")
			--print("STATE 1")
		elseif self._actionState == 2 then
			interface:_setDockState(false) --interface:_setDockState(true)
			self:selectedUnitGetAction(Game.cursorX, Game.cursorY)
			--print("STATE 2")
			--print("STATE 2 CURSOR X: "..Game.cursorX.." CURSOR Y: "..Game.cursorY.."")
			--print("STATE 2")
		elseif self._actionState == 3 then
			--print("STATE 3")
			self:_confirmAttackAction(Game.cursorX, Game.cursorY)
			interface:_setDockState(false)
		elseif self._actionState == 4 then
			self:selectedUnitMoveTo(Game.cursorX, Game.cursorY)
			interface:_setDockState(false)
			--print("STATE 4")
		end
	--elseif self._onUi == true then
	--	interface:_AUNavigation(key)
	end
end


function unit:keyreleased(key)

end

function unit:touchpresed( )
	--if building:_getAtPos(self._msx, self._msy) == nil and building:selectBuilding(self._msx, self._msy) == nil then
	if self._onUi == false then
		MouseDown = true
		--camera:setJoystickVisible( )
	end
	--end
	self._touchEventType = false
end

function unit:mousereleased( )
	
	MouseDown = false	
	--camera:setJoystickHidden( )

	if unit:_getTouchState( ) == true then
		self._touchEventType = true
	end

	if self._onUi == false and self._awatingCommand == false and MouseDown == false and self._teamToPlayer[self._turn].name == "Human" then
		if self._actionState == 1 then

			--Game:setCollisionAt(self._msx, self._msy, true)
			self:selectUnit(self._msx, self._msy)
			--print("STATE 1")
		elseif self._actionState == 2 then
			interface:_setDockState(false) --interface:_setDockState(true)
			self:selectedUnitGetAction(self._msx, self._msy)
			--print("STATE 2")
		elseif self._actionState == 3 then
			--print("STATE 3")
			self:_confirmAttackAction(self._msx, self._msy)
			interface:_setDockState(false)
		elseif self._actionState == 4 then
			self:selectedUnitMoveTo(self._msx, self._msy)
			interface:_setDockState(false)
			--print("STATE 4")
		end
	end


end

function unit:touchlocation(_x, _y)

	self.___msx = _x
	self.___msy = _y


end

function unit:returnEventType( )
	return self._touchEventType
end

function unit:setEventType(_bool)
	self._touchEventType = false
end

function unit:_getTurn( )
	return self._turn
end

function unit:_getTurnCounter( )
	return self._turnCounter
end

function unit:_getRandomUnitOfTeam(_team)

	-- first scroll towardsa a unit
	local rUnit 
	local score = 0
	local dist = 200
	local mapSX, mapSY = map:getSize( )
	for i,v in ipairs(self._unitTable) do
		if v.team ~= _team then
			local dst = math.dist(v.x, v.y, v.x, math.floor(mapSY/2))
			if dst < dist then
				dist = dst
				rUnit = v
			end
		end
	end

	if rUnit == nil then -- so, no units :(
		local bldTable = building:_returnBuildingTable( )
		for i,v in ipairs(bldTable) do
			if v.team ~= _team then
				local dst = math.dist(v.x, v.y, v.x, math.floor(mapSY/2))
				if dst < dist then
					dist = dst
					rUnit = v
				end
			end
		end

	end

	return rUnit

	

end

function unit:_returnTypeOfPlayer( )
	return self._teamToPlayer[self._turn].name
end


function unit:_setATargetToScrollTo(_turn)

	local v = self:_getRandomUnitOfTeam(_turn)
	if v ~= nil then
		map:setScreen(v.act_x, v.act_y)
	end

	--
end

 
function unit:_getFalseTurn( )
	return self._falseTurn
end

function unit:_getChangingTurnState( )
	return self._changingTurns
end

function unit:turn_loop( )
	--print("FRAKING TURN COUNTER: "..self._turnCounter.."")
	if self._turnCounter == 1 and self._teamToPlayer[self._turn].name == "Human" then -- so start of the game:
		if self._scrollCameraToPlayerOnTurnOne == false then
			unit:_setATargetToScrollTo(2)
			self._lastDirtyHack = false 
			self._scrollCameraToPlayerOnTurnOne  = true
			
		elseif self._scrollCameraToPlayerOnTurnOne == true then
			
			if self._lastDirtyHack == false then
				map:scroll()
			end

			local bool = map:getScrollStatus( )
			if bool == true then
			--	print("AND IT shooouuuullllllldd be scrolllll")
			else
				self._lastDirtyHack = true
				self._scrollCameraToPlayerOnTurnOne = 1337 -- why not?
			--	print("Well then... well well well")
			end
		end

	end

	if self._changingTurns == 1 then
	

		self._turnDelay = Game.worldTimer
		--unit:_setATargetToScrollTo(1)
		
		
		if self._turn == 1 then
			interface:_ap_updateCommanderPanel(2)
			interface:_setMenuPanelLock(74)
			unit:_setATargetToScrollTo(1)
			self._falseTurn = 2
		elseif self._turn == 2 then
			interface:_ap_updateCommanderPanel(1)
			interface:_setMenuPanelLock(0)
			unit:_setATargetToScrollTo(2)
			self._falseTurn = 1
		end

		interface:_setPropperCommanderCollorTurn( )
		
		self._changingTurns = 2
	elseif self._changingTurns == 2 then
		

		--camera:setScroll
		--if self._teamToPlayer[self._turn].name == "Human" then
			
		--end



		interface:_setMenuPanelState(false)
		self._onUi = true
		
		if Game.worldTimer > self._turnDelay + 1 then

			self._changingTurns = self._changingTurns + 1
			self._turnDelay = Game.worldTimer
		end

		building:_generateIncome( )
	elseif self._changingTurns == 3 then

		if Game.worldTimer > self._turnDelay + 0.3 then
			if self._turn == 1 then
				
				interface:_setTurnState(2, true)
				
				--apTopBar:tweenPos(0, 180)	
			else

				interface:_setTurnState(1, true)
				--apTopBar:tweenPos(0, 90)
				self._turnCounter = self._turnCounter + 1
			end
			self._once = true
			unit:_advanceTurn2()
			
			map:_updateFogOfWar( )
			self._changingTurns = self._changingTurns + 1
			self._onUi = false


		end
	else

		--map:scroll( )
	end
end

function unit:advanceTurn( )
	------print("FUCKING HERE ALREADY")
	--map:_updateFogOfWar( )
	
	--print("SELF CHANGING FREAKING TURN IS: "..self._changingTurns.."")
	if self._changingTurns > 3 then



		local mapScrollBool = map:getScrollStatus( )
		--if mapScrollBool == false then
			self._changingTurns = 1
		--end
	end

end

function unit:_advanceTurn2( )

	if self._once == true then
		------print("ONLY")
		if self._turn == 1 then
			--apTopBar:tweenPos(0, 180)
			self._turn = 2
			--map:recordOffset( )
			--map:setOffset(170, 96)
			--Game:ViewportScale(1, 1)
		else
			--apTopBar:tweenPos(0, 90)
			
			self._turn = 1

			--map:setOffset(map:returnOldOffset( ))
			--Game:ViewportScale(zoomIDX, zoomIDX)
		end
		
		unit:_resetStats(self._turn)

		building:_resetStats()	
		
		

		self:_checkVictoryConditions( )
		self._once = false
	end
end

function unit:_nextStep( )
	if currentStep < 3 then
		interface:setBuyMenu(false)
		currentStep = currentStep + 1
		unit:_resetStats(self._turn)
		unit:_dropTargetList( )
		interface:setTargetAtLoc(5000, 5000)
	else

		unit:advanceTurn( )
		unit:_resetStats(self._turn)

		
		unit:_dropTargetList( )
		unit:_dropListOfPcUnits( )
		building:_generateIncome( )
		currentStep = 1
		building:_resetStats()
	end

	unit:_clearSelections( )
end

function unit:_setTouchState(_bool)
	self._canMouseBeTrusted = _bool
end

function unit:_getTouchState( )
	return self._canMouseBeTrusted
end

function unit:_returnTurn( )
	return self._turn
end

function unit:_returnTable( )
	return self._unitTable
end

function unit:_loopThroughEnemiesDisableDebugDis( )
	for i,v in ipairs(self._unitTable) do
		if v.team == 2 then
			v.__debugDispRange = false
		end
	end
end

function unit:_setAwatingCommand(_bool)
	self._awatingCommand = _bool
end

function unit:_getAwatingCommand( )
	return self._awatingCommand
end

function unit:_getNrFactories( )
	local factoriesPlayers = { p1 = 0, p2 = 0 }
	local listOfBuildings = building:_returnBuildingTable( )
	
	for i,v in ipairs(listOfBuildings) do
		-- type must be 1, so only factories
		if v._type == 1 then
			if v.team == 1 then -- player 1
				factoriesPlayers.p1 = factoriesPlayers.p1 + 1
			elseif v.team == 2 then
				factoriesPlayers.p2 = factoriesPlayers.p2 + 1
			end
		end
	end

	return factoriesPlayers
end
--[[
	Victory Conditions:
	- when no units can be created and none remain -
]]
function unit:_checkVictoryConditions( )
	print("=====================================================")
	print("================   CHECK VICTORY CONDITIONS =========")
	local listOfBuildings = building:_returnBuildingTable( )
	local p1BuildingList = {}
	local p2BuildingList = {}

	-- get a list of both player's factories
	-- p1 factories:
	for i,v in ipairs(listOfBuildings) do
		-- type must be 1, so only factories
		if v._type == 1 and building:_isFactoryOccupied(i) == false then
			if v.team == 1 then -- player 1
				table.insert(p1BuildingList, i)
			elseif v.team == 2 then
				table.insert(p2BuildingList, i)
			end
		end
	end


	local p1Units = 0
	local p2Units = 0

	for i,v in ipairs(self._unitTable) do
		if v.team == 1 then
			p1Units = p1Units + 1
		else
			p2Units = p2Units + 1
		end
	end

	if p1Units == 0 and #p1BuildingList == 0 then
		print("PLAYER 2 is VICTOR")
		interface:setVictoryStatus(true)
		interface:_updateVictoryScreen( 1 )

	elseif p2Units == 0 and #p2BuildingList == 0 then
		print("PLAYER 1 IS VICTOR")
		print("PLAYER 1 IS VICTOR")
		print("PLAYER 1 IS VICTOR")
		print("PLAYER 1 IS VICTOR")
		print("PLAYER 1 IS VICTOR")
		print("PLAYER 1 IS VICTOR")
		print("PLAYER 1 IS VICTOR")
		print("PLAYER 1 IS VICTOR")
		print("PLAYER 1 IS VICTOR")
		print("PLAYER 1 IS VICTOR")
		interface:setVictoryStatus(true)
		interface:_updateVictoryScreen (1)
	else
		print("None of them are victors")
	end
	print("================   CHECK VICTORY CONDITIONS =========")
	print("=====================================================")
end

function unit:_quitToWorldMap( )
	--Game.mapFile = "temp_test_map022701227"
	map:destroyAll( )
	unit:dropAll( )
	building:_dropAll( )
	font:dropAll( )
	anim:dropAll( )

	Game:dropUI(g, resources )
	_bGuiLoaded = false
	currentState = Game.lastState
	
end

function unit:_returnRandomEnemy()
	local bList = {}
	for i,v in ipairs(self._unitTable) do
		if v.team ~= unit:_returnTurn( ) then
			--if v.tp == 1 then
			table.insert(bList, v)
			--end
		end
	end

	local sz = #bList
	local rnd = 1
	if sz >= 1 then
		rnd = math.random(1, sz)
	else
		rnd = 1
	end

	return bList[rnd]
end