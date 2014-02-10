require "Game.ui.freeBattle.commander_stats"
-- big image as background panel holder
-- buttons for maps
-- widget list for Map details
-- image for map preview
-- image for commander background
-- widget list for commander info
-- buttons for up, down START


function interface:_init_fb_menu( )
	self._activeView = {}
	self._activeView[1] = {name="player1_panel", panel = nil, x = 0.5, y = 0.5, ox = 50, oy = 0.5, childView = {} }
	self._activeView[2] = {name="player2_panel", panel = nil, x = 0.5, y = 0.5, ox = 50, oy = 0.5, childView = {} }
	self._currentView = 1
	self._activeTeam = 1

	self._mapButtonList = {}
	self._commanderButtons = { }
	self._commanderButtons2 = { }

	self._playerToTeam = {}
	self._playerToTeam[1] = player1
	self._playerToTeam[2] = player2

	self:_create_fb_bg_Panel( )
	self:_create_fb_MapWidget( )
	self:_add_fb_commanderPanels( )
	self:_loadMapButtons( )

	self:_add_ContentButtons( )

	self:_add_fb_commander_stats( )

	self:_create_map_preview( )

	local lvName = string.gsub(self._mapButtonList[1].name, ".mig", "")

	self:_update_fb_mapStats(lvName)



	_scrollLine = 0

	Game.mapFile = lvName
end



function interface:_create_fb_bg_Panel( )
	fb_panel = element.gui:createImage( )
	fb_panel:setDim(100, 100)
	fb_panel:setPos(0, 0)
	fb_panel:setImage(element.resources.getPath("freeBattle/bgPanel.png") )
end

function interface:_create_map_preview( )
	self._fb_map_preview = element.gui:createImage( )
	self._fb_map_preview:setDim(18, 23)
	self._fb_map_preview:setPos(80, 3 )
	self._fb_map_preview:setImage(element.resources.getPath("freeBattle/maps/temp_preview.png") )

	fb_panel:addChild(self._fb_map_preview)
end

function interface:_create_fb_MapWidget( )
	fb_map_widget = element.gui:createWidgetList()
	fb_map_widget:setDim(22, 23)
	fb_map_widget:setPos(57, 3)
	fb_map_widget:setBackgroundImage(element.resources.getPath("freeBattle/widget_list_bg.png") )

-- Create the columns
	fb_map_widget:addColumn("", 10)
	fb_map_widget:addColumn("", 14)
	fb_map_widget:setRowHeight(6)
	fb_map_widget:setColumnWidget(1, element.gui, "createLabel")
	fb_map_widget:setColumnWidget(2, element.gui, "createLabel")

	fb_map_widget:setSelectionImage(element.resources.getPath("freeBattle/widget_list_bg.png"))

	--fb_map_widget:setMaxSelections(0)
	for i = 1, 5 do
		local row = fb_map_widget:addRow()

		-- The return from getCell is the widget created by setColumnWidget, so the normal
		-- functionality for the widget is available.
		if i < 5 then
			row:getCell(1):setText(""..map_table[i].stat.."")
			row:getCell(2):setText("value = "..tostring(i).."")
		end
	end

	fb_panel:addChild(fb_map_widget)
	fb_map_widget:_displayRows()
end

function interface:_add_fb_commander_stats( )
	self._fb_com_stats = element.gui:createWidgetList( )
	self._fb_com_stats:setDim(20, 16)
	self._fb_com_stats:setPos(2, 24)

	self._fb_com_stats:setBackgroundImage(element.resources.getPath("freeBattle/widget_list_bg.png") )

	self._fb_com_stats:addColumn("", 9)
	self._fb_com_stats:addColumn("", 8)

	self._fb_com_stats:setRowHeight(4)

	self._fb_com_stats:setColumnWidget(1, element.gui, "createLabel")
	self._fb_com_stats:setColumnWidget(2, element.gui, "createLabel")

	self._fb_com_stats:setSelectionImage(element.resources.getPath("freeBattle/widget_list_bg.png"))

	for i = 1, 6 do
		local row = self._fb_com_stats:addRow( )
		if i < 6 then
			row:getCell(1):setText(""..stat_table[i].stat.."")
			row:getCell(2):setText(""..stat_table[i].value.."")
			print("I IS: "..i.."")
		end
	end

	self._fb_com_stats:setSelectionImage(element.resources.getPath("freeBattle/widget_list_bg.png"))

	self._fb_comPanel:addChild(self._fb_com_stats)
	self._fb_com_stats:_displayRows()



end

function interface:_loadMapButtons( )
	self._ldRow = 0
	self._ldCol = 0
	self._ldWidth = 17
	self._ldHeight = 10
	local result = MOAIFileSystem.checkPathExists("map/")
	if result == false then
		MOAIFileSystem.affirmPath("map/")
	end
	local fileList = MOAIFileSystem.listFiles("map/")
	for i,v in ipairs(fileList) do
		local _string = string.find(""..v.."", ".mig", 1)
		if _string ~= nil then
			interface:_create_fb_mapBttn_Template(""..v.."")
		end
	end
end

function interface:_create_fb_mapBttn_Template(_name)
	local temp = {
		ldButton = element.gui:createButton( ),
		name = _name,
	}
	
	temp.ldButton:setDim(self._ldWidth, self._ldHeight)
	temp.ldButton.row = self._ldRow
	temp.ldButton.x = 2 + self._ldRow
	temp.ldButton.col = self._ldCol
	temp.ldButton.y = 3 + self._ldCol
	temp.ldButton:setPos(temp.ldButton.x , temp.ldButton.y)
	temp.ldButton:setNormalImage(element.resources.getPath("freeBattle/widget_list_bg.png"))
	self._currentMapname = _name
	local lvName = string.gsub(_name, ".mig", "")
	temp.ldButton:setText(lvName)

	self._ldRow = self._ldRow +self._ldWidth + 1
	if self._ldRow >= 3 * (self._ldWidth + 1 ) then
		self._ldCol = self._ldCol + self._ldHeight + 1
		self._ldRow = 0
	end

	temp.ldButton:registerEventHandler(temp.ldButton.EVENT_BUTTON_CLICK, nil, _handleFbButtonLoadMapPressed, _name)
	fb_panel:addChild(temp.ldButton)

	if temp.ldButton.y >= 70 then
		temp.ldButton:setPos(temp.ldButton.x , 150 )
	end

	table.insert(self._mapButtonList, temp)
end

function interface:_add_fb_commanderPanels( )
	self._fb_comPanel = element.gui:createImage( )
	self._fb_comPanel:setDim(41, 40)
	self._fb_comPanel:setPos(57, 27)
	self._fb_comPanel:setImage(element.resources.getPath("freeBattle/widget_list_bg.png"))

	fb_panel:addChild(self._fb_comPanel)

	self._fb_player1Panel = element.gui:createImage( )
	self._fb_player1Panel:setDim(40, 23 )
	self._fb_player1Panel:setPos( 0.5, 0.5 )
	self._fb_player1Panel:setImage(element.resources.getPath("freeBattle/p1_commander_panel.png"))

	self._fb_player2Panel = element.gui:createImage( )
	self._fb_player2Panel:setDim(40, 23 )
	self._fb_player2Panel:setPos( 50, 0.5 )
	self._fb_player2Panel:setImage(element.resources.getPath("freeBattle/p2_commander_panel.png"))

	self._activeView[1].panel = self._fb_player1Panel
	self._activeView[2].panel = self._fb_player2Panel

	self._fb_comPanel:addChild(self._fb_player1Panel)
	self._fb_comPanel:addChild(self._fb_player2Panel)

	self:_add_fb_commanderButtons( )
	self:_add_fb_selectPlayer_cmd( )
end

function interface:_add_fb_commanderButtons( )
	--self._cdRow = 0
	--self._cdCol = 0
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
		self:_fb_commanderBttnTemplate(i, 1)
	end


	for i = 1, 8 do
		self:_fb_commanderBttnTemplate(i, 2)
	end
end




function interface:_fb_commanderBttnTemplate(_id, _parrent)
	local temp = {
		cdButton = element.gui:createButton( ),
		_id = _id,
		team = _parrent,
	}

	if _parrent == 1 then
		self._fb_player1Panel:addChild(temp.cdButton)
	else
		self._fb_player2Panel:addChild(temp.cdButton)
	end

	temp.cdButton:setDim(self._cdWidth, self._cdHeight)
	--[[if commander[_id].team == 1 then
		temp.cdButton:setNormalImage(element.resources.getPath("freeBattle/bttn_tex.png"))
	else
		temp.cdButton:setNormalImage(element.resources.getPath("freeBattle/bttn_tex2.png"))
	end--]]
	if _id == 1 then
		temp.cdButton:setNormalImage(element.resources.getPath("freeBattle/portraits/".._id.."d.png"))
	else
		temp.cdButton:setNormalImage(element.resources.getPath("freeBattle/portraits/".._id.."".._parrent..".png"))
	end
	temp.cdButton:setHoverImage(element.resources.getPath("freeBattle/portraits/".._id.."d.png"))
	temp.cdButton:setPushedImage(element.resources.getPath("freeBattle/portraits/".._id.."d.png"))
	temp.cdButton:registerEventHandler(temp.cdButton.EVENT_BUTTON_CLICK, nil, _handleCDButtonPressed, temp)
	temp.cdButton.row = self.team[_parrent].row
	temp.cdButton.x = 5 + self.team[_parrent].row
	temp.cdButton.col = self.team[_parrent].col
	temp.cdButton.y = 1 + self.team[_parrent].col
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

function interface:_add_fb_selectPlayer_cmd( )
	self._select_pl_cmd = element.gui:createButton( )
	self._select_pl_cmd:setDim(16, 14)
	self._select_pl_cmd:setPos(24, 24)
	self._select_pl_cmd:setText("SELECT P2")
	self._fb_comPanel:addChild(self._select_pl_cmd)

	self._select_pl_cmd:registerEventHandler(self._select_pl_cmd.EVENT_BUTTON_CLICK, nil, _fb_handle_playerPanel_change )
end

function _handleCDButtonPressed(event, data)
	interface:_fb_updateCdStats(data._id)
	Game.commander[data.team].imgID = data._id
	Game.commander[data.team].name = commander[data._id].name
	if data.team == 1 then
		player1.team = commander[data._id].team
	else
		player2.team = commander[data._id].team
	end
end

function interface:_fb_updateCdStats(_id)
	_setStatValue(_id)
	for i = 1, 6 do
		local row = self._fb_com_stats:getRow(i)
		if i < 6 then
			row:getCell(1):setText(""..stat_table[i].stat.."")
			row:getCell(2):setText(""..stat_table[i].value.."")
			print("I IS: "..i.."")
		end
	end
	local table 
	if self._activeTeam == 1 then
		table = self._commanderButtons
	else
		table = self._commanderButtons2
	end

	for i,v in ipairs(table) do
		if v._id ~= _id then
			v.cdButton:setNormalImage(element.resources.getPath("freeBattle/portraits/"..i..""..self._activeTeam..".png"))
		else
			v.cdButton:setNormalImage(element.resources.getPath("freeBattle/portraits/".._id.."d.png"))
		end
	end
end

function interface:_add_ContentButtons( )
	self._upButton = element.gui:createButton( )
	self._upButton:setDim(25, 15)
	self._upButton:setPos(2, 82)
	self._upButton:setText("UP")

	self._downButton = element.gui:createButton( )
	self._downButton:setDim(25, 15)
	self._downButton:setPos(28, 82)
	self._downButton:setText("DOWN")

	self._startButton = element.gui:createButton( )
	self._startButton:setDim( 41, 12 )
	self._startButton:setPos( 57, 68 )
	self._startButton:setText( "START BATTLE" )

	self._returnMainMenu = element.gui:createButton( )
	self._returnMainMenu:setDim( 41, 15 )
	self._returnMainMenu:setPos( 57, 82 )
	self._returnMainMenu:setText("RETURN TO MAIN MENU")

	self._startButton:registerEventHandler(self._startButton.EVENT_BUTTON_CLICK, nil, _HandleFbStartBattlePressed)
	self._returnMainMenu:registerEventHandler(self._returnMainMenu.EVENT_BUTTON_CLICK, nil, _handleFbBackMMPressed)

	self._upButton:registerEventHandler(self._upButton.EVENT_BUTTON_CLICK, nil, _handleFBIncRowPressed)
	self._downButton:registerEventHandler(self._downButton.EVENT_BUTTON_CLICK, nil, _handleFBDecRowPressed)

	fb_panel:addChild(self._upButton)
	fb_panel:addChild(self._downButton)
	fb_panel:addChild(self._startButton)
	fb_panel:addChild(self._returnMainMenu)
end

function interface:_update_fb( )
	self:_fb_updateViews( )
end

function _handleFbButtonLoadMapPressed(event, data)
	local lvName = string.gsub(data, ".mig", "")
	Game.mapFile = lvName
	interface:_update_fb_mapStats(Game.mapFile)

end

function interface:_update_fb_mapStats(_name)
	local mapValuesTable = {}
	local tbWidth
	local tbHeight
	local tbTemples
	local tbHouses

	local tb = table.load("map/".._name..".mig")
	local tb2 = table.load("map/".._name..".mib")
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
		local row = fb_map_widget:getRow(i)

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
		self._fb_map_preview:setImage(element.resources.getPath(imageName))
	else
		print("NAME: "..imageName.." DOES NOT")
		self._fb_map_preview:setImage(element.resources.getPath("freeBattle/maps/temp_preview.png"))
	end
end

function interface:_getComButtonList( )
	return self._mapButtonList
end

function _handleFbBackMMPressed( )
	--sound:stopAllFromCategory(SOUND_WORLDMAP)
	--worldMap:destroy( )
	--anim:dropAll( )
	_bGuiLoaded = false
	_bGameLoaded = false
	Game:dropUI(g, resources )
	currentState = 2
end

function _handleFBIncRowPressed( )
	_scrollLine = _scrollLine - 1
	 _fb_updateButtons(_scrollLine, interface:_getComButtonList( ))
end

function _handleFBDecRowPressed( )
	_scrollLine = _scrollLine + 1
	 _fb_updateButtons(_scrollLine, interface:_getComButtonList( ))
end

function _fb_updateButtons(_scrollLine, _list)
	for i,v in ipairs(_list) do

		v.ldButton:setPos(v.ldButton.x , v.ldButton.y + _scrollLine * 14 )
		local posX, posY = v.ldButton:getPos( )
		if posY >= 70 then
			v.ldButton:setPos(v.ldButton.x , 150 )
		end
	end
end

function interface:_fb_getActiveView( )
	return self._currentView
end

function interface:_fb_setCurrentView(_value)
	self._currentView = _value
	if _value == 1 then
		self._select_pl_cmd:setText("SELECT P2")
		self._activeTeam = 1
	else
		self._select_pl_cmd:setText("SELECT P1")
		self._activeTeam = 2
	end
end

function _fb_handle_playerPanel_change( )
	if interface:_fb_getActiveView( ) == 1 then
		interface:_fb_setCurrentView(2)
		
	else
		interface:_fb_setCurrentView(1)
		--self._select_pl_cmd:setText("SELECT P2")
	end
end

function interface:_fb_updateViews( )
	--print("ACTIVE TEAM = :"..self._activeTeam.."")
	--print("COMMANDER FOR TEAM 1 IS: "..Game.commander[1].. " | AND FOR TEAM 2 IS: "..Game.commander[2].."")
	local _st = self._activeView[self._currentView].name



	for i = 1, #self._activeView do
		if self._activeView[i].name ~= _st then
			self._activeView[i].panel:tweenPos(self._activeView[i].ox, self._activeView[i].oy)
		else
			self._activeView[i].panel:tweenPos(self._activeView[i].x, self._activeView[i].y)
		end
	end
end

function _HandleFbStartBattlePressed( )
	_bGuiLoaded = false
	_bGameLoaded = false
	Game:dropUI(g, resources )
	Game.lastState = 10
	currentState = 5
end