function interface:_create_ap_buttons( )

	confirmMoveButton = nil
	confirmAttackButton = nil
	confirmCancelButton = nil
	
	confActionPanel = element.gui:createImage( )
	confActionPanel:setDim(14, 26)
	confActionPanel:setPos(-100, 0)
	confActionPanel:setImage(element.resources.getPath("actionBar_Background.png"))

	self:_createMoveButton(1)
	self:_createAttackButton(11)
	self:_createCancelButton(22)

	--[[confirmCancelButton = element.gui:createButton( )
	confirmCancelButton:setDim(12, 9)
	confirmCancelButton:setPos(1, 22)
	confirmCancelButton:setNormalImage(element.resources.getPath("keyboard/bttn_bg.png"))
	confirmCancelButton:setText("CANCEL")	--]]


	--confActionPanel:addChild(confirmMoveButton)
	
	--confActionPanel:addChild(confirmCancelButton)

	--confirmMoveButton:registerEventHandler(confirmMoveButton.EVENT_BUTTON_CLICK, nil, _handleConfirmMovementPressed, confirmMoveButton.unit )
	
	--confirmAttackButton:registerEventHandler(confirmAttackButton.EVENT_BUTTON_CLICK, nil, _handleAttackMovementPressed)

	confActionPanel:registerEventHandler(confActionPanel.EVENT_MOUSE_ENTERS, nil, _handleConfAcEnter)
	confActionPanel:registerEventHandler(confActionPanel.EVENT_MOUSE_LEAVES, nil, _handleConfAcLeave)

end

function interface:_createMoveButton(_y)

	if confirmMoveButton == nil then
		confirmMoveButton = element.gui:createButton( )
		confirmMoveButton:setDim(12, 9)
		confirmMoveButton:setPos(1, _y)
		confirmMoveButton:setNormalImage(element.resources.getPath("actionBar_Background.png"))
		confirmMoveButton:setText("MOVE")

		confirmMoveButton:registerEventHandler(confirmMoveButton.EVENT_BUTTON_CLICK, nil, _handleConfirmMovementPressed, confirmMoveButton.unit )
		confActionPanel:addChild(confirmMoveButton)
	end
end

function interface:_createAttackButton(_y)
	--11
	if confirmAttackButton == nil then
		confirmAttackButton = element.gui:createButton( )
		confirmAttackButton:setDim(12, 9)
		confirmAttackButton:setPos(1, _y)
		confirmAttackButton:setNormalImage(element.resources.getPath("actionBar_Background.png"))
		confirmAttackButton:setText("ATTACK")

		confirmAttackButton:registerEventHandler(confirmAttackButton.EVENT_BUTTON_CLICK, nil, _handleAttackMovementPressed)
		confActionPanel:addChild(confirmAttackButton)
	end
end

function interface:_createCancelButton(_y)
	--22
	if confirmCancelButton == nil then
		confirmCancelButton = element.gui:createButton( )
		confirmCancelButton:setDim(12, 9)
		confirmCancelButton:setPos(1, _y)
		confirmCancelButton:setNormalImage(element.resources.getPath("actionBar_Background.png"))
		confirmCancelButton:setText("CANCEL")	

		confirmCancelButton:registerEventHandler(confirmCancelButton.EVENT_BUTTON_CLICK, nil, _handleCancelMovementPressed)
		confActionPanel:addChild(confirmCancelButton)
	end
end

function interface:_addAtPos(_x, _y, _v)
	local posX, posY = _getPercentageOf(_x, _y)
	confirmMoveButton:setPos(posX, posY)
	confirmMoveButton.unit = _v
	self.___unitV = _v
end

function interface:_moveToPos(_x, _y, _childs)
	if _childs == 1 then
		confirmMoveButton:setPos(1, 1)
		confirmAttackButton:setPos(- 200, 1)
		confirmCancelButton:setPos(1, 11)
	elseif _childs == 2 then
		confirmMoveButton:setPos(-200, 1)
		confirmAttackButton:setPos(1, 1)
		confirmCancelButton:setPos(1, 11)
	elseif childs == 3 then

	else


	end
	confActionPanel:setPos(_x, _y)
end

function interface:_actionPanelUpdate( )
	local _st = unit:_getAwatingCommand( )
	if _st == true then
		interface:_moveToPos(0,0, Game.global_action_type)
	else
		interface:_moveToPos(-100, 0)
	end
end

function interface:_getUnitVSelf( )
	return self.___unitV
end

function interface:_setUnitVSelf( )
	self.___unitV = nil
end

function _getPercentageOf(_x, _y)
	return _x/resX * 100 , _y/resY * 100
end

function interface:_setUnitMovementCoordinates( )

end

function _handleConfirmMovementPressed(event, data)
	local v
	local destX
	local destY 

	v, destX, destY = unit:_returnGlobalMovement( )
	if v~= nil then
		--print("DEST X: "..destX.." DEST Y: "..destY.."")
		--unit:_moveOnPath(v, "NotNill")
		unit:_clearSelections( )
		unit:_clearPathTable( )
		unit:g_getTargetLocation(v, destX, destY)
		
		interface:setTargetAtLoc(-200, 0)
		unit:_setAwatingCommand(false)
		unit:_resetGlobalMovement( )
		--print("GO AND MOVE")
	end
end

function _handleAttackMovementPressed(event, data)
	local v
	local destX
	local destY 
	local __target
	v, destX, destY, __target = unit:_returnGlobalMovement( )
	if v~= nil then
		--print("DEST X: "..destX.." DEST Y: "..destY.."")
		--unit:_moveOnPath(v, "NotNill")
		unit:_clearSelections( )
		unit:_clearPathTable( )
		unit:g_getTargetLocation(v, destX, destY)
		
		unit:_setAwatingCommand(false)

	end
end

function _handleCancelMovementPressed( )
	unit:_clearSelections( )
	unit:_clearPathTable( )
	interface:setTargetAtLoc(200, 200)
	unit:_setAwatingCommand(false)
end

function _handleConfAcEnter( )
	unit:setOnUi(true)
	--print("ON UI TRUE")
end

function _handleConfAcLeave( )
	unit:setOnUi(false)
	--print("ON UI FALSE")
end