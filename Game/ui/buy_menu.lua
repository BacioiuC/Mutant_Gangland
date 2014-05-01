require "Game.ui.resource_tables"
local textstyles = require "gui/textstyles"

local path = "buy_menu/unit_icons/"
function interface:_buy_menu_init( )
	-- setting up the unit stuff
	self._buyUnitTable = {}
	self._teamToPlayer = { }
	self._teamToPlayer[1] = player1
	self._teamToPlayer[2] = player2
	

	self._buyMenuElementsTable = {}
	self._pointerPosition = 1
	-- table in table. First value = team. Second value - unit id
	--self._buyUnitTable[1] = { }
	


	self._buyUnitTable[1] = { } -- team
	self._buyUnitTable[1][1] = { } -- faction 1
	self._buyUnitTable[1][2] = { } -- faction 2



	self._buyUnitTable[1][1][1] = { icon = ""..path.."11.png", name = " Spottah", cost = 20 } -- 30, 40, 120, 150
	self._buyUnitTable[1][1][2] = { icon = ""..path.."12.png", name = " Panza Spottah" , cost = 30 }
	self._buyUnitTable[1][1][3] = { icon = ""..path.."13.png", name = " Attaka" , cost = 40 }
	self._buyUnitTable[1][1][4] = { icon = ""..path.."14.png", name = " Butcha" , cost = 80 }
	self._buyUnitTable[1][1][5] = { icon = ""..path.."15.png", name = " Bamtank"  , cost = 130}

	--self._buyUnitTable[2] = { }
	self._buyUnitTable[1][2][1] = { icon = ""..path.."21.png", name = " TrekBot" , cost = 15 }
	self._buyUnitTable[1][2][2] = { icon = ""..path.."22.png", name = " Panza \n TrekBot" , cost = 25 }
	self._buyUnitTable[1][2][3] = { icon = ""..path.."23.png", name = " Killbot" , cost = 35 }
	self._buyUnitTable[1][2][4] = { icon = ""..path.."24.png", name = " Supa \n Killbot" , cost = 80 }
	self._buyUnitTable[1][2][5] = { icon = ""..path.."25.png", name = " Mecha \n Attaka"  , cost = 110}

	self._buyUnitTable[2] = { } -- team
	self._buyUnitTable[2][1] = { } -- faction 1
	self._buyUnitTable[2][2] = { } -- faction 2


	self._buyUnitTable[2][1][1] = { icon = ""..path.."31.png", name = " Spottah", cost = 20 } -- 30, 40, 120, 150
	self._buyUnitTable[2][1][2] = { icon = ""..path.."32.png", name = " Panza \n Spottah" , cost = 30 }
	self._buyUnitTable[2][1][3] = { icon = ""..path.."33.png", name = " Attaka" , cost = 40 }
	self._buyUnitTable[2][1][4] = { icon = ""..path.."34.png", name = " Butcha" , cost = 80 }
	self._buyUnitTable[2][1][5] = { icon = ""..path.."35.png", name = " Bamtank"  , cost = 130}


	self._buyUnitTable[2][2][1] = { icon = ""..path.."41.png", name = " TrekBot" , cost = 15 }
	self._buyUnitTable[2][2][2] = { icon = ""..path.."42.png", name = " Panza \n TrekBot" , cost = 25 }
	self._buyUnitTable[2][2][3] = { icon = ""..path.."43.png", name = " Killbot" , cost = 35 }
	self._buyUnitTable[2][2][4] = { icon = ""..path.."44.png", name = " Supa \n Killbot" , cost = 80 }
	self._buyUnitTable[2][2][5] = { icon = ""..path.."45.png", name = " Mecha \n Attaka"  , cost = 110}

	self._buyUnitStats = { "Health", "Attk Rng", "Mobility", "Damage", "Capture", "Cost"  }

	self._biconList = { }
	self._biconList[1] = "buy_menu/stat/health.png"
	self._biconList[2] = "buy_menu/stat/range.png"
	self._biconList[3] = "buy_menu/stat/mobility.png"
	self._biconList[4] = "buy_menu/stat/damage.png"
	self._biconList[5] = "buy_menu/stat/cost.png"
	self._biconList[6] = "buy_menu/stat/money.png"



	self._unitBuyButtons = {}
	self._powerupBuyButtons = {}

	self._buyMenuTween = false
	--self:_createBuyMenu_panel( )
	--interface:_addUnitButtons( )
	--[[interface:_addUnitButtonsTemplate(1, 1)
	interface:_addUnitButtonsTemplate(1, 2)
	interface:_addUnitButtonsTemplate(1, 3)
	interface:_addUnitButtonsTemplate(1, 4)
	interface:_addUnitButtonsTemplate(1, 5)--]]

	
	--self:_addPowerupButtonsTemplate(1)
	--self:_addPowerupButtonsTemplate(2)


	-- unit display go here
	local roots, widgets, groups = g:loadLayout(resources.getPath("buymenu.lua"))

	self._buyMenuWidgets = widgets
	self._buyMenuRoots = roots
	self._buyMenuGroups = groups
	buyPanel = widgets.bgPanel.window
	buyPanel:registerEventHandler(buyPanel.EVENT_MOUSE_ENTERS, nil, _handleMouseEnters)
	buyPanel:registerEventHandler(buyPanel.EVENT_MOUSE_LEAVES, nil, _handleMouseLeaves)

	local counter = 1
	for i,v in pairs(widgets) do
		v.window:registerEventHandler(v.window.EVENT_MOUSE_ENTERS, nil, _onEnter )
		v.window:registerEventHandler(v.window.EVENT_MOUSE_LEAVES, nil, _onExit )
		self:_makeListOfTableElementsForBuyMenu(counter, i, v)--recording them
		counter = counter + 1
	end


	self._bm_widgets = widgets

	self:_populate_buyMenu_unitsList(roots, widgets, groups)
	self:_populate_buyMenu_untiInfo(roots, widgets, groups)
	self:_addBuyButton(roots, widgets, groups)

	self._building = nil

end

--function interface:_updateBuyMenu_unitList( )
--	local widgetList = self._unitWidgetList
--end

function interface:_makeListOfTableElementsForBuyMenu(_i, _input, _v)
	print("I'S VALUE IS: ".._i.."")
	self._buyMenuElementsTable[_i] = { input = _input, v = _v }
end

function interface:_debugPrintElementsTable( )
	for i = 1, #self._buyMenuElementsTable do
		print(type(self._buyMenuElementsTable[i].input))
		print(type(self._buyMenuElementsTable[i].v))
	end
end

function interface:_keyboardNavigationThroughMenu(key)


	--[[if self._pointerPosition < 1 then self._pointerPosition = 1 end
	if self._pointerPosition > #self._buyMenuElementsTable then self._pointerPosition = #self._buyMenuElementsTable end
	local tableElement = self._buyMenuElementsTable[self._pointerPosition].v
	local tableName = self._buyMenuElementsTable[self._pointerPosition].i
	local x = tableElement.window:screenX()
	local y = tableElement.window:screenY()

	print("X IS: "..x.. " WHILE Y IS: "..y.."")
	local gMSX, gMSY = element.gui:getMouseCoords( )
	print("MS X: "..gMSX.." MOUSE Y: "..gMSY.."")
	local sx, sy = tableElement.window:getDim()
	print("CHILD NAME I IS: "..self._buyMenuElementsTable[self._pointerPosition].input.."")

	element.gui:setFocus(tableElement.window)
	element.gui:injectMouseMove(x+2, y+2)
	

	if key == 115 then
		self._pointerPosition = self._pointerPosition - 1
	elseif key == 119 then
		self._pointerPosition = self._pointerPosition + 1
	elseif key == 32 then
		element.gui:injectMouseButtonDown(inputconstants.LEFT_MOUSE_BUTTON)
	end
	element.gui:injectMouseMove(x+2, y+2)--]]
end

 
function interface:_makeBuyMenu(_roots, _widgets, _groups)

end

function interface:_populate_buyMenu_unitsList( )
	local roots, widgets, groups = self._buyMenuRoots, self._buyMenuWidgets, self._buyMenuGroups
	widgets.unitWidget.window:clearList()

	local _chkTurn = unit:_returnTurn( )
	local _turn = 1

	if _chkTurn ~= nil then
		_turn = _chkTurn
	end

	local player1Team = _turn
	local player1Faction = self._teamToPlayer[_turn].team
	if (nil ~= widgets.unitWidget) then
		local widgetList = widgets.unitWidget.window
		self._unitWidgetList = widgets.unitWidget.window
		widgetList:registerEventHandler(widgetList.EVENT_WIDGET_LIST_SELECT, nil, handle_BuyMenu_UnitSel_pressed)
		widgetList:registerEventHandler(widgetList.EVENT_WIDGET_LIST_UNSELECT, nil, handle_BuyMenu_UnitSel_released)

		widgetList:registerEventHandler(widgetList.EVENT_MOUSE_ENTERS, nil, _handleMouseEnters)
		widgetList:registerEventHandler(widgetList.EVENT_MOUSE_LEAVES, nil, _handleMouseLeaves)

		local scrollBar = widgetList:_returnScrollbar( )
		scrollBar:registerEventHandler(scrollBar.EVENT_MOUSE_ENTERS, nil, _handleMouseEnters)
		scrollBar:registerEventHandler(scrollBar.EVENT_MOUSE_LEAVES, nil, _handleMouseLeaves)

		local header = widgetList:_returnHeader( )
		header:registerEventHandler(header.EVENT_MOUSE_ENTERS, nil, _handleMouseEnters)
		header:registerEventHandler(header.EVENT_MOUSE_LEAVES, nil, _handleMouseLeaves)	


		--local nrUnitsTeam1 = #unit_type[1]
		--local nrUnitsTeam2 = #unit_type[2]

		--[[
	local teamTable = self._tTexture[untTeam][_type].p1
	if _team == 2 then
		teamTable = self._tTexture[untTeam][_type].p2
	end



		 ]]

		--widgetList:setBackgroundImage( element.resources.getPath( "buy_menu/item_bg.png" ) )
		-- Add some rows, and fill it with some junk data
		local nrUnitsForBuy = #unit_type[player1Faction]

		for i = 1, nrUnitsForBuy do
			local row = widgetList:addRow()
			local row2 = widgetList:getRow(i)
			row:setOneRowLower(true)
			row:registerEventHandler(row.EVENT_MOUSE_ENTERS, nil, _handleMouseEnters)
			row:registerEventHandler(row.EVENT_MOUSE_LEAVES, nil, _handleMouseLeaves)
			-- The return from getCell is the widget created by setColumnWidget, so the normal
			-- functionality for the widget is available.
			local iconToUse = unit_type[player1Faction][i].buyMenuIcon1
			if _turn == 2 then
				iconToUse = unit_type[player1Faction][i].buyMenuIcon2
			end
			local iconPath 
			if iconToUse == "empty.png" or iconToUse == nil or iconToUse == "" then
				iconPath = ""..path.."empty.png"
			else
				iconPath = ""..path..""..iconToUse.."" 
			end
			
			--if i < 6 then
				--row:getCell(2):setTextStyle(textstyles.get( "stats" ), 14)
				row:getCell(1):setImage( element.resources.getPath( iconPath ) )
				row:getCell(2):setImage( element.resources.getPath( "buy_menu/bg_list.png" ) )
				row:getCell(2):setText( ""..unit_type[player1Faction][i].Name.."\n "..unit_type[player1Faction][i].cost..""  )
			--end
		end
		
		--widgetList:setSelection(1)
	end
end

--[[
self._buyMenuWidgets
self._buyMenuRoots
self._buyMenuGroups 
]]
function interface:_update_buymenu_unitList( )
	local _turn = unit:_returnTurn()

	local player1Team = _turn
	local player1Faction

	--[[if _turn == 2 then
		if self._teamToPlayer[_turn].team == 1 then
			player1Faction = 2
		else
			player1Faction = 1
		end
	else
		player1Faction = self._teamToPlayer[_turn].team
	end--]]
	player1Faction = self._teamToPlayer[_turn].team

	for i = 1, 5 do
			local iconToUse = unit_type[player1Faction][i].buyMenuIcon1
			if _turn == 2 then
				iconToUse = unit_type[player1Faction][i].buyMenuIcon2
			end
			local iconPath 
			if iconToUse == "empty.png" or iconToUse == nil then
				iconPath = ""..path.."empty.png"
			else
				iconPath = ""..path..""..iconToUse.."" 
			end
		local row = self._unitWidgetList:getRow(i)
		row:getCell(1):setImage( element.resources.getPath( iconPath ) )
		row:getCell(2):setText( ""..unit_type[player1Faction][i].Name.."\n "..unit_type[player1Faction][i].cost..""  )
			
	end
end


function interface:_update_buyMenu_unitInfo(_selID)
	local widgetList = self._bm_widgets.infoWidget.window

	local turn = unit:_returnTurn( )
	local player1Team = self._teamToPlayer[turn].team
	local player1Faction = 1
	--[[if turn == 2 then
		if self._teamToPlayer[turn].team == 1 then
			player1Faction = 2
		else
			player1Faction = 1
		end
	else
		
	end--]]
	player1Faction = self._teamToPlayer[turn].team
	local statTable = { }
	local unTable = unit_type[player1Faction][_selID]
	local answer = "NO"
	if unTable ~= nil then
		if unTable.canCapture == true then
			answer = "YES"
		end
	end
	statTable = {  unTable.health,  unTable.max_range,  unTable.mobility,  unTable.damage,  answer, unTable.cost  }
	for i = 1, #self._buyUnitStats+1  do
		local row = widgetList:getRow(i)

		-- The return from getCell is the widget created by setColumnWidget, so the normal
		-- functionality for the widget is available.
		if i <= #self._buyUnitStats then
			row:getCell(1):setImage( element.resources.getPath( "buy_menu/bg_normal_4x4.png" ) ) 
			row:getCell(2):setImage(element.resources.getPath( ""..self._biconList[i].."")) 
			row:getCell(3):setImage(element.resources.getPath( "buy_menu/bg_middle_to_end.png" ) )
			row:getCell(3):setText( " "..statTable[i].."" )
		end
	end
	--widgetList:setBackgroundImage(element.resources.getPath("buy_menu/selection_image.png"))--empty.png
end

function interface:_addBuyButton(_roots, _widgets, _groups)
	local roots, widgets, groups = _roots, _widgets, _groups
	if (nil ~= widgets.buyButton) then
		local buyButton = widgets.buyButton.window
		 buyButton:registerEventHandler( buyButton.EVENT_BUTTON_CLICK, nil, _handleBuyUnitPressed )
		 local cancelButton = widgets.cancelButton.window
		 cancelButton:registerEventHandler( cancelButton.EVENT_BUTTON_CLICK, nil, _handleCancelPressed )
	end
	--tempButton:registerEventHandler(tempButton.EVENT_BUTTON_CLICK, nil, _handleBuyUnitPressed, tempButton.id )
end

function interface:_populate_buyMenu_untiInfo(_roots, _widgets, _groups)
	local roots, widgets, groups = _roots, _widgets, _groups

	if (nil ~= widgets.infoWidget) then
		local widgetList = widgets.infoWidget.window
		widgetList:registerEventHandler(widgetList.EVENT_MOUSE_ENTERS, nil, _handleMouseEnters)
		widgetList:registerEventHandler(widgetList.EVENT_MOUSE_LEAVES, nil, _handleMouseLeaves)

		local scrollBar = widgetList:_returnScrollbar( )
		scrollBar:registerEventHandler(scrollBar.EVENT_MOUSE_ENTERS, nil, _handleMouseEnters)
		scrollBar:registerEventHandler(scrollBar.EVENT_MOUSE_LEAVES, nil, _handleMouseLeaves)

		local header = widgetList:_returnHeader( )
		header:registerEventHandler(header.EVENT_MOUSE_ENTERS, nil, _handleMouseEnters)
		header:registerEventHandler(header.EVENT_MOUSE_LEAVES, nil, _handleMouseLeaves)	
		--widgetList:setBackgroundImage(element.resources.getPath("buy_menu/selection_image.png"))--empty.png

		--widgetList:setBackgroundImage(element.resources.getPath("/buy_menu/info_bg.png"))
		-- Add some rows, and fill it with some junk data
		for i = 1, #self._buyUnitStats+1  do
			local row = widgetList:addRow()
			row:setInteractable(false)
			row:setSelectedTextStyle( textstyles.get( "stats" )	)
			row:setUnselectedTextStyle( textstyles.get( "statsBad" )	 )
			row:registerEventHandler(row.EVENT_MOUSE_ENTERS, nil, _handleMouseEnters)
			row:registerEventHandler(row.EVENT_MOUSE_LEAVES, nil, _handleMouseLeaves)
			-- The return from getCell is the widget created by setColumnWidget, so the normal
			-- functionality for the widget is available.
			if i <= #self._buyUnitStats then
				--row:getCell(1):setImage(element.resources.getPath( ""..self._biconList[i]..""))
				row:getCell(1):setImage( element.resources.getPath( "buy_menu/bg_normal_4x4.png" ) ) 
				row:getCell(2):setImage(element.resources.getPath( "buy_menu/stat/empty.png")) 
				row:getCell(3):setImage(element.resources.getPath( "buy_menu/bg_middle_to_end.png" ) )
				row:getCell(3):setText( "" )
				row:getCell(3):setTextStyle(textstyles.get( "stats" ), 14)
			end
		end
		widgetList:_disableScrollBar( )
	end
end



function interface:_createBuyMenu_panel( )
	buyPanel = element.gui:createImage( )
	buyPanel:setDim(37, 84)
	buyPanel:setPos(-37, 8)
	buyPanel:setImage(element.resources.getPath("build_background.png"))
	buyPanel:registerEventHandler(buyPanel.EVENT_MOUSE_ENTERS, nil, _handleMouseEnters)
	buyPanel:registerEventHandler(buyPanel.EVENT_MOUSE_LEAVES, nil, _handleMouseLeaves)
end



function interface:_addUnitButtonsTemplate(_team, _id)
	local tempButton = element.gui:createButton( )
	tempButton:setDim(33, 14)
	tempButton:setPos(1, 1 + #self._unitBuyButtons*15 )
	tempButton.id = _id
	tempButton:setNormalImage(element.resources.getPath( button_img[_id] ) )--setBackgroundImage(element.resources.getPath("attack_button"))
	tempButton:setHoverImage(element.resources.getPath( button_h_img[_id] ) )
	tempButton:setPushedImage(element.resources.getPath( button_h_img[_id] ) )
	tempButton:setDisabledImage(element.resources.getPath( button_d_img[_id] ) )
	

	buyPanel:addChild(tempButton)
	tempButton:registerEventHandler(tempButton.EVENT_MOUSE_ENTERS, nil, _handleMouseEnters)
	tempButton:registerEventHandler(tempButton.EVENT_MOUSE_LEAVES, nil, _handleMouseLeaves)

	table.insert(self._unitBuyButtons, tempButton)
end

function interface:_disableButtonsBasedOnMoney(_turn)
	local cash
	if _turn == 1 then
		cash = player1.coins
	else
		cash = player2.coins
	end

	for i = 1, #self._unitBuyButtons do 
		if cash >= unit_type[1][i].cost then
			self._unitBuyButtons[i]:setEnabled(true)
		else
			self._unitBuyButtons[i]:setEnabled(false)
		end
	end

	for i = 1, #self._powerupBuyButtons do
		if cash >= power_table[i].cost then
			self._powerupBuyButtons[i]:setEnabled(true)
		else
			self._powerupBuyButtons[i]:setEnabled(false)
		end
	end

end

function interface:_addPowerupButtonsTemplate(_id)
	local tempButton = element.gui:createButton( )
	tempButton:setDim(9, 12)
	tempButton:setPos(1+#self._powerupBuyButtons*10, 1 + #self._unitBuyButtons*15 )
	tempButton.id = _id
	tempButton:setNormalImage(element.resources.getPath( power_up_img[_id] ) )--setBackgroundImage(element.resources.getPath("attack_button"))
	tempButton:setHoverImage(element.resources.getPath( power_uph_img[_id] ) )
	tempButton:setPushedImage(element.resources.getPath( power_uph_img[_id] ) )
	tempButton:setDisabledImage(element.resources.getPath( power_uph_img[_id] ) )
	tempButton:registerEventHandler(tempButton.EVENT_BUTTON_CLICK, nil, _handlePowerupButtonPressed, tempButton.id )

	buyPanel:addChild(tempButton)
	tempButton:registerEventHandler(tempButton.EVENT_MOUSE_ENTERS, nil, _handleMouseEnters)
	tempButton:registerEventHandler(tempButton.EVENT_MOUSE_LEAVES, nil, _handleMouseLeaves)

	tempButton:setEnabled(false)

	table.insert(self._powerupBuyButtons, tempButton)
end

function interface:_getBuyMenuTweenStatus( )
	return self._buyMenuTween 
end

function interface:_tweenBuyMenu( )
	local buyX = 0
	local turn = unit:_returnTurn( )
	if turn == 1 then
		buyX = 26
	else
		buyX = 5
	end
	if self._buyMenuTween == false then
		buyPanel:tweenPos(-80, 2, 0.2)
		unit:setOnUi(false)
	elseif self._buyMenuTween == true then
		buyPanel:tweenPos( buyX , 2, 0.2)
		unit:setOnUi(true)
	end
end

function interface:setBuyMenu(_bool, _building)

	self._buyMenuTween = _bool
	if self._buyMenuTween == true then
		self:_addUiToDaddyTable(self._buyMenuWidgets, "infoWidget", "infoWidgetBG", "bgPanel")
	else
		interface:_clearUiWidgets( )
	end
	self:_disableButtonsBasedOnMoney(1)
	if _building ~= nil then
		--------------------------------
		--------------------------------
		---- SOUND HERE ----------------
		sound:play(sound.menuSwipe)
		---- SOUND HERE ----------------
		--------------------------------
		--------------------------------
		self._building = _building
	end
end

function _handleMouseEnters( )
	unit:_setTouchState(false)
	camera:setScroll(false)
end

function _handleMouseLeaves( )
	unit:_setTouchState(true)
	camera:setScroll(true)
	
end

function interface:_getBuilding( )
	return self._building
end



function _handlePowerupButtonPressed(event, _id)
	local _building = interface:_getBuilding( )
	print("_ID IS:".._id.."")
	local cost = power_table[_id].cost
	print("COST IS: "..cost.."")
	if player1.coins >= cost then
		if _id == 1 then
			unit:_applyPowerupHealAll( )
		elseif _id == 2 then
			unit:_applyPowerupDmgAll( )
		end
		interface:setBuyMenu(false)
		player1.coins = player1.coins - cost
	end
end

function _bmnOnEnter( )
	unit:setOnUi(true)
	camera:setScroll(false)
end

function _bmnOnExit( )
	camera:setScroll(true)
	unit:setOnUi(false)
end

function interface:_returnBmWidgets( )
	return self._bm_widgets
end

function handle_BuyMenu_UnitSel_pressed( )
	print("PRESSED MOFO! PRESSSED")
	local bmWidge = interface:_returnBmWidgets( )
	local widgetList = bmWidge.unitWidget.window
	--local text = element.widgets.textBox1.window
	--if widgetList:getSelections() == 6 then
	local selection = widgetList:getSelections()

	interface:_update_buyMenu_unitInfo(selection[1])
end

function interface:_returnTeamToPlayer( )
	return self._teamToPlayer
end

function _handleBuyUnitPressed( )
	print("THIS HAS BEEN PRESSED")
	local turn = unit:_returnTurn( )
	local player1Team = interface:_returnTeamToPlayer( )[turn].team
	local pPlayer = interface:_returnTeamToPlayer( )[turn]
	local bmWidge = interface:_returnBmWidgets( )
	local widgetList = bmWidge.unitWidget.window
	--local text = element.widgets.textBox1.window
	--if widgetList:getSelections() == 6 then
	local selection = widgetList:getSelections()
	local _id = selection[1]

	--[[if turn == 2 then
		if player1Team == 1 then
			player1Team = 2
		else
			player1Team = 1
		end

	end--]]
	local _building = interface:_getBuilding( )
	if _id ~= nil then
		if _building.canProduce == true and  pPlayer.coins >= unit_type[player1Team][_id].cost then
			print(" WE CAN DO IT")
			pPlayer.coins =  pPlayer.coins - unit_type[player1Team][_id].cost

			--------------------------------
			--------------------------------
			---- SOUND HERE ----------------
			sound:play(sound.factoryProd)
			---- SOUND HERE ----------------
			--------------------------------
			--------------------------------

			unit:new(unit:_returnTurn( ), _building.x, _building.y, _id)
			_building.canProduce = false
			interface:setBuyMenu(false)
		end
	end
end

function  handle_BuyMenu_UnitSel_released( )
	interface:_clear_buyMenu_info( )
end

function interface:_clear_buyMenu_info( )
	local widgetList = self._bm_widgets.infoWidget.window

	for i = 1, #self._buyUnitStats+1  do
		local row = widgetList:getRow(i)

		-- The return from getCell is the widget created by setColumnWidget, so the normal
		-- functionality for the widget is available.
		if i <= #self._buyUnitStats then
			row:getCell(2):setImage(element.resources.getPath("buy_menu/stat/empty.png"))
			row:getCell(3):setText( "" )
		end
	end
	--widgetList:setBackgroundImage(element.resources.getPath("buy_menu/empty.png"))--empty.png
end


function _handleCancelPressed( )
	interface:setBuyMenu(false)
end