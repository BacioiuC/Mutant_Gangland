map = {}

map.offX = 32
map.offY = 32
map.gridSize = 32

-- minus 1073741824

map.Ground = 1073741825
map.Ground2 = 1073741826
map.GroundDamaged = 1073741834
map.Swamp1 = 1073741835
map.Swamp2 = 1073741847

map.Forest = 1073741833
map.Forest2 = 1073741833

map.Road1 = 1073741827
map.Road2 = 1073741828
map.Road3 = 1073741829
map.Road4 = 1073741831
map.Road5 = 1073741832

colGridLayer = 2
function map:getDefenseValue(_x, _y)
	local tile = mGrid:getTile(self._mainGrid, _x, _y)
	if tile == map.Ground then
		return 10
	elseif tile == map.Ground2 then
		return 10
	elseif tile == map.GroundDamaged then
		return 5
	elseif tile == map.Swamp1 then
		return -20
	elseif tile == map.Swamp2 then
		return - 20
	elseif tile == map.Forest then
		return 40
	elseif tile == map.Forest2 then
		return 40
	elseif tile == map.Road1 then
		return 20
	elseif tile == map.Road2 then
		return 20
	elseif tile == map.Road3 then
		return 20
	elseif tile == map.Road4 then
		return 20
	elseif tile == map.Road5 then
		return 20
	else
		return 1
	end
end

function map:init( )

	self._initShake = false
	self._shakeTimer = Game.worldTimer
	self._shakeInterval = 2.2

	self._rightOffsetMax = { }
	self._rightOffsetMax[1] = { x = 608, y = 352 }
	self._rightOffsetMax[2] = { x = 268, y = 128 }
	self._rightOffsetMax[3] = { x = 148, y = 128 }

	self._corner = {}

	self._baseTable = {}
	self._mainGrid = 1
	self._buildingGrid = 2
	self._collisionGridDebug = 3

	self._tileSize = 32

	self._mapSizeX = 99
	self._mapSizeY = 99

	self._deckIndex = 1 -- level deck

	self._tileMovementCost = 1

	self._globalMapScroll = false
	map.targetLocX = map.offX
	map.targetLocY = map.offY
	map.oldX = map.offX
	map.oldY = map.offY

	self._mapScrollDelay = 0.9
	self._startDelay = false

	self._scrollVarRes = { }
	self._scrollVarRes[1] = { x = -224, y = 108 }
	self._scrollVarRes[2] = { x = 256, y = 128 }
	self._scrollVarRes[3] = { x = 512, y = 255 }


	self._teamToPlayer = {} -- basically, calls player1 or 2 based on turn
	self._teamToPlayer[1] = player1
	self._teamToPlayer[2] = player2
end



function map:getTileCost(_x, _y)
	local tile = mGrid:getTile(self._mainGrid, _x, _y)

	if tile == map.Ground then
		return 2
	elseif tile == map.Forest then
		return 8
	elseif tile == map.Road1 then
		return 1
	elseif tile == map.Road2 then
		return 1
	elseif tile == map.Road3 then
		return 1
	elseif tile == map.Road4 then
		return 1
	elseif tile == map.Road5 then
		return 1
	elseif tile == map.Road6 then
		return 1
	elseif tile == map.Road7 then
		return 1
	elseif tile == map.Road8 then
		return 2
	else
		return 2
	end	
end

function map:returnSize( )
	return self._mapSizeX, self._mapSizeY
end

function map:initAP (_mapToLoad)
	mGrid:_debugDestroyAll( )


	self._mainGrid = mGrid:new(self._mapSizeX, self._mapSizeY, self._tileSize, "Game/media/"..Game.tileset.."", 2 )
	--self._mainGrid = mGrid:new2(self._mapSizeX, self._mapSizeY, 34/160, 34/256, 1/160, 1/256, 32/160, 32/256 , "Game/media/"..Game.tileset.."", 2 )
	self._buildingGrid = mGrid:new(self._mapSizeX, self._mapSizeY, self._tileSize, "Game/media/editor_building_tiles.png", 9)
	mGrid:setPos(self._mainGrid, self._tileSize, self._tileSize)
	mGrid:setPos(self._buildingGrid, self._tileSize, self._tileSize)
	--map:_addCollisionInMiddle( )
	mGrid:new(self._mapSizeX, self._mapSizeY, self._tileSize, "Game/media/grid_overlay.png", 3, nil, colGridLayer)
	mGrid:setPos(self._collisionGridDebug, self._tileSize, self._tileSize)

	if _mapToLoad ~= nil then
		map:loadAndReset(_mapToLoad)
	else
	 	map:loadAndReset("lv_3")
	end

end

function map:getSize( )
	return self._mapSizeX, self._mapSizeY
end


function map:_addCollisionInMiddle( )
	for i = 1, 40 do
		local _x = math.random( 4, 19 )
		local _y = math.random( 4, 13 )
		mGrid:updateTile(self._mainGrid, _x, _y, math.random(2,4)) -- debug path test
	end
	--mGrid:updateTile(self._mainGrid, 3, 2, 2)

end

function map:_resetMap( )
	for x = 1, self._mapSizeX do
		for y = 1, self._mapSizeY do
			mGrid:updateTile(self._mainGrid, x, y, 1)
		end
	end
end


function map:update( )

	map:_updateShake( )
	--if map.offY < 16 then map.offY = 16 end

	--if map.offX + self._mapSizeX * 32 > self._mapSizeX * 32 + 32 then map.offX = 32 + self._mapSizeX * 32 end
	--if map.offY + self._mapSizeY * 32 > self._mapSizeY * 32 + 16 then map.offY = 16 + self._mapSizeY * 32 end

	mGrid:setPos(self._mainGrid, map.offX , map.offY )
	mGrid:setPos(self._buildingGrid, map.offX , map.offY )

	----print("OFFX: "..map.offX.."")
	----print("OFFY: "..map.offY.."")
	local sox, soy = camera:returnOffset( )
	
	mGrid:setPos(self._collisionGridDebug, map.offX, map.offY)
	if self._globalMapScroll == false then
		----print("UNITS SHOULD MOVE")
	end
end



function map:setOffset(_x, _y)
	map.offX = _x
	map.offY = _y
end

function map:shake(_int, _int2, _dur)
	if self._initShake == false then
		self._oldOffX = map.offX
		self._oldOffY = map.offY
		self._shakeTimer = Game.worldTimer
		self._initShake = true
		self._int = _int
		self._duration = _dur
	--else

	end
end

function map:_updateShake( )
	if self._initShake == true then
		local dur
		if self._duration ~= nil then
			dur = self._duration
		else
			dur = 0.2
		end
		if Game.worldTimer <= self._shakeTimer + dur then
			map.offX = math.random(self._oldOffX - self._int, self._oldOffX + self._int)
			map.offY = math.random(self._oldOffY - self._int, self._oldOffY + self._int)
			print("THIS SHAKE")

		else
			self._initShake = false
			map.offX = self._oldOffX
			map.offY = self._oldOffY
			interface:setTargetAtLoc(2000, 200000)
		end
	end
end
function map:recordOffset( )
	self._recX = map.offX
	self._recY = map.offY
end

function map:returnOldOffset( )
	map.offX = self._recX
	map.offY = self._recY
	--self:setScreen(self._recX, self._recY)
end

function map:updateScreen(_x, _y)
	map.offX = map.offX + _x
	map.offY = map.offY + _y 

	--if map.offX + _x + self._mapSizeX * 32 > self._mapSizeX * 32 + 32 then map.offX = 32 end
	--if map.offY + _y + self._mapSizeY * 32 > self._mapSizeY * 32 + 16 then map.offY = 16 end
	--if map.offX + _x + self._mapSizeX * 32 < - 64 then map.offX = -32 end

	
	

	local leScale = interface:_getScale( )

	if self._mapSizeX > 18 then
		if map.offX + _x > 32 then map.offX = 32 end
		local maxR = self._rightOffsetMax[leScale].x
		if map.offX + _x < -( self._mapSizeX * 32 - maxR) then map.offX = -( self._mapSizeX * 32 - maxR ) end
	end

	if self._mapSizeY > 11 then
		if map.offY + _y > 72 then map.offY = 72 end
		local mayR = self._rightOffsetMax[leScale].y
		if map.offY + _y < -( self._mapSizeY * 32 - mayR) then map.offY = -( self._mapSizeY * 32 - mayR ) end
	end
	--if map.offX + _x < -32 then map.offX = self._mapSizeX * 32 - 64 end

	--print("map.offX + _x:" ..(map.offX + _x).."" )
	--print("map.offY + _y: "..(map.offY + _y).."" )

end

function map:setScreen(_x, _y)
	map.targetLocX = map.offX - _x + resX/2.5 + self._scrollVarRes[1].x
	map.targetLocY = map.offY - _y + resY/4 + self._scrollVarRes[1].y

	local leScale = interface:_getScale( )
	if map.targetLocX > 32 then map.targetLocX = 32 end
	local maxR = self._rightOffsetMax[leScale].x
	if map.targetLocX < -( self._mapSizeX * 32 - maxR) then map.targetLocX = -( self._mapSizeX * 32 - maxR ) end

	if map.targetLocY > 158 then map.targetLocY = 158 end
	local mayR = self._rightOffsetMax[leScale].y
	if map.targetLocY < -( self._mapSizeY * 32 - mayR) then map.targetLocY = -( self._mapSizeY * 32 - mayR ) end	 
end

function map:scroll( )

	local map_tx = map.targetLocX
	local map_ty = map.targetLocY

	map:tweenPos(map_tx, map_ty)

	if math.aprox(map.offY, map.targetLocY, 0.01) == true and math.aprox(map.offX, map.targetLocX, 0.01) == true then
		self._globalMapScroll = false
		print("STILL FALSE!")
	else
		self._globalMapScroll = true
		print("STILL TRUE!")
	end
	--print("MAP.offX "..map.offX.." | TargetX: "..map.targetLocX.."")
	--print("MAP.offY "..map.offY.." | TargetY: "..map.targetLocY.."")
end

function map:tweenPos(_twX, _twY, _optionalTime)

	--Tweening x = x + (target -x) *0.1
	local tTime
	if _optionalTime ~= nil then
		tTime = _optionalTime
	else
		tTime = 0.125
	end
	local newX = 0
	local newY = 0
	map.offX = map.offX + (_twX - map.offX ) * tTime
	map.offY = map.offY + (_twY - map.offY ) * tTime

	--[[if map.offX > _twX then map.offX = map.offX - 9 end
	if map.offX < _twX then map.offX = map.offX + 9 end

	if map.offY > _twY then map.offY = map.offY - 9 end
	if map.offY < _twY then map.offY = map.offY + 9 end--]]
	--local dist1 = math.dist(map.offX, map.offY, map.targetLocX, map.targetLocY)
	--print("DISTANCE IS: "..dist1.."")

end

function map:getScrollStatus( )
	return self._globalMapScroll
end

function map:returnOffset( )
	return map.offX, map.offY
end


function map:_initFogOfWar( )
	--[[
		how to fog of war:
		- get turn. check if player[ofturn] = "human".
		loop through building lists. if buildings lists.team = turn then do not fog of war
		loop through unit lists. if unit list.team = true nthen do not fog of war
		everything else? FOG IT!

	]]

	
	if Game.globalFogOfWar == true then
		mGrid:setAllTilesTo(self._collisionGridDebug, 2)
	end



end

function map:_updateFogOfWar( )
	local turn = unit:_returnTurn( )
	local name = self._teamToPlayer[turn].name

	local buildingList = building:_returnBuildingTable( )
	local unitList = unit:_returnTable( )
	local fogOfWarTable = { }
	
	if Game.globalFogOfWar == true then
	--if name ~= "Computer" then
		mGrid:setAllTilesTo(self._collisionGridDebug, 2)
	
		for i,v in ipairs(buildingList) do
			if v.team ~= 0 and self._teamToPlayer[v.team].name ~= "Computer" then
				for range = -1, 1 do
					for rangeY = -1, 1 do
						local distCheck = math.dist(v.x, v.y, v.x-range, v.y-rangeY)
						if distCheck <= 1 then
							mGrid:setTiles3(self._collisionGridDebug, v.x-range, v.y-rangeY, 3)
							--print("TILE VALUE: "..mGrid:getTile(self._collisionGridDebug, v.x-range, v.y-rangeY))
						end
					end
				end
			end
		end


		for i,v in ipairs(unitList) do
			if self._teamToPlayer[v.team].name ~= "Computer" then
				for range = -v.range, v.range do
					for rangeY = -v.range, v.range do
						local distCheck = math.dist(v.x, v.y, v.x-range, v.y-rangeY)
						if distCheck <= v.range then
							mGrid:setTiles3(self._collisionGridDebug, v.x-range, v.y-rangeY, 3)
						end
					end
				end
			end
		end
	end
end

function map:_disableFogOfWar( )
	mGrid:setAllTilesTo(self._collisionGridDebug, 3)
end

function map:updateTile(_x, _y, _optional)
	if _optional == nil then
		mGrid:updateTile(self._deckIndex, _x, _y, self._deckIndex)
	else
		mGrid:updateTile(self._deckIndex, _x, _y, _optional)
	end
end

-- we're just going to dump all _grid elements into a lua table and serialize it :)
function map:dumpToTable(_name)
	local tb = mGrid:getLocalTable(1)
	table.save(tb, "map/".._name..".col")
end

function map:loadMap(_file)
	--if _file == "temp_test_map022701227" then

	--else
		local tb = table.load("map/".._file..".mig")
	--end
end

function map:returnBaseTable( )
	return self._baseTable
end



function map:generateCollision(_table)
	self._collisionGrid = {}
	for x = 1, #_table do
		self._collisionGrid[x] = {}
		for y = 1, #_table[x] do
			if _table[x][y] == 1073741826 then
				self._collisionGrid[x][y] = 0
			else
				self._collisionGrid[x][y] = 1
			end
		end
	end

	--Game:initPathfinding(self._collisionGrid)
	return self._collisionGrid
end

function map:returnCollisionGrid( )
	return self._collisionGrid
end

function map:setLevel(_value)
	self._EditingLevel = _value
	self._deckIndex = _value
	--map:updateAidDeckTexture( )
end

function map:destroyAll( )

	mGrid:destroy(self._collisionGridDebug )
	mGrid:destroy(self._buildingGrid)
	mGrid:destroy(self._mainGrid)
	--mGrid:_debugDestroyAll( )
end

function map:setGridSize(_sx, _sy, _tileSet)
	self._mapSizeX = _sx
	self._mapSizeY = _sy

	self._minScrollX = 64
	self._minScrollY = 64

	--self._maxScrollX = -(self._gridX * 32 - 512)
	--self._maxScrollY = -(self._gridY * 32 - 256)
	
	--mGrid:destroy(self._collisionGridDebug)
	--mGrid:destroy(self._buildingGrid)
	--mGrid:destroy(self._mainGrid)
	map:destroyAll( )
	mGrid:new(self._mapSizeX, self._mapSizeY, 32, _tileSet, 1)
	mGrid:setPos(self._mainGrid, 0, 0)

	mGrid:new(self._mapSizeX, self._mapSizeY, 32, "Game/LevelEditor/editor_building_tiles.png", 9)
	mGrid:setPos(self._buildingGrid, 0, 0)

	mGrid:new(self._mapSizeX, self._mapSizeY, self._tileSize, "Game/media/grid_overlay.png", 3, nil, colGridLayer)
	mGrid:setPos(self._collisionGridDebug, 0, 0)
	map:updateScreen(1, 1)


end
function map:loadAndReset(_file)
	local tb
	local tb2
	local tb3
	if _file == "temp_test_map022701227" then
		tb = table.load(pathToWrite.."player_map/".._file..".mig")
		tb2 = table.load(pathToWrite.."player_map/".._file..".mib")
		tb3 = table.load(pathToWrite.."player_map/".._file..".mic")
	else
		local pathCat = interface:_returnPathCategory( )
		tb = table.load(""..pathCat.map.."/".._file..".mig")
		tb2 = table.load(""..pathCat.map.."/".._file..".mib")
		tb3 = table.load(""..pathCat.map.."/".._file..".mic")
	end

	interface:_setUpCategories( )
	local tileSet = "Game/LevelEditor/"..Game.tileset..""
	local pathCat = interface:_returnPathCategory( )
	if pathCat == nil then
		pathCat = { }
		pathCat.map = "player_map/"
	end

	print("FILE SHOULD BE: /"..pathCat.map.."/".._file..".png")
	local result = MOAIFileSystem.checkFileExists(""..pathCat.map.."/".._file..".png")
	if result == true then
		tileSet = ""..pathCat.map.."/".._file..".png"
	else
		print("EGHH EGH EGH EGH WRONG!!!!!")
		print("EGHH EGH EGH EGH WRONG!!!!!")
		print("EGHH EGH EGH EGH WRONG!!!!!")
		print("EGHH EGH EGH EGH WRONG!!!!!")
		print("EGHH EGH EGH EGH WRONG!!!!!")
		print("EGHH EGH EGH EGH WRONG!!!!!")
		print("EGHH EGH EGH EGH WRONG!!!!!")
		print("EGHH EGH EGH EGH WRONG!!!!!")
		print("EGHH EGH EGH EGH WRONG!!!!!")
		print("EGHH EGH EGH EGH WRONG!!!!!")
		print("EGHH EGH EGH EGH WRONG!!!!!")
	end
	map:setGridSize(#tb, #tb[#tb], tileSet)

	map:setLevel(1)
	for x = 1, #tb do
		for y = 1, #tb[x] do
			map:updateTile(x, y, tb[x][y])
		end
	end


	_tab = mGrid:getLocalTable(self._buildingGrid)
	
	_collGrid = map:generateCollision(tb3)
	
	

	Game.grid = mGrid:transformTableForJumper(tb3)
	local debugGrid = mGrid:transformTableForJumper(tb3)
	--for x = 1, #tb3 do
	--	for y = 1, #tb3[x] do
			--if tb3[x][y] == 1 then
			--map:updateTile(x, y, tb3[x][y])
			--else
	--mGrid:setTiles2(self._collisionGridDebug, debugGrid)
	--for x = 1, #_collGrid do
	--	for y = 1, #_collGrid[x] do
			----print("VALUE: ".._collGrid[x][y].."")
	--	end
	--end

		--end

--	end

	Game:initPathfinding( Game.grid )
	--[[map:setLevel(2)
	for x = 1, #tb2 do
		for y = 1, #tb2[x] do
			map:updateTile(x, y, tb2[x][y])
		end
	end--]]

	self:_initFogOfWar( )
end