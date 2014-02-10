local textstyles = require "gui/textstyles"
function interface:_init_worldMap( )
	self._activeView = {}
	--self._activeView[1] = {name="wm_bar", panel = nil, x = 0, y = 0, ox = 0, oy = 0, childView = {} }
	--self._activeView[2] = {name="confirmMission", panel = nil, x = 0, y = 0, ox = 0, oy = 0, childView = {} }


	self._showConfirmMission = false

	self._testString1 = "  Mission Name: TODO: NAME IT\n"
	self._testString2 = "  Mission Type: Battle\n"
	self._testString3 = "  Opposing army: Mutants\n"
	self._testString4 = "  Description: TODO - description"
	--self:_create_worldMap_bar( )

	self._victor = nil
	--image:setColor(bg_l3, Game.bgColor[3].r,  Game.bgColor[3].g,  Game.bgColor[3].b, 255)
	self:_ap_zoonButton( )

	_handleZoomBttnMinPressed( )
	_handleZoomBttnPressed( )

	--local 
	sound:playFromCategory(SOUND_WORLDMAP)
end

function interface:_create_worldMap_bar( )
	wm_bar = element.gui:createImage( )
	wm_bar:setDim(100, 10)
	wm_bar:setPos(0, 90)
	wm_bar:setImage(element.resources.getPath("worldMap/worldmap_bar.png") )

	--[[EVENT_MOUSE_ENTERS
EVENT_MOUSE_LEAVES]]
	wm_bar:registerEventHandler(wm_bar.EVENT_MOUSE_ENTERS, nil, _wmOnEnter)
	wm_bar:registerEventHandler(wm_bar.EVENT_MOUSE_LEAVES, nil, _wmOnExit)
	
	self:_create_worldMap_backButton( )
	self:_create_worldMap_accept_mission_panel( )
end

function interface:_create_worldMap_backButton( )

	--worldmap_backButton
	wm_back = element.gui:createButton( )
	wm_back:setDim(14, 10)
	wm_back:setPos(84, 0)
	wm_back:setNormalImage(element.resources.getPath("worldMap/worldmap_backButton.png") )
	wm_back:setHoverImage(element.resources.getPath("worldMap/worldmap_backButton_hover.png") )
	wm_back:setPushedImage(element.resources.getPath("worldMap/worldmap_backButton_hover.png") )

	wm_save = element.gui:createButton( )
	wm_save:setDim(14, 10)
	wm_save:setPos(68, 0)
	wm_save:setNormalImage(element.resources.getPath("worldMap/button_temp.png") )
	wm_save:setHoverImage(element.resources.getPath("worldMap/button_temp_hover.png") )
	wm_save:setPushedImage(element.resources.getPath("worldMap/button_temp_hover.png") )


	wm_back:registerEventHandler(wm_back.EVENT_BUTTON_CLICK, nil, _handle_wm_BackButtonPressed)
	wm_save:registerEventHandler(wm_save.EVENT_BUTTON_CLICK, nil, _handle_wm_SaveButtonPressed)

	wm_bar:addChild(wm_back)
	wm_bar:addChild(wm_save)

end

function interface:_populateDescriptionBox(_nameOfFile)
	wm_mission_box:clearText()
	print("NAME OF FILE IS: ".._nameOfFile.."")
	print("NAME OF FILE IS: ".._nameOfFile.."")
	print("NAME OF FILE IS: ".._nameOfFile.."")
	print("NAME OF FILE IS: ".._nameOfFile.."")
	print("NAME OF FILE IS: ".._nameOfFile.."")
	--local lvName = string.gsub(_nameOfFile, ".mig", "")
	local _fileName = "map/description/".._nameOfFile..".txt"
	local file = io.open(_fileName, "r");
	--local data = file:read("*a")
	
	wm_mission_box:_addNewLine( )
	for line in file:lines() do
		wm_mission_box:addText(line)
		wm_mission_box:_addNewLine( )
	  -- table.insert (_tableName[self.tCounter], line);
	end
	--self.tCounter = self.tCounter + 1

end

function interface:_create_worldMap_accept_mission_panel( )


	wm_confirmMission = element.gui:createImage( )
	wm_confirmMission:setDim(100, 90)
	wm_confirmMission:setPos(0, -90) -- so it should be zero :P
	wm_confirmMission:setImage(element.resources.getPath("worldMap/trans_bg.png"))

	wm_confirmMission:registerEventHandler(wm_confirmMission.EVENT_MOUSE_ENTERS, nil, _wmOnEnter)
	wm_confirmMission:registerEventHandler(wm_confirmMission.EVENT_MOUSE_LEAVES, nil, _wmOnExit)

	wm_bar:addChild(wm_confirmMission)

	self:_create_worldMap_missionButtons( )
end

function interface:_create_worldMap_missionButtons( )
	wm_cm_Accept = element.gui:createButton( )
	wm_cm_Accept:setDim(40, 25)
	wm_cm_Accept:setPos(55, 10)
	wm_cm_Accept:setText("START MISSION!")

	wm_cm_Accept:setNormalImage(element.resources.getPath("worldMap/button_temp2.png") )
	wm_cm_Accept:setHoverImage(element.resources.getPath("worldMap/button_temp_hover2.png") )
	wm_cm_Accept:setPushedImage(element.resources.getPath("worldMap/button_temp_hover2.png") )


	wm_cm_Accept:registerEventHandler(wm_cm_Accept.EVENT_BUTTON_CLICK, nil, _handleWmAcceptButton)

	wm_cm_Cancel = element.gui:createButton( )
	wm_cm_Cancel:setDim(40, 25)
	wm_cm_Cancel:setPos(55, 60)
	wm_cm_Cancel:setText("CANCEL")

	wm_cm_Cancel:setNormalImage(element.resources.getPath("worldMap/button_temp2.png") )
	wm_cm_Cancel:setHoverImage(element.resources.getPath("worldMap/button_temp_hover2.png") )
	wm_cm_Cancel:setPushedImage(element.resources.getPath("worldMap/button_temp_hover2.png") )

	wm_cm_Cancel:registerEventHandler(wm_cm_Cancel.EVENT_BUTTON_CLICK, nil, _handleWmCancelButton)

	wm_mission_panel = element.gui:createImage( )
	wm_mission_panel:setDim(45, 76)
	wm_mission_panel:setPos( 2.5, 10 )

	wm_mission_box = element.gui:createTextBox( )
	wm_mission_box:setDim( 43, 74 )
	wm_mission_box:setPos( 3, 11 )
	wm_mission_box:setLineHeight(3)
	wm_mission_box:addText("TEST 1 2 3 4 5 6 7 8 9 10 ashara test lol wtf qq bbby please don't durt me, don't durt me, no more")

	print("THIS FRIKING THINGZ")

	wm_mission_box:setTextStyle(textstyles.get( "listselected" ), 22)

	wm_mission_panel:setImage(element.resources.getPath("worldMap/actionBar_Background.png"))

	wm_confirmMission:addChild(wm_cm_Accept)
	wm_confirmMission:addChild(wm_cm_Cancel)
	wm_confirmMission:addChild(wm_mission_panel)
	wm_confirmMission:addChild(wm_mission_box)
end

function interface:_setConfirmMission(_state)
	self._showConfirmMission = _state
	element.gui:setFocus(wm_confirmMission)
end

function interface:_getConfirmMissionState( )
	return self._showConfirmMission
end

function interface:_loopWorldMapStuff( )
	--[[if self._showConfirmMission == true then
		wm_confirmMission:tweenPos(0, -90)
	else
		wm_confirmMission:tweenPos(-200, -90)
	end--]]
end


function interface:_setVictor(_player)
	Game.victor = _player
end

---callbacks
function _handle_wm_BackButtonPressed( )
	sound:stopAllFromCategory(SOUND_WORLDMAP)
	worldMap:destroy( )
	anim:dropAll( )
	_bGuiLoaded = false
	Game:dropUI(g, resources )
	currentState = 2
end

function _handle_wm_SaveButtonPressed( )
	wmBuildings:saveGameState( )
end

function _handleSimCapture( )
	--wmBuildings:simulateCapture( )
	wmBuildings:setTurnUpdateTo(true)
end

function _handleWmAcceptButton( )
	sound:stopAllFromCategory(SOUND_WORLDMAP)
	worldMap:destroy( )
	anim:dropAll( )
	_bGuiLoaded = false
	Game:dropUI(g, resources )
	--Game.mapFile = "beanisland"
	currentState = 5
	Game.lastState = 4
end

function _wmOnEnter( )
	print("ENTER")
	worldMap:setTouchState(true)
end

function _wmOnExit( )
	print("EXIT")
	worldMap:setTouchState(false)
end

function _handleWmCancelButton( )
	interface:_setConfirmMission(false)
end