function interface:_leditor_create_menu( )
	ldMainMenu = element.gui:createImage( )
	ldMainMenu:setDim(50, 77)
	ldMainMenu:setPos(25, -140)
	ldMainMenu:setImage(element.resources.getPath("/level_editor_gui/background_black_fade.png") )

	self._activeView[3].panel = ldMainMenu
	self._activeView[3].x = 25
	self._activeView[3].y = 10
	self._activeView[3].ox = 25
	self._activeView[3].oy = -140

	self._mapButtonList = {}

	interface:_leditor_add_buttons( )
	interface:_leditor_saveFileDialog( )
	interface:_leditor_loadMapDialog( )
	interface:_create_resize_menu( )

	_scrollLine = 0
end

function interface:_leditor_add_buttons( )
	-- Back
	ldBackButton = element.gui:createButton( )
	ldBackButton:setDim(40, 12)
	ldBackButton:setPos(5, 2)
	ldBackButton:setText("BACK")

	ldSaveButton = element.gui:createButton( )
	ldSaveButton:setDim(40, 12)
	ldSaveButton:setPos(5, 14)
	ldSaveButton:setText("SAVE MAP")

	ldLoadButton = element.gui:createButton( )
	ldLoadButton:setDim(40, 12)
	ldLoadButton:setPos(5, 26)
	ldLoadButton:setText("LOAD MAP")

	ldSizeButton = element.gui:createButton( )
	ldSizeButton:setDim(40, 12)
	ldSizeButton:setPos(5, 38)
	ldSizeButton:setText("CHANGE SIZE")

	ldTestButton = element.gui:createButton( )
	ldTestButton:setDim(40, 12)
	ldTestButton:setPos(5, 50)
	ldTestButton:setText("TEST MAP")

	ldQuitMmButton = element.gui:createButton( )
	ldQuitMmButton:setDim(40, 12)
	ldQuitMmButton:setPos(5, 62)
	ldQuitMmButton:setText("QUIT")


	ldMainMenu:addChild(ldBackButton)
	ldMainMenu:addChild(ldSaveButton)
	ldMainMenu:addChild(ldLoadButton)
	ldMainMenu:addChild(ldSizeButton)
	ldMainMenu:addChild(ldTestButton)
	ldMainMenu:addChild(ldQuitMmButton)

	ldBackButton:registerEventHandler(ldBackButton.EVENT_BUTTON_CLICK, nil, _handleBackButtonPressed )
	ldSaveButton:registerEventHandler(ldSaveButton.EVENT_BUTTON_CLICK, nil, _handleSaveButtonPressed )
	ldLoadButton:registerEventHandler(ldLoadButton.EVENT_BUTTON_CLICK, nil, _handleLoadButtonPressed )
	ldSizeButton:registerEventHandler(ldSizeButton.EVENT_BUTTON_CLICK, nil, _handleSizeButtonPressed )
	ldTestButton:registerEventHandler(ldTestButton.EVENT_BUTTON_CLICK, nil, _handleTestButtonPressed )
	ldQuitMmButton:registerEventHandler(ldQuitMmButton.EVENT_BUTTON_CLICK, nil, _handleQuitMMButtonPressed )
end

function interface:_leditor_saveFileDialog( )
	ldSave_Dialog = element.gui:createImage( )
	ldSave_Dialog:setDim(100, 100)
	ldSave_Dialog:setPos(-105, 3.5)
	ldSave_Dialog:setImage(element.resources.getPath("/level_editor_gui/background_black_fade.png") )

	self._activeView[4] = { name = "Save_Dialog", panel = ldSave_Dialog,  x = 0, y = 0, ox = -105, oy = 0, childView = {} }
	interface:_leditor_save_addKeyboard( )	
	interface:_leditor_save_addBackAndSave( )
end

function interface:_leditor_save_addBackAndSave( )
	sv_save_button = element.gui:createButton( )
	sv_save_button:setDim(20, 10)
	sv_save_button:setPos(78, 1)
	sv_save_button:setText("SAVE")

	sv_back_button = element.gui:createButton( )
	sv_back_button:setDim(20, 10)
	sv_back_button:setPos(2, 1)
	sv_back_button:setText("BACK")

	sv_back_button:registerEventHandler(sv_back_button.EVENT_BUTTON_CLICK, nil, _handlesvBackButtonPressed )
	sv_save_button:registerEventHandler(sv_save_button.EVENT_BUTTON_CLICK, nil, _handlesvSaveButtonPressed, level_name_box:getText() )
	
	ldSave_Dialog:addChild(sv_save_button)
	ldSave_Dialog:addChild(sv_back_button)
end

function interface:_leditor_save_addKeyboard( )
	level_name_box = element.gui:createEditBox()
	level_name_box:setPos(30, 1)
	level_name_box:setDim(40, 10)
	level_name_box:setText(self._currentMapname)


	--editBox._onHandleGainFocus = handleEditBoxGainFocus

	softKeyBoard:createKeyboard(element.gui, 8, 8)
	softKeyBoard:setY(60)

	keys = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "BKP",
	        "q", "w", "e", "r", "t", "y", "u", "i", "o", "p", ".",
	        "", "a", "s", "d", "f", "g", "h", "j", "k", "l", "",  "",
	        "", "z", "x", "c", "v", "b", "n", "m",}
	for i, v in pairs(keys) do
	    softKeyBoard:addKey(v)
	end 
	softKeyBoard:setOutputField(level_name_box)

	ldSave_Dialog:addChild(level_name_box)
	softKeyBoard:bindToPanel(ldSave_Dialog)
end

function interface:_update_saveDialog_mapname(_name)
	level_name_box:setText(_name)
end

function interface:_leditor_loadMapDialog( )
	ldLoad_Dialog = element.gui:createImage( )
	ldLoad_Dialog:setDim(100, 100)
	ldLoad_Dialog:setPos(115, 0)
	ldLoad_Dialog:setImage(element.resources.getPath("/level_editor_gui/background_black_fade.png"))

	self._activeView[5] = {name="LoadFile_Dialog", panel = ldLoad_Dialog, x = 0, y = 0, ox = 115, oy = 0, childView = {} }
	interface:_leditor_loadMap_add_buttons( )

	ldDialog_back_button = element.gui:createButton( )
	ldDialog_back_button:setDim(23, 14)
	ldDialog_back_button:setPos(1, 85)
	ldDialog_back_button:setText("BACK")

	ldDialog_row_up = element.gui:createButton( )
	ldDialog_row_up:setDim(23, 14)
	ldDialog_row_up:setPos(75, 85)
	ldDialog_row_up:setText("DOWN")

	ldDialog_row_down = element.gui:createButton( )
	ldDialog_row_down:setDim(23, 14)
	ldDialog_row_down:setPos(50, 85)
	ldDialog_row_down:setText("UP")


	ldDialog_back_button:registerEventHandler(ldDialog_back_button.EVENT_BUTTON_CLICK, nil, _handlesvBackButtonPressed)
	ldDialog_row_up:registerEventHandler(ldDialog_row_up.EVENT_BUTTON_CLICK, nil, _handleIncRowPressed)
	ldDialog_row_down:registerEventHandler(ldDialog_row_down.EVENT_BUTTON_CLICK, nil, _handleDecRowPressed)

	ldLoad_Dialog:addChild(ldDialog_back_button)
	ldLoad_Dialog:addChild(ldDialog_row_up)
	ldLoad_Dialog:addChild(ldDialog_row_down)
end

function interface:_leditor_loadMap_add_buttons( )
	self:_clear_loadMapButtons( )
	self._ldRow = 0
	self._ldCol = 0
	self._ldWidth = 23
	self._ldHeight = 14
	local result = MOAIFileSystem.checkPathExists(pathToWrite.."player_map/")
	if result == false then
		MOAIFileSystem.affirmPath(pathToWrite.."player_map/")
	end
	local fileList = MOAIFileSystem.listFiles(pathToWrite.."player_map/")
	for i,v in ipairs(fileList) do
		local _string = string.find(""..v.."", ".mig", 1)
		if _string ~= nil then
			interface:_leditor_loadMap_button_template(""..v.."")
		end
	end
end

function interface:_leditor_loadMap_button_template(_name)
	local temp = {
		ldButton = element.gui:createButton( ),
	}
	
	temp.ldButton:setDim(self._ldWidth, self._ldHeight)
	temp.ldButton.row = self._ldRow
	temp.ldButton.x = 1 + self._ldRow
	temp.ldButton.col = self._ldCol
	temp.ldButton.y = 1 + self._ldCol
	temp.ldButton:setPos(temp.ldButton.x , temp.ldButton.y)
	temp.ldButton:setNormalImage(element.resources.getPath("keyboard/bttn_bg.png"))
	self._currentMapname = _name
	temp.ldButton:setText(_name)

	self._ldRow = self._ldRow +self._ldWidth + 2
	if self._ldRow >= 4 * (self._ldWidth + 2 ) then
		self._ldCol = self._ldCol + self._ldHeight + 2
		self._ldRow = 0
	end

	temp.ldButton:registerEventHandler(temp.ldButton.EVENT_BUTTON_CLICK, nil, _handleLdButtonLoadMapPressed, _name)
	ldLoad_Dialog:addChild(temp.ldButton)

	if temp.ldButton.y >= 70 then
		temp.ldButton:setPos(temp.ldButton.x , 150 )
	end

	table.insert(self._mapButtonList, temp)
end

function interface:_getMapButtonList( )
	return self._mapButtonList
end

function interface:_clear_loadMapButtons( )
	for i, v in ipairs(self._mapButtonList) do
		v.ldButton:destroy()
	end
	self._mapButtonList = {}

end

function interface:__getDescBoxText( )
	return level_name_box:getText()
end

function _handleBackButtonPressed( )
	lEditor:setTouchState(true)
	interface:_setCurrentView(1)
end

function _handleSaveButtonPressed( )
	interface:_setCurrentView(4)
end

function _handleLoadButtonPressed( )
	interface:_leditor_loadMap_add_buttons( )
	interface:_setCurrentView(5)
end

-- return to Main Menu
function _handlesvBackButtonPressed( )
	interface:_setCurrentView(3)
end

function _handleLdDialogBackButton( )

end

function _handleSizeButtonPressed( )
	interface:_setCurrentView(6)
end

function _handleLdButtonLoadMapPressed(event, data)
	print("WE SHOULD LOAD MAP NAMED: "..data.."")
	local lvName = string.gsub(data, ".mig", "")
	print("WE SHOULD LOAD MAP NAMED: "..lvName.."")
	print("WE SHOULD LOAD MAP NAMED: "..lvName.."")
	print("WE SHOULD LOAD MAP NAMED: "..lvName.."")
	print("WE SHOULD LOAD MAP NAMED: "..lvName.."")
	print("WE SHOULD LOAD MAP NAMED: "..lvName.."")
	print("WE SHOULD LOAD MAP NAMED: "..lvName.."")
	print("WE SHOULD LOAD MAP NAMED: "..lvName.."")
	print("WE SHOULD LOAD MAP NAMED: "..lvName.."")
	lEditor:loadAndReset(lvName)
	interface:_update_saveDialog_mapname(lvName)
end

function _handlesvSaveButtonPressed(event, data)
	--lEditor:dumpToTable
	if data ~= nil then
		print("NAME IS: "..interface:__getDescBoxText( ).."")
	end
	if interface:__getDescBoxText( ) ~= nil and interface:__getDescBoxText( ) ~= "" then
		lEditor:dumpToTable(interface:__getDescBoxText( ))
	end
	--print("TEXT: "..interface:__getDescBoxText( ).."")
end

function _handleTestButtonPressed( )
	lEditor:saveAndTest( )
	Game.mapFile = "temp_test_map022701227"
	lEditor:destroyAll( )
	anim:dropAll( )
	Game:dropUI(g, resources )
	Game.fromEditor = true
	_bGuiLoaded = false
	_bGameLoaded = false
	cursor_anim = nil
	Game.lastState = 9
	currentState = 5
end

function _handleQuitMMButtonPressed( )
	lEditor:destroyAll( )
	anim:dropAll( )
	_bGuiLoaded = false
	_bGameLoaded = false
	cursor_anim = nil
	Game:dropUI(g, resources )
	currentState = 2
end

function interface:_getRow( )
	return self._ldRow, self._ldCol
end

function _handleIncRowPressed( )
	_scrollLine = _scrollLine + 1
	_updateButtons(_scrollLine, interface:_getMapButtonList( ))
end

function _handleDecRowPressed( )
	_scrollLine = _scrollLine - 1
	_updateButtons(_scrollLine, interface:_getMapButtonList( ))
end

function _updateButtons(_scrollLine, _list)
	for i,v in ipairs(_list) do

		v.ldButton:setPos(v.ldButton.x , v.ldButton.y + _scrollLine * 14 )
		local posX, posY = v.ldButton:getPos( )
		if posY >= 70 then
			v.ldButton:setPos(v.ldButton.x , 150 )
		end
	end
end