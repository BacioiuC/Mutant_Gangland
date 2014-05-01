function interface:_setUpCategories( )
	self._categoryTable = {}
	self._categoryTable[1] = { map = "map/normal", name = "NORMAL BATTLE" }
	self._categoryTable[2] = { map = "map/skirmish", name = "SKIRMISH " }
	self._categoryTable[3] = { map = "player_map/", name = "PLAYER DESIGNED" }
	--
end

function interface:_init_map_selection( )

	self._updateState = 1

	self._mapButtonList = { }
	_scrollLine = 0

	--[[self._categoryTable = {}
	self._categoryTable[1] = { map = "map/normal", name = "NORMAL BATTLE" }
	self._categoryTable[2] = { map = "map/skirmish", name = "SKIRMISH " }
	self._categoryTable[3] = { map = "player_map/", name = "PLAYER DESIGNED" }
	self._currentCategory = 1--]]
	self._currentCategory = 1
	self:_setUpCategories( )

	local roots, widgets, groups = element.gui:loadLayout(resources.getPath("free_battle_1.lua"), "")

	-- register all the elements internally

	if (nil ~= widgets.mapDock) then
		self._bgImage = widgets.mapDock.window
		print("BG IMAGE REGISTERED")
	else
		print("BG IMAGE FAILED")
	end



	if (nil ~= widgets.bgPanel) then
	  self._smBgPanel = widgets.bgPanel.window
	  print("PREVIOUS BUTTON REGISTERED")
	else
		print("ONE FAIL")
	end

	if (nil ~= widgets.prevButton) then
	  self._smPrevButton = widgets.prevButton.window
	  self._smPrevButton:registerEventHandler(self._smPrevButton.EVENT_BUTTON_CLICK, nil, _handlePrevButtonClick)
	  --self._smPrevButton:setNormalImage(element.resources.getPath("maps/PNR_Button_Up.png"))
	  --print("PREVIOUS BUTTON REGISTERED")
	else
		print("ONE FAIL")
	end

	if (nil ~= widgets.nextButton) then
	  self._smNextButton = widgets.nextButton.window
	  self._smNextButton:registerEventHandler(self._smNextButton.EVENT_BUTTON_CLICK, nil, _handleNextButtonClick)
	  --self._smNextButton:setNormalImage(element.resources.getPath("maps/PNR_Button_Up.png"))
	  print("NEXT BUTTON REGISTERED")
	else
		print("ONE FAIL")
	end

	if (nil ~= widgets.categoryNameLabel) then
	  self._smCatName = widgets.categoryNameLabel.window
	  print("Cateorgy NAME REGISTERED")
	else
		print("ONE FAIL")
	end

	if (nil ~= widgets.upButton) then
	  self._smUpButton = widgets.upButton.window
	  self._smUpButton:registerEventHandler(self._smUpButton.EVENT_BUTTON_CLICK, nil, _handleUpButtonClick)
	  --self._smUpButton:setNormalImage(element.resources.getPath("maps/PNR_Button_Down.png"))
	  print("UP BUTTON REGISTERED")
	else
		print("ONE FAIL")
	end

	if (nil ~= widgets.downButton) then
	  self._smDownButton = widgets.downButton.window
	  self._smDownButton:registerEventHandler(self._smDownButton.EVENT_BUTTON_CLICK, nil, _handleDownButtonClick)
	 -- self._smDownButton:setNormalImage(element.resources.getPath("maps/PNR_Button_Down.png"))
	  print("DOWN BUTTON REGISTERED")
	else
		print("ONE FAIL")
	end

	if (nil ~= widgets.mapDetails) then
	  self._smMapWidget = widgets.mapDetails.window
	  self._smMapWidget:setBackgroundImage(element.resources.getPath("maps/widget_list_bg.png") )
	  print("MAP WIDGET REGISTERED")
	else
		print("ONE FAIL")
	end

	if (nil ~= widgets.mapImage) then
	  self._smMapPicture = widgets.mapImage.window
	  print("MAP PICTURE REGISTERED")
	else
		print("ONE FAIL")
	end	

	if (nil ~= widgets.continueButton) then
	  self._smContinueButton = widgets.continueButton.window
	  self._smContinueButton:registerEventHandler(self._smContinueButton.EVENT_BUTTON_CLICK, nil, _handleContinueButtonClick)
	  --self._smContinueButton:setNormalImage(element.resources.getPath("maps/PNR_Button_Down.png"))
	  print("CONTINUE BUTTON REGISTERED")
	else
		print("ONE FAIL")
	end	

	if(nil ~= widgets.returnToMenu) then
		self._smReturnMenu = widgets.returnToMenu.window
		self._smReturnMenu:registerEventHandler(self._smReturnMenu.EVENT_BUTTON_CLICK, nil, _HandleSmReturnMenuPressed)
		--self._smReturnMenu:setNormalImage(element.resources.getPath("maps/PNR_Button_Down.png"))
		print("RETURN TO MENU REGISTERED")
	else
		print("ONE FAILED")
	end
	-- button:registerEventHandler(button.EVENT_BUTTON_CLICK, nil, _handleButton1Click)

	self:_sm_loadMapButtons( )

	local lvName = string.gsub(self._mapButtonList[1].name, ".mig", "")

	self:_populate_sm_widget( )
	self:_update_sm_mapStats(lvName)
	Game.mapFile = lvName



	------------------------
	-- Check if the Main Menu theme is playing when entering here. If it is, don't play anything let it continue.
	-- If not, PLAY SONG!
	--
	local isSongPlaying = sound:getCategoryPlaying(SOUND_MAIN_MENU)
	if isSongPlaying == false then
		print("Nothing playing here")
		sound:playFromCategory(SOUND_MAIN_MENU)
	end

	--self._bgImage:_setPriority(2)
	--self:_initMapSel_grid(lvName)
end

function interface:_initMapSel_grid(_name)

	tb = table.load(""..self._categoryTable[self._currentCategory].map.."/".._name..".mig")

	local szX = #tb
	local szY = #tb[#tb]

	self._gridMap = mGrid:new(szX, szY, 32, "Game/LevelEditor/"..Game.tileset.."", 1)
	mGrid:setPos(self._gridMap, 0, 0)

	for x = 1, #tb do
		for y = 1, #tb[x] do
			mGrid:updateTile(self._gridMap, x, y, tb[x][y])
		end
	end
end

function interface:_updateMalSel_grid(_name)
	mGrid:destroy(self._gridMap)

	tb = table.load(""..self._categoryTable[self._currentCategory].map.."/".._name..".mig")

	local szX = #tb
	local szY = #tb[#tb]

	self._gridMap = mGrid:new(szX, szY, 32, "Game/LevelEditor/"..Game.tileset.."", 1)
	mGrid:setPos(self._gridMap, 0, 0)

	for x = 1, #tb do
		for y = 1, #tb[x] do
			mGrid:updateTile(self._gridMap, x, y, tb[x][y])
		end
	end

end

function interface:_populate_sm_widget( )
	for i = 1, 5 do
		local row = self._smMapWidget:addRow()
		row:setInteractable(false)
		-- The return from getCell is the widget created by setColumnWidget, so the normal
		-- functionality for the widget is available.
		if i < 5 then
			
			row:getCell(1):setText(""..map_table[i].stat.."")
			row:getCell(2):setText("value = "..tostring(i).."")
		end
		self._smMapWidget:_disableScrollBar( )
	end
end

function interface:_sm_loadMapButtons( )
	self._ldRow = 0
	self._ldCol = 0
	self._ldWidth = 17
	self._ldHeight = 10
	local result = MOAIFileSystem.checkPathExists("map/")
	if result == false then
		MOAIFileSystem.affirmPath("map/")
	end
	local fileList = MOAIFileSystem.listFiles(""..self._categoryTable[self._currentCategory].map.."/")
	for i,v in ipairs(fileList) do
		local _string = string.find(""..v.."", ".mig", 1)
		if _string ~= nil then
			interface:_create_ms_mapBttn_Template(""..v.."")
		end
	end
end

function interface:_create_ms_mapBttn_Template(_name)
	local temp = {
		ldButton = element.gui:createButton( ),
		name = _name,
	}
	
	temp.ldButton:setDim(self._ldWidth, self._ldHeight)
	temp.ldButton.row = self._ldRow
	temp.ldButton.x = 6 + self._ldRow
	temp.ldButton.col = self._ldCol
	temp.ldButton.y = 8 + self._ldCol
	temp.ldButton:setPos(temp.ldButton.x , temp.ldButton.y)
	temp.ldButton:setNormalImage(element.resources.getPath("maps/PNR_Button_Up.png"))
	temp.ldButton:setHoverImage(element.resources.getPath("maps/PNR_Button_down.png"))
	temp.ldButton:setPushedImage(element.resources.getPath("maps/PNR_Button_down.png"))
	self._currentMapname = _name
	local lvName = string.gsub(_name, ".mig", "")
	temp.ldButton:setText(lvName)

	self._ldRow = self._ldRow +self._ldWidth + 1
	if self._ldRow >= 3 * (self._ldWidth + 1 ) then
		self._ldCol = self._ldCol + self._ldHeight + 1
		self._ldRow = 0
	end

	temp.ldButton:registerEventHandler(temp.ldButton.EVENT_BUTTON_CLICK, nil, _handleFbButtonLoadMapPressed, _name)
	self._bgImage:addChild(temp.ldButton)

	if temp.ldButton.y >= 50 then
		temp.ldButton:setPos(temp.ldButton.x , 150 )
	end

	table.insert(self._mapButtonList, temp)
end

function interface:_sm_destroyButtons( )
	for i,v in ipairs(self._mapButtonList) do
		v.ldButton:destroy( )
	end
end

function _sm_updateButtons(_scrollLine, _list)
	for i,v in ipairs(_list) do

		v.ldButton:setPos(v.ldButton.x , v.ldButton.y + _scrollLine * 10 )
		local posX, posY = v.ldButton:getPos( )
		--v.ldButton:setText("".. posY .."")
		
		if posY >= 50 then
			v.ldButton:setPos(v.ldButton.x , 150 )
		elseif posY < 6 then
			v.ldButton:setPos(v.ldButton.x, - 150 )
		end

	end
end

function interface:_update_sm_mapStats(_name)
	local mapValuesTable = {}
	local tbWidth
	local tbHeight
	local tbTemples
	local tbHouses

	local tb = table.load(""..self._categoryTable[self._currentCategory].map.."/".._name..".mig")
	local tb2 = table.load(""..self._categoryTable[self._currentCategory].map.."/".._name..".mib")
	tbWidth = #tb
	tbHeight = #tb[#tb]

	_NeutralHQ = 1073741825
	_PlayerHQ = 1073741826
	_EnemyHQ = 1073741827

	_NeutralTown = 1073741828
	_PlayerTown = 1073741829
	_EnemyTown = 1073741830

	local hCounter = 0
	local tCounter = 0
	for x = 1, #tb2 do
		for y = 1, #tb2[#tb2] do
			local value = tb2[x][y]
			if value == _NeutralHQ or value == _PlayerHQ or value == _EnemyHQ then
				tCounter = tCounter + 1
			elseif value == _NeutralTown or value == _PlayerTown or value == _EnemyTown then
				hCounter = hCounter + 1
			end
		end
	end

	tbTemples = tCounter
	tbHouses = hCounter

	local map_values = {}
	map_values[1] = _name
	map_values[2] = ""..tbWidth.." / "..tbHeight..""
	map_values[3] = ""..tbTemples..""
	map_values[4] = ""..tbHouses..""
	map_values[5] = "random"

	--mapValuesTable[1] = 

	for i = 1, 5 do
		local row = self._smMapWidget:getRow(i)

		-- The return from getCell is the widget created by setColumnWidget, so the normal
		-- functionality for the widget is available.
		if i < 5 then
			if i == 1 then
				row:getCell(1):setText(""..map_values[i].."")
				row:getCell(2):setText("")
			else
				row:getCell(1):setText(""..map_table[i].stat.."")
				row:getCell(2):setText(""..map_values[i].."")
			end
		end
	end

	local imageName = "freeBattle/maps/".._name..".png"

	if MOAIFileSystem.checkFileExists("resources/gui/"..imageName) == true then
		print("NAME: "..imageName.." EXISTS")
		self._smMapPicture:setImage(element.resources.getPath(imageName))
	else
		print("NAME: "..imageName.." DOES NOT")
		self._smMapPicture:setImage(element.resources.getPath("freeBattle/maps/temp_preview.png"))
	end
end

function interface:_update_map_selection( )
	--print("LOOP DA SWOOP LOOP - DA DO RUN RUN")
end

function _handleFbButtonLoadMapPressed(event, data)
	--------------------------------
	--------------------------------
	---- SOUND HERE ----------------
	sound:play(sound.buttonPressed)	
	---- SOUND HERE ----------------
	--------------------------------
	--------------------------------
	print("PRESSED MAP BUTTON")
	print("NAME IS: "..data.."")
	local lvName = string.gsub(data, ".mig", "")
	interface:_update_sm_mapStats(lvName)
	Game.mapFile = lvName
	--interface:_updateMalSel_grid(lvName)
end


function interface:_return_sm_categoryStuff( )
	return self._currentCategory, self._categoryTable
end

function interface:_sm_setCategory(_value)
	self._currentCategory = _value
end

function interface:_sm_catNameLabel_setText(_text)
	self._smCatName:setText(_text)
end

function interface:_sm_updatePanel( )
	if self._updateState == 1 then
		self._smBgPanel:tweenPos(0, 0, 0.2)
	else
		self._smBgPanel:tweenPos(-100, 0, 0.2)
		local bgX, bgY = self._bgImage:getPos( )
		if bgX <= - 80 then

		end
	end
end

function _handlePrevButtonClick( )
	--------------------------------
	--------------------------------
	---- SOUND HERE ----------------
	sound:play(sound.buttonPressed)	
	---- SOUND HERE ----------------
	--------------------------------
	--------------------------------
	local cat, catTable = interface:_return_sm_categoryStuff( )
	if cat > 1 then
		cat = cat - 1
	else
		cat = #catTable
	end
	interface:_sm_setCategory(cat)

	interface:_sm_destroyButtons( )
	_scrollLine = 0
	print("IT HAS BEEN DEALT WITH")
	interface:_sm_loadMapButtons( )
	interface:_sm_catNameLabel_setText(catTable[cat].name)

end

function _handleNextButtonClick( )
	--------------------------------
	--------------------------------
	---- SOUND HERE ----------------
	sound:play(sound.buttonPressed)	
	---- SOUND HERE ----------------
	--------------------------------
	--------------------------------
	local cat, catTable = interface:_return_sm_categoryStuff( )
	if cat < #catTable then
		cat = cat + 1
	else
		cat = 1
		
	end
	interface:_sm_setCategory(cat)
	interface:_sm_destroyButtons( )
	_scrollLine = 0
	print("IT HAS BEEN DEALT WITH")
	interface:_sm_loadMapButtons( )
	interface:_sm_catNameLabel_setText(catTable[cat].name)
end

function interface:_sm_returnButtonList( )
	return self._mapButtonList
end

function _handleUpButtonClick( )
	--------------------------------
	--------------------------------
	---- SOUND HERE ----------------
	sound:play(sound.buttonPressed)	
	---- SOUND HERE ----------------
	--------------------------------
	--------------------------------
	
	_scrollLine = _scrollLine - 1
	_sm_updateButtons(_scrollLine, interface:_sm_returnButtonList( ))
end

function _handleDownButtonClick( )
	--------------------------------
	--------------------------------
	---- SOUND HERE ----------------
	sound:play(sound.buttonPressed)	
	---- SOUND HERE ----------------
	--------------------------------
	--------------------------------
	_scrollLine = _scrollLine + 1
	_sm_updateButtons(_scrollLine, interface:_sm_returnButtonList( ))
end

function interface:_getCatState( )
	return self._currentCategory
end

function interface:_setUpdateState(_value)
	self._updateState = _value
end

function _handleContinueButtonClick( )
	--------------------------------
	--------------------------------
	---- SOUND HERE ----------------
	sound:play(sound.buttonPressed)	
	---- SOUND HERE ----------------
	--------------------------------
	--------------------------------

	interface:_setUpdateState(2)
	_bGuiLoaded = false
	_bGameLoaded = false
	Game:dropUI(g, resources )
	Game.lastState = 10
	currentState = 3
				--mGrid:destroy(1)
	local cat = interface:_getCatState( )
	if cat == 2 then
		Game.winCondition = 2 

	else
		Game.winCondition = 1
	end
	print("WIN CODITIONS: "..Game.winCondition.."")
	print("WIN CODITIONS: "..Game.winCondition.."")
	print("WIN CODITIONS: "..Game.winCondition.."")
	print("WIN CODITIONS: "..Game.winCondition.."")
	print("WIN CODITIONS: "..Game.winCondition.."")
	print("WIN CODITIONS: "..Game.winCondition.."")
	print("WIN CODITIONS: "..Game.winCondition.."")
	print("WIN CODITIONS: "..Game.winCondition.."")
	print("WIN CODITIONS: "..Game.winCondition.."")
	print("WIN CODITIONS: "..Game.winCondition.."")
	print("WIN CODITIONS: "..Game.winCondition.."")
	print("WIN CODITIONS: "..Game.winCondition.."")
	print("WIN CODITIONS: "..Game.winCondition.."")
	print("WIN CODITIONS: "..Game.winCondition.."")
	print("WIN CODITIONS: "..Game.winCondition.."")
	print("WIN CODITIONS: "..Game.winCondition.."")
	print("WIN CODITIONS: "..Game.winCondition.."")
end

function _HandleSmReturnMenuPressed( )
	_bGuiLoaded = false
	_bGameLoaded = false
	Game:dropUI(g, resources )
	Game.lastState = 10
	currentState = 2
	--mGrid:destroy(1)
end

function interface:_returnPathCategory( )
	return self._categoryTable[self._currentCategory]
end