Game = {} -- MAIN CLASS

Game.modInUse = "stream"

local Grid = require ("Game.lib.jumper.grid")
-- Calls the pathfinder class
local Pathfinder = require ("Game.lib.jumper.pathfinder")



-------------------------------------------
--------- GAME FILES ----------------------
--------------------------------------------
-- needed to allow images and animations to be loaded from /mods
-- doing this to avoid having to mantain two separate versions of my /Chaurus framework from /core
require "Game.wrapper.wImage"
require "Game.wrapper.wAnim"
require "Game.wrapper.wEffect"

require "Game.include_list"

--- WOOOHOO works!
for i,v in ipairs(includeList) do

	local prePath = "mods."..Game.modInUse.."."

	if isModuleAvailable(""..prePath..""..v.."") == false then
		prePath = "Game."
		local string = ""..prePath..""..v..""
		require("Game."..v.."")
	else
		print("GOING FOR MODS")

		local string = ""..prePath..""..v..""
		require(""..prePath..""..v.."")	
	end

end

--[[require "Game.file_io"
require "Game.camera"
require "Game.map"
require "Game.influence_map"
require "Game.ui.userInterface"
require "Game.ui.action_phase.action_phase"
require "Game.ui.action_phase.ap_buttons"
require "Game.ui.mainMenu"
require "Game.ui.mainMenu_callbacks"
require "Game.ui.levelSelect"
require "Game.ui.buy_menu"
require "Game.LevelEditor.levelEditor"
require "Game.ui.leditor"
require "Game.ui.level_editor_main_menu.leditor_menu_options"
require "Game.ui.level_editor_main_menu.leditor_resize_menu"
require "Game.ui.worldMap.worldMap_ui"
require "Game.ui.action_phase.ingame_menu"
require "Game.ui.freeBattle.battle_menu"
require "Game.ui.action_phase.endBattle_Screen"
require "Game.ui.freeBattle.map_select"
require "Game.ui.freeBattle.commander_select"
require "Game.ui.intro_moai"
require "Game.ui.layoutTesting.layoutTest"
require "Game.table_work"
require "Game.units.unit"
require "Game.units.unit_textures"
require "Game.units.unit_private_functions"
require "Game.units.unit_ai"
require "Game.units.unit_type_table"
require "Game.units.ai.steve"
require "Game.units.ai.dave"
require "Game.units.ai.elenoir"
require "Game.units.ai.elena"
require "Game.units.ai.francois"
require "Game.units.ai.gharcea"
require "Game.units.ai.harrold"
require "Game.units.ai.irene"
require "Game.units.ai.juliette"
require "Game.units.winCases"
require "Game.player.player"
require "Game.worldMap.sharks"
require "Game.buildings.building"
require "Game.buildings.towns"
require "Game.info.information"

require "Game.worldMap.worldmap"

require "Game.player.player"--]]



require "core.StateMachine"
--------------------------------------
---- PATHFINDER INCLUDES -------------
---------------------------------------

require "gui/support/class"

zKey = false

Game.movement = false
Game.attack = false
Game.Turn = 1
Game.globalUn = nil
Game.targetAcquired = false
Game.disableDock = false
walkable = 1073741825--1
Game.levelString = "lv_1"

Game.grid = nil
Game.mapFile = "mirrormantis"
Game.fromEditor = false
_gTouchPressed = false -- global TOUCH PRESSED 
Game.firstTurn = 1
Game.victor = nil
Game.buildingID = nil

Game.bgColor = {}
Game.bgColor[1] = { r = 0, g = 0.3, b = 0.8 }
Game.bgColor[2] = { r = 0.99, g = 0.2, b = 0.2 }
Game.bgColor[3] = { r = 1, g = 1, b = 1 }
Game._currentScale = 1
Game.wantedScale = 1
Game.oldScale = 1
zoomInProgress = false
Game.disableInteraction = false
Game.masterVolume = 0.9
Game.commander = {}
Game.commander[1] = { imgID = 1, name = commander[1].name, smBttn = 1 }
Game.commander[2] = { imgID = 2, name = commander[1].name, smBttn = 1 }
Game.player1 = "Human"
Game.player2 = "Computer"
Game.lastState = 2
Game.winCondition = 1
Game.tileset = "tileset_ground.png"
Game.victory = false
Game.globalFogOfWar = false
Game.optionControls = { }

Game.cursorX = 5
Game.cursorY = 5
Game.cursorEnabled = false
Game.key = nil
Game.keyTimer = Game.worldTimer
Game.persistantKey = false

Game.optionControls.soundVolume = Game.masterVolume
Game.optionControls.fullScreen = false


--Game.freeCam = false
function Game:initGui( )
	
	g:addToResourcePath(filesystem.pathJoin("resources", "fonts"))
	g:addToResourcePath(filesystem.pathJoin("resources", "gui"))
	g:addToResourcePath(filesystem.pathJoin("resources", "media"))
	g:addToResourcePath(filesystem.pathJoin("resources", "themes"))
	g:addToResourcePath(filesystem.pathJoin("resources", "layouts"))

	layermgr.addLayer("gui", 99999, g:layer())
	g:setTheme(THEME_NAME)
	g:setCurrTextStyle("default")

	--- Background STATIC IMAGE
	bg_l3_tex = wimage:newTexture("media/game_bg.png", g_BackgroundLayer, "bg_l3_tex")
	bg_l3 = image:newImage(bg_l3_tex, 0, 0)
	image:_setScale(bg_l3, 2, 2)
	--self.bg_l3_grid = mGrid:new(50, 50, 32, "Game/media/MGL_Clouds02.png", 1, "BLABLA", g_BackgroundLayer)
end

function Game:handleTurns(_turn)

end

function Game:prepareAllSounds( )
	sound:new(SOUND_MAIN_MENU, "Game/media/audio/bgmusic/grace_song_1_menus.ogg", Game.masterVolume, true, false)
	sound.mechWheel = sound:new(SOUND_WALKING, "Game/media/audio/units/GanglandMechanicWheel.ogg", Game.masterVolume, false, true)
	sound.mechWalk = sound:new(SOUND_WALKING, "Game/media/audio/units/GanglandMechanicWalk.ogg", Game.masterVolume, false, true)
	sound.orgWalk = sound:new(SOUND_WALKING, "Game/media/audio/units/walk.ogg", Game.masterVolume, false, true)
	sound.chainSaw = sound:new(SOUND_GUNS, "Game/media/audio/units/gun/GanglandChainsaw.ogg", Game.masterVolume, false, true)
	sound.gun = sound:new(SOUND_GUNS, "Game/media/audio/units/gun/GanglandGun.ogg", Game.masterVolume, false, true)
	sound.punch = sound:new(SOUND_GUNS, "Game/media/audio/units/gun/GanglandPunch.ogg", Game.masterVolume, false, true)
	sound.factoryProd = sound:new(SOUND_GUNS, "Game/media/audio/units/building/GanglandFactProdUnit.ogg", Game.masterVolume, false, true)
	sound.factorySel = sound:new(SOUND_GUNS, "Game/media/audio/units/building/GanglandSelectFactory.ogg", Game.masterVolume, false, true)
	sound.buildingCaptured = sound:new(SOUND_GUNS, "Game/media/audio/units/building/GanglandBuildingCaptured.ogg", Game.masterVolume, false, true)
	sound.menuSwipe = sound:new(SOUND_GUNS, "Game/media/audio/units/ui/GanglandMenuSwipe.ogg", Game.masterVolume, false, true)
	sound.buttonPressed = sound:new(SOUND_BUTTONS, "Game/media/audio/units/ui/GanglandPressingAButton.ogg", Game.masterVolume, false, true)
	sound.buttonHover = sound:new(SOUND_BUTTONS, "Game/media/audio/units/ui/GanglandMouseOverButton.ogg", Game.masterVolume, false, true)
	sound.bigGun = sound:new(SOUND_GUNS, "Game/media/audio/units/bigGun.ogg", Game.masterVolume, false, true)
	sound.mechDying = sound:new(SOUND_GUNS, "Game/media/audio/units/GanglandMechanicDying.ogg", Game.masterVolume, false, true)
	sound.orgDying = sound:new(SOUND_GUNS, "Game/media/audio/units/GanglandOrganicDying.ogg", Game.masterVolume, false, true)

	sound.punch = sound:new(SOUND_GUNS, "Game/media/audio/units/GanglandPunch.ogg", Game.masterVolume, false, true)
	sound.club = sound:new(SOUND_GUNS, "Game/media/audio/units/GanglandClub_spottah.ogg", Game.masterVolume, false, true)
	sound.knife = sound:new(SOUND_GUNS, "Game/media/audio/units/GanglandKnife.ogg", Game.masterVolume, false, true)--GanglandKnife
	sound.powerHeal = sound:new(SOUND_GUNS, "Game/media/audio/units/GanglandPowerupHealing.ogg", Game.masterVolume, false, true)
	sound:new(SOUND_BGMUSIC, "Game/media/audio/bgmusic/grace_song_2_ap.ogg", 0.04, true, false) -- Game.masterVolume
	sound.cash = sound:new(SOUND_GUNS, "Game/media/audio/MGL_Cash.ogg", Game.masterVolume, false, true)

	--MOAIUntzSystem:setVolume(Game.masterVolume)
end

function Game:init( )


	
	image:init()
	mGrid:init( )
	anim:init(0.01)
	font:init( )
	effect:init( )
	Game:initGui( )
	interface:init(g, resources)
	

	initStates( )


	map:init( )
	
	camera:init( )
	Game:loadOptionsState( )
	--self:prepareAllSounds( )
	
	
end

function Game:update( )


	Game.worldTimer = MOAISim.getElapsedTime( )
	--mGrid:_debugAnim(self.bg_l3_grid, 1, 5)
	Game:loopPersistantKeyPressed( )
	anim:update(Game.worldTimer)
	handleStates( )
	Game:cameraUpdate( )
	_updateZoom( )
end


function Game:draw( )


end

function Game:touchRight( )
	--if zKey == false then
	local _st = state[currentState]
	if _st ~= "LevelEditor" then
		--[[
When right clicking, the map scrolling is stuck, and needs a left click, tho I'm not sure it's ment to be that way or not

		--]]
		--MouseDown = true
		--camera:setJoystickVisible( )
	end
	--end
	----print("X: "..math.floor( (Game.mouseX-map.offX+map.gridSize) /map.gridSize).." Y: ".. math.floor( (Game.mouseY-map.offY+map.gridSize) /map.gridSize).."")
end

function Game:keypressed( key )
	Game.keyTimer = Game.worldTimer
	local _st = state[currentState]
	if _st == "ActionPhase" then
		unit:keypressed( key )
		if key == 102 then
			Game.globalFogOfWar = not Game.globalFogOfWar
			if Game.globalFogOfWar == true then
				print("FOG OF WAR IS ON: ")
				map:_updateFogOfWar( )
			else
				map:_disableFogOfWar( )
				print("FOG OF WAR IS OF: ")
			end
		end

		-- 97, 100, 115, 119
		if Game.cursorEnabled == true then
			Game.key = key
			--interface:_AUNavigation(key)
			if interface:_getBuyMenuTweenStatus( ) == false then
				if key == 97 then -- a
					Game.cursorX = Game.cursorX - 1--map:updateScreen(32, 0)
					Game.persistantKey = true
					interface:_updateGameCursor( )

				elseif key == 100 then --d
					Game.cursorX = Game.cursorX + 1--map:updateScreen(-32, 0)
					Game.persistantKey = true
					interface:_updateGameCursor( )
				elseif key == 115 then -- s
					Game.cursorY = Game.cursorY + 1--map:updateScreen(0, -32)
					Game.persistantKey = true
					interface:_updateGameCursor( )
				elseif key == 119 then -- w
					
					Game.cursorY = Game.cursorY - 1--map:updateScreen(0, 32)
					Game.persistantKey = true
					interface:_updateGameCursor( )
				elseif key == 101 then
					_handleTurnEndPressed( )
				elseif key == 113 then
					_handleApQuitMMButton( )
				elseif key == 103 then
					interface:_debugPrintElementsTable( )
				elseif key == 104 then
					--local flagBool = input:_getFlag( )
					input:setFlagTo(false)
				elseif key == 106 then
					input:setFlagTo(true)
				end


			else
				if key == 104 then
					--local flagBool = input:_getFlag( )
					input:setFlagTo(false)
				elseif key == 106 then
					input:setFlagTo(true)
				end
				interface:_keyboardNavigationThroughMenu(key)
				if key == 9 then
					print("BUT TAB?")
					print("BUT TAB?")
					print("BUT TAB?")
					print("BUT TAB?")
					print("BUT TAB?")
					print("BUT TAB?")
					interface:_IncIndex( )
				end

				if key == 32 then
					g:injectMouseButtonDown(inputconstants.LEFT_MOUSE_BUTTON)
					g:injectMouseButtonUp(inputconstants.LEFT_MOUSE_BUTTON)				
				end
				
			end

			--interface:_keyboardNavigationThroughMenu( )
		else -- no cursor BUT SCROLL MAP
			Game.key = key
			if key == 97 then -- a
				Game.persistantKey = true
				map:updateScreen(32, 0)
			elseif key == 100 then --d
				Game.persistantKey = true
				map:updateScreen(-32, 0)
			elseif key == 115 then -- s
				Game.persistantKey = true
				map:updateScreen(0, -32)
			elseif key == 119 then -- w
				map:updateScreen(0, 32)
				Game.persistantKey = true
			end		
		end

	end

	if key == 61 then
		core:setFullscreen(true)
	elseif key == 45 then
		core:setFullscreen(false)
	elseif key == 91 then
		_handleZoomBttnPressed( )
	elseif key == 93 then
		_handleZoomBttnMinPressed( )
	end
end

function Game:loopPersistantKeyPressed( )
	if Game.persistantKey == true then
		if Game.worldTimer > Game.keyTimer + 0.5 then
			local key = Game.key

			if Game.cursorEnabled == true then
				if key == 97 then -- a
					Game.cursorX = Game.cursorX - 1--map:updateScreen(32, 0)
					interface:_updateGameCursor( )

				elseif key == 100 then --d
					Game.cursorX = Game.cursorX + 1--map:updateScreen(-32, 0)
					interface:_updateGameCursor( )
				elseif key == 115 then -- s
					Game.cursorY = Game.cursorY + 1--map:updateScreen(0, -32)
					interface:_updateGameCursor( )
				elseif key == 119 then -- w
					
					Game.cursorY = Game.cursorY - 1--map:updateScreen(0, 32)
					interface:_updateGameCursor( )
				end
			else
				if key == 97 then -- a
					map:updateScreen(32, 0)
				elseif key == 100 then --d
					map:updateScreen(-32, 0)
				elseif key == 115 then -- s
					map:updateScreen(0, -32)
				elseif key == 119 then -- w
					map:updateScreen(0, 32)
				end	
			end
		end


	end
end

function Game:keyreleased( key )
	local _st = state[currentState]
	if _st == "ActionPhase" then
		Game.persistantKey = false
		unit:keyreleased(key)
	end
end

function Game:touchPressed (_idx)
	if Game.disableInteraction == false then
		_gTouchPressed = true
		local _st = state[currentState]
		if _st == "Intro" then
			local introValue = interface:_introGetIntroState( )
			if introValue == 2 then
				interface:_setIntroState(3)
			end
		elseif _st == "ActionPhase" then
			unit:touchpresed( )
		elseif _st == "Levels" then
			worldMap:touchpressed( )
		elseif _st == "LevelEditor" then
			lEditor:touchpressed2( )
		end

		if _idx ~= nil then
			--print("_IDX NOT NILL!!!! and value: ".._idx.."")
			if _idx >= 1 then
			--	MouseDown = true
			--	camera:setJoystickVisible( )
			end
		end
	end
end

function Game:touchLeftReleased ( )
	if Game.disableInteraction == false then
		local _st = state[currentState]
		if _st == "ActionPhase" then
			unit:mousereleased( )
		elseif _st == "Levels" then
			worldMap:touchreleased( )
		elseif _st == "LevelEditor" then
			lEditor:touchreleased( )
		end
		_gTouchPressed = false
	end
end

function Game:dropUI(_gui, _resources)
	if (nil ~= _gui) then
		if (nil ~= widgets) then
        	unregisterScreenWidgets(widgets)
       	end
        _gui:layer():clear()
	end
end

function Game:touchReleased ( )
	if Game.disableInteraction == false then
		local _st = state[currentState]
		if _st == "Levels" then
			MouseDown = false
			camera:setJoystickHidden( )	
		elseif _st == "LevelEditor" then

		end
	end
	
end

function Game.touchLocation( x, y )
	
	Game.mouseX, Game.mouseY = core:returnLayerTable( )[1].layer:wndToWorld(x, y)
	Game.msX, Game.msY = x, y

	
	

end

function Game:cameraUpdate( )
	if Game.disableInteraction == false then 
		local _st = state[currentState]
		if _st == "ActionPhase" then
			unit:touchlocation(Game.mouseX, Game.mouseY)
		elseif _st == "Levels" then
			worldMap:touchlocation(Game.mouseX, Game.mouseY)
		elseif _st == "LevelEditor" then
			if _gTouchPressed == true then
				lEditor:touchpressed( )
			end
		end
	end
end

function Game:ViewportScale(_ammX, _ammY)
	core:returnViewPort( )[1].viewPort:setScale(core:returnVPWidth()/_ammX, -core:returnVPHeight()/_ammY)
end
--MOAIInputMgr.device.pointer:setCallback(Game.touchLocation)


function Game:initPathfinding(__grid)
	--grid = Grid(_grid) 
	
	--pather = Jumper(_grid, walkable, false)
	grid = Grid(__grid, false)
	_grid = Grid(__grid, false)
	pather = Pathfinder(grid, 'JPS', walkable)
	pather:setMode("ORTHOGONAL")
	
end

function Game:updatePathfinding()
	--grid = Grid(_grid) 
	--grid = Grid(_grid)
	--_grid = Grid(Game.grid)
	--pather = Pathfinder(_grid, 'JPS', walkable)
	--pather = Jumper(Game.grid, walkable, false)

end

function Game:setCollisionAt(_x, _y, _state)
	if _state == true then
		Game.grid[_x][_y] = walkable+200
	else
		Game.grid[_x][_y] = walkable
	end
	----print("GRID WIDTH: "..#Game.grid.." AND HEGHT: "..#Game.grid[#Game.grid].."")
	self:updatePathfinding( )
end

function Game:loop( )
	Game:update( )
	Game:draw( )
end

function Game:drop( )
	
end

function onMouseLeftEvent(down)
  if (down) then
    g:injectMouseButtonDown(inputconstants.LEFT_MOUSE_BUTTON)
  else
    g:injectMouseButtonUp(inputconstants.LEFT_MOUSE_BUTTON)
  end
end

function Game:saveOptionsState( )
	local saveFile = "config.sv"
	--table.save(tb, "map/".._name..".col")
	local result = MOAIFileSystem.checkPathExists(pathToWrite.."config/")
	if result == false then
		MOAIFileSystem.affirmPath(pathToWrite.."config/")
	end
	table.save(Game.optionControls, ""..pathToWrite.."config/"..saveFile.."" )
	print("SAVED INFO FROM OPTIONS MENU")
end

function Game:loadOptionsState( )
	local saveFile = ""..pathToWrite.."config/config.sv"
	local tb = table.load(saveFile)
	print("LOADED TABLE!!!!!")
--
	--for i,v in pairs(tb) do
		--print(""..i.."")
	--end
	local bool = false
	if tb ~= nil then
		bool = true
	end
	return tb, bool
end