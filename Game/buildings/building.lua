

building = {}
function building:init(_mapFile)

	self._incomePlayers = { p1 = 0, p2 = 0 }


	self._bldTex = image:newTexture("Game/media/bld_hq.png", 1, "bld_hq")
	self._bldTex2 = image:newTexture("Game/media/bld_hq_t2.png", 1, "bld_hq_2")

	self._bldHqTex = image:newDeckTexture("Game/media/hq_png.png", 1, "HQ_TEX", 32, "NOT NILL")
	self._bldTownTex = anim:newDeck("Game/media/tileset_town.png", 48, 1 )
--image:newDeckTexture("Game/media/towns_png.png", 1, "town_tex", 32, "NOT NILL")

	self._hqNeutral = anim:newDeck("Game/media/tileset_building.png", 48, 1 )
	self._hqBlue = anim:newDeck("Game/media/player1_hq.png", 32, 1 )
	self._hqRed = anim:newDeck("Game/media/player2_hq.png", 32, 1 )
	self._roof = anim:newDeck("Game/media/tileset_building_roofs.png", 64, 5)
	self._roofTown = anim:newDeck("Game/media/tileset_town_roofs.png", 64, 5)


	self._incomGenAnimation = anim:newDeck("Game/media/incom_gen_anim.png", 64, 6)

	self._selectedBuilding = {}
	self._selectedColor = { r = 240, g = 15, b = 240, a = 1 }

	self._bldTexTable = {}
	self._bldTexTable[1] = self._bldTex
	self._bldTexTable[2] = self._bldTex2

	self._bldTable = {}

	self._hqTable = {}
	self._townTable = {}

	self._tileSize = 32
	self._offsetX = 0
	self._offsetY = 0
	
	self._hq = 1
	self._town = 2

	self._teamEdward = 0 -- 0, as in Neutral, as in Edwards gender! Get it? :D
	self._teamOne = 1
	self._teamTwo = 2

	self._occupiedCounter = 0

	self._player = {}
	self._player[1] = player1
	self._player[2] = player2

	self._transparencyRegular = 1
	self._transparencyWhenOverlap = 0.55
	self._currentTransparency = self._transparencyRegular

	--anim:createState("AVAILABLE", 1, 4, 0.04)
	
	anim:createState("BUILDING_CONQUERED", 5, 8, 0.07 )
	anim:createState("BUILDING_TOWN_DIDLE", 1, 1, 0.07)

	anim:createState("BUILDING_P2_IDLE", 1, 4, 0.2)
	anim:createState("BUILDING_P2_CAPTURE", 5, 8, 0.2)
	anim:createState("BUILDING_P2_USED", 25, 25, 0.1)
	anim:createState("BUILDING_P1_IDLE", 9, 12, 0.2)
	anim:createState("BUILDING_P1_CAPTURE", 13, 16, 0.2)
	anim:createState("BUILDING_P1_USED", 21, 21, 0.1)
	anim:createState("BUILDING_IDLE", 17, 20, 0.2 )

	self._usedState = {}
	self._usedState[1] = "BUILDING_P1_USED"
	self._usedState[2] = "BUILDING_P2_USED"

	self._idleState = {}
	self._idleState[1] = "BUILDING_P1_IDLE"
	self._idleState[2] = "BUILDING_P2_IDLE"

	self._hqTeam = {}
	self._hqTeam[1] = "BUILDING_IDLE"
	self._hqTeam[2] = "BUILDING_P1_IDLE"
	self._hqTeam[3] = "BUILDING_P2_IDLE"

	self._capturedTeam = {}
	self._capturedTeam[1] = "BUILDING_P1_CAPTURE"
	self._capturedTeam[2] = "BUILDING_P2_CAPTURE"

	self._captureAnimTown = { }
	self._captureAnimTown[1] = anim:newDeck("Game/media/town_captured_team1.png", 48, 6 )
	self._captureAnimTown[2] = anim:newDeck("Game/media/town_captured_team2.png", 48, 6 )

	self._captureAnimFactory = { }
	self._captureAnimFactory[1] = anim:newDeck("Game/media/hq_captured_team1.png", 48, 6 )
	self._captureAnimFactory[2] = anim:newDeck("Game/media/hq_captured_team2.png", 48, 6 )

	building:_addDebugBuildings(_mapFile)
end

function building:_addDebugBuildings(_mapFile)
	_NeutralHQ = 1073741825
	_PlayerHQ = 1073741826
	_EnemyHQ = 1073741827

	_NeutralTown = 1073741828
	_PlayerTown = 1073741829
	_EnemyTown = 1073741830

	local tb2 

	if _mapFile == "temp_test_map022701227" then 
		tb2 = table.load(pathToWrite.."player_map/".._mapFile..".mib")
	else
		interface:_setUpCategories( )
		local pathCat = interface:_returnPathCategory( )
		print("FRAKING PATH IS: "..pathCat.map.."/".._mapFile..".mib")

		tb2 = table.load(""..pathCat.map.."/".._mapFile..".mib")
	end

	for x = 1, #tb2 do
		for y = 1, #tb2[x] do
			local _tbValue = tb2[x][y]
			if _tbValue == _NeutralHQ then
				building:new(x, y, self._teamEdward, self._hq)
			elseif _tbValue == _PlayerHQ then
				building:new(x, y, self._teamOne, self._hq)
			elseif _tbValue == _EnemyHQ then
				building:new(x, y, self._teamTwo, self._hq)
			elseif _tbValue == _NeutralTown then
				building:new(x, y, self._teamEdward, self._town)
			elseif _tbValue == _PlayerTown then
				building:new(x, y, self._teamOne, self._town)
			elseif _tbValue == _EnemyTown then
				building:new(x, y, self._teamTwo, self._town)
			end
		end
	end

end

function building:_generateIncome(_turn)
	local counter = 0
	for i,v in ipairs(self._bldTable) do
		
		if v._type == 2 and v.canProduce == true then
			if unit:_returnTurn( ) == 1 and v.team == 2 then 
				player2.coins = player2.coins + v.gold + math.floor( (player2.incomeBonus / 100) )
				self._incomePlayers.p2 = self._incomePlayers.p2 + v.gold + math.floor( (player2.incomeBonus / 100) )
				local cash = effect:new("MONEY", v.x, v.y-1, self._incomGenAnimation, 12)
				effect:setSpeed(cash, 0.07)
				counter = counter + 1
			elseif unit:_returnTurn( ) == 2 and v.team == 1 then
				player1.coins = player1.coins + v.gold + math.floor( (player1.incomeBonus / 100) )
				self._incomePlayers.p1 = v.gold + self._incomePlayers.p1 + math.floor( (player1.incomeBonus / 100) )
				local cash = effect:new("MONEY", v.x, v.y-1, self._incomGenAnimation, 12 )
				effect:setSpeed(cash, 0.07)
				counter = counter + 1

			end
			v.canProduce = false

			if counter ~= 0 then
				if sound:isPlaying(sound.cash) == false then
					sound:play(sound.cash)
				end
			end
		end
	end
end

function building:_getLifetimeIncome( )
	return  self._incomePlayers
end

function building:new(_x, _y, _team, __type)
	local temp = {
		x = _x,
		y = _y,
		act_x = _x,
		act_y = _y,
		team = _team,
		_type =  __type, -- type 1 - HQ, type - 2 village
		canProduce = true,
		units = {}, -- going to get the unit list from else where
		gold = 15, -- produces 5 gold / turn,
		isSelected = false,
		occupied = false,
		transparency = 1,
	}

	if temp._type == 1 then
		temp.img = anim:newAnim(self._hqNeutral, 8, _x*32, _y*32, 1) --image:newDeckImage(self._bldHqTex, _x*32, _y*32, _team+1) --image:newImage(self._bldTexTable[_team], _x*32, _y*32)
		--temp.roof = anim:newAnim(self._roof, 8, _x*32, _y*32, 1)
	else
		temp.img = anim:newAnim(self._bldTownTex, 4, _x*32, _y*32, _team+1) --image:newDeckImage(self._bldTownTex, _x*32, _y*32, _team+1)
		--temp.roof = anim:newAnim(self._roofTown, 8, _x*32, _y*32, _team+1)
		--anim:setState(temp.img, "BUILDING_TOWN_DIDLE")
	end
	--temp.roof = image:newDeckImage(self._roof, _x*32, _y*32, _team+1)
	anim:setState(temp.img, self._hqTeam[_team+1])
	--anim:setState(temp.roof, self._hqTeam[_team+1])
	--anim:setSpeed(temp.roof, math.random(0.6, 2))
	table.insert(self._bldTable, temp)
end

function building:_draw(i)
	local v = self._bldTable[i]

	v.act_x = v.x * self._tileSize - self._tileSize+self._offsetX - 8
	v.act_y = v.y * self._tileSize - self._tileSize+self._offsetY - 16

	--self:_adjustTransparency(i)

	if v.isSelected == true then
	--	image:setColor(v.img.img, self._selectedColor.r, self._selectedColor.g, self._selectedColor.b, self._selectedColor.a)
	--	image:setColor(v.roof.img, self._selectedColor.r, self._selectedColor.g, self._selectedColor.b, self._selectedColor.a)
	elseif v.canProduce == false and v._type == 1 then
		--image:setColor(v.img.img, 200, 200, 200, 1)
		local team = v.team
		anim:setState(v.img, self._usedState[team] )
		--image:setColor(v.roof.img, 200, 200, 200, v.transparency)
		--anim:setState(v.roof, self._usedState[team])
	elseif v.team ~= 0 then
		local team = v.team
		anim:setState(v.img, self._idleState[team] )
		--anim:setState(v.roof, self._idleState[team])
	end

	--image:updateImage(v.img, v.act_x, v.act_y)
	--if v.roof ~= nil then
		--image:updateImage(v.roof, v.act_x, v.act_y)
	--end
	anim:updateAnim(v.img, v.act_x, v.act_y)
	--anim:updateAnim(v.roof, v.act_x, v.act_y)
end

function building:_adjustTransparency(_id)
	local unitTable = unit:_returnTable( )
	local b = self._bldTable[_id]
	if b._type == self._hq then
		b.transparency = self._transparencyRegular
		for i,v in ipairs(unitTable) do
			if v.x == b.x and v.y == b.y-1 then
				b.transparency = self._transparencyWhenOverlap 

			end
		end
	end
end

function building:update( )
	self._offsetX, self._offsetY = map:returnOffset( )
	for i,v in ipairs(self._bldTable) do
		building:_draw(i)
	end
end

function building:_getAtPos(_x, _y)
	local _building = nil
	for i,v in ipairs(self._bldTable) do
		if v.x == _x and v.y == _y then
			_building = i
		end
	end
	return _building
end


function building:_addSelected(_id)
	local v = self._bldTable[_id]
	local selNum = self:_getNumSelections( )
	if v ~= nil then
		self:_clearSelected( )
		v.isSelected = true
		table.insert(self._selectedBuilding, _id)
	else
	--	print("BUILDING SELECTED IS NIL")
	end
end

function building:_getNumSelections( )
	return #self._selectedBuilding 
end

function building:_clearSelected( )
	local selNum = self:_getNumSelections( )
		if selNum > 0 then
		local v = self._bldTable[ self._selectedBuilding[1] ]
		v.isSelected = false
		table.remove(self._selectedBuilding, 1)
	end

	self._selectedBuilding = {}
end

function building:clearSelected( )
	--if unit:_getTouchState( ) == true then
	building:_clearSelected( )
	--end

end

function building:selectBuilding(_x, _y)
	
	if (unit:returnEventType( ) == true and unit:_getTouchState( ) == true) or Game.cursorEnabled == true then
		
		local _building = self:_getAtPos(_x, _y)
		local v = self._bldTable[_building]


			if v ~= nil and v.team == unit:_returnTurn( )  and v.canProduce and v._type == 1 then
				self:_addSelected(_building)
				interface:setBuyMenu(true, v)
				interface:_update_buymenu_unitList( )
				--------------------------------
				--------------------------------
				---- SOUND HERE ----------------
				--sound:play(sound.menuSwipe)

				sound:play(sound.factorySel)
				---- SOUND HERE ----------------
				--------------------------------
				--------------------------------
				--building:createNewUnit(v)
			else
				interface:setBuyMenu(false)
			end
		unit:setEventType(false)

		return _building
	end

end

function building:createNewUnit(_building, _turn, _dp)
    local v = _building
    if v._type == 1 then
        if v.canProduce == true then

            local _unitType

            _unitType = _dp

            if _unitType ~= nil then
                local turn = unit:_returnTurn()

                local faction = self._player[_turn].team
                print("STEP ONE !!!!11111!!11!!")
                print("TURN IS: "..turn.."")

                if _turn == 2 then
                	if faction == 1 then
                		faction = 2
                	elseif faction == 2 then
                		faction = 1
                	end
                end
                print("FACTION IS: "..faction.."")
                print("COST SHOULD BE: "..unit_type[faction][_unitType].cost.."")
                if self._player[_turn].coins >= unit_type[faction][_unitType].cost then
                	print("STep 2222 2222")
                --------------------------------
                --------------------------------
                ---- SOUND HERE ----------------
                sound:play(sound.factoryProd)
                ---- SOUND HERE ----------------
                --------------------------------
                --------------------------------
                    unit:new(v.team, v.x, v.y, _unitType)
                    v.canProduce = false
                    self._player[_turn].coins = self._player[_turn].coins - unit_type[faction][_unitType].cost
                end
            end
        end
    end
end

function building:createUnits(_turn, _dp)
	local counter = 0
	for i,v in ipairs(self._bldTable) do
		if v.team == _turn and v._type == 1 and v.canProduce == true then
			if unit:isLocEmpty(v.x, v.y) == nil then --self:_checkIfHQSlotOccupied(v.x, v.y) == 0 then
				counter = counter + 1
				building:createNewUnit(v, _turn, _dp[counter])
			end
		end
	end
end

function building:_createUnits(_temple, _turn, _type)
	--local counter = 0
	--for i,v in ipairs(self._bldTable) do
		local v = _temple
		if v.team == _turn and v._type == 1 and v.canProduce == true then
			if unit:isLocEmpty(v.x, v.y) == nil then --self:_checkIfHQSlotOccupied(v.x, v.y) == 0 then
				--counter = counter + 1
				building:createNewUnit(v, _turn, _type)
			end
		end
	--end
end

function building:_checkIfHQSlotOccupied(_x, _y)
	local unitList = unit:_returnTable( )
	for i,v in ipairs(unitList) do
		if v.x == _x and v.y == _y then
			self._occupiedCounter = self._occupiedCounter + 1
		end
	end

	return self._occupiedCounter
end

function building:_isFactoryOccupied(_id)
	local unitList = unit:_returnTable( )
	local bld = self._bldTable[_id]
	local bool = false

	for i,v in ipairs(unitList) do
		if v.x == bld.x and v.y == bld.y then
			bool = true
		end
	end

	return bool
end

function building:_resetStats()
	for i,v in ipairs(self._bldTable) do
		v.canProduce = true
		
		self._occupiedCounter = 0
		building:_setCaptured(i)
	end
	--building:_generateIncome( )
end

function building:_getListOfOpposingHq( )
	for i,v in ipairs(self._bldTable) do
		if v.team ~= unit:_returnTurn( ) and v._type == 1 and v.occupied == false then
			table.insert(self._hqTable, v)
		end
	end

	return self._hqTable
end


function building:_getListOfTowns( )
	for i,v in ipairs(self._bldTable) do
		if v.team ~= unit:_returnTurn( ) and v._type == 2 and v.occupied == false then
			table.insert(self._townTable, v)
		end
	end

	return self._townTable
end

function building:_dropTownsAndHqTables( )
	self._townTable = {}
	self._hqTable = {}
end

function building:_dropAll( )
	for i,v in ipairs(self._bldTable) do
		image:removeProp(v.img, 1)
	end

	self._bldTable = {}
end

function building:_returnBuildingTable( )
	return self._bldTable
end

function building:_returnRandomEnemyHq( )
	local bList = {}
	for i,v in ipairs(self._bldTable) do
		if v.team ~= unit:_returnTurn( ) then
			if v._type == 1 then
				table.insert(bList, v)
			end
		end
	end

	local sz = #bList
	local rnd = 1
	if sz >= 1 then
		rnd = math.random(1, sz)
	else
		rnd = 1
	end

	return bList[rnd]
end

function building:setVictory(_player)
	for i,v in ipairs(self._bldTable) do
		v.team = _player
	end
end