commander = { }
commander[1] = { sound = "prima.ogg", name = "Mortel V", team = 1, mobility = 50, attackBonus = 40, defenseBonus = 100, incomeBonus = 50, critChance = 0.5, powerup = "Healing" }
commander[2] = { sound = "twinning.ogg", name = "Twinning", team = 1, mobility = 100, attackBonus = 40, defenseBonus = 40, incomeBonus = 0, critChance = 19, powerup = "Dmg"  }
commander[3] = { sound = "killchip.ogg", name = "Killchip", team = 2, mobility = 150, attackBonus = 200, defenseBonus = 0, incomeBonus = 50, critChance = 10, powerup = "Healing" }
commander[4] = { sound = "thunderbite.ogg", name = "Tunderbite", team = 2, mobility = 0, attackBonus = 40, defenseBonus = 150, incomeBonus = 50, critChance = 19, powerup = "Dmg"  }

commander[5] = { sound = "amy.ogg", name = "Amy", team = 1, mobility = 150, attackBonus = 80, defenseBonus = 120, incomeBonus = 50, critChance = 10, powerup = "Healing" }
commander[6] = { sound = "buzzmaw.ogg", name = "Buzzmaw", team = 1, mobility = 20, attackBonus = 150, defenseBonus = 0, incomeBonus = 60, critChance = 19, powerup = "Dmg"  }
commander[7] = { sound = "trigon.ogg", name = "Trigon V", team = 2, mobility = 10, attackBonus = 50, defenseBonus = 50, incomeBonus = 200, critChance = 10, powerup = "Healing" }
commander[8] = { sound = "signal.ogg", name = "Signal", team = 2, mobility = 10, attackBonus = 50, defenseBonus = 50, incomeBonus = 20, critChance = 19, powerup = "Dmg"  }


stat_table = {}
stat_table[1] = {stat = "DMG: ", value = commander[1].attackBonus }
stat_table[2] = {stat = "DEF: ", value = commander[1].defenseBonus }
stat_table[3] = {stat = "MOB: ", value = commander[1].mobility }
stat_table[4] = {stat = "INC: ", value = commander[1].incomeBonus }
stat_table[5] = {stat = "", value = commander[1].attackBonus }

function _setStatValue(_id)
	local string = "Mutants"
	if commander[_id].team == 2 then
		string = "Robots"
	end
	stat_table[1] = {stat = "DMG: ", value = commander[_id].attackBonus }
	stat_table[2] = {stat = "DEF: ", value = commander[_id].defenseBonus }
	stat_table[3] = {stat = "MOB: ", value = commander[_id].mobility }
	stat_table[4] = {stat = "INC: ", value = commander[_id].incomeBonus }
	stat_table[5] = {stat = "", value = commander[_id].attackBonus }
	
end

function interface:_loopThroughComandersAndLoadSound( )
	if self._commanderSounds == nil then
		self._commanderSounds = { }
		for i,v in ipairs(commander) do
			if v.sound ~= nil then
				self._commanderSounds[i] = sound:new(SOUND_COMMANDERS, "Game/media/audio/commanders/"..v.sound.."", 1, false, false)
			end
		end
	end
end

function interface:_returnCommanderSoundTable( )
	return self._commanderSounds
end

function interface:_init_commander_sel( )
	local roots, widgets, groups = element.gui:loadLayout(resources.getPath("commander_win.lua"), "")

	---------------------------------------------------------
	----
	----
	--primaSOUND = sound:new(SOUND_COMMANDERS, "Game/media/audio/commanders/prima.ogg", 1, false, false)
	-----

	------
	self:_loopThroughComandersAndLoadSound( )

	self._commanderButtons = { }
	self._commanderButtons2 = { }

	self._playerToTeam = {}
	self._playerToTeam[1] = player1
	self._playerToTeam[2] = player2

	self._selected = { }
	self._selected[1] = true
	self._selected[2] = false
	self._selected[3] = false
	self._selected[4] = true

	self._selectedGFX = { }
	self._selectedGFX[1] = "selected_button.png"
	self._selectedGFX[2] = "unselected_button.png"

	--[[if (nil ~= widgets.bgImage) then
		self._bgImage = widgets.bgImage.window
		print("BG IMAGE REGISTERED")
	else
		print("BG IMAGE FAILED")
	end--]]

	if (nil ~= widgets.bgPanel) then
	  self._csBgPanel = widgets.bgPanel.window
	  print("BG PANEL REGISTERED")
	else
		print("ONE FAIL")
	end

	if (nil ~= widgets.commanderInfo1) then
	  self._csComanderInfo1 = widgets.commanderInfo1.window
	  print("ComanderInfo1 REGISTERED")
	else
		print("ONE FAIL")
	end

--comander1Pic
	if (nil ~= widgets.comander1Pic) then
	  self._csComander1Pic = widgets.comander1Pic.window
	  print("Comander1Pic REGISTERED")
	else
		print("ONE FAIL")
	end

--commanderNameLabel1
	if (nil ~= widgets.commanderNameLabel1) then
	  self._csCommanderNameLabel1 = widgets.commanderNameLabel1.window
	  print("commanderNameLabel1 REGISTERED")
	else
		print("ONE FAIL")
	end

	if (nil ~= widgets.factionNameLabel1) then
	  self._csFactionNameLabel1 = widgets.factionNameLabel1.window
	  print("factionNameLabel1 REGISTERED")
	else
		print("ONE FAIL")
	end

	if (nil ~= widgets.commander1StatWidget) then
	  self._csCommander1StatWidget = widgets.commander1StatWidget.window
	  print("commander1StatWidget REGISTERED")
	else
		print("ONE FAIL")
	end



	if (nil ~= widgets.commanderInfo2) then
	  self._csComanderInfo2 = widgets.commanderInfo2.window
	  print("ComanderInfo2 REGISTERED")
	else
		print("ONE FAIL")
	end

	if (nil ~= widgets.comander2Pic) then
	  self._cscomander2Pic = widgets.comander2Pic.window
	  print("comander2Pic REGISTERED")
	else
		print("ONE FAIL")
	end

	if (nil ~= widgets.commanderNameLabel2) then
	  self._cscommanderNameLabel2 = widgets.commanderNameLabel2.window
	  print("commanderNameLabel2 REGISTERED")
	else
		print("ONE FAIL")
	end

	if (nil ~= widgets.factionNameLabel2) then
	  self._csfactionNameLabel2 = widgets.factionNameLabel2.window
	  print("factionNameLabel2 REGISTERED")
	else
		print("ONE FAIL")
	end

	if (nil ~= widgets.commander2StatWidget) then
	  self._cscommander2StatWidget = widgets.commander2StatWidget.window
	  print("commander2StatWidget REGISTERED")
	else
		print("ONE FAIL")
	end

	if (nil ~= widgets.commanderPanel1) then
	  self._cscommanderPanel1 = widgets.commanderPanel1.window
	  print("commander2StatWidget REGISTERED")
	else
		print("ONE FAIL")
	end

	if (nil ~= widgets.Player1Label) then
	  self._csPlayer1Label = widgets.Player1Label.window
	  print("commander2StatWidget REGISTERED")
	else
		print("ONE FAIL")
	end

	if (nil ~= widgets.commanderPanel2) then
	  self._cscommanderPanel2 = widgets.commanderPanel2.window
	  print("commanderPanel2 REGISTERED")
	else
		print("ONE FAIL")
	end	

	if (nil ~= widgets.Player2Label) then
	  self._csPlayer2Label = widgets.Player2Label.window
	  print("Player2Label REGISTERED")
	else
		print("ONE FAIL")
	end	

	if (nil ~= widgets.startButton) then
	  self._csStartButton = widgets.startButton.window
	  self._csStartButton:registerEventHandler(self._csStartButton.EVENT_BUTTON_CLICK, nil, _handleStartPressed)
	  print("Player2Label REGISTERED")
	else
		print("ONE FAIL")
	end	

	if (nil ~= widgets.returnButton) then
	  self._csReturnButton = widgets.returnButton.window
	  self._csReturnButton:registerEventHandler(self._csReturnButton.EVENT_BUTTON_CLICK, nil, _handeReturnPressed)
	  print("Player2Label REGISTERED")
	else
		print("ONE FAIL")
	end	


	self._activeButtons = { }

	if (nil ~= widgets.humanButton1) then
		self._activeButtons[1] = widgets.humanButton1.window
		self._activeButtons[1]:registerEventHandler(self._activeButtons[1].EVENT_BUTTON_CLICK, nil, _handeP1HumanPressed)
		--self._activeButtons[1].sel = true
	else

	end

	if (nil ~= widgets.humanButton2) then
		self._activeButtons[2] = widgets.humanButton2.window
		self._activeButtons[2]:registerEventHandler(self._activeButtons[2].EVENT_BUTTON_CLICK, nil, _handeP2HumanPressed)
		--self._activeButtons[2].sel =false
	else

	end

	if (nil ~= widgets.aiButton1) then
		self._activeButtons[3] = widgets.aiButton1.window
		self._activeButtons[3]:registerEventHandler(self._activeButtons[3].EVENT_BUTTON_CLICK, nil, _handeP1AiPressed)
	else

	end

	if (nil ~= widgets.aiButton2) then
		self._activeButtons[4] = widgets.aiButton2.window
		self._activeButtons[4]:registerEventHandler(self._activeButtons[4].EVENT_BUTTON_CLICK, nil, _handeP2AiPressed)
	else

	end

	for i,v in ipairs(self._activeButtons) do
		if self._selected[i] == true then
			v:setNormalImage(element.resources.getPath( "commander/"..self._selectedGFX[1].."" ) )
		else
			v:setNormalImage(element.resources.getPath( "commander/"..self._selectedGFX[2].."" ) )
		end
	end
--startButton

--returnButton

	_setStatValue(1)
	self:_cs_populateWidget(1)
	_setStatValue(1)
	self:_cs_populateWidget(2)

	self:_cs_populatePanelsWithItems()
	player1.team = commander[1].team
	player2.team = commander[1].team
	self:_cs_setPlayerStats(1, 1)
	self:_cs_setPlayerStats(2, 1)
	local temp = { team = 1, _id = 1}
	local temp2 = { team = 2, _id = 1 }
	interface:_update_cs_profile(temp)
	interface:_update_cs_profile(temp2)

	--self:_initMapSel_grid(Game.mapFile)
end

function interface:_cs_populatePanelsWithItems()
	local widget

	self._cdWidth = 7
	self._cdHeight = 10

	self.team = {}
	self.team[1] = {}
	self.team[2] = {}
	self.team[1].row = 0
	self.team[1].col = 0
	self.team[2].row = 0
	self.team[2].col = 0

	for i = 1, 8 do
		self:_cs_commanderBttnTemplate(i, 1)
	end

	for i = 1, 8 do
		self:_cs_commanderBttnTemplate(i, 2)
	end
end

function interface:_cs_commanderBttnTemplate(_id, _parrent)
	local temp = {
		cdButton = element.gui:createButton( ),
		_id = _id,
		team = _parrent,
	}

	if _parrent == 1 then
		self._cscommanderPanel1:addChild(temp.cdButton)
	else
		self._cscommanderPanel2:addChild(temp.cdButton)
	end

	temp.cdButton:setDim(self._cdWidth, self._cdHeight)

	if _id == 1 then
		temp.cdButton:setNormalImage(element.resources.getPath("commander/portraits/".._id.."".._parrent.."d.png"))
	else
		temp.cdButton:setNormalImage(element.resources.getPath("commander/portraits/".._id.."".._parrent..".png"))
	end
	temp.cdButton:setHoverImage(element.resources.getPath("commander/portraits/".._id.."".._parrent.."d.png"))
	temp.cdButton:setPushedImage(element.resources.getPath("commander/portraits/".._id.."".._parrent.."d.png"))
	temp.cdButton:registerEventHandler(temp.cdButton.EVENT_BUTTON_CLICK, nil, _handleCsCommanderSelButtonPressed, temp)
	temp.cdButton.row = self.team[_parrent].row
	temp.cdButton.x = 4 + self.team[_parrent].row
	temp.cdButton.col = self.team[_parrent].col
	temp.cdButton.y = 7 + self.team[_parrent].col
	temp.cdButton:setPos(temp.cdButton.x , temp.cdButton.y)

	self.team[_parrent].row = self.team[_parrent].row + self._cdWidth + 1
	if self.team[_parrent].row >= 4 * (self._cdWidth + 1 ) then
		self.team[_parrent].col = self.team[_parrent].col + self._cdHeight + 1
		self.team[_parrent].row = 0
	end

	if _parrent == 1 then
		table.insert(self._commanderButtons, temp)
	else
		table.insert(self._commanderButtons2, temp)
	end
end

function interface:_cs_populateWidget(_team)
	local widget
	if _team == 1 then
		widget = self._csCommander1StatWidget
	else
		widget = self._cscommander2StatWidget
	end

	for i = 1, 5 do
		local row = widget:addRow()
		row:getCell(1):setText(""..stat_table[i].stat.."")
		local cMax
		cMax = math.ceil(stat_table[i].value / 40 )+ 1
		for j = 2, 5  do
			if j <= cMax+1 then
				row:getCell(j):setImage(element.resources.getPath("commander/star.png"))
			else
				row:getCell(j):setImage(element.resources.getPath("commander/star_empty.png"))
			end
		end
	end
end

function interface:_csupdateWidget(_team)
	local widget
	local pic
	if _team == 1 then
		widget = self._csCommander1StatWidget
		pic = self._csComander1Pic
	else
		widget = self._cscommander2StatWidget
		pic = self._csComander2Pic
	end

	for i = 1, 5 do
		local row = widget:getRow(i)
		row:getCell(1):setText(""..stat_table[i].stat.."")
		local cMax
		cMax = math.ceil(stat_table[i].value / 40 )+ 1
		for j = 2, 6  do
			if j <= cMax+1 then
				row:getCell(j):setImage(element.resources.getPath("commander/star.png"))
			else
				row:getCell(j):setImage(element.resources.getPath("commander/star_empty.png"))
			end
		end
	end





end

function interface:_update_cs_comButtonIcon(data)
	local table 
	if data.team == 1 then
		table = self._commanderButtons
	else
		table = self._commanderButtons2
	end
	local _id = data._id
	local _team = data.team
	for i,v in ipairs(table) do
		if v._id ~= _id then
			v.cdButton:setNormalImage(element.resources.getPath("commander/portraits/"..i.."".._team..".png"))
		else
			v.cdButton:setNormalImage(element.resources.getPath("commander/portraits/"..i.."".._team.."d.png"))
		end
	end
end

function interface:_update_cs_profile(data)
	local _team = data.team

	local pic
	local name
	local faction
	if _team == 1 then
		pic = self._csComander1Pic
		name = self._csCommanderNameLabel1
		faction = self._csFactionNameLabel1
	else
		pic = self._cscomander2Pic
		name = self._cscommanderNameLabel2
		faction = self._csfactionNameLabel2
	end

	local i = data._id
	pic:setImage( element.resources.getPath("commander/portraits/"..i.."".._team..".png")  )
	name:setText(""..Game.commander[data.team].name.."")
	local string = "Robots"
	if commander[data._id].team == 1 then
		string = "Mutants"
	end
	faction:setText(""..string.."")
end

function _handleCsCommanderSelButtonPressed(event, data )
	--------------------------------
	--------------------------------
	---- SOUND HERE ----------------
	local comSounds = interface:_returnCommanderSoundTable( )
	sound:play(comSounds[data._id])
	---- SOUND HERE ----------------
	--------------------------------
	--------------------------------
	_setStatValue(data._id)
	interface:_csupdateWidget(data.team)
	interface:_update_cs_comButtonIcon(data)
	
	Game.commander[data.team].imgID = data._id
	Game.commander[data.team].name = commander[data._id].name

	if data.team == 1 then
		player1.team = commander[data._id].team
		interface:_cs_setPlayerStats(1, data._id)
	else
		if commander[data._id].team == 1 then
			player2.team = 2
		else
			player2.team = 1
		end
		interface:_cs_setPlayerStats(2, data._id)
	end

	interface:_update_cs_profile(data)

end

function interface:_cs_setPlayerStats(_team, _id)
--[[attackBonus
defenseBonus
critChance
]]

--[[attackBonus
defenseBonus
mobility]]
	self._playerToTeam[_team].attackBonus = commander[_id].attackBonus
	self._playerToTeam[_team].defenseBonus = commander[_id].defenseBonus
	self._playerToTeam[_team].mobility = commander[_id].mobility
	self._playerToTeam[_team].incomeBonus = commander[_id].incomeBonus
end

function debugPrintPlayStats( )
	print("PLAYER 1 - STR: "..player1.attackBonus.." DEF: "..player1.defenseBonus.." MOB: ")
	print("PLAYER 2 - STR: "..player2.attackBonus.." DEF: "..player2.defenseBonus.." MOB: ")
end

function interface:_getSelectedStats( )
	return self._selected
end

function _handleStartPressed( )
	--------------------------------
	--------------------------------
	---- SOUND HERE ----------------
	sound:play(sound.buttonPressed)	
	---- SOUND HERE ----------------
	--------------------------------
	--------------------------------
	sound:stopAllFromCategory(SOUND_MAIN_MENU)

	local selectedTable = interface:_getSelectedStats( )
	if selectedTable[1] == true then
		Game.player1 = "Human"
		player1.name = "Human"
	else
		Game.player1 = "Computer"
		player1.name = "Computer"
	end

	if selectedTable[2] == true then
		Game.player2 = "Human"
		player2.name = "Human"
	else
		Game.player2 = "Computer"
		player2.name = "Computer"
	end

	_bGuiLoaded = false
	_bGameLoaded = false
	--mGrid:destroy(1)
	Game:dropUI(g, resources )
	Game.lastState = 10
	currentState = 5

	debugPrintPlayStats( )

end

function _handeReturnPressed( )
	--------------------------------
	--------------------------------
	---- SOUND HERE ----------------
	sound:play(sound.buttonPressed)	
	---- SOUND HERE ----------------
	--------------------------------
	--------------------------------
	_bGuiLoaded = false
	_bGameLoaded = false
	--mGrid:destroy(1)
	Game:dropUI(g, resources )
	Game.lastState = 10
	currentState = 10
end

function interface:_cs_updatePanels( )
	self._csBgPanel:tweenPos(-100, 0, 0.2)
	--self._bgImage:tweenPos(-100, 0, 0.05)
	--[[
commanderInfo1
2, 2
commanderInfo2
59, 2

commanderPanel1
2 , 50
commanderPanel2
59 , 50
self._csComanderInfo1
self._csComanderInfo2
self._cscommanderPanel1
self._cscommanderPanel2
]]

	--[[self._csComanderInfo1:tweenPos(2, 2)
	self._csComanderInfo2:tweenPos(59, 2)
	self._cscommanderPanel1:tweenPos(2, 50)
	self._cscommanderPanel2:tweenPos(59, 50)--]]
end

function interface:_setP1Status(bool1, bool2)
	self._selected[1] = bool1
	self._selected[3] = bool2

	self:_updatePlayerButtons( )
end

function interface:_updatePlayerButtons( )
	for i,v in ipairs(self._activeButtons) do
		if self._selected[i] == true then
			v:setNormalImage(element.resources.getPath( "commander/"..self._selectedGFX[1].."" ) )
		else
			v:setNormalImage(element.resources.getPath( "commander/"..self._selectedGFX[2].."" ) )
		end
	end
end

function interface:_setP2Status(bool1, bool2)
	self._selected[2] = bool1
	self._selected[4] = bool2

	self:_updatePlayerButtons( )
end

function _handeP1HumanPressed( )
	interface:_setP1Status(true, false)
end

function _handeP2HumanPressed( )
	interface:_setP2Status(true, false)
end

function _handeP1AiPressed( )
	interface:_setP1Status(false, true)
end

function _handeP2AiPressed( )
	interface:_setP2Status(false, true)
end