worldMap = {}

worldMap.offX = 0
worldMap.offY = 0
map.offX = 64
map.offY = 64
worldMap.gridSize = 32

require "Game.worldMap.buildings"



function worldMap:init( )
	self._influenceTable = {}
	self._radius = 1
	self._decay = 0.5

	self._gridX = 30
	self._gridY = 30

	self._deckIndex = 1

	self._worldMap = mGrid:new(self._gridX, self._gridY, 32, "Game/worldMap/editor_tiles2.png", 1)
	mGrid:setPos(self._worldMap, 32, 32)

	

	self._minScrollX = 64
	self._minScrollY = 64

	self._maxScrollX = -(self._gridX * 32 - 256)
	self._maxScrollY = -(self._gridY * 32 - 128)

	wmBuildings:init( )

	worldMap:load("worldmap")
	
	self._touchState = false

	
	info:init( )
	info:new(1, "Commander! I am Apul, you don't pay us sir! TEST \n SOME MORE TEST TEST TEST TEST \n LOL TEST")
	info:new(2, "Commander! I am Apul, you don't pay us sir! TEST \n SOME MORE TEST TEST TEST TEST \n LOL TEST")
	
end

function worldMap:getGridSize( )
	return self._gridX, self._gridY
end

function worldMap:touchlocation(_x, _y)

	wmBuildings:touchlocation(_x, _y)
end

function worldMap:touchpressed( )
	MouseDown = true
	camera:setJoystickVisible( )


end

function worldMap:touchreleased( )
	MouseDown = false	
	camera:setJoystickHidden( )
	if self:getTouchState( ) == false then
		wmBuildings:touchpressed( )
	end
end

function worldMap:loop( ) -- all stuff loop in here
	self:update( )
	interface:_loopWorldMapStuff( )
	interface:updateInLoop( )
	info:update( )
end

function worldMap:update( )
	local tbLen = mGrid:returnNrGrids( )

	for i = 1, tbLen do 
		mGrid:setPos(i, worldMap.offX, worldMap.offY)
	end
	--mGrid:setPos(self._aidGrid, 0, 0)

	map.offX = worldMap.offX
	map.offY = worldMap.offY
	wmBuildings:update(map.offX, map.offY)
end

function worldMap:updateScreen(_x, _y)
	worldMap.offX = worldMap.offX + _x
	worldMap.offY = worldMap.offY + _y

	if worldMap.offX >= self._minScrollX then worldMap.offX = self._minScrollX end
	if worldMap.offX <= self._maxScrollX then worldMap.offX = self._maxScrollX end

	if worldMap.offY >= self._minScrollY then worldMap.offY = self._minScrollY end
	if worldMap.offY <= self._maxScrollY then worldMap.offY = self._maxScrollY end


end

function worldMap:load(_file)
	
	local tb = table.load("Game/worldMap/map/".._file..".mig")
	local tb3 = table.load("Game/worldMap/map/".._file..".mic")
	--local tb2 = table.load("Game/worldMap/map/".._file..".mib")
	self:setGridSize(#tb, #tb[#tb])

	self._influenceTable = {}
	for x = 1, #tb do
		self._influenceTable[x] = {}
		for y = 1, #tb[x] do
			self._influenceTable[x][y] = 0
			--print("X: "..x.." Y: "..y.."")
			worldMap:updateTile(self._worldMap, x, y, tb[x][y])
		end
	end

	wmBuildings:_addBuildings(_file)

	if Game.victor ~= nil then
		wmBuildings:setOwnership(2, Game.victor)
	end


	-- col grid
	_collGrid = map:generateCollision(tb3)
	Game.grid = mGrid:transformTableForJumper(_collGrid)
	Game:initPathfinding( Game.grid )
	--self:calculateInfluence( )
end

function worldMap:setInfluenceAt(_x, _y, _value)
	self._influenceTable[_x][_y] = _value
end

function worldMap:getInfluenceAt(_x, _y)
	--print("VAL X: "..#self._influenceTable.." VAL Y: "..#self._influenceTable[#self._influenceTable].."")
	return self._influenceTable[_x][_y]

end

function worldMap:calculateInfluence( )
--[[
for (y = 0; y < height; ++y) {
    for (x = 0; x < width; ++x) {
        total = 0
            for (ky = -radius; ky <= radius; ++ky)
                for (kx = -radius; kx <= radius; ++kx)
                    total += source(x + kx, y + ky)
            dest(x, y) = total / (radius * 2 + 1) ^ 2  
        }
    }
]]
	local radius = self._radius
	for x = 1, #self._influenceTable do
		for y = 1, #self._influenceTable[x] do
			local total = 0
			for kx = -radius, radius do
				for ky = -radius, radius do
					if x+kx <= #self._influenceTable and x+kx >= 1 then
						if y+ky <= #self._influenceTable[#self._influenceTable] and y+ky >= 1 then
							total = self:getInfluenceAt(x, y)-kx*0.5
							self:setInfluenceAt(x+kx, y+ky, total)
						end
					end
				end
				local dest = total
				
			end
		end
	end

end

function worldMap:influenceTest( )
	local influenceVar = self:getInfluenceAt(self._msx, self._msy)
	print("INFLUENCE AT "..self._msx.. " | "..self._msy.."  is "..influenceVar.."")
end

function worldMap:destroy( )
	mGrid:destroy(self._worldMap)
	wmBuildings:destroy( )
end

function worldMap:setGridSize(_sx, _sy)
	self._gridX = _sx
	self._gridY = _sy

	self._minScrollX = 64
	self._minScrollY = 64

	self._maxScrollX = -(self._gridX * 32 - 256)
	self._maxScrollY = -(self._gridY * 32 - 128)
	
	mGrid:destroy(self._worldMap)

	self._worldMap = mGrid:new(self._gridX, self._gridY, 32, "Game/worldMap/editor_tiles2.png", 1)
	mGrid:setPos(self._worldMap, 32, 32)
end

function worldMap:updateTile(_grid, _x, _y, _optional)
	if _optional == nil then
		mGrid:updateTile(_grid, _x, _y, self._deckIndex)
	else
		mGrid:updateTile(_grid, _x, _y, _optional)
	end
end

function worldMap:getTouchState( )
	return self._touchState
end

function worldMap:setTouchState(_state)
	self._touchState = _state
end