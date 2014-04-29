lEditor = {}

lEditor.offX = 0
lEditor.offY = 0
map.offX = 64
map.offY = 64
lEditor.gridSize = 32
function lEditor:init( )
	self._gridX = 25
	self._gridY = 22

	self._minScrollX = 64
	self._minScrollY = 64

	self._maxScrollX = -(self._gridX * 32 - 512)
	self._maxScrollY = -(self._gridY * 32 - 256)

	self._mainGrid = 1
	self._buildingGrid = 2
	self._entityGrid = 3
	self._aidGrid = 4
	self._collisionGrid = 5

	self._deckIndex = self._mainGrid

	self._mainGrid = mGrid:new(self._gridX, self._gridY, 32, "Game/LevelEditor/tileset_ground.png", 2)
	mGrid:setPos(self._mainGrid, 32, 32)

	self._buildingGrid = mGrid:new(self._gridX, self._gridY, 32, "Game/LevelEditor/editor_building_tiles.png", 9)
	mGrid:setPos(self._buildingGrid, 32, 32)

	self._entityGrid=mGrid:new(self._gridX, self._gridY, 32, "Game/LevelEditor/editor_entity_tiles.png", 11)
	mGrid:setPos(self._entityGrid, 64, 128)

	self._aidGrid=mGrid:new(self._gridX, self._gridY, 32, "Game/LevelEditor/grid_overlay.png", 1)
	mGrid:setPos(self._aidGrid, 96, 256)

	self._collisionGrid=mGrid:new(self._gridX, self._gridY, 32, "Game/LevelEditor/collision_sprite.png", 1)
	mGrid:setPos(self._collisionGrid, 32, 32)

	print(" ========================================================== ")
	print(" ========================================================== ")
	print(" =========== CREATING LD GRIDS ============================= ")
	print(" Main grid: "..self._mainGrid.." Building Grid: "..self._buildingGrid.." Entity Grid: "..self._entityGrid.." \n  aid Grid: "..self._aidGrid.. " Collision Grid: "..self._collisionGrid.."")

	self._EditingLevel = 1

	self._fileName = "test_lEditor_1"
	self._state = true
	self._emptyTile = 11

	--[[
		Possible editing modes:
		EDIT - place tiles on all 3 levels
		DEL - cannot place tiles, but will remove buildings
		MAP - scroll map
	]]
	self._editMode = "EDIT"

	if Game.lastState == 5 then
		self:loadAndReset("temp_test_map022701227")
	end


end

function lEditor:setLevel(_value)
	self._EditingLevel = _value
	
	
end

function lEditor:incIndex( )
	self._deckIndex = self._deckIndex + 1
	lEditor:displayCurrentTile( )
end

function lEditor:setIndex(_value)
	self._deckIndex = _value
end

function lEditor:decIndex( )
	self._deckIndex = self._deckIndex - 1
	lEditor:displayCurrentTile( )
end

function lEditor:displayCurrentTile( )
	mGrid:updateTile(self._aidGrid, 1, 1, self._deckIndex)
end

function lEditor:update( )
	local tbLen = mGrid:returnNrGrids( )

	for i = 1, tbLen do 
		mGrid:setPos2(i, lEditor.offX, lEditor.offY)
	end
	mGrid:setPos(self._aidGrid, 0, 0)

	map.offX = lEditor.offX
	map.offY = lEditor.offY

	interface:_leditor_updateViews( )
end

function lEditor:updateScreen(_x, _y)
	print("UPDATING SCREEN")
	lEditor.offX = lEditor.offX + _x
	lEditor.offY = lEditor.offY + _y

	--[[if lEditor.offX >= self._minScrollX then lEditor.offX = self._minScrollX end
	if lEditor.offX <= self._maxScrollX then lEditor.offX = self._maxScrollX end

	if lEditor.offY >= self._minScrollY then lEditor.offY = self._minScrollY end
	if lEditor.offY <= self._maxScrollY then lEditor.offY = self._maxScrollY end--]]


end

function lEditor:updateAidDeckTexture( )
	if self._EditingLevel == 1 then
		mGrid:setDeck(self._aidGrid, 1, 32)
	elseif self._EditingLevel == 2 then
		mGrid:setDeck(self._aidGrid, 2, 32)
	else
		mGrid:setDeck(self._aidGrid, 3, 32)
	end
end

function lEditor:updateTile(_x, _y, _optional)
	if _optional == nil then
		mGrid:updateTile(self._EditingLevel, _x, _y, self._deckIndex)
	else
		mGrid:updateTile(self._EditingLevel, _x, _y, _optional)
	end
end

function lEditor:touchpressed( )

	if self._state == true then
		print("TRUE....")
		if self._editMode == "EDIT" then
			lEditor:updateTile(math.floor( (Game.mouseX-map.offX+map.gridSize) /map.gridSize), math.floor( (Game.mouseY-map.offY+map.gridSize) /map.gridSize), self._deckIndex)
		elseif self._editMode == "DEL" then
			lEditor:updateTile(math.floor( (Game.mouseX-map.offX+map.gridSize) /map.gridSize), math.floor( (Game.mouseY-map.offY+map.gridSize) /map.gridSize), self._emptyTile)
		else

		end
	else
		print("FALSE")
	end
end

-- we're just going to dump all _grid elements into a lua table and serialize it :)
function lEditor:dumpToTable(_name)
	local tb = mGrid:getLocalTable(1)
	local tb2 = mGrid:getLocalTable(2)
	local tb3 = mGrid:getLocalTable(3)
	local tb4 = mGrid:getLocalTable(5)

	print("DUMPING")
	local result = MOAIFileSystem.checkPathExists(pathToWrite.."player_map/")
	if result == false then
		MOAIFileSystem.affirmPath(pathToWrite.."player_map/")
	end
	table.save(tb,  pathToWrite.."player_map/".._name..".mig")
	table.save(tb2, pathToWrite.."player_map/".._name..".mib")
	table.save(tb3, pathToWrite.."player_map/".._name..".mie")
	table.save(tb4, pathToWrite.."player_map/".._name..".mic")

	
end

function lEditor:saveAndTest( )
	local tb = mGrid:getLocalTable(1)
	local tb2 = mGrid:getLocalTable(2)
	local tb3 = mGrid:getLocalTable(3)
	local tb4 = mGrid:getLocalTable(5)
	print("DUMPING")
	local result = MOAIFileSystem.checkPathExists(pathToWrite.."player_map/")
	if result == false then
		MOAIFileSystem.affirmPath(pathToWrite.."player_map/")
	end
	print('checkPathExists: 1:>> ', MOAIFileSystem.checkPathExists (pathToWrite.."player_map/")  )
	print('checkPathExists: 2:>> ', MOAIFileSystem.checkPathExists (pathToWrite.."player_map/")  )
	print('checkPathExists: 3:>> ', MOAIFileSystem.checkPathExists (pathToWrite.."player_map/")  )
	print('+ checkPathExists: 4:>> ', MOAIFileSystem.checkPathExists (pathToWrite) )

	table.save(tb,  pathToWrite.."player_map/temp_test_map022701227.mig")
	table.save(tb2, pathToWrite.."player_map/temp_test_map022701227.mib")
	table.save(tb3, pathToWrite.."player_map/temp_test_map022701227.mie")
	table.save(tb4, pathToWrite.."player_map/temp_test_map022701227.mic")

	print("22222 PATH IS: "..pathToWrite.."player_map/")
	print("TABLE DUMPED")
end

function lEditor:destroyAll( )
	mGrid:destroy(self._collisionGrid)
	mGrid:destroy(self._aidGrid)
	mGrid:destroy(self._entityGrid)
	mGrid:destroy(self._buildingGrid)
	mGrid:destroy(self._mainGrid)
end
function lEditor:setGridSize(_sx, _sy)
	self._gridX = _sx
	self._gridY = _sy

	self._minScrollX = 64
	self._minScrollY = 64

	self._maxScrollX = -(self._gridX * 32 - 512)
	self._maxScrollY = -(self._gridY * 32 - 256)
	
	--[[mGrid:destroy(self._collisionGrid)
	mGrid:destroy(self._aidGrid)
	mGrid:destroy(self._entityGrid)
	mGrid:destroy(self._buildingGrid)
	mGrid:destroy(self._mainGrid)--]]
	mGrid:_debugDestroyAll( )
	
	self._mainGrid=mGrid:new(self._gridX, self._gridY, 32, "Game/LevelEditor/tileset_ground.png", 2)
	mGrid:setPos(self._mainGrid, 32, 32)

	self._buildingGrid=mGrid:new(self._gridX, self._gridY, 32, "Game/LevelEditor/editor_building_tiles.png", 9)
	mGrid:setPos(self._buildingGrid, 32, 32)

	self._entityGrid=mGrid:new(self._gridX, self._gridY, 32, "Game/LevelEditor/editor_entity_tiles.png", 11)
	mGrid:setPos(self._entityGrid, 32, 32)

	self._aidGrid=mGrid:new(self._gridX, self._gridY, 32, "Game/LevelEditor/grid_overlay.png", 1)
	mGrid:setPos(self._aidGrid, 32,32)	

	self._collisionGrid=mGrid:new(self._gridX, self._gridY, 32, "Game/LevelEditor/collision_sprite.png", 1)
	mGrid:setPos(self._collisionGrid, 32, 32)

	lEditor:updateScreen(1, 1)
end

function lEditor:loadAndReset(_file)
	local tb = table.load(pathToWrite.."player_map/".._file..".mig")
	local tb2 = table.load(pathToWrite.."player_map/".._file..".mib")
	local tb3 = table.load(pathToWrite.."player_map/".._file..".mie")
	local tb4 = table.load(pathToWrite.."player_map/".._file..".mic")
	lEditor:setGridSize(#tb, #tb[#tb])

	lEditor:setLevel(1)
	for x = 1, #tb do
		for y = 1, #tb[x] do
			lEditor:updateTile(x, y, tb[x][y])
		end
	end


	lEditor:setLevel(2)
	for x = 1, #tb2 do
		for y = 1, #tb2[x] do
			lEditor:updateTile(x, y, tb2[x][y])
		end
	end

	lEditor:setLevel(3)
	for x = 1, #tb3 do
		for y = 1, #tb3[x] do
			lEditor:updateTile(x, y, tb3[x][y])
		end
	end


	lEditor:setLevel(5)
	for x = 1, #tb4 do
		for y = 1, #tb4[x] do
			lEditor:updateTile(x, y, tb4[x][y])
		end
	end
	print("REACHED HERE LEVEL 1")
end

function lEditor:setTouchState(_state)
	self._state = _state
end

function lEditor:setEditMode(_mode)
	self._editMode = _mode
	if self._editMode == "EDIT" then
		anim:setState(cursor_anim, "NORMAL_CURSOR")
	elseif self._editMode == "SCROLL" then

	else
		anim:setState(cursor_anim, "DEL_CURSOR")
	end
end

function lEditor:getEditMode( )
	return self._editMode 
end


function lEditor:touchpressed2( )
	if self._editMode == "SCROLL" then
		print("PRINTING")
		MouseDown = true
		camera:setJoystickVisible( )
		print("FREAKING PRESSE")
	end
end

function lEditor:touchreleased( )
	print("FREAKING RELEASED")
	MouseDown = false	
	camera:setJoystickHidden( )
end