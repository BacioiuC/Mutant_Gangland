function interface:initLVSelect( )
	self._lvPointerX = 69.4
	self._lvPointerY = 55
	self._pointerLoc = {}
	self._pointerLoc[1] = 23
	self._pointerLoc[2] = 46.4
	self._pointerLoc[3] = 69.4

	self._lvPIDX = {}
	self._lvPIDX[1] = "lv_1"
	self._lvPIDX[2] = "lv_2"
	self._lvPIDX[3] = "lv_3"

	self._pidx = 1


	interface:_loadLVSGrid( )
	interface:_createLVSPanel( )

	self._tweenDescBox = true
	self._reset = false


end

function interface:_loadLVSGrid( )
	mGrid:new(20, 20, 32, "Game/media/ground_tiles.png", 14)
	mGrid:setPos(1, 0, 0)

	mGrid:new(20, 20, 32, "Game/media/building_tiles.png", 0)
	mGrid:setPos(2,  0, 0)

	map:loadMap("lvSel")
end

function interface:_createLVSPanel( )
	--lv_sel_top_bar
	lvPanel = element.gui:createImage( )
	lvPanel:setDim(100, 10)
	lvPanel:setPos(0, 0)
	lvPanel:setImage( element.resources.getPath("lv_sel_top_bar.png") )

	interface:_createLVSBackButton( )
	interface:_createLVSPlayButton( )
	interface:_createLVSDescBox( )
	interface:_createInvButtons( )
	interface:_createLvPointer( )

end

function interface:_createLVSBackButton( )
	--lv_sel_back_button
	backButton = element.gui:createButton( )
	backButton:setDim(16, 10)
	backButton:setPos(0.35, 0.20 )

	backButton:setNormalImage(element.resources.getPath("lv_sel_back_button.png") )--setBackgroundImage(element.resources.getPath("attack_button"))
	backButton:setHoverImage(element.resources.getPath("lv_sel_back_hover.png"))
	backButton:setPushedImage(element.resources.getPath("lv_sel_back_pushed.png") )

	backButton:registerEventHandler(backButton.EVENT_BUTTON_CLICK, nil, _handleLvBackPressed )

	lvPanel:addChild(backButton)	
end

function interface:_createLVSPlayButton( )
	--lv_sel_back_button
	playButton = element.gui:createButton( )
	playButton:setDim(16, 10)
	playButton:setPos(83.65, 0.20 )

	playButton:setNormalImage(element.resources.getPath("lv_sel_play_button.png") )--setBackgroundImage(element.resources.getPath("attack_button"))
	playButton:setHoverImage(element.resources.getPath("lv_sel_play_hover.png"))
	playButton:setPushedImage(element.resources.getPath("lv_sel_play_pushed.png") )

	playButton:registerEventHandler(playButton.EVENT_BUTTON_CLICK, nil, _handleLvPlayPressed )

	lvPanel:addChild(playButton)	
end

function interface:_createLVSDescBox( )
	descBox = element.gui:createImage( )
	descBox:setDim(100, 44)
	descBox:setPos(-100, 11)
	descBox:setImage(element.resources.getPath("mission_desc_bg_"..self._pidx..".png"))
	lvPanel:addChild(descBox)
end

function interface:_createInvButtons( )
	--lv_sel_inv_button
	invBttn1 = element.gui:createButton( )
	invBttn1:setDim(14, 14)
	invBttn1:setPos(20, 68.5)

	invBttn1:setNormalImage(element.resources.getPath("lv_sel_inv_button.png") )--setBackgroundImage(element.resources.getPath("attack_button"))
	invBttn1:setHoverImage(element.resources.getPath("lv_sel_inv_button.png"))
	invBttn1:setPushedImage(element.resources.getPath("lv_sel_inv_button.png") )

	lvPanel:addChild(invBttn1)

	invBttn2 = element.gui:createButton( )
	invBttn2:setDim(20, 14)
	invBttn2:setPos(40, 68.5)

	invBttn2:setNormalImage(element.resources.getPath("lv_sel_inv_button.png") )--setBackgroundImage(element.resources.getPath("attack_button"))
	invBttn2:setHoverImage(element.resources.getPath("lv_sel_inv_button.png"))
	invBttn2:setPushedImage(element.resources.getPath("lv_sel_inv_button.png") )

	lvPanel:addChild(invBttn2)

	invBttn3 = element.gui:createButton( )
	invBttn3:setDim(16, 14)
	invBttn3:setPos(65, 68.5)

	invBttn3:setNormalImage(element.resources.getPath("lv_sel_inv_button.png") )--setBackgroundImage(element.resources.getPath("attack_button"))
	invBttn3:setHoverImage(element.resources.getPath("lv_sel_inv_button.png"))
	invBttn3:setPushedImage(element.resources.getPath("lv_sel_inv_button.png") )

	lvPanel:addChild(invBttn3)

	invBttn1:registerEventHandler(invBttn1.EVENT_BUTTON_CLICK, nil, _handleinvBttn1Pressed )
	invBttn2:registerEventHandler(invBttn2.EVENT_BUTTON_CLICK, nil, _handleinvBttn2Pressed )
	invBttn3:registerEventHandler(invBttn3.EVENT_BUTTON_CLICK, nil, _handleinvBttn3Pressed )

end

function interface:_createLvPointer( )
	lvPointer = element.gui:createImage( )
	lvPointer:setDim(7, 10)
	lvPointer:setPos(self._lvPointerX, self._lvPointerY)
	lvPointer:setImage(element.resources.getPath("lv_pointer.png"))
end

function interface:_destroyLVSGrid( )
	mGrid:destroy(2)
	mGrid:destroy(1)
end


function _handleLvBackPressed( )
	print("Back Button Pressed")
	interface:_destroyLVSGrid( )
	print("Grid Destroyed")
	Game:dropUI(g, resources )
	print("Gui Dropped")
	_bGuiLoaded = false
	currentState = 2
end

function _handleLvPlayPressed( )
	print("Back Button Pressed")
	interface:_destroyLVSGrid( )
	print("Grid Destroyed")
	Game:dropUI(g, resources )
	print("Gui Dropped")
	_bGuiLoaded = false
	currentState = 5
end

function interface:_updateLVS( )

	if self._pidx ~= nil and self._pidx ~= 0 then
		Game.levelString = self._lvPIDX[self._pidx]
		print("HERE IS OK")
	else
		Game.levelString = self._lvPIDX[1]
		print("ERE WE ARE")
	end

	if self._tweenDescBox == true then
		descBox:tweenPos(0, 11)
		lvPointer:tweenPos(self._pointerLoc[self._pidx], self._lvPointerY)
		
		--print("TWEEN TO POSITION")
	elseif self._tweenDescBox == false then
		descBox:tweenPos(-100, 11)
		lvPointer:tweenPos(-100, self._lvPointerY)
		playButton:setEnabled(false)
		--print("TETRAILES BAHTALO")
	end
end

function interface:_returnDescState( )
	return self._tweenDescBox
end

function interface:_setDescState(_bool)
	self._tweenDescBox = _bool
	self._pidx = 0
end

function interface:_setPIDX(_value)
	self._pidx = _value
	self._tweenDescBox = true
	descBox:setImage(element.resources.getPath("mission_desc_bg_"..self._pidx..".png"))
end

function interface:_getPIDX( )
	return self._pidx
end

function _handleinvBttn1Pressed( )
	local pidX = 1
	if interface:_getPIDX( ) ~= pidX then
		--interface:_setPIDX(1)
		interface:_setPIDX(pidX)
		playButton:setEnabled(true)
	else
		
		interface:_setDescState(false)
	end
	

end

function _handleinvBttn2Pressed( )
	local pidX = 2
	if interface:_getPIDX( ) ~= pidX then
		--interface:_setPIDX(1)
		interface:_setPIDX(pidX)
		playButton:setEnabled(true)
	else
		
		interface:_setDescState(false)
	end
end

function _handleinvBttn3Pressed( )
	local pidX = 3
	if interface:_getPIDX( ) ~= pidX then

		interface:_setPIDX(pidX)
		playButton:setEnabled(true)
	else
		interface:_setDescState(false)
	end
end

function _checkTP( )
	if interface:_returnDescState( ) == false then
		interface:_setDescState(true)

	elseif interface:_returnDescState( ) == true then
		interface:_setDescState(false)

	end
end
