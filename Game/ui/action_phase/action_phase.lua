local textstyles = require "gui/textstyles"



function interface:init_ap_buttons( )

	self._tweenMenuPanel = false
	self._dockX = 1
	self._dockX_out = -100

	self._bringUpConfirmBox = false

	self._menuPanelLocX = 0

	self._uStatTable = {}
	self._uStatTable[1] = { "HP", 10 }
	self._uStatTable[2] = { "RNG", 20 }
	self._uStatTable[3] = { "MOB", 30 }
	self._uStatTable[4] = { "DMG", 40 }

	self._uVictory = { }
	self._uVictory[1] = "Built: "
	self._uVictory[2] = "Lost: "
	self._uVictory[3] = "Days: "
	self._uVictory[4] = "Income: "
	self._uVictory[5] = "Damage Dealt: "
	self._uVictory[6] = "Score: "

	self._iconList = { }
	self._iconList[1] = "buy_menu/stat/shealth.png"
	self._iconList[2] = "buy_menu/stat/srange.png"
	self._iconList[3] = "buy_menu/stat/smobility.png"
	self._iconList[4] = "buy_menu/stat/sdamage.png"
	self._iconList[5] = "buy_menu/stat/cost.png"

	nextStepText = {}
	nextStepText[1] = "Build"
	nextStepText[2] = "Move"
	nextStepText[3] = "Attack"

	self._teamToPlayer = {}
	self._teamToPlayer[1] = player1
	self._teamToPlayer[2] = player2

	self._slideBanner = false
	self._slideImage = true
	self._pTurn = 1
	self._sliding = false
	self._topBarTween = false

	self:_ap_addTopBar( )
	self:_ap_endTurn( )
	self:_ap_zoonButton( )
	self:_initEndScreen( )

	self._confirmationType = 1

	zoomButtonState = false

	zoomList = {}
	zoomList[1] = 1
	zoomList[2] = 2
	zoomList[3] = 2

	zoomIDX = 1
	playerSetScale = 1

	self:_create_ap_buttons( )
	self:_create_slideTurn( )
	self:_init_ap_menu( )



	self._slideControls = false
	--anim:addToPool(self._goldCoinAnim)

	--_handleZoomBttnMinPressed( )
	--_handleZoomBttnPressed( )
	--_handleZoomBttnMinPressed( )

	self:_ap_createCommanderPanel( )

	self:_prepare_power_dock( )

	self:_prepare_victory_screen( )

	self._showDock = false
	self._showVictory = false

	local isSoundPlaying = sound:getCategoryPlaying(SOUND_BGMUSIC)

	if isSoundPlaying == false then
		sound:playFromCategory(SOUND_BGMUSIC)
	end

	self:_createConfirmationScreen(  )
	--self:_loadup_cmd( )
end

function interface:_loadup_cmd( )
	local roots, widgets, groups = element.gui:loadLayout(resources.getPath("cmd.lua"), "")
end

function interface:_getScale( )
	return zoomList[zoomIDX]
end

function interface:_prepare_victory_screen( )
	local roots, widgets, groups = element.gui:loadLayout(resources.getPath("victory_screen.lua"), "")
	--self:_addUiToDaddyTable(widgets)

	if (nil ~= widgets.vicWindow) then
		self._victoryPanel = widgets.vicWindow.window
	 	self._victoryPanel:registerEventHandler(self._victoryPanel.EVENT_MOUSE_ENTERS, nil, _onEnter)
	 	self._victoryPanel:registerEventHandler(self._victoryPanel.EVENT_MOUSE_LEAVES, nil, _onExit)
	else
		print("Widget Window FAIL")
	end

	if (nil ~= widgets.lbVictory) then
		self._victoryLabel = widgets.lbVictory.window
	 	self._victoryLabel:registerEventHandler(self._victoryLabel.EVENT_MOUSE_ENTERS, nil, _onEnter)
	 	self._victoryLabel:registerEventHandler(self._victoryLabel.EVENT_MOUSE_LEAVES, nil, _onExit)
	 	self._victoryLabel:setTextStyle(textstyles.get( "stats" ), 14)
	else
		print("Victory Label FAIL")
	end

	if (nil ~= widgets.scoreWidget) then
		self._scoreWidget = widgets.scoreWidget.window
	 	self._scoreWidget:registerEventHandler(self._scoreWidget.EVENT_MOUSE_ENTERS, nil, _onEnter)
	 	self._scoreWidget:registerEventHandler(self._scoreWidget.EVENT_MOUSE_LEAVES, nil, _onExit)
	else
		print("Score Widget FAIL")
	end

	if (nil ~= widgets.rematchButton) then
		self._rematchButton = widgets.rematchButton.window
		self._rematchButton:registerEventHandler(self._rematchButton.EVENT_BUTTON_CLICK, nil, _handleRematchPressed)
	 	self._rematchButton:registerEventHandler(self._rematchButton.EVENT_MOUSE_ENTERS, nil, _onEnter)
	 	self._rematchButton:registerEventHandler(self._rematchButton.EVENT_MOUSE_LEAVES, nil, _onExit)
	else
		print("REMATCH BUTTON FAIL")
	end

	local widgetList = self._scoreWidget
	for i = 1, 7 do
		local row = widgetList:addRow( )
		row:setInteractable(false)
		if i < 7 then
			if math.even(i) == true then
				row:setRowImage( element.resources.getPath("victory_screen/row.png") )
			end
			row:getCell(1):setText(""..self._uVictory[i].."")
			
			row:getCell(2):setText(""..math.random(1, 9000).."")
			row:setCellStyle(2,"statsBlue")
			row:getCell(3):setText(""..math.random(1, 9000).."")
			row:setCellStyle(3,"statsBad")
		end
	end

	if _bGameLoaded == true then
		self:_updateVictoryScreen( 1 )
	end
	--widgetList:_setHeaderStyle(1, "statsBlue")
	--widgetList:_setHeaderStyle(2, "statsBad")
end

function interface:_createConfirmationScreen(  )
	local roots, widgets, groups = element.gui:loadLayout(resources.getPath("confirmation_screen.lua"), "")
	--self:_addUiToDaddyTable(widgets)
	if (nil ~= widgets.bgFull) then
		self._confirmationScreen = widgets.bgFull.window
	else
		print("Confirmation Screen FAIL")
	end

	if(nil ~= widgets.confirmButton) then
		self._confirmButton = widgets.confirmButton.window
		self._confirmButton:registerEventHandler(self._confirmButton.EVENT_BUTTON_CLICK, nil, _handleConfirmQuitPressed)
		self._confirmButton:registerEventHandler(self._confirmButton.EVENT_MOUSE_ENTERS, nil, _onEnter)
		self._confirmButton:registerEventHandler(self._confirmButton.EVENT_MOUSE_LEAVES, nil, _onExit)	 
	else
		print("cannot register confirm button")
	end

	if(nil ~= widgets.cancelButton) then
		self._cancelButton = widgets.cancelButton.window
		self._cancelButton:registerEventHandler(self._cancelButton.EVENT_BUTTON_CLICK, nil, _handleCancelQuitPressed)
		self._cancelButton:registerEventHandler(self._cancelButton.EVENT_MOUSE_ENTERS, nil, _onEnter)
		self._cancelButton:registerEventHandler(self._cancelButton.EVENT_MOUSE_LEAVES, nil, _onExit)	 
	else
		print("cannot register confirm button")
	end	

	if(nil ~= widgets.lbText) then
		self._confirmationText = widgets.lbText.window
	else
		print("FAILED TO REGISTER CONFIRM TEXT")
	end
	print("CONFIRMATION HAPPENING")
end

function interface:_setConfirmationScreenText(_text)
	self._confirmationText:setText(_text)
end

function interface:_updateVictoryScreen( data )

--[[
	self._uVictory = { }
	self._uVictory[1] = "Units Built: "
	self._uVictory[2] = "Units Lost: "
	self._uVictory[3] = "Factories: "
	self._uVictory[4] = "Income: "
	self._uVictory[5] = "Damage Dealt: "
	self._uVictory[6] = "Score: "


]]

self._uVicStat = { }
local p1ub = unit:_getNrUnitsBuilt( ).p1 or 0
local p2ub = unit:_getNrUnitsBuilt( ).p2 or 0

local p1Lost = unit:_getNrUnitsLost( ).p1 or 0
local p2Lost = unit:_getNrUnitsLost( ).p2 or 0

local p1Dmg = math.floor(unit:_getTotalDamagedDealt( ).p1) or 0
local p2Dmg = math.floor(unit:_getTotalDamagedDealt( ).p2) or 0

local p1Fact = unit:_getNrFactories( ).p1 or 0
local p2Fact = unit:_getNrFactories( ).p2 or 0

local p1Income = building:_getLifetimeIncome( ).p1 or 0
local p2Income = building:_getLifetimeIncome( ).p2 or 0

self._uVicStat[1] = { p1 = p1ub, p2 = p2ub }
self._uVicStat[2] = { p1 = p1Lost, p2 = p2Lost }
self._uVicStat[3] = { p1 = p1Fact, p2 = p2Fact }
self._uVicStat[4] = { p1 = p1Income, p2 = p2Income }
self._uVicStat[5] = { p1 = p1Dmg, p2 = p2Dmg }

--[[
	Scoring Formula: 

]]
self._uVicStat[6] = { p1 = 1, p2 = 2 }
	local widgetList = self._scoreWidget
	for i = 1, 7 do
		local row = widgetList:getRow(i)
		--row:setInteractable(false)
		if i < 7 then
			--if math.even(i) == true then
			--	row:setRowImage( element.resources.getPath("victory_screen/row.png") )
			--end
			row:getCell(1):setText(""..self._uVictory[i].."")
			
			row:getCell(2):setText(""..self._uVicStat[i].p1.."")
			row:setCellStyle(2,"statsBlue")
			row:getCell(3):setText(""..self._uVicStat[i].p2.."")
			row:setCellStyle(3,"statsBad")
		end
	end
end

function interface:_prepare_power_dock( )
	local roots, widgets, groups = element.gui:loadLayout(resources.getPath("power_dock.lua"), "")
	--self:_addUiToDaddyTable(widgets)

	if (nil ~= widgets.dockPanel) then
	  self._dockPanel = widgets.dockPanel.window
	  self._dockPanel:registerEventHandler(self._dockPanel.EVENT_MOUSE_ENTERS, nil, _onEnter)
	  self._dockPanel:registerEventHandler(self._dockPanel.EVENT_MOUSE_LEAVES, nil, _onExit)
	  print("Dock PANEL REGISTERED")
	else
		print("ONE FAIL")
	end

	if (nil ~= widgets.labelBonus) then

		self._bonusLabel = widgets.labelBonus.window
	else
		print("PHAIL LABEL BONUS")
	end

	if (nil ~= widgets.header) then
	  self._dockHeader = widgets.header.window
	  self._dockHeader:registerEventHandler(self._dockHeader.EVENT_MOUSE_ENTERS, nil, _onEnter)
	  self._dockHeader:registerEventHandler(self._dockHeader.EVENT_MOUSE_LEAVES, nil, _onExit)
	  print("Dock Header REGISTERED")
	else
		print("ONE FAIL")
	end

	if (nil ~= widgets.abilityButton) then
	  self._abilityButton = widgets.abilityButton.window
	  self._abilityButton:registerEventHandler(self._abilityButton.EVENT_BUTTON_CLICK, nil, _handleAbilityButtonPressed)
	  self._abilityButton:registerEventHandler(self._abilityButton.EVENT_MOUSE_ENTERS, nil, _onEnter)
	  self._abilityButton:registerEventHandler(self._abilityButton.EVENT_MOUSE_LEAVES, nil, _onExit)	  

	  print("Dock abilityButton REGISTERED")
	else
		print("ONE FAIL")
	end

	if (nil ~= widgets.abilityButton2) then
	  self._abilityButton2 = widgets.abilityButton2.window
	  self._abilityButton2:registerEventHandler(self._abilityButton2.EVENT_BUTTON_CLICK, nil, _handleAbilityButton2Pressed)
	  self._abilityButton2:registerEventHandler(self._abilityButton2.EVENT_MOUSE_ENTERS, nil, _onEnter)
	  self._abilityButton2:registerEventHandler(self._abilityButton2.EVENT_MOUSE_LEAVES, nil, _onExit)	  

	  print("Dock abilityButton REGISTERED")
	else
		print("ONE FAIL")
	end


	print("HEREEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE")
	if (nil ~= widgets.infoWidget) then
		self._apInfoWidget = widgets.infoWidget.window
		print("INFO WIDGET GO")
	end
	print("HEREEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE")

	--self._comPanel:addChild(self._dockPanel)
	--self._apInfoWidget
	self:_fillUnitStatWidget( )


end


function interface:_updateDock( )
	
	if self._showDock == true then
		self._dockPanel:tweenPos(self._dockX, 56, 0.2)
	else
		self._dockPanel:tweenPos(self._dockX_out, 56, 0.2)
	end

	if self._bringUpConfirmBox == true then
		self._tweenMenuPanel = false
		self._confirmationScreen:tweenPos(0, 0, 0.6)
	else
		self._confirmationScreen:setPos(0, -100, 0.6)
	end
end

function interface:_showConfirmMenu(_state, _type)
	self._bringUpConfirmBox = _state
	self._confirmationType = _type
	if _state == true then
		interface:setBuyMenu(false)
	end
	element.gui:setFocus(self._confirmationScreen)
end

function interface:_getConfirmationType( )
	return self._confirmationType
end

function interface:_setDockState(_state, _unitID, _showAbility)

	self._showDock = _state
	self._unitID = _unitID
	

	local _mouseX = g:getMouseX( )
	local ac = (Game.cursorX-1)*32+map.offX-8
	--print("MOUSE X IS: ".._mouseX.."")
	print("MOUSE X IS: ".._mouseX.." WHILE CURSOR IS: "..ac.."")

	if Game.cursorEnabled == false then
		if _mouseX > resX/2 then
			self._dockX = -2
			self._dockPanel:setPos(-100, 62)
			self._dockX_out = - 100
		else
			self._dockPanel:setPos(100, 62)
			self._dockX = 69
			self._dockX_out = 100
		end
	else
		if ac > 256 then
			self._dockX = 0
			self._dockPanel:setPos(-100, 62)
			self._dockX_out = - 100
		else
			self._dockPanel:setPos(100, 62)
			self._dockX = 65
			self._dockX_out = 100
		end
	end

	if _unitID ~= nil then
		self:_setMenuPanelState(false)
		interface:_setState_ControlSlider(false)
		local v = unit:_returnTable()[_unitID]
		if v.faction == 1 then
			self._abilityButton:setNormalImage(element.resources.getPath("action_phase/heal_icon.png"))
		else
			self._abilityButton:setNormalImage(element.resources.getPath("action_phase/boom_icon.png"))
		end
		local check = unit_type[v.faction][v.tp]
		if _showAbility == true or _showAbility == nil then
			self._abilityButton:setPos(2000, 2)
			if check.secondAbility == true then
				self._abilityButton2:setPos(9, -20)
				self._abilityButton2:setNormalImage(element.resources.getPath("action_phase/temp_icon_3.png"))
			else
				self._abilityButton2:setPos(9000.5, 0.5)
			end
		else
			self._abilityButton:setPos(9000.5, 0.5)
			self._abilityButton2:setPos(9000.5, 0.5)
			--self._dockPanel:setPos(9000.5, 0.5)
		end
		self:_populateUnitStatWidgets(_unitID)
	end
end


-- fill it with junk data on create
function interface:_fillUnitStatWidget( )
	--self._uVicData = { }
	--self._uVicData[1] = { , }
	self._bonusLabel:setTextStyle(textstyles.get( "commanderBonus" ))
	local widgetList = self._apInfoWidget
	for i = 1, 5 do
		local row = widgetList:addRow( )
		if i <= 4 then
			
			row:getCell(1):setImage(element.resources.getPath( ""..self._iconList[i]..""))
			row:getCell(2):setText(""..self._uStatTable[i][2].."")
			row:getCell(3):setText("+2")
		end
	end
end

function interface:_populateUnitStatWidgets(_unitID)
	local v = unit:_returnTable()[_unitID]

	local fac = v.faction
	local tp = v.tp

	local uState = { }
	uState[1] = math.floor(v.hp*10)
	uState[2] = v.attack_range
	uState[3] = v.range
	uState[4] = v.damage

	local uInState = { }
	uInState[1] = unit_type[fac][tp].health*10
	uInState[2] = unit_type[fac][tp].max_range
	uInState[3] = unit_type[fac][tp].mobility
	uInState[4] = unit_type[fac][tp].damage

	local widgetList = self._apInfoWidget
	for i = 1, 5 do
		local row = widgetList:getRow(i)
		if i <= 4 then
			if math.even(i) == false then
				row:setRowImage( element.resources.getPath("victory_screen/row.png") )
			end
			--row:getCell(1):setTextStyle(textstyles.get( "stats" ), 14)
			--row:getCell(1):setText(self._uStatTable[i][1])
			row:getCell(1):setImage(element.resources.getPath( ""..self._iconList[i]..""))
			row:getCell(2):setText("   "..uState[i].."")


			local statVal = tonumber(row:getCell(2):getText())
			local difInStat = math.floor(uState[i] - uInState[i])
			
			if difInStat ~= 0 then
				if uState[i] < uInState[i] then
					row:getCell(3):setText("   "..difInStat.."")
					row:getCell(3):setTextStyle(textstyles.get( "commanderBonus" ), 14)
				else
					row:getCell(3):setText("   +"..difInStat.."")
					row:getCell(3):setTextStyle(textstyles.get( "stats" ), 14)				
				end
			else
				row:getCell(3):setText("")
			end
			row:setInteractable(false)
		end
	end
end

function interface:_getUnitID( )
	return self._unitID
end

function interface:_setMenuPanelState(_state)
	self._tweenMenuPanel = _state
	if _state == true then
		unit:_clearAllInput( )--self:_setDockState(false)
	end
end

function interface:_getMenuPanelState( )
	return self._tweenMenuPanel
end

function _handleMenuPanelPressed( )
	local bool = interface:_getMenuPanelState( )
	interface:_setMenuPanelState( not bool )
end

function interface:_returnCommanderWindow( )
	return self._comanderImgHolder, self._commanderImgButton
end

function interface:_ap_createCommanderPanel( )

	local roots, widgets, groups = element.gui:loadLayout(resources.getPath("commander_panel.lua"), "cm")
	--self:_addUiToDaddyTable(widgets)
	-- register Commander Image, Com Name and Coin Label as self._controls of the interface
	-- in order to change 'em'

	---- NEW CMP
	if (nil ~= widgets.cmmenuPanel1) then
		self._menuPanel1 = widgets.cmmenuPanel1.window
		print("AHO AHO COPCHII SI FRATI")
		--self._menuPanel1:registerEventHandler(self._menuPanel1.EVENT_BUTTON_CLICK, nil, _handleMenuPanelPressed )
	else
		print("COULD NOT REGISTER MENU PANEL 1")
	end

	if(nil ~= widgets.cmcommanderPortrait_HOLDER) then
		self._comanderImgHolder = widgets.cmcommanderPortrait_HOLDER.window
		self._commanderImgButton = widgets.cmmenu_button_p.window
		print("REGISTERED THE COMMANDER WINDOW")
	else
		print("COULD NOT REGISTER COMMANDER WINDOW")
	end

	if (nil ~= widgets.cmmenuPanBttn) then
		self._menuPanelBttn = widgets.cmmenuPanBttn.window
		print("AHO AHO COPCHII SI FRATI")
		self._menuPanelBttn:registerEventHandler(self._menuPanelBttn.EVENT_BUTTON_CLICK, nil, _handleMenuPanelPressed )
	else
		print("COULD NOT REGISTER MENU PANEL 1")
	end

	if(nil ~= widgets.cmbuttonScrollUp) then
		self._bttnScrrlUp = widgets.cmbuttonScrollUp.window
		print("AHO AHO COPCHII SI FRATI")
		self._bttnScrrlUp:registerEventHandler(self._bttnScrrlUp.EVENT_BUTTON_CLICK, nil, _handleMenuPanelPressed )
	else

	end

	if (nil ~= widgets.cmendTurnButton2) then
		self._mpEndTurn = widgets.cmendTurnButton2.window
		self._mpEndTurn:registerEventHandler(self._mpEndTurn.EVENT_BUTTON_CLICK, nil, _handleTurnEndPressed )
		self._mpEndTurn:registerEventHandler(self._mpEndTurn.EVENT_MOUSE_ENTERS, nil, _onEnter )
		self._mpEndTurn:registerEventHandler(self._mpEndTurn.EVENT_MOUSE_LEAVES, nil, _onExit )	
	else
		print("END TURN BUTTON FAIL")
	end

	if(nil ~= widgets.cmquuitToMap) then
		self._mpQuitButton = widgets.cmquuitToMap.window
		self._mpQuitButton:registerEventHandler(self._mpQuitButton.EVENT_BUTTON_CLICK, nil, _handleApQuitMMButton)

	else
		print("QUIT TO MAPS FAILED")
	end

	if (nil ~= widgets.cmcommanderImage) then
		self._comImage = widgets.cmcommanderImage.window
	else
		print("FAILED TO REGISTER COMM IMAGE")
	end

	if (nil ~= widgets.cmendTurnButton3) then
		self._endTurnButton3 = widgets.cmendTurnButton3.window
		self._endTurnButton3:registerEventHandler(self._endTurnButton3.EVENT_BUTTON_CLICK, nil, _handleTurnEndPressed )
		self._endTurnButton3:registerEventHandler(self._endTurnButton3.EVENT_MOUSE_ENTERS, nil, _onEnter )
		self._endTurnButton3:registerEventHandler(self._endTurnButton3.EVENT_MOUSE_LEAVES, nil, _onExit )	
	else
		print("FAILED TO REGISTER SMALLER COM BUTTON")
	end

	if (nil ~= widgets.cmcommanderDay2) then
		self._comDay = widgets.cmcommanderDay2.window
	else
		print("Commander Day failed to register")
	end

	if (nil ~= widgets.cmcashLabel2) then
	  self._comCashLabel = widgets.cmcashLabel2.window
	 -- button:registerEventHandler(button.EVENT_BUTTON_CLICK, nil, _handleButton1Click)
	end

	---- OLD CMP
	if (nil ~= widgets.cmcomputerSign) then
		self._cmpSign = widgets.cmcomputerSign.window
	else
		print("FAILED COMPUTER SIGN")
	end

	if (nil ~= widgets.cmimagePanel) then
	  self._comPanel = widgets.cmimagePanel.window
	 -- button:registerEventHandler(button.EVENT_BUTTON_CLICK, nil, _handleButton1Click)
	end

	if (nil ~= widgets.cmcommanderPicture) then
	 -- self._comImage = widgets.cmcommanderPicture.window
	 -- button:registerEventHandler(button.EVENT_BUTTON_CLICK, nil, _handleButton1Click)
	end

	if (nil ~= widgets.cmcommanderName) then
	  self._comName = widgets.cmcommanderName.window
	 -- button:registerEventHandler(button.EVENT_BUTTON_CLICK, nil, _handleButton1Click)
	end

	if (nil ~= widgets.cmcommanderDay) then
	  --self._comDay = widgets.cmcommanderDay.window
	 -- button:registerEventHandler(button.EVENT_BUTTON_CLICK, nil, _handleButton1Click)
	end


	if (nil ~= widgets.cmcashLabel) then
	 -- self._comCashLabel = widgets.cmcashLabel.window
	 -- button:registerEventHandler(button.EVENT_BUTTON_CLICK, nil, _handleButton1Click)
	end

	if (nil ~= widgets.cmmenuButton) then
		self._menuButton = widgets.cmmenuButton.window
		self._menuButton:registerEventHandler(self._menuButton.EVENT_BUTTON_CLICK, nil, _handleReturnEdPressed )
	end

	if (nil ~= widgets.cmmenuChildHolder) then
		self._menuChildHolder = widgets.cmmenuChildHolder.window
	end

	--apQuitMmButton:registerEventHandler(apQuitMmButton.EVENT_BUTTON_CLICK, nil, _handleApQuitMMButton)

	if (nil ~= widgets.cmabandonButton) then
		self._quitToMM = widgets.cmabandonButton.window
		self._quitToMM:registerEventHandler(self._quitToMM.EVENT_BUTTON_CLICK, nil, _handleApQuitMMButton)
	end

	if (nil ~= widgets.cmendTurnButton) then
	  	self._dEndTurn = widgets.cmendTurnButton.window
		self._dEndTurn:registerEventHandler(endTurnBttn.EVENT_BUTTON_CLICK, nil, _handleTurnEndPressed )
		self._dEndTurn:registerEventHandler(endTurnBttn.EVENT_MOUSE_ENTERS, nil, _onEnter )
		self._dEndTurn:registerEventHandler(endTurnBttn.EVENT_MOUSE_LEAVES, nil, _onExit )
	 -- button:registerEventHandler(button.EVENT_BUTTON_CLICK, nil, _handleButton1Click)
	end

	if (nil ~= widgets.cmzoomPlus) then
	  	self._dZoomP = widgets.cmzoomPlus.window
		self._dZoomP:registerEventHandler(self._dZoomP.EVENT_BUTTON_CLICK, nil, _handleZoomBttnPressed )
		self._dZoomP:registerEventHandler(self._dZoomP.EVENT_MOUSE_ENTERS, nil, _onEnter )
		self._dZoomP:registerEventHandler(self._dZoomP.EVENT_MOUSE_LEAVES, nil, _onExit )
	 -- button:registerEventHandler(button.EVENT_BUTTON_CLICK, nil, _handleButton1Click)
	end

	if (nil ~= widgets.cmzoomMin) then
	  	self._dZoomM = widgets.cmzoomMin.window
		self._dZoomM:registerEventHandler(self._dZoomM.EVENT_BUTTON_CLICK, nil, _handleZoomBttnMinPressed )
		self._dZoomM:registerEventHandler(self._dZoomM.EVENT_MOUSE_ENTERS, nil, _onEnter )
		self._dZoomM:registerEventHandler(self._dZoomM.EVENT_MOUSE_LEAVES, nil, _onExit )
	 -- button:registerEventHandler(button.EVENT_BUTTON_CLICK, nil, _handleButton1Click)
	end

	for i,v in pairs(widgets) do
		v.window:registerEventHandler(v.window.EVENT_MOUSE_ENTERS, nil, _onEnter )
		v.window:registerEventHandler(v.window.EVENT_MOUSE_LEAVES, nil, _onExit )	
	end
	
	self:_ap_updateCommanderPanel( 1, 1 )
end

function interface:_ap_updateCommanderPanel(_turn, _ttTurns)
	self._comImage:setImage(element.resources.getPath("commander/portraits/"..Game.commander[_turn].imgID.."".._turn..".png"))

	self._comName:setText(""..Game.commander[_turn].name.."")

	self._comCashLabel:setText(""..self._teamToPlayer[_turn].coins.."")
	print("TURN IS: ".._turn.."")
	print("COINS ARE: "..self._teamToPlayer[_turn].coins.."")

	local totalTurns = unit:_getTurnCounter( )
	if _ttTurns ~= nil then
		self._comDay:setText("DAY: ".._ttTurns.."")
	else
		self._comDay:setText("DAY: "..totalTurns.."")
	end
end

function interface:_setState_ControlSlider(_state)

	self._slideControls = _state
	if _state == true then
		--------------------------------
		--------------------------------
		---- SOUND HERE ----------------
		sound:play(sound.menuSwipe)
		---- SOUND HERE ----------------
		--------------------------------
		--------------------------------
	end
end

function interface:_getState_ControlSlider( )
	return self._slideControls
end

function interface:_create_slideTurn( )
	self._p1Slide = "action_phase/p1Slide.png"
	self._p2Slide = "action_phase/p2Slide.png"

	self._p1Text = "action_phase/p1Text.png"
	self._p2Text = "action_phase/p2Text.png"

	self._gfxTab = {}
	self._gfxTab[1] = self._p1Slide
	self._gfxTab[2] = self._p2Slide

	self._txtTab = {}
	self._txtTab[1] = self._p1Text
	self._txtTab[2] = self._p2Text

	turnSlide = element.gui:createImage( )
	turnSlide:setDim(60, 60)
	turnSlide:setPos(-2000, 20)
	turnSlide:setImage(element.resources.getPath(self._p1Slide))

	player1Turn = element.gui:createImage( )
	player1Turn:setDim( 30, 20 )
	player1Turn:setPos( -1500, 20 )
	player1Turn:setImage(element.resources.getPath(self._p1Text) )

	turnSlide:addChild(player1Turn)
end

function interface:setVictoryStatus(_state)
	Game.victory = _state
	self._showVictory = _state

end

function interface:_setPropperCommanderCollorTurn( )
	local turn = unit:_returnTurn( )
	local imgHolder, bttnHolder = interface:_returnCommanderWindow( )
	print("TURN IS: "..turn.."")
	if turn == 1 then
		imgHolder:setImage(element.resources.getPath("/action_phase/portrait_holder2.png"))
		bttnHolder:setImage(element.resources.getPath("/action_phase/menu_button2.png"))
		self._endTurnButton3:setNormalImage(element.resources.getPath("/action_phase/end_turn_small2.png"))
		self._endTurnButton3:setHoverImage(element.resources.getPath("/action_phase/end_turn_small_hover2.png"))
		self._endTurnButton3:setPushedImage(element.resources.getPath("/action_phase/end_turn_small_hover2.png"))
	else
		imgHolder:setImage(element.resources.getPath("/action_phase/portrait_holder.png"))
		bttnHolder:setImage(element.resources.getPath("/action_phase/menu_button.png"))
		self._endTurnButton3:setNormalImage(element.resources.getPath("/action_phase/end_turn_small.png"))
		self._endTurnButton3:setHoverImage(element.resources.getPath("/action_phase/end_turn_small_hover.png"))
		self._endTurnButton3:setPushedImage(element.resources.getPath("/action_phase/end_turn_small_hover.png"))
	end
end


--[[

	TODO: Get rid of ugly if if Game.optionControls.uiZoomToggle == true then
	and create a new interfac check for ui elements
--]]

function interface:_setMenuPanelLock(_value)
	self._menuPanelLocX = _value
end

function interface:_updateTurnSlide()
	if self._tweenMenuPanel == true then
		self._menuPanel1:tweenPos( self._menuPanelLocX, 0, 0.2 )

	else
		self._menuPanel1:tweenPos(self._menuPanelLocX , -68, 0.4)
		
	end

	if Game.victory == false then
		--print("VICTORY FALSE")
	else
		--print("VICTORY TRUE")
		self._showVictory = Game.victory
	end
	local _turn = unit:_returnTurn( )
	--image:setColor(bg_l3, Game.bgColor[_turn].r,  Game.bgColor[_turn].g,  Game.bgColor[_turn].b, 255)
	--unit:_advanceTurn2( )

	if self._showVictory == true then
		self._victoryPanel:tweenPos(25, 25)
	end

	if _turn == 2 or self._slideControls == true or self._buyMenuTween == true then

		--self._menuPanelLocX = 74
		if Game.optionControls.uiZoomToggle == true then
			zoomHandle:setPos(4, 2)
		end
		
	else
		--self._menuPanelLocX = 0
		--potatoBg:tweenPos(46.2, 83)
		--[[zoomHandle:tweenPos(92, 2, 0.2)
		endTurnBttn:tweenPos(2, 83, 0.2)
		returnToEditor:tweenPos(82, 83, 0.2)
		self._comPanel:tweenPos(2, 2, 0.2)--]]
		--self._comPanel:tweenPos(176,0)
		endTurnBttn:setPos(200, 83)
		returnToEditor:setPos(200, 83)
		if Game.optionControls.uiZoomToggle == true then
			zoomHandle:setPos(92, 2)
		else
			zoomHandle:setPos(292, 2)
		end
		--self._dEndTurn:tweenPos(1.5, 62, 0.25)
		--if self._cmpSign ~= nil then
		--	self._cmpSign:tweenPos(24 , -50)
		--end
	end

	if self._buyMenuTween == true then
		zoomHandle:setPos(5000, 2)
	end
end

function interface:_getSlideState( )
	return self._sliding
end

function interface:_setTurnState(_turn, _state)
	self._pTurn = _turn
	self._slideBanner = _state
	self._slideImage = true
	self._sliding = true
end


function interface:_ap_addTopBar( )
	apTopBar = element.gui:createImage( )
	apTopBar:setDim(1, 1)
	apTopBar:setPos(0, 0)
	--apTopBar:setImage(element.resources.getPath("actionBar_Background.png"))


	--[[potatoBg = element.gui:createImage( )
	potatoBg:setDim(14, 13)
	potatoBg:setPos(46.2, 83)
	potatoBg:setImage(element.resources.getPath("potato_background.png"))--]]

	--apTopBar:addChild(potatoBg)
	--[[self._fpsCounter = element.gui:createLabel( )
	self._fpsCounter:setDim(25, 12)
	self._fpsCounter:setPos(75, 0)
	FRAME = MOAISim.getPerformance ()
	self._fpsCounter:setText("FPS: ")--]]


	potatoLabel = element.gui:createLabel( )
	potatoLabel:setDim(14, 12)
	potatoLabel:setPos(6, -400.2)
	potatoLabel:setText("GOLD: "..player1.coins.."")
	--potatoBg:addChild(potatoLabel)

	--interface:_ap_createUnitInfoBox( )
	interface:_ap_createBattleInfoBox(  )
end

function interface:_updateCoinLabel( )
	



	self._comCashLabel:setText(""..self._teamToPlayer[unit:_getFalseTurn( )].coins.."")



	potatoLabel:setText(""..player1.coins.."")
	FRAME = math.floor( MOAISim.getPerformance () )
	--self._fpsCounter:setText("FPS: "..FRAME.."")
end

function interface:_ap_endTurn( )
	endTurnBttn = element.gui:createButton( )
	--apTopBar:addChild(endTurnBttn)
	endTurnBttn:setPos(200, 83)
	endTurnBttn:setDim(16, 13)
	endTurnBttn:setText("END TURN")
	--endTurnBttn:setText(nextStepText[1])

	endTurnBttn:setNormalImage(element.resources.getPath("end_turn_button.png") )--setBackgroundImage(element.resources.getPath("attack_button"))
	endTurnBttn:setHoverImage(element.resources.getPath("end_turn_button_hover.png"))
	endTurnBttn:setPushedImage(element.resources.getPath("end_turn_button_hover.png") )
	endTurnBttn:registerEventHandler(endTurnBttn.EVENT_BUTTON_CLICK, nil, _handleTurnEndPressed )
	endTurnBttn:registerEventHandler(endTurnBttn.EVENT_MOUSE_ENTERS, nil, _onEnter )
	endTurnBttn:registerEventHandler(endTurnBttn.EVENT_MOUSE_LEAVES, nil, _onExit )

	returnToEditor = element.gui:createButton( )
	returnToEditor:setDim(160, 13)
	returnToEditor:setPos(820, 83)
	returnToEditor:setNormalImage(element.resources.getPath("editorButton.png"))
	returnToEditor:setHoverImage(element.resources.getPath("editorButton_Hover.png"))
	returnToEditor:setPushedImage(element.resources.getPath("editorButton_Hover.png") )
	returnToEditor:setText("MENU")
	returnToEditor:registerEventHandler(returnToEditor.EVENT_BUTTON_CLICK, nil, _handleReturnEdPressed )

	--apTopBar:addChild(returnToEditor)
end

function interface:_ap_zoonButton( )
	zoomList = {}
	zoomList[1] = 1
	zoomList[2] = 2
	zoomList[3] = 3

	zoomIDX = 1

	zoomHandle = element.gui:createImage( )
	zoomHandle:setDim(6, 40)
	zoomHandle:setPos(292, 2)

	zoomBttn = element.gui:createButton( )
	zoomBttn:setDim(6, 9)
	zoomBttn:setPos(0, 0)
	zoomBttn:setNormalImage(element.resources.getPath("zoom_button.png"))
	zoomBttn:setHoverImage(element.resources.getPath("zoom_button.png"))
	zoomBttn:setPushedImage(element.resources.getPath("zoom_button_over.png"))

	zoomIcon = element.gui:createImage( )
	zoomIcon:setDim(6, 9)
	zoomIcon:setPos(0, 9)
	zoomIcon:setImage(element.resources.getPath("zoom_symbol.png"))

	zoomBttnMin = element.gui:createButton( )
	zoomBttnMin:setDim(6, 9)
	zoomBttnMin:setPos(0, 17)
	zoomBttnMin:setNormalImage(element.resources.getPath("zoom_minus.png"))
	zoomBttnMin:setHoverImage(element.resources.getPath("zoom_minus.png"))
	zoomBttnMin:setPushedImage(element.resources.getPath("zoom_minus_over.png"))

	--apTopBar:addChild(zoomBttn)
	zoomBttn:registerEventHandler(zoomBttn.EVENT_BUTTON_CLICK, nil, _handleZoomBttnPressed )
	zoomBttnMin:registerEventHandler(zoomBttnMin.EVENT_BUTTON_CLICK, nil, _handleZoomBttnMinPressed )

	zoomBttn:registerEventHandler(zoomBttn.EVENT_MOUSE_ENTERS, nil, _onEnter )
	zoomBttn:registerEventHandler(zoomBttn.EVENT_MOUSE_LEAVES, nil, _onExit )

	zoomBttnMin:registerEventHandler(zoomBttn.EVENT_MOUSE_ENTERS, nil, _onEnter )
	zoomBttnMin:registerEventHandler(zoomBttn.EVENT_MOUSE_LEAVES, nil, _onExit )

	zoomHandle:addChild(zoomBttn)
	zoomHandle:addChild(zoomIcon)
	zoomHandle:addChild(zoomBttnMin)

	zoomHandle:registerEventHandler(zoomHandle.EVENT_MOUSE_ENTERS, nil, _onEnter )
	zoomHandle:registerEventHandler(zoomHandle.EVENT_MOUSE_LEAVES, nil, _onExit )
end

function interface:_ap_createUnitInfoBox( )
	unitInfoBox = element.gui:createImage( )
	unitInfoBox:setDim(25, 25)
	unitInfoBox:setPos(3, 3)
	unitInfoBox:setImage(element.resources.getPath("/level_editor_gui/background_black_fade.png") )
	unitInfoBox.x = 3
	unitInfoBox.y = 3
	unitInfoBox.ox = - 50
	unitInfoBox.oy = 3
	unitInfoBox.tween = false

	unitNameLb = element.gui:createLabel( )
	unitNameLb:setDim(50, 5)
	unitNameLb:setPos(1, 0.5)
	unitNameLb:setText("Skull Trooper")

	unitHpLb = element.gui:createLabel( )
	unitHpLb:setDim(50, 5)
	unitHpLb:setPos(1, 6)
	unitHpLb:setText("HP: 10")

	unitModLb = element.gui:createLabel( )
	unitModLb:setDim(50, 5)
	unitModLb:setPos(1, 12)
	unitModLb:setText("Modifiers: \n +dmg -rng")

	unitInfoBox:addChild(unitNameLb)
	unitInfoBox:addChild(unitHpLb)
	unitInfoBox:addChild(unitModLb)
end

function interface:_ap_createBattleInfoBox(  )
	--[[battleInfoBox = element.gui:createImage( )
	battleInfoBox:setDim(25, 25)
	battleInfoBox:setPos(72, 3)
	battleInfoBox:setImage(element.resources.getPath("/level_editor_gui/background_black_fade.png") )--]]
end

function interface:_update_ap_unitInfoBox()
	--[[if unitInfoBox.tween == true then
		unitInfoBox:tweenPos(unitInfoBox.x, unitInfoBox.y)
	else
		unitInfoBox:tweenPos(unitInfoBox.ox, unitInfoBox.oy)
	end--]]
end

function interface:_toggleUnitInfoBox(_tweenState, _unit)
	

	--[[local _mouseX = Game.mouseX
	local _mouseY = Game.mouseY
	--print("MOUSE Y: ".._mouseY.."")
	if _mouseY < resY/zoomList[zoomIDX]/2 then
		unitInfoBox.y = 60
		unitInfoBox.oy = 60
	else
		unitInfoBox.y = 3
		unitInfoBox.oy = 3
	end
	

	if _unit ~= nil then
		unitHpLb:setText("HP: ".._unit.hp.."")
		unitNameLb:setText("NO NAME")
	end

	unitInfoBox.tween = _tweenState--]]
end

function interface:_ap_update( )

	self:_updateCoinLabel( )
	self:_update_ap_unitInfoBox()
	_update_ap_buttons( )
	self:_updateTurnSlide()
	self:_ap_update_IGM( )

	self:_tweenEndPanels( )
	self:_updateDock( )

end


function _update_ap_buttons( )
	--if unit:_getTurn( ) == 1 then
		--apTopBar:tweenPos(0, 90)
	--else
		--apTopBar:tweenPos(0, 180)
	--end
end

function interface:_returnTeamToPlayer( )
	return self._teamToPlayer
end
function _handleZoomBttnPressed( )
	local _turn = unit:_returnTurn( )
	local table = interface:_returnTeamToPlayer( )

	if state[currentState] ~= "LevelEditor" then
		if table[_turn].name ~= "Computer" then
			--------------------------------
			--------------------------------
			---- SOUND HERE ----------------
			sound:play(sound.buttonPressed)	
			---- SOUND HERE ----------------
			--------------------------------
			--------------------------------
			--[[if zoomButtonState == false then
				Game:ViewportScale(2, 2)
				zoomButtonState = true
			elseif zoomButtonState == true then
				Game:ViewportScale(1, 1)
				zoomButtonState = false
			end--]]
			if zoomIDX < 3 then
				zoomIDX = zoomIDX + 1
			--else
			--	zoomIDX = 1
			end
			print("PRESSED ZOOM")
			-- = zoomIDX
			_zoomSetScale(zoomIDX)
			map:updateScreen(0, 0)
		end
	end
end



function _handleZoomBttnMinPressed( )
	if zoomIDX > 1 then 
		zoomIDX = zoomIDX - 1
	end
	_zoomSetScale(zoomIDX)
	map:updateScreen(0, 0)
end

function _zoomRecordOldScale(_scale)
	--print("HAPPE-FREAKING-NING")

	Game.oldScale = _scale
end

function _zoomReturnOldScale( )
	return _scale
end

function zoomReturnScale( )
	return zoomIDX
end

function _zoomSetScale(_scale)

	--[[if _scale ~= zoomList[zoomIDX] then
		_wantedScale = zoomList[_scale]
		_currentScale = _currentScale + math.floor( (_wantedScale - _currentScale) * 0.05 )
		playerSetScale = _wantedScale
		zoomIDX = _scale
	else
		_currentScale = _scale
		zoomIDX = _scale
	end--]]
	
	Game.wantedScale = zoomList[_scale]
	--print("WANTED SCALE: "..Game.wantedScale.."")
	--if _bool ~= false then
	_zoomRecordOldScale(zoomIDX)
	--end
	--print("ZOOM IDX FREAKING IS: "..zoomIDX.."")
	map:recordOffset( )
	zoomInProgress = true
	zoomIDX = _scale
	--print("NEW ZOOMIDX IS: "..zoomIDX.."")

end

function _zoomSetOldScale()
	map:returnOldOffset( )
	--map:setScreen(v.act_x, v.act_y)
	map:updateScreen(0, 0)
	_zoomSetScale(Game.oldScale)

end

function _updateZoom( )
	
		if zoomInProgress == true then
			Game._currentScale = Game._currentScale + (Game.wantedScale - Game._currentScale) * 0.1
			Game:ViewportScale(Game._currentScale, Game._currentScale)

		end

		if Game._currentScale == Game.wantedScale then
			zoomInProgress = false
		end
	
end

function _handleRematchPressed( )

	_zoomSetScale(1)
	map:destroyAll( )
	font:dropAll( )
	unit:dropAll( )
	building:_dropAll( )
	effect:dropAll( )
	anim:dropAll( )
	cursor_anim = nil
	Game:dropUI(g, resources )
	--sound:stopAll( )
	_bGuiLoaded = false
	_bGameLoaded = false
end

function _handleReturnEdPressed( )
	--------------------------------
	--------------------------------
	---- SOUND HERE ----------------
	sound:play(sound.buttonPressed)	
	---- SOUND HERE ----------------
	--------------------------------
	--------------------------------
	print("TAKE ME BACK WHERE PIGS DON'T QUACK")

	--[[Game.mapFile = "temp_test_map022701227"
	map:destroyAll( )
	unit:dropAll( )
	building:_dropAll( )
	anim:dropAll( )
	Game:dropUI(g, resources )
	_bGuiLoaded = false
	currentState = 9--]]
	--if Game.disableInteraction == false then
	local slideState = interface:_getState_ControlSlider( )
	if slideState == false then
		interface:_setState_ControlSlider(true)
		--unit:setOnUi(true)
	--elseif Game.disableInteraction == true then
	elseif slideState == true then
		interface:_setState_ControlSlider(false)
		--unit:setOnUi(false)		
	end
	unit:_clearAllInput( )
	--end
end

function _onEnter( )

	unit:setOnUi(true)
end

function _onExit( )
	unit:setOnUi(false)
end

function _handleAbilityButton2Pressed( )
	--------------------------------
	--------------------------------
	---- SOUND HERE ----------------
	sound:play(sound.buttonPressed)	
	---- SOUND HERE ----------------
	--------------------------------
	--------------------------------
	local unitID = interface:_getUnitID( )
	if unitID ~= nil then
		print("HAPPENING! !!!")
		local v = unit:_returnTable()[unitID]
		if v.faction == 1 then
			_handleMutantAbilities2(unitID)
		else
			_handleRobotAbilities2(unitID)
		end
	end
	print("CHECKS OUT")
	print("Pressed 2")
end

function _handleMutantAbilities2(_unitID)
	local aura = unit:_returnAuraEffect( )
	local v = unit:_returnTable()[_unitID]
	if v.eff == nil then
		v.eff = effect:new("AURA", v.x, v.y, aura, 8, v, true)
		v.damage = v.damage + 10
		v.hp = v.hp / 2
		v.displayHP = v.hp
		v.done = true
		local table = unit:_returnTable()
		for i,j in ipairs(table) do
			if j.team == v.team then
				if j.eff == nil then
					if math.dist(v.x, v.y, j.x, j.y ) < 3 then
						j.eff = effect:new("AURA", j.x, j.y, aura, 10, j, true)
						j.damage = j.damage + 10
					end
				end
			end
		end
	end

	interface:_setDockState(false)
	unit:_removeRange( )
	unit:_clearSelections( )
end

function _handleRobotAbilities2(_unitID)

end

function _handleAbilityButtonPressed( )
	--------------------------------
	--------------------------------
	---- SOUND HERE ----------------
	sound:play(sound.buttonPressed)	
	---- SOUND HERE ----------------
	--------------------------------
	--------------------------------
	local unitID = interface:_getUnitID( )
	if unitID ~= nil then
		print("HAPPENING! !!!")
		local v = unit:_returnTable()[unitID]
		if v.faction == 1 then
			_handleMutantsAbilities(unitID)
		else
			_handleRobotAbilities(unitID)
		end
	end
	print("CHECKS OUT")
end

function _handleMutantsAbilities(_unitID, _optionalV)
		interface:_setDockState(false)

		local v = 0
		if _optionalV == nil then
			v = unit:_returnTable()[_unitID]
		else
			v = _optionalV
		end

		local healEffect = unit:_returnHealEffAnim( )
		--anim:setSpeed(healEffect, 1)

		local myEff = effect:new("HEAL_EFFECT", v.x, v.y, healEffect, 10 )

		lastFrame = effect:_getLastFrameValue(myEff)

		local effAnim = effect:_getAnim(myEff)
		local crFrm = anim:getCurrentFrame(effAnim)

		--if crFrm >= lastFrame-1 and crFrm <= lastFrame + 1 then
			print("NEVAR HAPPENS")
			v.hp = v.hp + 3
			v.displayHP = v.hp
			v.done = true
		--end

		
		sound:play(sound.powerHeal)

		unit:_removeRange( )
		unit:_clearSelections( )	
		print("V.HP IS: "..v.hp.."")
		print("V.HP IS: "..v.hp.."")
		print("V.HP IS: "..v.hp.."")
		print("V.HP IS: "..v.hp.."")
		print("V.HP IS: "..v.hp.."")
		print("V.HP IS: "..v.hp.."")
		print("V.HP IS: "..v.hp.."")
end

function _handleRobotAbilities(_unitID, _optionalV)
	interface:_setDockState(false)
	local v = 0
	if _optionalV == nil then
		v = unit:_returnTable()[_unitID]
	else
		v = _optionalV
	end
	local offsetX, offsetY = unit:_getOffset()
	local tileSize = unit:_getTileSize( )
	--[[
	v.act_x = v.x * self._tileSize - self._tileSize+self._offsetX
	v.act_y = v.y * self._tileSize - self._tileSize+self._offsetY-5
	]]
	
	local damageEffect = unit:_returnDamageEffect( )
	local lastFrame = 0
	--effect:new("DAMAGE_EFFECT", v.x, v.y, damageEffect, 7, v )
	local myEff
	for x = -1, 1 do
		for y = -1, 1 do
			if unit:_isWalkable(v.x+x, v.y+y) then
					
				--local path = pather:getPath(v.x, v.y, v.x+x, v.y+y)
				--if path ~= nil then
					--local length = path:getLength()
					--local nodeList = path:getNodeList( )
					--for i = 1, #nodeList do
						--if v.ap > (i*map:getTileCost(v.x+x, v.y+y) ) and length <= v.range and v.x == nodeList[i]._x and v.y == nodeList[i]._y then
							--if unit:_isLocEmpty(v.x - x, v.y - y) 
							local unitInRange = unit:_getAtPos(v.x+x, v.y+y)
							if unitInRange ~= nil and unitInRange ~= _unitID then
								local j = unit:_returnTable()[unitInRange]
								--j.hp = 0
								--unit:_do_attack(v, j)
								local dmg = unit:_calculateAttack(v, j)
								--unit:_do_attack(v, j)
								j.hp = j.hp - dmg
								j.displayHP = j.hp
								
							end
							local vact_x = (v.x+x) 
							local vact_y = (v.y+y) 
							myEff = effect:new("DAMAGE_EFFECT",  vact_x, vact_y, damageEffect, 7 )
							lastFrame = effect:_getLastFrameValue(myEff)
							local path = pather:getPath(v.x, v.y, v.x+x, v.y+y)
							if path ~= nil then
								map:updateTile(v.x+x, v.y+y, 10)
							end

						--end
					--end
				--end
			end
		end
	end
	sound:play(sound.gun)
	map:shake(10, 10, 0.5)	
	unit:_removeRange( )
	unit:_clearSelections( )
	v.done = true
	v.hp = 0
	local effAnim = effect:_getAnim(myEff)
	local crFrm = anim:getCurrentFrame(effAnim )
	print("CURRENT FRAME: "..crFrm.."")

	---if crFrm >= lastFrame-1 and crFrm <= lastFrame + 1 then
		
	--end	
	--if anim:getCurrentFrame(damageEffect.anim) >= lastFrame-1 and anim:getCurrentFrame(damageEffect.anim) <= lastFrame+1 then
	
	--end
end