function interface:_create_resize_menu( )
	leditor_rs_panel = element.gui:createImage( )
	leditor_rs_panel:setDim(30, 40)
	leditor_rs_panel:setPos(-100, 20)
	leditor_rs_panel:setImage(element.resources.getPath("/level_editor_gui/background_black_fade.png") )


	self._rs_X_counter = 10
	self._rs_Y_counter = 10

	self._rs_maxValue = 45
	self._rs_minValue = 5
	self._rs_curValueX = 10
	self._rs_curValueY = 10



	interface:_resize_menu_add_buttons( )

	self._activeView[6] = {name="ResizeMap_Dialog", panel = leditor_rs_panel, x = 35, y = 20, ox = -100, oy = 20, childView = {} }
end

function interface:_resize_menu_add_buttons( )
	-- handle X increase buttons
	lrp_increase_button = element.gui:createButton( )
	lrp_increase_button:setDim(9, 9)
	lrp_increase_button:setPos(5, 8)
	lrp_increase_button:setText("+")
	lrp_increase_button:setNormalImage(element.resources.getPath("keyboard/bttn_bg.png"))

	-- X decrease button
	lrp_decrease_button = element.gui:createButton( )
	lrp_decrease_button:setDim(9, 9)
	lrp_decrease_button:setPos(5, 30)
	lrp_decrease_button:setText("-")
	lrp_decrease_button:setNormalImage(element.resources.getPath("keyboard/bttn_bg.png"))

	-- X Value control
	lrp_output_x = element.gui:createLabel( )
	lrp_output_x:setDim(9, 9)
	lrp_output_x:setPos(7.5, 18)
	lrp_output_x:setText(""..self._rs_curValueX.."")



	-- Y Increase Button
	lrp_increase_buttonY = element.gui:createButton( )
	lrp_increase_buttonY:setDim(9, 9)
	lrp_increase_buttonY:setPos(16, 8)
	lrp_increase_buttonY:setText("+")
	lrp_increase_buttonY:setNormalImage(element.resources.getPath("keyboard/bttn_bg.png"))

	-- Y Decrease Button
	lrp_decrease_buttonY = element.gui:createButton( )
	lrp_decrease_buttonY:setDim(9, 9)
	lrp_decrease_buttonY:setPos(16, 30)
	lrp_decrease_buttonY:setText("+")
	lrp_decrease_buttonY:setNormalImage(element.resources.getPath("keyboard/bttn_bg.png"))

	-- Y Value Control
	lrp_output_y = element.gui:createLabel( )
	lrp_output_y:setDim(9, 9)
	lrp_output_y:setPos(18.5, 18)
	lrp_output_y:setText(""..self._rs_curValueY.."")

	lrp_increase_button:registerEventHandler(lrp_increase_button.EVENT_BUTTON_CLICK, nil, _handleIncreaseXPressed)
	lrp_decrease_button:registerEventHandler(lrp_decrease_button.EVENT_BUTTON_CLICK, nil, _handleDecreaseXPressed)

	lrp_increase_buttonY:registerEventHandler(lrp_increase_buttonY.EVENT_BUTTON_CLICK, nil, _handleIncreaseYPressed)
	lrp_decrease_buttonY:registerEventHandler(lrp_decrease_button.EVENT_BUTTON_CLICK, nil, _handleDecreaseYPressed)

	-- CONFIRM BUTTON
	lrp_confirm_button = element.gui:createButton( )
	lrp_confirm_button:setDim(14, 10)
	lrp_confirm_button:setPos(35, 70)
	lrp_confirm_button:setText("APPLY")
	lrp_confirm_button:setNormalImage(element.resources.getPath("keyboard/bttn_bg.png"))

	-- CANCEL BUTTON -> BACK TO MM
	lrp_cancel_button = element.gui:createButton( )
	lrp_cancel_button:setDim(14, 10)
	lrp_cancel_button:setPos(51, 70)
	lrp_cancel_button:setText("BACK")
	lrp_cancel_button:setNormalImage(element.resources.getPath("keyboard/bttn_bg.png"))

	lrp_confirm_button:registerEventHandler(lrp_confirm_button.EVENT_BUTTON_CLICK, nil, _handleConfirmResizePressed)
	lrp_cancel_button:registerEventHandler(lrp_cancel_button.EVENT_BUTTON_CLICK, nil, _handleLrpBackPressed)

	leditor_rs_panel:addChild(lrp_increase_button)
	leditor_rs_panel:addChild(lrp_decrease_button)
	leditor_rs_panel:addChild(lrp_output_x)
	leditor_rs_panel:addChild(lrp_increase_buttonY)
	leditor_rs_panel:addChild(lrp_decrease_buttonY)
	leditor_rs_panel:addChild(lrp_output_y)

	leditor_rs_panel:addChild(lrp_confirm_button)
	leditor_rs_panel:addChild(lrp_cancel_button)
end

function interface:_resize_menu_getXValue( )
	return self._rs_curValueX
end

function interface:_resize_menu_getYValue( )
	return self._rs_curValueY
end

function interface:_get_rsMaxValue( )
	return 	self._rs_maxValue
	
end

function interface:_get_rsMinValue( )
	return self._rs_minValue
end

function interface:_resize_menu_setXValue(_value)
	self._rs_curValueX = _value
	lrp_output_x:setText(""..self._rs_curValueX.."")
end

function interface:_resize_menu_setYValue(_value)
	self._rs_curValueY = _value
	lrp_output_y:setText(""..self._rs_curValueY.."")
end

function _handleIncreaseXPressed( )
	local curX = interface:_resize_menu_getXValue( )

	if curX < interface:_get_rsMaxValue( ) then
		curX = curX + 1
	end
	interface:_resize_menu_setXValue(curX)
end

function _handleDecreaseXPressed( )
	local curX = interface:_resize_menu_getXValue( )

	if curX > interface:_get_rsMinValue( ) then
		curX = curX - 1
	end
	interface:_resize_menu_setXValue(curX)
end

function _handleIncreaseYPressed( )
	local curY = interface:_resize_menu_getYValue( )

	if curY < interface:_get_rsMaxValue( ) then
		curY = curY + 1
	end
	interface:_resize_menu_setYValue(curY)
end

function _handleDecreaseYPressed( )
	local curY = interface:_resize_menu_getYValue( )

	if curY > interface:_get_rsMinValue( ) then
		curY = curY - 1
	end
	interface:_resize_menu_setYValue(curY)
end

function _handleConfirmResizePressed( )
	local sx = interface:_resize_menu_getXValue( )
	local sy = interface:_resize_menu_getYValue( )
	lEditor:setGridSize(sx, sy)
end

function _handleLrpBackPressed( )
	interface:_setCurrentView(3)
end