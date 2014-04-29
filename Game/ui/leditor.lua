function interface:level_editor_init( )
	self._activeView = {}
	self._activeView[1] = {name="bottomBar", panel = nil, x = 0, y = 0, ox = 0, oy = 0, childView = {} }
	self._activeView[2] = {name="listPanel", panel = nil, x = 0, y = 0, ox = 0, oy = 0, childView = {} }
	self._activeView[3] = {name="editorMainMenu", panel = nil, x = 0, y = 0, ox = 0, oy = 0, childView = {} }
	self._activeView[4] = {name="SaveFile_Dialog", panel = nil, x = 0, y = 0, ox = 0, oy = 0, childView = {} }
	self._activeView[5] = {name="LoadFile_Dialog", panel = nil, x = 0, y = 0, ox = 0, oy = 0, childView = {} }
	self._activeView[6] = {name="ResizeMap_Dialog", panel = nil, x = 0, y = 0, ox = 0, oy = 0, childView = {} }

	self._currentView = 1
	self._currentChildView = 1
	self._currentMapname = "untitled"

	maximumRows = 4
	maximumCollumns = 5
	widthCollumns = 7
	self._tileSize = 32
	self:_createBottomBar( )
	interface:_createTileList( )
	interface:_leditor_create_menu( )

	interface:_registerEnterExitViews( )

	self:_ap_zoonButton( )
	_handleZoomBttnMinPressed( )
	_handleZoomBttnPressed( )
	_handleZoomBttnMinPressed( )
end

-- Save and Quit buttons
function interface:_createBottomBar( )
	ldTopBar = element.gui:createImage( )
	ldTopBar:setDim(100, 10)
	ldTopBar:setPos(0, 90)
	ldTopBar:setImage(element.resources.getPath("leditor_top_bar_bg.png") )
	interface:_addBottomBarButtons( )
	self._activeView[1].panel = ldTopBar
	self._activeView[1].x = 0
	self._activeView[1].y = 90
	self._activeView[1].ox = 120
	self._activeView[1].oy = 90

	interface:setup_cursors( )

end

function interface:_addBottomBarButtons( )
	-- set button -> enables tile placement
	setButton = element.gui:createButton( )
	setButton:setDim(10, 15)
	setButton:setNormalImage(element.resources.getPath("/level_editor_gui/set_button.png") )
	setButton:setHoverImage(element.resources.getPath("/level_editor_gui/set_button_pressed.png") )
	setButton:setPushedImage(element.resources.getPath("/level_editor_gui/set_button_pressed.png") )

	setButton:setPos(1, -6)
	setButton:registerEventHandler(setButton.EVENT_BUTTON_CLICK, nil, _handleSetButtonPressed )

	ldTopBar:addChild(setButton)

	delButton = element.gui:createButton( )
	delButton:setDim(10, 15)
	delButton:setNormalImage(element.resources.getPath("/level_editor_gui/del_button.png") )
	delButton:setHoverImage(element.resources.getPath("/level_editor_gui/del_button_pressed.png") )
	delButton:setPushedImage(element.resources.getPath("/level_editor_gui/del_button_pressed.png") )
	delButton:setPos(12, -6)
	delButton:registerEventHandler(delButton.EVENT_BUTTON_CLICK, nil, _handleDelButtonPressed )

	ldTopBar:addChild(delButton)

	listButton = element.gui:createButton()
	listButton:setDim(10, 15)
	listButton:setNormalImage(element.resources.getPath("/level_editor_gui/list_button.png") )
	listButton:setHoverImage(element.resources.getPath("/level_editor_gui/list_button_pressed.png") )
	listButton:setPushedImage(element.resources.getPath("/level_editor_gui/list_button_pressed.png") )

	listButton:setPos(23, -6)
	listButton:registerEventHandler(listButton.EVENT_BUTTON_CLICK, nil, _handleListButtonPressed )

	ldTopBar:addChild(listButton)	

	colButton = element.gui:createButton()
	colButton:setDim(10, 15)
	colButton:setNormalImage(element.resources.getPath("/level_editor_gui/col_button.png") )
	colButton:setHoverImage(element.resources.getPath("/level_editor_gui/col_button_pressed.png") )
	colButton:setPushedImage(element.resources.getPath("/level_editor_gui/col_button_pressed.png") )

	colButton:setPos(34, -6)
	colButton:registerEventHandler(colButton.EVENT_BUTTON_CLICK, nil, _handleColButtonPressed )

	ldTopBar:addChild(colButton) -- _handleColMButtonPressed( )

	colMButton = element.gui:createButton()
	colMButton:setDim(10, 15)
	colMButton:setNormalImage(element.resources.getPath("/level_editor_gui/colM_button.png") )
	colMButton:setHoverImage(element.resources.getPath("/level_editor_gui/colM_button_pressed.png") )
	colMButton:setPushedImage(element.resources.getPath("/level_editor_gui/colM_button_pressed.png") )


	colMButton:setPos(45, -6)
	colMButton:registerEventHandler(colMButton.EVENT_BUTTON_CLICK, nil, _handleColMButtonPressed )

	ldTopBar:addChild(colMButton)

	menuButton = element.gui:createButton( )
	menuButton:setDim(10, 15)
	menuButton:setNormalImage(element.resources.getPath("/level_editor_gui/menu_button.png") )
	menuButton:setHoverImage(element.resources.getPath("/level_editor_gui/menu_button_pressed.png") )
	menuButton:setPushedImage(element.resources.getPath("/level_editor_gui/menu_button_pressed.png") )

	menuButton:setPos(90+self._offsetAndroidX, -6)
	menuButton:registerEventHandler(menuButton.EVENT_BUTTON_CLICK, nil, _handleMenuButtonPressed )

	ldTopBar:addChild(menuButton)

	scrollButton = element.gui:createButton( )
	scrollButton:setDim(10, 15)
	scrollButton:setNormalImage(element.resources.getPath("/level_editor_gui/scroll_button.png") )
	scrollButton:setHoverImage(element.resources.getPath("/level_editor_gui/scroll_button_pressed.png") )
	scrollButton:setPushedImage(element.resources.getPath("/level_editor_gui/scroll_button_pressed.png") )

	
	scrollButton:setPos(56+self._offsetAndroidX, -6)
	scrollButton:registerEventHandler(scrollButton.EVENT_BUTTON_CLICK, nil, _handleScrollButtonPressed )

	ldTopBar:addChild(scrollButton)
	ldTopBar:registerEventHandler(ldTopBar.EVENT_MOUSE_ENTERS, nil, _EnterView)
	ldTopBar:registerEventHandler(ldTopBar.EVENT_MOUSE_LEAVES, nil, _ExitView )

	-- regist event handles for all buttons
	setButton:registerEventHandler(setButton.EVENT_MOUSE_ENTERS, nil, _EnterView)
	setButton:registerEventHandler(setButton.EVENT_MOUSE_LEAVES, nil, _ExitView )

	delButton:registerEventHandler(delButton.EVENT_MOUSE_ENTERS, nil, _EnterView)
	delButton:registerEventHandler(delButton.EVENT_MOUSE_LEAVES, nil, _ExitView )

	listButton:registerEventHandler(listButton.EVENT_MOUSE_ENTERS, nil, _EnterView)
	listButton:registerEventHandler(listButton.EVENT_MOUSE_LEAVES, nil, _ExitView )

	colButton:registerEventHandler(colButton.EVENT_MOUSE_ENTERS, nil, _EnterView)
	colButton:registerEventHandler(colButton.EVENT_MOUSE_LEAVES, nil, _ExitView )

	menuButton:registerEventHandler(menuButton.EVENT_MOUSE_ENTERS, nil, _EnterView)
	menuButton:registerEventHandler(menuButton.EVENT_MOUSE_LEAVES, nil, _ExitView )

	scrollButton:registerEventHandler(scrollButton.EVENT_MOUSE_ENTERS, nil, _EnterView)
	scrollButton:registerEventHandler(scrollButton.EVENT_MOUSE_LEAVES, nil, _ExitView )
end

function interface:_createTileList( )
	listPanel = element.gui:createImage( )
	listPanel:setDim(100, 100)
	listPanel:setPos(0, -100)
	listPanel:setImage(element.resources.getPath("/level_editor_gui/background_black_fade.png") )

	-- Panel that keeps track of the MAP TILES! [Terrain and Such]
	lp_tiles = element.gui:createImage( )
	lp_tiles:setDim(80, 80)
	lp_tiles:setPos(10, 10)
	lp_tiles:setImage(element.resources.getPath("/level_editor_gui/background_black_fade.png") )

	listPanel:addChild(lp_tiles)

	-- Panel that keeps track of BUILDING/ENTITY TILES! [HQ, TOWNS, UNITS? and such]
	bld_tiles = element.gui:createImage( )
	bld_tiles:setDim(80, 80)
	bld_tiles:setPos(10, 10)
	bld_tiles:setImage(element.resources.getPath("/level_editor_gui/background_black_fade.png") )

	listPanel:addChild(bld_tiles)

	-- Panel that keeps track of all ENTITIES [UNITS] for both teams
	ent_tiles = element.gui:createImage( )
	ent_tiles:setDim(80, 80)
	ent_tiles:setPos(10, 10)
	ent_tiles:setImage(element.resources.getPath("/level_editor_gui/background_black_fade.png") )

	listPanel:addChild(ent_tiles)

	self._activeView[2].panel = listPanel
	self._activeView[2].x = 0
	self._activeView[2].y = 0
	self._activeView[2].ox = 0
	self._activeView[2].oy = -100
	self._activeView[2].childView[1] = { name = "map_tiles", panel = lp_tiles,  x = 10, y = 10, ox = 10, oy = -150}
	self._activeView[2].childView[2] = { name = "building_tiles", panel = bld_tiles, x = 10, y = 10, ox = -150, oy = 10}
	self._activeView[2].childView[3] = { name = "ent_tiles", panel = ent_tiles, x = 10, y = 10, ox = 150, oy = 10}

	self:_tileList_add_buttons( )
end

function interface:_tileList_add_buttons( )
	-- load the map tiles as buttons
	for i = 1, 28 do  -- ground tiles
		self:_create_MapTiles_Button(i)
	end

	for i = 1, 6 do -- building tiles
		self:_create_BuildingTiles_Button(i)
	end

	for i = 1, 10 do -- entity tiles
		self:_create_EntityTiles_Button(i)
	end
	-- create the CONFIRM and CANCEL buttons that return the user to the normal view
	tlConfirm = element.gui:createButton( )
	tlConfirm:setDim(12, 11)
	tlConfirm:setPos(72+self._offsetAndroidX, 89)
	tlConfirm:setNormalImage(element.resources.getPath("/level_editor_gui/ok.png"))
	tlConfirm:setHoverImage(element.resources.getPath("/level_editor_gui/ok_h.png"))
	tlConfirm:setPushedImage(element.resources.getPath("/level_editor_gui/ok_h.png"))
	--back_h.png

	tlCancel = element.gui:createButton( )
	tlCancel:setDim(12, 11)
	tlCancel:setPos(86+self._offsetAndroidX, 89)
	tlCancel:setNormalImage(element.resources.getPath("/level_editor_gui/back.png"))
	tlCancel:setHoverImage(element.resources.getPath("/level_editor_gui/back_h.png"))
	tlCancel:setPushedImage(element.resources.getPath("/level_editor_gui/back_h.png"))
	
	listPanel:addChild(tlConfirm)
	listPanel:addChild(tlCancel)

	-- Switch between TILE PANELS (MAP -> BUILDINGS)
	tlMapTiles = element.gui:createButton( )
	tlMapTiles:setDim(8, 10.5)
	tlMapTiles:setPos(92+self._offsetAndroidX, 10)
	tlMapTiles:setNormalImage(element.resources.getPath("/level_editor_gui/map_tiles.png"))
	tlMapTiles:setHoverImage(element.resources.getPath("/level_editor_gui/map_tiles_h.png"))
	tlMapTiles:setPushedImage(element.resources.getPath("/level_editor_gui/map_tiles_h.png"))

	tlBuildingView = element.gui:createButton( )
	tlBuildingView:setDim(8, 10.5)
	tlBuildingView:setPos(92+self._offsetAndroidX, 22)	
	tlBuildingView:setNormalImage(element.resources.getPath("/level_editor_gui/building_tiles.png"))
	tlBuildingView:setHoverImage(element.resources.getPath("/level_editor_gui/building_tiles_h.png"))
	tlBuildingView:setPushedImage(element.resources.getPath("/level_editor_gui/building_tiles_h.png"))

	tlEntityView = element.gui:createButton( )
	tlEntityView:setDim(8, 10.5)
	tlEntityView:setPos(92 + self._offsetAndroidX, 34)
	tlEntityView:setNormalImage(element.resources.getPath("/level_editor_gui/unit_tiles.png"))
	tlEntityView:setHoverImage(element.resources.getPath("/level_editor_gui/unit_tiles_h.png"))
	tlEntityView:setPushedImage(element.resources.getPath("/level_editor_gui/unit_tiles_h.png"))

	listPanel:addChild(tlBuildingView)
	listPanel:addChild(tlMapTiles)
	listPanel:addChild(tlEntityView)

	tlConfirm:registerEventHandler(tlConfirm.EVENT_BUTTON_CLICK, nil, _handleTlConfirmPressed )
	tlMapTiles:registerEventHandler(tlMapTiles.EVENT_BUTTON_CLICK, nil, _handleTlMapTilesPressed )
	tlBuildingView:registerEventHandler(tlBuildingView.EVENT_BUTTON_CLICK, nil, _handleTlBuildingViewPressed )
	tlEntityView:registerEventHandler(tlEntityView.EVENT_BUTTON_CLICK, nil, _handleTlEntityViewPressed )
end

function interface:_create_MapTiles_Button(__id)
	local _id = __id
	local _rowX = math.floor(_id / maximumRows) * widthCollumns
	local colY
	colY = math.abs( 1 + ( math.floor(_id % maximumRows) ) ) * 15 - 15

	local temp = {
		id = _id,
		x = 2 + _rowX,
		y = 3 + colY,
		bttn = element.gui:createButton( )
	}
	temp.bttn:setDim(6, 10)
	temp.bttn:setPos(temp.x, temp.y)
	temp.bttn:setNormalImage(element.resources.getPath("/level_editor_gui/tiles/tiles3/"..temp.id..".png"), 1, 1, 1, 1, _idx )
	temp.bttn:registerEventHandler(temp.bttn.EVENT_BUTTON_CLICK, nil, _TileButtonPressed, temp)
	lp_tiles:addChild(temp.bttn)
end

function interface:_create_BuildingTiles_Button(__id)
	local _id = __id
	local _rowX = math.floor(_id / maximumRows) * widthCollumns
	local colY
	colY = math.abs( 1 + ( math.floor(_id % maximumRows) ) ) * 15 - 15

	local temp = {
		id = _id,
		x = 2 + _rowX,
		y = 3 + colY,
		bttn = element.gui:createButton( )
	}
	temp.bttn:setDim(6, 10)
	temp.bttn:setPos(temp.x, temp.y)
	temp.bttn:setNormalImage(element.resources.getPath("/level_editor_gui/tiles/buildings/"..temp.id..".png"))
	temp.bttn:registerEventHandler(temp.bttn.EVENT_BUTTON_CLICK, nil, _TileButtonPressed, temp)
	bld_tiles:addChild(temp.bttn)
end

function interface:_create_EntityTiles_Button(__id)
	local _id = __id
	local _rowX = math.floor(_id / maximumRows) * widthCollumns
	local colY
	colY = math.abs( 1 + ( math.floor(_id % maximumRows) ) ) * 15 - 15

	local temp = {
		id = _id,
		x = 2 + _rowX,
		y = 2 + colY,
		bttn = element.gui:createButton( )
	}
	temp.bttn:setDim(6, 10)
	temp.bttn:setPos(temp.x, temp.y)
	temp.bttn:setNormalImage(element.resources.getPath("/level_editor_gui/tiles/entities/"..temp.id..".png"))
	temp.bttn:registerEventHandler(temp.bttn.EVENT_BUTTON_CLICK, nil, _TileButtonPressed, temp)
	ent_tiles:addChild(temp.bttn)
end

function interface:_leditor_updateViews( )
	local _st = self._activeView[self._currentView].name

	if _st == "bottomBar" then
		--lEditor:setTouchState(true)
	else
		lEditor:setTouchState(false)
	end

	for i = 1, #self._activeView do
		if self._activeView[i].name ~= _st then
			self._activeView[i].panel:tweenPos(self._activeView[i].ox, self._activeView[i].oy)
		else
			self._activeView[i].panel:tweenPos(self._activeView[i].x, self._activeView[i].y)
			if #self._activeView[i].childView > 0 then
				local _childTable = self._activeView[i].childView
				local _stc = self._activeView[i].childView[self._currentChildView].name
				for j = 1, #_childTable do
					if _childTable[j].name ~= _stc then
						_childTable[j].panel:tweenPos(_childTable[j].ox, _childTable[j].oy)
					else
						_childTable[j].panel:tweenPos(_childTable[j].x, _childTable[j].y)
					end
				end
			end
		end
	end
end


function interface:_registerEnterExitViews( )
	for i = 1, #self._activeView do
		self._activeView[i].panel:registerEventHandler(self._activeView[i].panel.EVENT_MOUSE_ENTERS, nil, _EnterView)
		self._activeView[i].panel:registerEventHandler(self._activeView[i].panel.EVENT_MOUSE_LEAVES, nil, _ExitView)
	end 
end

function interface:_setCurrentView(_idx)
	self._currentView = _idx
end

function interface:_setCurrentChildView(_idx)
	self._currentChildView = _idx
end

function interface:_getChildView( )
	return self._currentChildView
end

function _TileButtonPressed(event, _table)
	lEditor:setIndex(_table.id)
end

function _handleMenuButtonPressed( )
	lEditor:setTouchState(false)
	interface:_setCurrentView(3)
end

function _handleListButtonPressed( )
	lEditor:setTouchState(false)
	--lEditor:setEditMode("EDIT")
	interface:_setCurrentView(2)
end

function _handleColButtonPressed( )
	lEditor:setEditMode("EDIT")
	lEditor:setLevel(5)
	lEditor:setIndex(2)
end

function _handleColMButtonPressed( )
	lEditor:setEditMode("EDIT")
	lEditor:setLevel(5)
	lEditor:setIndex(1)
end


function _handleSetButtonPressed( )
	
	lEditor:setEditMode("EDIT")
	lEditor:setLevel(interface:_getChildView( ))
end

function _handleDelButtonPressed( )
	lEditor:setEditMode("DEL")
	if interface:_getChildView( ) ~= 1 then
		lEditor:setLevel(interface:_getChildView( ))
	else
		lEditor:setLevel(2)
	end
end

function _handleTlConfirmPressed( )
	lEditor:setTouchState(true)
	lEditor:setEditMode("EDIT")
	interface:_setCurrentView(1)
	
	lEditor:setLevel(interface:_getChildView( ))
end

function _handleTlMapTilesPressed( )
	lEditor:setLevel(1)
	interface:_setCurrentChildView(1)
end



function _handleTlBuildingViewPressed( )
	lEditor:setLevel(2)
	interface:_setCurrentChildView(2)
end

function  _handleTlEntityViewPressed( )
	lEditor:setLevel(3)
	interface:_setCurrentChildView(3)
end

function _EnterView( )
	lEditor:setTouchState(false)
	print("ENTER VIEW")
end

function _ExitView( )
	lEditor:setTouchState(true)
	print("EXIT VIEW")
end

function _handleScrollButtonPressed( )
	lEditor:setTouchState(true)
	lEditor:setEditMode("SCROLL")
end