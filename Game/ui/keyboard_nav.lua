function interface:_setupAlternateUiNavigation( )
	self._uiElementTable = { }
	self._uiTableIndex = 1 -- used to access elements of daddy ui table
	self._nrChildTables = 0
	self._pointerPosition = 1
	self._internalPointer = 1

	self._cursTex = image:newTexture("Game/media/cursor.png",  g_Text_Layer, "bg2_l3_tex") 
	self._curs = image:newImage(self._cursTex, 0, 0)
end

function interface:_clearUiWidgets( )
	self._uiElementTable = { }
	self._uiTableIndex = 1 -- used to access elements of daddy ui table
	self._nrChildTables = 0
	self._pointerPosition = 1
	self._internalPointer = 1
end

function interface:_addUiToDaddyTable(widgets, _doNotInclude1, _doNotInclude2, _doNotInclude3)
	--table.insert(self._uiElementTable, _table)
	local childTable = { }
	local counter = 1
	for i,k in orderedPairs(widgets) do
		if _doNotInclude1 == nil then
			_doNotInclude1 = "RANDOMGWTFNONAMEHEREIFIEVERNAMEITLIKETHISTHANRAINHELLONMYASS"
		end--infoWidgetBG
		if _doNotInclude2 == nil then
			_doNotInclude2 = "RANDOMGWTFNONAMEHEREIFIEVERNAMEITLIKETHISTHANRAINHELLONMYASS"
		end
		if _doNotInclude3 == nil then
			_doNotInclude3 = "RANDOMGWTFNONAMEHEREIFIEVERNAMEITLIKETHISTHANRAINHELLONMYASS"
		end
		if ""..i.."" ~= "".._doNotInclude1.."" and ""..i.."" ~= "".._doNotInclude2.."" and ""..i.."" ~= "".._doNotInclude3..""   then
			print("FUCKING I: "..i.." FUCKING PARAM: ".._doNotInclude1.."")
			print("FUCKING I: "..i.." FUCKING PARAM: ".._doNotInclude1.."")

			print("AND za tyepes be: ".. k.window:getType().."")
			if k.window:getType() == "Button" or k.window:getType() == "WidgetList" then
				k.window:registerEventHandler(k.window.EVENT_MOUSE_ENTERS, nil, _onEnter )
				k.window:registerEventHandler(k.window.EVENT_MOUSE_LEAVES, nil, _onExit )
				--if k.window:getType() == "Widgetlist" then

				if k.window:getType() == "WidgetList" then

				end

				--print("FIRST ONE TO ENTER IS: "..i.." and v is: "..k.window.widget.."")
				--self:_makeListOfTableElements(counter, i, v)--recording them
				childTable[counter] = { input = i, v = k }
				counter = counter + 1
			end
		end
	end
	if #childTable > 0 then
		table.insert(self._uiElementTable, childTable)

		self._nrChildTables = self._nrChildTables + 1
	end
end

function interface:_retrieveCurrentChildTable( )
	return self._uiElementTable[self._uiTableIndex]
end

function interface:_decIndex( )
	if self._uiTableIndex > 1 then
		self._uiTableIndex = self._uiTableIndex - 1
	end
	return self._uiTableIndex
end

function interface:_IncIndex( )
	print("INCREASE INDEX")
	if self._uiTableIndex < #self._uiElementTable then
		self._uiTableIndex = self._uiTableIndex + 1
	else
		self:_decIndex( )
	end
	self._pointerPosition = 1
	print("INCRESED")
	return self._uiTableIndex
end



function interface:_makeListOfTableElements(_i, _input, _v)
	print("I'S VALUE IS: ".._i.."")
	self._uiTable[_i] = { input = _input, v = _v }
end

function interface:_debugPrintElementsTable( )
	local tab = self:_retrieveCurrentChildTable( )
	for i,v in pairs(tab) do
		print(tab[i].input)
		--print(type(tab[i].v))
	end
end

function interface:_AUNavigation(key)
	local tab = self:_retrieveCurrentChildTable( )

	local tableElement = tab[self._pointerPosition].v

	if tableElement.window:getType( ) == "WidgetList" then
		local widgetList = tableElement.window
		local nrSelected = widgetList:getNumRows( )
		widgetList:clearSelections()

		if key == 119 then
			self._internalPointer = self._internalPointer - 1
		elseif key == 115 then
			self._internalPointer = self._internalPointer + 1
		end	

		widgetList:setSelection(self._internalPointer)

		if self._internalPointer < 1 then
			self._pointerPosition = #tab
			widgetList:clearSelections()
			self._internalPointer = 0
			self:_decIndex( )
		end


		if self._internalPointer > nrSelected  then
			widgetList:clearSelections()
			self._pointerPosition = 0
			self:_IncIndex( )
			self._pointerPosition = 1
		end
		

	else
		if key == 119 then
			self._pointerPosition = self._pointerPosition - 1
		elseif key == 115 then
			self._pointerPosition = self._pointerPosition + 1
		end
	end

	if self._pointerPosition < 1 then
		self._pointerPosition = #tab
		self:_decIndex( )
	end


	if self._pointerPosition > #tab  then
		self._pointerPosition = 1
		self:_IncIndex( )
	end
end

function interface:_handleUiNavigation( )
	local tab = self:_retrieveCurrentChildTable( )
	if tab ~= nil then
		--[[if self._pointerPosition < 1 then self._pointerPosition = 1 end
		if self._pointerPosition > #tab  then self._pointerPosition = #tab  end--]]

		
		local tableElement = tab[self._pointerPosition].v
		--local x = tableElement.window:screenX()
		--local y = tableElement.window:screenY()
		local x, y = tableElement.window:getScreenPos()
	--	print("X IS: "..x.. " WHILE Y IS: "..y.."")
		local gMSX, gMSY = element.gui:getMouseCoords( )
	--	print("MS X: "..gMSX.." MOUSE Y: "..gMSY.."")
		local sx, sy = tableElement.window:getDim()

		if tableElement.window:getType() == "WidgetList" then

		end
		print("CHILD NAME I IS: "..tab[self._pointerPosition].input.."")

		--print("Current Table Element is: "..tableElement.window:getType().."")
		--element.gui:setFocus(tableElement.window)
		--element.gui:injectMouseMove(x-2, y-2)
		--element.gui:injectMouseMove(x+sx/2, y+sy/2)

		print("X IS AT: "..x.." Y I AT: "..y.." GMSX: "..gMSX.." GMSY: "..gMSY.."")
		self._vMouseX = x
		self._vMouseY = (y)
	end


	--print("KEY PRESSED IS: "..key.."")
end

function interface:_updateVirtualMouse( )

	if inputFlag == false then
		image:updateImage(self._curs , self._vMouseX, self._vMouseY)
		g:injectMouseMove(self._vMouseX, self._vMouseY, self._vMouseY)	
	end
end

function _testNewGamePressed( )
	--print("NEW GAME PRESSED")
end

function  _onEnter( )
	--print("MOUSE ENTERS: ")
end

--[[
Ordered table iterator, allow to iterate on the natural order of the keys of a
table.

Example:
]]

function __genOrderedIndex( t )
    local orderedIndex = {}
    for key in pairs(t) do
        table.insert( orderedIndex, key )
    end
    table.sort( orderedIndex )
    return orderedIndex
end

function orderedNext(t, state)
    -- Equivalent of the next function, but returns the keys in the alphabetic
    -- order. We use a temporary ordered key table that is stored in the
    -- table being iterated.

    --print("orderedNext: state = "..tostring(state) )
    if state == nil then
        -- the first time, generate the index
        t.__orderedIndex = __genOrderedIndex( t )
        key = t.__orderedIndex[1]
        return key, t[key]
    end
    -- fetch the next value
    key = nil
    for i = 1,table.getn(t.__orderedIndex) do
        if t.__orderedIndex[i] == state then
            key = t.__orderedIndex[i+1]
        end
    end

    if key then
        return key, t[key]
    end

    -- no more value to return, cleanup
    t.__orderedIndex = nil
    return
end

function orderedPairs(t)
    -- Equivalent of the pairs() function on tables. Allows to iterate
    -- in order
    return orderedNext, t, nil
end

function interface:_createTestUI( )
	local roots, widgets, groups = g:loadLayout(resources.getPath("test_layout.lua"))

	
	-- register the elements of the ui
	if (nil ~= widgets.newGameBttn) then
		self._newGameBttn = widgets.newGameBttn.window
		self._newGameBttn:registerEventHandler(self._newGameBttn.EVENT_BUTTON_CLICK, nil, _testNewGamePressed)
	else
		print("Asteroid Button false")
	end

	if (nil ~= widgets.mainMenuPanel) then
		self._mainMenuPanel = widgets.mainMenuPanel.window
		--self._newGameBttn:registerEventHandler(self._newGameBttn.EVENT_BUTTON_CLICK, nil, _handleNewGameButtonPressed)
	else
		print("Asteroid Button false")
	end

	--self._uiTable = { }
	--counter = 1

	print("BEFORE PAIRS LOOP")
	self:_addUiToDaddyTable(widgets)


	local roots, widgets, groups = g:loadLayout(resources.getPath("test_layout2.lua"))
	-- Check if the widget list is a part of the layout file
	if (nil ~= widgets.widgetlist1) then
		local widgetList = widgets.widgetlist1.window

		-- Add some rows, and fill it with some junk data
		for i = 1, 4 do
			local row = widgetList:addRow()

			-- The return from getCell is the widget created by setColumnWidget, so the normal
			-- functionality for the widget is available.
			row:getCell(1):setText("Name " .. i)
			row:getCell(2):setText(tostring(i))
		end
	end




	self:_addUiToDaddyTable(widgets)
	local roots, widgets, groups = g:loadLayout(resources.getPath("test_layout3.lua"))

	if (nil ~= widgets.textBox) then
		self._testLabel = widgets.textBox.window
	end

	--self._testLabel:fitLabelText( )
	for i,v in pairs(self._testLabel) do
		--print("LABEL I CONTENT: "..i.."")
		if type(v) == "table" then
			for k, j in pairs(v) do
			--	print("V is: "..k.."")
			end
		end
	end
	--self._testLabel._text:fitLabelText(	self._testLabel._text)
	--print("TyPE OF TEXT IS: "..type(self._testLabel._text).."")
	--[[for i,v in pairs(self._testLabel._text) do
		print("I IS: "..i.."")
	end--]]
	self:_addUiToDaddyTable(widgets)

	self._vMouseX = 1
	self._vMouseY = 1

	self._pointerPosition = 1

	interface:_debugPrintElementsTable( )
end



