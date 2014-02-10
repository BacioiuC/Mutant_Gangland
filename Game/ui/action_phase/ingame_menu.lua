function interface:_init_ap_menu( )
	apMainMenu = element.gui:createImage( )
	apMainMenu:setDim(100, 100)
	apMainMenu:setPos(0, -100)
	apMainMenu:setImage(element.resources.getPath("/action_phase/igm_background.png") )

	self:_ap_menu_addButtons( )
end

function interface:_ap_menu_addButtons( )
	apReturnButton = element.gui:createButton( )
	apReturnButton:setDim(40, 12)
	apReturnButton:setPos(30, 10)
	apReturnButton:setText("RESUME GAME")

	apReturnButton:registerEventHandler(apReturnButton.EVENT_BUTTON_CLICK, nil, _handleApReturnButton)
	apReturnButton:setNormalImage(element.resources.getPath("/action_phase/button_temp.png"))
	apReturnButton:setHoverImage(element.resources.getPath("/action_phase/button_temp_hover.png"))
	apReturnButton:setPushedImage(element.resources.getPath("/action_phase/button_temp_hover.png"))

	apSaveButton = element.gui:createButton( )
	apSaveButton:setDim(40, 12)
	apSaveButton:setPos(30, 24)
	apSaveButton:setText("SAVE")

	apSaveButton:setNormalImage(element.resources.getPath("/action_phase/button_temp.png"))
	apSaveButton:setHoverImage(element.resources.getPath("/action_phase/button_temp_hover.png"))
	apSaveButton:setPushedImage(element.resources.getPath("/action_phase/button_temp_hover.png"))

	apHelpButton = element.gui:createButton( )
	apHelpButton:setDim(40, 12)
	apHelpButton:setPos(30, 38)
	apHelpButton:setText("HELP")

	apHelpButton:setNormalImage(element.resources.getPath("/action_phase/button_temp.png"))
	apHelpButton:setHoverImage(element.resources.getPath("/action_phase/button_temp_hover.png"))
	apHelpButton:setPushedImage(element.resources.getPath("/action_phase/button_temp_hover.png"))

	apQuitMmButton = element.gui:createButton( )
	apQuitMmButton:setDim(40, 12)
	apQuitMmButton:setPos(30, 52)
	apQuitMmButton:setText("ABANDON")	

	apQuitMmButton:registerEventHandler(apQuitMmButton.EVENT_BUTTON_CLICK, nil, _handleApQuitMMButton)
	apQuitMmButton:setNormalImage(element.resources.getPath("/action_phase/button_temp.png"))
	apQuitMmButton:setHoverImage(element.resources.getPath("/action_phase/button_temp_hover.png"))
	apQuitMmButton:setPushedImage(element.resources.getPath("/action_phase/button_temp_hover.png"))

	apMainMenu:addChild(apReturnButton)
	apMainMenu:addChild(apSaveButton)
	apMainMenu:addChild(apHelpButton)
	apMainMenu:addChild(apQuitMmButton)
end

function interface:_ap_update_IGM( )
	if self._slideControls == false then
		--apMainMenu:tweenPos(0, - 100)
		self._menuChildHolder:tweenPos(50, 1.5, 0.25)
	else
		self._menuChildHolder:tweenPos(0, 1.5, 0.25)
		--apMainMenu:tweenPos(0, 0)
	end
end

function _handleApReturnButton( )
	interface:_setState_ControlSlider(false)
	unit:setOnUi(false)
end

function _handleApQuitMMButton( )
	--[[_zoomSetScale(1)
	map:destroyAll( )
	font:dropAll( )
	unit:dropAll( )
	building:_dropAll( )
	effect:dropAll( )
	anim:dropAll( )

	Game:dropUI(g, resources )
	sound:stopAll( )
	_bGuiLoaded = false
	_bGameLoaded = false
	currentState = Game.lastState--]]
	interface:_setConfirmationScreenText("Quit the battle?")
	interface:_setMenuPanelState(false)
	interface:_showConfirmMenu(true, 1)
	interface:setBuyMenu(false)
end

function _handleCancelQuitPressed( )
	interface:_showConfirmMenu(false)
end


function _handleTurnEndPressed( )
	interface:setBuyMenu(false)
	local nr = unit:_getNrOfUnitsLeftToMove( )
	local table = interface:_returnTeamToPlayer( )
	local _turn = unit:_returnTurn( )
	if nr == 0 then
		if unit:_getChangingTurnState( ) == 4 and table[_turn].name ~= "Computer" then
			interface:_showConfirmMenu(false, 2)
			--------------------------------
			--------------------------------
			---- SOUND HERE ----------------
			sound:play(sound.buttonPressed)	
			---- SOUND HERE ----------------
			--------------------------------
			--------------------------------
			interface:_setMenuPanelState(false)
			if Game.disableInteraction == false then
				unit:advanceTurn( )
			end
		end
	else
		local table = interface:_returnTeamToPlayer( )
		local _turn = unit:_returnTurn( )
		if unit:_getChangingTurnState( ) == 4 and table[_turn].name ~= "Computer" then
			interface:_setConfirmationScreenText("There are still units\nleft to move! Are you sure \nyou want to end your turn?")
			interface:_setMenuPanelState(false)
			interface:_showConfirmMenu(true, 2)		
		end
	end



end

function _handleConfirmQuitPressed( )
	local confType = interface:_getConfirmationType( )

	if confType == 1 then
		_zoomSetScale(1)
		map:destroyAll( )
		font:dropAll( )
		unit:dropAll( )
		building:_dropAll( )
		effect:dropAll( )
		anim:dropAll( )
		cursor_anim = nil
		Game:dropUI(g, resources )
		sound:stopAll( )
		_bGuiLoaded = false
		_bGameLoaded = false
		currentState = Game.lastState
	else

		if unit:_getChangingTurnState( ) == 4 then
			interface:_showConfirmMenu(false, 2)
			--------------------------------
			--------------------------------
			---- SOUND HERE ----------------
			sound:play(sound.buttonPressed)	
			---- SOUND HERE ----------------
			--------------------------------
			--------------------------------
			interface:_setMenuPanelState(false)
			if Game.disableInteraction == false then
				unit:advanceTurn( )
			end
		end

	end
end
