
wmBuildings = {}

function wmBuildings:init( )
	self._bTable = {}
	self._LevelList = {}
	self._LevelDesc = {}
	self._tileSize = 32
	self._hq = 1
	self._town = 2
	self._teamEdward = 0 -- 0, as in Neutral, as in Edwards gender! Get it? :D
	self._teamOne = 1
	self._teamTwo = 2

	self._bldHqTex = image:newDeckTexture("Game/media/hq_png.png", 1, "HQ_TEXwm", 32, "NOT NILL")
	--self._bldTownTex = image:newDeckTexture("Game/media/towns_png.png", 1, "town_texwm", 32, "NOT NILL")

	self._bldTownTex = anim:newDeck("Game/media/tileset_town.png", 64, 1 )--image:newDeckTexture("Game/media/towns_png.png", 1, "town_tex", 32, "NOT NILL")
	self._hqNeutral = anim:newDeck("Game/worldMap/tileset_building.png", 64, 1 )

	self._type = {}
	self._type[1] = self._bldHqTex
	self._type[2] = self._bldTownTex

	self:setLevelList( )
	self:setLevelDesc( )

	self._msx = 0
	self._msy = 0
	self.___msx = 0
	self.___msy = 0

	self._offsetX = 0
	self._offsetY = 0

	self._availableAnim_Tex = anim:newDeck("Game/worldMap/available_mission_animation.png", 48, g_ActionPhase_UI_Layer)

	--self._billboard_tex = anim:newDeck("Game/worldMap/billboard_build_unit_anim_pdn.png", 64, g_ActionPhase_UI_Layer) -- billboard.png
	--self._bilboard = anim:newAnim(self._billboard_tex, 15, 4, 4, 1)
	--self._billX = 9
	--self._billY = 1

	anim:createState("AVAILABLE", 1, 4, 0.04)
	anim:createState("MINE", 5, 8, 0.06)
	anim:createState("BAD_BUILDING", 9, 12, 0.04)
	anim:createState("EMPTY", 14, 15, 0.04)

	anim:createState("BUILDING_CONQUERED", 5, 8, 0.07 )
	anim:createState("BUILDING_TOWN_DIDLE", 1, 1, 0.07)

	anim:createState("BUILDING_P2_IDLE", 1, 4, 0.2)
	anim:createState("BUILDING_P2_CAPTURE", 5, 8, 0.04)
	anim:createState("BUILDING_P2_USED", 9, 12, 0.1)
	anim:createState("BUILDING_P1_IDLE", 13, 16, 0.2)
	anim:createState("BUILDING_P1_CAPTURE", 17, 20, 0.04)
	anim:createState("BUILDING_P1_USED", 25, 28, 0.1)
	anim:createState("BUILDING_IDLE", 21, 24, 0.2 )

	anim:createState("WELCOME_BILBOARD", 1, 4, 0.8)
	anim:createState("INFO_LOOP_BIL", 5, 12, 1)

	anim:createState("BUILD_UNIT", 1, 14, 0.3)
	anim:createState("ATTK_UNIT", 18, 45, 0.2)
	anim:createState("INTRO_STATE", 49, 61, 0.4)
	anim:createState("INFO_ANIM", 1, 45, 0.4 )

	--anim:setState(self._bilboard, "INTRO_STATE", "INFO_ANIM")

	self._hqTeam = {}
	self._hqTeam[1] = "BUILDING_IDLE"
	self._hqTeam[2] = "BUILDING_P1_IDLE"
	self._hqTeam[3] = "BUILDING_P2_IDLE"

	self._capturedTeam = {}
	self._capturedTeam[1] = "BUILDING_P1_CAPTURE"
	self._capturedTeam[2] = "BUILDING_P2_CAPTURE"

	self._buildingUnderAttack = nil --BUA

	self._hqIndexTable = {}
	self._hqIndexTable[1] = 1073741825
	self._hqIndexTable[2] = 1073741826
	self._hqIndexTable[3] = 1073741827

	self._townIndexTable = {}
	self._townIndexTable[1] = 1073741828
	self._townIndexTable[2] = 1073741829
	self._townIndexTable[3] = 1073741830

	self._distCheck = 8

	self._pBuildingList = {}
	self._turnUpdate = true


	--[[shark:init( )
	shark:new(7, 10)
	shark:new(14, 12)
	shark:new(18, 17)
	shark:new(25, 22)
	shark:new(17, 2)--]]
end

function wmBuildings:create(_x, _y, _team, _type)
	local temp = {
		x = _x,
		y = _y,
		act_x = _x,
		act_y = _y,
		team = _team+1,
		
		tp = _type,
		img = nil,
		unlcoked = false,
		--anim = anim:newAnim(self._availableAnim_Tex, 9, _x*32, _y*32, 1),
		bonus = 0,
	}
	if temp.tp == 1 then
		temp.img = anim:newAnim(self._hqNeutral, 8, _x*32, _y*32,  _team+1)

	else
		temp.img = anim:newAnim(self._bldTownTex, 4, _x*32, _y*32, _team+1) 
	end
	anim:setState(temp.img, self._hqTeam[_team+1])

	--[[if temp.team == 1 then
		anim:setState(temp.anim, "EMPTY")
	elseif temp.team == 2 then
		anim:setState(temp.anim, "MINE")
	elseif temp.team == 3 then
		anim:setState(temp.anim, "BAD_BUILDING")
	end--]]
	if #self._bTable <= 3 then

		temp.MapName = self._LevelList[#self._bTable+1]
	else
		temp.MapName = self._LevelList[math.random(1, 6)]
	end
	table.insert(self._bTable, temp)
end

function wmBuildings:generateUnlockedList( )
	-- get list owned by player
	for i,v in ipairs(self._bTable) do
		--[[if v.team == 1 then
			anim:setState(v.anim, "AVAILABLE")
		else--]]if v.team == 2 then
			--anim:setState(v.anim, "MINE")
			v.unlcoked = true
			--table.insert(self._pBuildingList, i)
		elseif v.team == 3 then
		--	anim:setState(v.anim, "BAD_BUILDING")
		end
	end

	--[[for k,j in ipairs(self._pBuildingList) do
		local b = self._bTable[j]
		for i,v in ipairs(self._bTable) do
			if math.dist(b.x, b.y, v.x, v.y) <= 4 and v.team ~= 2 then
				v.unlocked = true
				anim:setState(v.anim, "AVAILABLE")
			end
		end
	end--]]



end

function wmBuildings:update(_offX, _offY)
	self:turnUpdate( )
	self._offsetX = _offX
	self._offsetY = _offY
	self:_MouseToWorld( )
	for i,v in ipairs(self._bTable) do
		v.act_x = v.x * self._tileSize - self._tileSize+_offX - 16
		v.act_y = v.y * self._tileSize - self._tileSize+_offY - 32
		anim:updateAnim(v.img, v.act_x, v.act_y)
		--anim:updateAnim(v.anim, v.act_x+8, v.act_y+32)
	end
	--local bilX = self._billX * self._tileSize - self._tileSize+_offX
	--local bilY = self._billY * self._tileSize - self._tileSize+_offY
	--anim:updateAnim(self._bilboard, bilX, bilY )
--	shark:update(_offX, _offY)
end

function wmBuildings:setLevelList( )
	self._LevelList[1] = "stranded"
	self._LevelList[2] = "rulardeath"
	self._LevelList[3] = "firstfront"
	self._LevelList[4] = "valley"
	self._LevelList[5] = "valley"
	self._LevelList[6] = "turfwar"
end

function wmBuildings:setLevelDesc( )
	self._LevelDesc[1] = { " Lorem Ipsum Doloret sit amet! This is all I can remember from that description lol" }
	self._LevelDesc[2] = { " Lorem Ipsum Doloret sit amet! This is all I can remember from that description lol" }
	self._LevelDesc[3] = { " Lorem Ipsum Doloret sit amet! This is all I can remember from that description lol" }
	self._LevelDesc[4] = { " Lorem Ipsum Doloret sit amet! This is all I can remember from that description lol" }
	self._LevelDesc[5] = { " Lorem Ipsum Doloret sit amet! This is all I can remember from that description lol" }
	self._LevelDesc[6] = { " Lorem Ipsum Doloret sit amet! This is all I can remember from that description lol" }
end

function wmBuildings:_addBuildings(_mapFile)
	_EmptySpace = 1073741833
	_NeutralHQ = 1073741825
	_PlayerHQ = 1073741826
	_EnemyHQ = 1073741827

	_NeutralTown = 1073741828
	_PlayerTown = 1073741829
	_EnemyTown = 1073741830

	local tb2
	local result = MOAIFileSystem.checkPathExists(pathToWrite.."saveFile/")
	
	if result == false then
		print("SO DOES: "..pathToWrite.."saveFile/".."EXIST? NO!!!!!!!!!!!!!!!!!")
		--MOAIFileSystem.affirmPath(pathToWrite.."saveFile/")
		print("WROTE SYSTEM")
		tb2 = table.load("Game/worldMap/map/".._mapFile..".mib")
		self._turnUpdate = false
	else
		print("SO DOES: "..pathToWrite.."saveFile/".."EXIST? YESSSSSS!!!!!!!!!!")
		tb2 = table.load(pathToWrite.."saveFile/".._mapFile..".mib")
		self._turnUpdate = tb2.turn
	end

	
	 

	for x = 1, #tb2 do
		for y = 1, #tb2[x] do
			local _tbValue = tb2[x][y]
			if _tbValue == _NeutralHQ then
				self:create(x, y, self._teamEdward, self._hq)
				--worldMap:setInfluenceAt(x, y, 0)
			elseif _tbValue == _PlayerHQ then
				self:create(x, y, self._teamOne, self._hq)
				--worldMap:setInfluenceAt(x, y, 4)
			elseif _tbValue == _EnemyHQ then
				self:create(x, y, self._teamTwo, self._hq)
				--worldMap:setInfluenceAt(x, y, -4)
			elseif _tbValue == _NeutralTown then
				self:create(x, y, self._teamEdward, self._town)
				--worldMap:setInfluenceAt(x, y, 0)
			elseif _tbValue == _PlayerTown then
				self:create(x, y, self._teamOne, self._town)
				--worldMap:setInfluenceAt(x, y, 4)
			elseif _tbValue == _EnemyTown then
				self:create(x, y, self._teamTwo, self._town)
				--worldMap:setInfluenceAt(x, y, -4)
			end
		end
	end

end

function wmBuildings:destroy( )
	for i,v in ipairs(self._bTable) do
		image:removeProp(v.img, 1)
	end

	self._bTable = {}
end

function wmBuildings:_MouseToWorld( )
	local msx = Game.mouseX
	local msy = Game.mouseY

	local _mx = math.floor( (msx - self._offsetX + self._tileSize) 	/ self._tileSize )
	local _my = math.floor( (msy - self._offsetY + self._tileSize) / self._tileSize )

	self._msx = _mx
	self._msy = _my

	return _mx, _my
end

function wmBuildings:touchlocation(_x, _y)
	self.__msx = _x
	self.__msy = _y
end

function wmBuildings:touchpressed( )
	wmBuildings:select(self._msx, self._msy)
end

-- Maybe a math dist check to see if nearby
function wmBuildings:select(_x, _y)
	--print("_X ".._x.." | _Y: ".._y.."")
	for i,v in ipairs(self._bTable) do
		if v.x == _x and v.y == _y then
			--if v.unlcoked == true then
				Game.mapFile = v.MapName
				Game.buildingID = i
				interface:_setConfirmMission(true)
				interface:_populateDescriptionBox(Game.mapFile)
			--end
			--self:setOwnership(self._buildingUnderAttack, 1)
		end
	end

	--local influenceVar = worldMap:getInfluenceAt(self._msx, self._msy)
	--print("INFLUENCE AT "..self._msx.. " | "..self._msy.."  is "..influenceVar.."")

end

function wmBuildings:turnUpdate( )
	if self._turnUpdate == true then
		self:simulateCapture( )
		self:generateUnlockedList( )
		self:checkDistance( )
		self:saveGameState( )
		self._turnUpdate = false
	else

	end
end

function wmBuildings:simulateCapture( )
	-- get a random p2 building
	local enemyBuilding = 0
	local random = math.random(1, 10)
	for i,v in ipairs(self._bTable) do
		if v.team == 3 then
			enemyBuilding = v
		end
	end

	if enemyBuilding ~= 0 then
		local capB = self:_checkIfBuildingNearby(enemyBuilding, self._distCheck)
		if capB ~= nil then	
			if random > 5 then
				self:setOwnership2(capB, 2)
				self._distCheck = 6
				print("ENEMY HAS CAPTURED A TOWN")
			end
		else
			self._distCheck = self._distCheck + 1
			self:simulateCapture( )
		end
	end
	print("DIST CHECK: "..self._distCheck.."")
end

function wmBuildings:checkDistance( )
	-- get a random p2 building
	local playerBuilding = 0
	
	for i,v in ipairs(self._bTable) do
		if v.team == 2 then
			playerBuilding = v
		end
	end

	if playerBuilding ~= 0 then
		local capB = self:_checkIfBuildingNearby2(playerBuilding, self._distCheck)
		if capB ~= nil then	
			--self:setOwnership2(capB, 2)
			local bld = self._bTable[capB]
			--anim:setState(bld.anim, "AVAILABLE" )
			bld.unlcoked = true
			self._distCheck = 6
		else
			self._distCheck = self._distCheck + 1
			self:checkDistance( )
		end
	end
	print("DIST CHECK: "..self._distCheck.."")
end

function wmBuildings:_checkIfBuildingNearby2(_bToCheck, _distance) 
	for i,v in ipairs(self._bTable) do
		if v.team ~= 2 then
			if math.dist(_bToCheck.x, _bToCheck.y, v.x, v.y) <= _distance then
				print("BUILDING NEARBY: "..i.."")
				return i
			end
		end
	end
	
end

function wmBuildings:_checkIfBuildingNearby(_bToCheck, _distance) 
	for i,v in ipairs(self._bTable) do
		if v.team ~= 3 then
			if math.dist(_bToCheck.x, _bToCheck.y, v.x, v.y) <= _distance then
				print("BUILDING NEARBY: "..i.."")
				return i
			end
		end
	end
	
end

function wmBuildings:setOwnership(_buildingID, _player)
	local bld = self._bTable[ Game.buildingID ]
	if bld ~= nil then
		bld.team = _player+1
		print("TEAM IS: "..bld.team.."")
		anim:setState(bld.img, self._capturedTeam[bld.team-1], self._hqTeam[bld.team])
		
		--image:setIndex(bld.img, bld.team)
		
		Game.buildingID = nil
		Game.victor = nil
		wmBuildings:saveGameState( )
	end
end

function wmBuildings:setOwnership2(_buildingID, _player)
	local bld = self._bTable[ _buildingID ]
	if bld ~= nil then
		bld.team = _player+1
		anim:setState(bld.img, self._capturedTeam[bld.team-1], self._hqTeam[bld.team])
		
		--image:setIndex(bld.img, bld.team)

		Game.buildingID = nil
		Game.victor = nil
		wmBuildings:saveGameState( )
	end
end

function wmBuildings:saveGameState( )
	local buildingTable = {}
	local gridX, gridY = worldMap:getGridSize( )
	-- two passes
	for x = 1, gridX do
		buildingTable[x] = {}
		for y = 1, gridY do

			buildingTable[x][y] = 1073741833

		end
	end

	for x = 1, gridX do
		for y = 1, gridY do
			for i,v in ipairs(self._bTable) do
				if v.x == x and v.y == y then
					--[[if v.team == 0 then

					elseif v.team == 1 then

					elseif v.team == 2 then

					end--]]
					if v.tp == 1 then
						buildingTable[x][y] = self._hqIndexTable[v.team]
						--print("TP 1 - X: "..x.." Y: "..y.." VALUE: "..buildingTable[x][y].."")
					elseif v.tp == 2 then

						buildingTable[x][y] = self._townIndexTable[v.team]
						--print("TP 2 - X: "..x.." Y: "..y.." VALUE: "..buildingTable[x][y].."")
					end
				end
			end
		end
	end


	local result = MOAIFileSystem.checkPathExists(pathToWrite.."saveFile/")
	if result == false then
		MOAIFileSystem.affirmPath(pathToWrite.."saveFile/")
	end
	if buildingTable ~= nil then
		print("BUILDING TABLE EXISTS")
		print("BUILDING TABLE EXISTS")

		print("BUILDING TABLE EXISTS")
		print("BUILDING TABLE EXISTS")
		print("BUILDING TABLE EXISTS")
		print("BUILDING TABLE EXISTS")
		print("BUILDING TABLE EXISTS")
		print("BUILDING TABLE EXISTS")
	end
	buildingTable.turn = self._turnUpdate
	table.save(buildingTable, pathToWrite.."saveFile/worldmap.mib" )
end

function wmBuildings:setTurnUpdateTo(_state)
	self._turnUpdate = _state
end

function wmBuildings:getTurnUpdate( )
	return self._turnUpdate
end

--[[function wmBuildings:setVictory(_player)

end--]]