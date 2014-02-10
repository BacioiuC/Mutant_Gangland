irene = {}


--[[
	TODO: Better search for empty spot! Tailor it specifically to the AI - FOR NOW
	GetTarget -> Move to Target: Make it so there are no more problems with positioning the units
	Get unit to only move, on the spot, somewhere where there is no other unit at the end of length
]]
function irene:init( )
	self._name = "irene"
	self._goal = nil -- no goal at the start

	self._goalX = nil
	self._goalY = nil

	self._enemyUnitList = {} -- keeps track of all units on the route to the goal
	self._enemyLeftToMove = { } -- keeps track of all our units that have not moved yet

	self._pathList = {} -- keeps track of all the possible paths to the goal
	self._buildingList = {} -- keeps track of neutral and enemy buildings towards the goal object

	self._killGoals = { } -- adds all enemies as a kill goal
	self._captureGoal = { } -- adds all buildings as a capture goal
	self._fortifyGoal = { } --

	-- score modifiers
	self._tAttackModifier = 0
	self._tDefenseModifier = 0 -- defense and attack terrain modifiers are not in yet. 
	self._movePrefference = -3 -- preffer to move then keep the unit still
	self._blockSpawnPoints = 1 -- preffer to not block spawn points in HQ's
	self._engangeEnemy = 1 -- prefference to attack the enemy should be jigh
	self._engageEnemyNearOwnBuilding = 1
	self._captureTown = 1 -- should capture towns
	self._captureHQ = 1-- prefference to gain control of a HQ
	self._capturePossibleLocation = 1 -- small weight for a villageo utside of range

	self._unitIDX = 1 -- start with the first unit in the unitList

	self._ONCE = false

	self._bestScore = -25

	self._startTurn = true

	self.gold = 30

	self._goalType = {}
	self._goalType[1] = "FORTIFY"
	self._goalType[2] = "ATTACK"
	self._goalType[3] = "CAPTURE"

	self._pointsPerHp = 29
	self._pointsPerDamage = 13
	self._pointsPerMobility = 7
	self._proximityPerUnit = 200 -- closeness to own buildings

	self._player = {}
	self._player[1] = player1
	self._player[2] = player2

	-- for buildings
	self._pointsPerType = 3 --substract type from points. If it's a HQ it's more important
	self._pointsOwnTeam = -2
	self._pointsNeutral = 4
	self._pointsEnemy = 4

	self._unitPriorityList = {}
	self._buildingPriorityList = {}
	self._targetedBuildingList = {}
	self._unitsNearOurBuildings = {}

	self._dispositionList = {}

	self._dispositionList[1] = { 1, 1, 3 }
	self._dispositionList[2] = { 1, 3 }
	self._dispositionList[3] = { 2, 3 }
	self._dispositionList[4] = { 1, 4 }
	self._dispositionList[5] = { 2, 4 }
	self._dispositionList[6] = { 1, 3, 1 }
	self._dispositionList[7] = {3, 3, 3}
	------------------------


	-- real disposition based on turns
	self._disposition = {}
	self._disposition[1] = "EXPANSIVE"
	self._disposition[2] = "AGGRESSIVE"
	self._disposition[3] = "DEFENSIVE"
	self._currentDisposition = 1

	self._templeIDX = 1
	self._templeCreationProcess = true

	self._desiredAssaultAmmount = 3
	self._desriedBattleAmmount = 7

	self._delayNext = Game.worldTimer
	self._startDelay = false
end

function irene:getCurrentDisposition( )
	return self._disposition[self._currentDisposition]
end

function irene:setDisposition(_value)
	self._currentDisposition = _value
end

function irene:smartSummoningComponent( )
	-- make a list of all owned temples
	local templeList = self:getListOfTemples( )
	local szTempleList = #templeList
	print("SZ LIST: "..szTempleList.."")
	if szTempleList > 0 then
		self._templeCreationProcess = true
		local _id = templeList[szTempleList] -- get last known unit
		local bld = building:_returnBuildingTable()[_id]
		-- analize what to spawn at said temple
		local bool, _id, _type = self:_handleTemple(bld)
		self:_createUnitAtTemple(bld, bool, _id, _type)
		
	else
		self._templeCreationProcess = false
	end
	print("STUCK IN SMART SUMMONING")
	print("PLAYER 2 MONEY: "..self._player[unit:_returnTurn()].coins.."")
end

function irene:_handleTemple(_v)
	local bld = _v
	local bool = false -- first process to see if it has a unit in range
	local _type = nil
	local _id = nil
	local score = 0
	for i,v in ipairs(unit:_returnTable()) do
		if v.team ~= unit:_returnTurn() then
			local distCheck = math.dist(bld.x, bld.y, v.x, v.y)
			-- check if assaults:
			if distCheck <= v.range then
				if v.tp == 1 or v.tp == 2 then
					local unitScore = self:scoreUnit(v)
					if unitScore > score then
						score = unitScore
						_id = i 
						_type = v.tp
					end
					bool = true
				end
			end
		end
	end

	return bool, _id, _type
	-- based on the outcome of the check see what's more apropriate to create
end

function irene:_createUnitAtTemple(_temple, _bool, _id, _type)
	local bld = _temple
	local bool = _bool
	local team = unit:_returnTurn()
	if bool == true then -- so we have an assault nearby
		if self._player[team].coins >= unit_type[team][3].cost then
			building:_createUnits(_temple, unit:_returnTurn(), 3)
		else
			_temple.canProduce = false
		end
	else
		--[[if turnNr <= 2 then
			building:_createUnits(_temple, unit:_returnTurn(), 1)
		else

		end--]]
		local unType = self:_checkUnitRatioAndDecideSpawn( )

		if self._player[team].coins >= unit_type[team][unType].cost then
			building:_createUnits(_temple, team, unType)

		else
			_temple.canProduce = false
		end

	end
end

-- returns what type of unit to spawn
function irene:_checkUnitRatioAndDecideSpawn( )
	--self._desiredAssaultAmmount
	local turnNr = unit:_getTurnCounter( ) -- check what turn it is
	local assCounter, batCounter = self:_getListNrOfUnitsPerClass( )
	-- early in the game, get some scouts out
	--[[
		what turn it is
		what is the desired ammount of assault units
		what is the desired ammount of battle units
		how many enemy units are out there
		
		result must be 1 -> 4

		ammountOfAssaultsWeHave - desiredAmmount = gap of units
		local AndreeaFactor = chance for enemy unit to GTFO and target something else


		if it's early on, favor the creation of socuts
		earlyFactor = 10 - turnNr * 3.
			Eg: turn == 1
			earlyFactor = 10 - (1*3) = 10 - 2 = 7! 8 points in favor of early factor
			eg: turn = 2
			earlyFactor = 10 - 6 = 4! 
			turn = 3
			earlyFactor = 10 - 9 = 1

		score for assault: 10
		score for chainsaw = 20
		score for rifle = 30
		score for rokkit = 40

	]]
	local score = 0
	local unitType = 1
	for i = 1, 5 do
		local unScore = self:_doMathPerType(i)
		if unScore > score then
			unitType = i 
			score = unScore
		end
	end
	
	return unitType
	

end

function irene:_doMathPerType(_type)
	local turnNr = unit:_getTurnCounter( ) -- check what turn it is
	local assCounter, batCounter = self:_getListNrOfUnitsPerClass( )
	local earlyFactor = 0 
	local unitFactor = 0
	local unitScore = 0
	local team = unit:_returnTurn( )
	if _type == 1 or _type == 2 then
		earlyFactor = 10 - (turnNr * 3) -- for the scouts
		unitFactor = self._desiredAssaultAmmount / assCounter -- multiply by this. If we have more then desired then
		unitScore = self:_doScoreUnit(_type)
		unitCost = unit_type[team][_type].cost
	else
		unitFactor = self._desriedBattleAmmount / batCounter
		earlyFactor = turnNr + 2
		unitScore = self:_doScoreUnit(_type)
		unitCost = unit_type[team][_type].cost
	end

	local equationToDecide = earlyFactor + ((unitScore*unitScore) * unitFactor) * ( (self._player[team].coins - unitCost) * unitScore )
	--[[
		earlyFactor = 10 - 3 = 7
		unitFactor = 5 / 2 = 2.5
		unitScore = 15
		equationToDecide = 7 + 15 * 2.5 = 44

		--- turn = 2
		earlyFactor = 6
	]]
	return equationToDecide
end

function irene:_doScoreUnit(_type)
	local team = unit:_returnTurn()
	local score = 0
	local v = unit_type[team][_type]
	score =  score + (v.health * self._pointsPerHp + ( 10 * (v.health-3) )) + (v.damage * self._pointsPerDamage) + (v.mobility * self._pointsPerMobility)
	return score
end

function irene:_getListNrOfUnitsPerClass( )
	local assCounter = 0
	local batCounter = 0
	for i,v in ipairs(unit:_returnTable()) do
		if v.team == unit:_returnTurn( ) then
			if v.tp == 1 or v.tp == 2 then
				assCounter = assCounter + 1
			else
				batCounter = batCounter + 1
			end
		end
	end

	return assCounter, batCounter
end

function irene:getListOfTemples( )
	local templeList = {}
	for i, v in ipairs(building:_returnBuildingTable()) do
		if v.team == unit:_returnTurn( ) then
			if v._type == 1 and v.canProduce == true and unit:isLocEmpty(v.x, v.y) == nil then -- temples 
				table.insert(templeList, i) -- add the building id to the list
			end
		end
	end
	return templeList
end

function irene:think( )

	if self._startTurn == true then
		----print("START START START")
		
		--irene:createUnits( )
		self:smartSummoningComponent( )
		local aSize = self:getListOfUnits( ) 
		print("THIS? + ASIZE:" ..#aSize.."")
		if #aSize == 0 then
			self:endTurn( )
		elseif self._templeCreationProcess == false then
			local rndCheck = 200
			if rndCheck <= 9 then
				unit:_applyPowerupDmgAll( )
			end
			self._targetedBuildingList = {}
			self:getListOfUnits( )
			self:getTactical( )
			_zoomSetScale(1)
			self._startTurn = false
		end		
	else
		--

		local unitsLeft = self:getUnitsLeftToMove( )
		if #unitsLeft > 0 then

			self:loopMovableList(unitsLeft)
		else
			self:endTurn( )
		end
	end
end

function irene:endTurn( )
	self._ONCE = false	
	self._bestScore = -25
	
	self._unitIDX = 1	

	unit:advanceTurn( )	
	self._startTurn = true
end

function irene:loopMovableList(_list)
	----print("We Learn so we can obey!!")
	local _id = _list[#_list]
	----print("LIST TOTAL: "..#_list..". ID IS: ".._id.."")
	local v = unit:_returnTable()[_id]
	if v~=nil then
		--self:assignGoals(v)
		map:scroll( )
		if v.objectiveSet == false then
		--	self:submitBestMoveForUnit(v)
			self:processTacticalInformation(v)

		else
		--	self:moveUnits(v, v.goal_x, v.goal_y)
			if v.isMoving == true and map:getScrollStatus( ) == false then
				self:moveTowardsTarget(v)
			end
		end
	else
		----print("WE BE HERE")
		self:endTurn( )
	end

end

function irene:scoreUnit(_unit)
	local v = _unit
	local score = 0
	score =  score + (v.hp * self._pointsPerHp) + (v.damage * self._pointsPerDamage) + (v.range * self._pointsPerMobility)
	return score
end
-- Tactic mod - activate! In the form of an ICE MANURA!
function irene:getTactical( )
	-- reset all lists
	self._unitPriorityList = {}
	self._buildingPriorityList = {}
	-- get enemy units and prioritize them


end

function irene:processTacticalInformation(_v)
	local disposition = self:getCurrentDisposition( )
	if disposition == "EXPANSIVE" then
		self:expansiveProcessing(_v)
	elseif disposition == "AGGRESSIVE" then

	elseif disposition == "DEFENSIVE" then

	end
end

function irene:expansiveProcessing(_v)
	-- in the expansive state, irene will search for buildings to conquer
	-- conquering units will head for buildings
	-- battle units will guard conquerers
	local v = _v
	if v.tp == 1 or v.tp == 2 then -- scout or melee
		self:_expansiveProcessingScouts(v)
	else -- battle units
		self:_expansiveProcessingBattleUnits(v)
	end
end


function irene:_expansiveProcessingScouts(_v)
	local v = _v
	self:scoreBuildingBasedOnProximity(v)
	if v.goal_x ~= v.x and v.goal_y ~= v.y then
		local posX, posY = self:checkClosestRangeLocation(v)
		if posX ~= nil and posY ~= nil then -- worthless check, but meh
			self:getTargetLocation(v, posX, posY)
		else -- well, phrak! Nothing to do now.
			v.done = true
			self:removeUnitFromTable( )			
		end
	else
		v.done = true
		self:removeUnitFromTable( )	
	end
end
-- goes through the unit's range and scores locations based on proximity (path length)
-- then selects the best position (unocuppied and close)
function irene:checkClosestRangeLocation(_v)
	local v = _v
	self._rangeTable = {}
	self:addRange(v)
	local score = -5
	local posX, posY = nil, nil -- worst case scenario? Stay where ye are
	if v.goal_x ~= nil and v.goal_y ~= nil then
		for i, j in ipairs(self._rangeTable) do
			--[[if j._x == v.x and j._y == v.y then
				score = score - 10
			end--]]

			if unit:isLocEmpty(j._x, j._y) == nil then
				if v.goal_x ~= j._x and v.goal_y ~= j._y then
					local path, length = pather:getPath(v.goal_x, v.goal_y, j._x, j._y)
					local moveScore = 0
					if path ~= nil then
						moveScore = moveScore + 50 - length
						if moveScore > score then
							posX = j._x
							posY = j._y
							score = moveScore
						end
					end
				elseif j._x == v.goal_x and j._y == v.goal_y then
					score = 3000
					posX = v.goal_x
					posY = v.goal_y
				end

			end
		end
	end
	return posX, posY
end

function irene:scoreBuildingBasedOnProximity(_v)
	local v = _v
	local score = 0
	local posX = nil
	local posY = nil
	--Game:updatePathfinding( )
	for i,j in ipairs(building:_returnBuildingTable()) do
		local bld = j

		--if j.point > 0 then --not our team
		if bld.team ~= unit:_returnTurn() and unit:isLocEmpty(bld.x, bld.y) == nil and bld.x ~= v.x and bld.y ~= v.y then	
			 

			
			local path, length = pather:getPath(v.x, v.y, bld.x, bld.y)
			if path ~= nil then -- make sure there's a path to that building
				local bool = false
				for k, l in ipairs(unit:_returnTable() ) do
					if l.tp == 1 or l.tp == 2 and l.team == v.team then
						local distCheck = math.dist(l.x, l.y, bld.x, bld.y)
						if length < 2 then
							bool = true
						end
					end
				end

				local moveScore = 0
				local modifier = 0
				if bool == true then
					modifier = 8
				end

				moveScore = moveScore + (9 - bld._type*2) + (30 - length) - modifier -- more focus on buildings that create units
				if moveScore > score then
					posX = bld.x
					posY = bld.y
					score = moveScore
				end
			else
				--print("VX: "..v.x.." | VY: "..v.y.." BX: "..bld.x.." BY: "..bld.y.."")
				--print("NIL NIL NIL IN SCORE BUILDING")
			end

		end
	end

	-- now we add our final positions to a list. This way, we'll make sure we didn't target the building before
	v.goal_x = posX
	v.goal_y = posY

end

function irene:_expansiveProcessingBattleUnits(_v)
	local v = _v
	self:_selectScoutToProtect(v)
	if v.goal_x ~= nil and v.goal_y ~= nil then
		--print("STEP ONE")
		local posX, posY = nil, nil --self:checkClosestRangeLocation(v)
		local path, length = pather:getPath(v.x, v.y, v.goal_x, v.goal_y)
		if path ~= nil then
			--print("STEP 2")
			if length <= v.range then -- go in for the kill
				--print("STEP 3 + LEN "..length.."")
				posX, posY = self:findFreeSpot(v.goal_x, v.goal_y, 1)
			else
				--print("STEP 4 + LENGTH IS: "..length.."")
				posX, posY = self:checkClosestRangeLocation(v)
			end
		else
			--print("NIL PATH TARGET")
			--print("NIL PATH TARGET")
			--print("NIL PATH TARGET")
			--print("NIL PATH TARGET")
			--print("NIL PATH TARGET")
			--print("NIL PATH TARGET")
			--print("NIL PATH TARGET")
			--print("NIL PATH TARGET")
			--print("NIL PATH TARGET")
			--print("NIL PATH TARGET")
			--print("NIL PATH TARGET")
			--print("NIL PATH TARGET")
			--print("NIL PATH TARGET")
			--print("NIL PATH TARGET")
			--print("NIL PATH TARGET")
			--print("NIL PATH TARGET")
			--print("NIL PATH TARGET")
			--print("NIL PATH TARGET")
		end

		
		if posX ~= nil and posY ~= nil then -- worthless check, but meh
			self:getTargetLocation(v, posX, posY)
		else -- well, phrak! Nothing to do now.
			--print("POS X IS NIL... ")
			self:selectWhatToAttack(v)
			v.done = true
			self:removeUnitFromTable( )			
		end
	else
		self:selectWhatToAttack(v)
		--print("VX IS NIL")
		v.done = true
		self:removeUnitFromTable( )	
	end
end

function irene:_selectScoutToProtect(_v)
	local v = _v
	
	local score = 0
	local scoutScore = 0
	local posX, posY = nil, nil
	local targetID = nil
	for i,j in ipairs(unit:_returnTable()) do
		local un = j
		if j.team ~= unit:_returnTurn() then
			local bool, threat, bid = self:isEnemyNearOneOfOurBuildings(j)

			local moveScore = 0
			local path, length = pather:getPath(v.x, v.y, un.x, un.y)
			local bunitScore = self:scoreUnit(v)
			local targUnScore = self:scoreUnit(un)
			if path ~= nil then
				local modifier = 0
				if bool == true then
					local extraMode = 0
					if bid ~= nil then
						local bld = building:_returnBuildingTable()[bid]
						-- get my own distance to the
						local distCheck = math.dist(v.x, v.y, bld.x, bld.y)
						if distCheck <= v.range then
							extraMode = 18 - distCheck*2
						end
						if length <= 4 then
							extraMode = extraMode + 500
						end
					end
					if threat == 1 then
						if j.tp == 1 or j.tp == 2 then
							modifier = 525 + extraMode
						else
							modifier = 125 + extraMode
						end
					else 
						modifier = 20
					end
				end
				local freeSpotModifier = 0
				local mcX, mcY = self:findFreeSpot(j.x, j.y, v.attack_range)
				if mcX ~= nil and mcy ~= nil then
					freeSpotModifier = - 200
				else
					freeSpotModifier = 40
				end
				moveScore = moveScore + (30 - length) + modifier + ( 20 ) + freeSpotModifier
				if moveScore > score then
					posX, posY = un.x, un.y
					score = moveScore
					targetID = i
				end
			else
				--print("NIL FUCKERE")
			end
		end
	end

	v.goal_x = posX
	v.goal_y = posY
	v.rival = i
	if v.goal_x == nil and v.goal_y == nil then
		--self:_selectScoutToProtect(v)
		--print("FIND FREE LOCATION")
		v.goal_x, v.goal_y = self:_findFreeLocation(v)
	end
		
end

function irene:_findFreeLocation(_v) -- the idea is to move our targetless combat units to an uncumbered space
	local v = _v
	self._rangeTable = {}
	self:addRange(v)
	local score = 0
	local posX = nil
	local posY = nil
	for k, l in ipairs(self._rangeTable) do
		if unit:isLocEmpty(l._x, l._y) == nil then
			local moveScore = 0
			for i,j in ipairs(building:_returnBuildingTable()) do
				if j.x == l._x and j.y == l._y then
					if j._type == 1 then
						moveScore = moveScore - 200 -- do not block spawn points... man
					end
				end
			end
			if l._x == v.x and l._y == v.y then
				--print("IT IS, IT IS, IT IS")
				moveScore = moveScore - 40 -- prefare to not stand still
			else
				moveScore = moveScore + 20 - map:getTileCost(l._x, l._y)
			end			
			if moveScore > score then
				posX = l._x
				posY = l._y
				score = moveScore
			end
		end
	end

	return posX, posY
end

function irene:_getGoodPath(_v, _path, _length)
	local v = _v
	local _px = _path[_length].x
	local _py = _path[_length].y
	if unit:isLocEmpty(_px, _py) == nil then
		return _px, _py
	else
		if _length > 1 then
			self:_getGoodPath(v, _path, _length-1)
		else
			--v.done = true
			--self:removeUnitFromTable()
			----print("STUCK HERE")
			local _npx, _npy = self:weightActions(v)
			if _npx ~= nil and _npy ~= nil then
				return _npx, _npy
			else
				return v.x, v.y --self:selectWhatToAttack(v)
			end
		end
	end
end

function irene:weightActions(_v)


end

-- add a table of all enemy units.
function irene:getListOfUnits( )
	self._enemyUnitList = {}
	local tempList = {}

	for i,v in ipairs(unit:_returnTable( ) ) do
		if v.team == unit:_returnTurn( ) and v.disabled == false then
			table.insert(tempList, i)
		end
	end
	self._enemyUnitList = tempList

	return self._enemyUnitList
end

function irene:getListOfEnemyUnits( )
	self._killGoals = {}
	local tempList = {}
	for i,v in ipairs(unit:_returnTable( ) ) do
		if v.team ~= unit:_returnTurn( ) and v.disabled == false then
			table.insert(tempList, i)
		end
	end
	self._killGoals = tempList
	return self._killGoals
end

function irene:getUnitsLeftToMove( )
	self._enemyLeftToMove = {}
	aSize = self:getListOfUnits( )
	for i,k in ipairs(aSize) do
		local v = unit:_returnTable()[k]
		if v ~= nil then
			if v.done == false then
				table.insert(self._enemyLeftToMove, k)
			end
		else
			self:endTurn( )
		end
	end

	return self._enemyLeftToMove
end

function irene:getListOfUnitsSize( )
	return #self._enemyUnitList
end

function irene:getListOfBuildings(_list)
	self._buildingList = {}
	self._buildingList = _list
end

function irene:removeUnitFromTable( )
	local units = self:getUnitsLeftToMove( )
	--if #units > 0 then
	table.remove(units, self._unitIDX)	
	--else
		
	--end
	----print("GETTING LIST OF UNITS" )
	self:getListOfUnits(  ) 
	local szUnits = #units
	----print("SIZE UNITS: "..szUnits.."")
	if szUnits < 0 then
		----print(" ENDING TURN" )
		self:endTurn( )
	end
	--table.remove(self._enemyUnitList, self._unitIDX)
	--francois:incIDX( )
	
	--francois:endTurn( )
	
	----print("DONE WITH FUNCTION")
	self:getTactical( )
end

function irene:getTargetLocation(_unit, _x, _y, _chkForPath)
	local v = _unit

	if v.isMoving == false then
		--v.goal_x, v.goal_y = _x, _y
	
		----print("GOAL FUCKING X IS: ".._x.." AND GOAL FUCKING Y IS: ".._y.."")
		if pather.grid:isWalkableAt(_x, _y) then
			----print("WE CAN HAZ GO")
			local __x = math.floor(v.x)
			local __y = math.floor(v.y)
			--Game:updatePathfinding()
			--local __posX, __posY = self:getClosestFreePointOnPath(v, v.goal_x, v.goal_y)
			v.path, v.length = pather:getPath(__x, __y, _x, _y)

			if v.path ~= nil --[[and v.length <= v.range--]] then
				map:setScreen(v.act_x, v.act_y)
				sound:playFromCategory(SOUND_WALKING)
				----print("WE CAN HAZ GO PATH NAO!!!!")
				--local test = math.dist(__x, __y, v.goal_x, v.goal_y)
				v.issuedOrder = true -- the unit has been commanded to move
				v.moveTimer = Game.worldTimer
				v.isThere = false
				v.objectiveSet = true
				v.isMoving = true
				--unit:_colorPath(v.path, v.length)	

			else
				----print("PATH IS NIL")
				--Game:updatePathfinding()
				--self:endTurn( )
				v.done = true
				self:removeUnitFromTable( )
				--self:getTargetLocation(_unit, _x, _y)
				
				--self:removeUnitFromTable( )--self:endTurn( )
			end
		else
			--Game:updatePathfinding()
			--self:endTurn( )
			v.done = true
			self:removeUnitFromTable( )
		end
	end
end

function irene:moveTowardsTarget(_unit)
	v = _unit

	if v.path ~= nil then
	--	--print("STEP 1: ")
		if v.isThere == false then
			----print("STEP 2: ")
			--camera:followOffset(v.x, v.y)
			--[[--print("LENGTH IS: "..#v.path.." AND CUR IS: "..v.cur.."")
			--print("LENGTH IS: "..#v.path.." AND CUR IS: "..v.cur.."")
			--print("LENGTH IS: "..#v.path.." AND CUR IS: "..v.cur.."")
			--print("LENGTH IS: "..#v.path.." AND CUR IS: "..v.cur.."")
			--print("LENGTH IS: "..#v.path.." AND CUR IS: "..v.cur.."")--]]
			local _x = v.path[v.cur].x
			local _y = v.path[v.cur].y
			--if Game.worldTimer > v.moveTimer + v.speed then
				if v.x > _x then
					v.x = v.x - v.move_speed
				elseif v.x < _x then
					v.x = v.x + v.move_speed
				end

				if v.y > _y then
					v.y = v.y - v.move_speed
				elseif v.y < _y then
					v.y = v.y + v.move_speed
				end
				v.isMoving = true 
				local _rangeMax
				 _rangeMax = v.length
				

				if v.x > _x then
					anim:setState(v.img, "MOVE_LEFT")
				elseif v.x < _x then
					anim:setState(v.img, "MOVE_RIGHT")
				elseif v.y > _y then
					anim:setState(v.img, "MOVE_UP")
				elseif v.y < _y then
					anim:setState(v.img, "MOVE_DOWN")
				end

				if v.x == _x and v.y == _y then
				--	--print("STEP 3: ")

					
					if v.cur <= _rangeMax then
						v.cur = v.cur + 1
						----print("STEP 4: ")
					else
						----print("STEP 5: ")
						----print("CORD X: "..v.x.." | COORD Y: "..v.y.."")
						--unit:_clearPathTable( )
						
								--unit:_addRange(_id)
						
						v.isThere = true	
						v.done = true
						self._bestScore = -55
						v.objectiveSet = false
						v.isMoving = false
						self._OnePath = true
						self:selectWhatToAttack(v)
						v.cur = 1
						v.isMoving = false
						self:removeUnitFromTable( )
						self:getListOfUnits( )
					
					end
				end
			--	v.moveTimer = Game.worldTimer

			--end

		end
	end

end

function irene:selectWhatToAttack(_v)
	local v = _v

	-- get list of enemis near our unit
	local unitList = unit:_returnTable( )
	local targetID = nil
	local unitScore = self:scoreUnit(v)

	local scoreModifier = 0 -- if enemies are at the gates, they will kamikaze the enemy
	--[[local enemyEngageCheck, threat = self:isEnemyNearOneOfOurBuildings(v)
	if enemyEngageCheck == true then
		if threat == 1 then
			scoreModifier = 400
		else
			scoreModifier = 20
		end
	end
	for i,j in ipairs(unitList) do
		if j.team ~= unit:_returnTurn() then
			local distCheck = math.dist(v.x, v.y, j.x, j.y)

			if distCheck <= v.attack_range then
				--print("CHOOSING TARGET")
				local targetScore = self:scoreUnit(j)

				if targetScore <= unitScore + scoreModifier + 20 then
					targetID = i
					--print("WE HAZ TARGET")
				end
			end
		end

	end--]]

	if v.rival ~= nil then
		targetID = v.rival
	else
		local enemyEngageCheck, threat = self:isEnemyNearOneOfOurBuildings(v)
		if enemyEngageCheck == true then
			if threat == 1 then
				scoreModifier = 670
			else
				scoreModifier = 0
			end
		end
		for i,j in ipairs(unitList) do
			if j.team ~= unit:_returnTurn() then
				local distCheck = math.dist(v.x, v.y, j.x, j.y)

				if distCheck <= v.attack_range then
					--print("CHOOSING TARGET")
					local targetScore = self:scoreUnit(j)
					local modTypeCheck = 5
					if v.tp == 3 or v.tp == 4 then
						modTypeCheck = 400 -- screw it, just attack!
					end
					if targetScore <= unitScore + scoreModifier + modTypeCheck then
						targetID = i
						--print("WE HAZ TARGET")
					end
				end
			end

		end		
	end

	if targetID ~= nil then
		local target = unit:_returnTable()[targetID]
		local dmg_tar = unit:_calculateAttack(v, target)
		local dmg_attk = unit:_calculateAttack(target, v)
		unit:_do_attack(v, target)
		--[[target.hp = target.hp - dmg_tar
		anim:setState(target.img, "HURT", "MOVE_LEFT")
		local distCheck = math.dist(target.x, target.y, v.x, v.y)
		if target.hp > 0.02 and distCheck <= target.attack_range then
			v.hp = v.hp - dmg_attk
			anim:setState(v.img, "HURT", "MOVE_LEFT")
		end--]]

	end
end

function irene:findFreeSpot(_x, _y, _range)
	local posX = nil
	local posY = nil
	local rScore = 0
	for x = -_range, _range do
		for y = -_range, _range do
			--if x ~= 0 and y ~= 0 then
				local distCheck = math.dist(x, y, _x + x, _y + y )
				if unit:_isWalkable(_x + x, _y + y) and unit:isLocEmpty(_x + x, _y + y) == nil then
						----print("WALKABLE")
						local moveScore = distCheck
						local path, length
						--if distCheck > 1 then
						path, length = pather:getPath(_x, _y, _x + x, _y + y)
						--end

						if path ~= nil then
							if moveScore > rScore --[[and length < v.range--]] then 
								rScore = moveScore
								posX = _x + x
								posY = _y + y
							end

						end
			
				end
			--end
		end
	end
	if posX ~= nil and posY ~= nil then
		--print("FREE SPOT X: "..posX.." FREE SPOT Y: "..posY.."")

	end
	return posX, posY
end

function irene:moveToPathZone(_unit, _path)
	local v = _unit
	local posX = nil
	local posY = nil
	for x = -v.range, v.range do
		for y = -v.range, v.range do
			for i = 1, #_path do
				if x == _path[i].x and y == _path[i].y and unit:isLocEmpty(x, y) == nil and i < v.range then
					posX = x
					posY = y
				end
			end
		end
	end

	return posX, posY
end

function irene:getClosestPointToPoint(_unit, _destX, _destY)
	Game:updatePathfinding()
	local v = _unit
	local score = 100
	local posX, posY = 0, 0
	for x = -v.range, v.range do
		for y = -v.range, v.range do
			if unit:_isWalkable(v.x-x, v.y-y) then
				local path, length = pather:getPath(v.x, v.y, v.x-x, v.y-y)
				if path ~= nil and length < v.range then
					
					if #path <= v.range and v.x + x > 0 and v.y + y > 0 and unit:isLocEmpty(v.x-x, v.y-y) == nil then
					--	--print("LENGTH "..length.."")
						local distCheck = math.dist(v.x-x, v.y-y, _destX, _destY)
						--if distCheck < score then
							score = distCheck
							posX = v.x-x
							posY = v.y-y
							----print("NEW POS X: "..posX.." NEW POST Y "..posY.."")
						--end
					end
				end
			end
		end
	end

	return posX, posY
end

function irene:_enemiesAtTheGames( )
	for i, j in ipairs(unit:_returnTable()) do
		-- loop through the buildings
		if j.team ~= unit:_returnTurn() then
			for e,k in ipairs(building:_returnBuildingTable() ) do
				if k.team == unit:_returnTurn()-1 then
					local distCheck = math.dist(j.x, j.y, k.x, k.y)

					return true
					
				end
			end
		end
	end
	return false
end

function irene:isEnemyNearOneOfOurBuildings(_v)
	local _unit = _v
	for i, v in ipairs(building:_returnBuildingTable( ) ) do
		if v.team == unit:_returnTurn( ) then
			local distCheck = math.dist(_unit.x, _unit.y, v.x, v.y) 
			if distCheck <= _unit.range then
					local id = 0
					if v._type == 1 then
						id = 1
					end

				return true, id, i
			end
		end
	end
end

function irene:addRange(_v)
		local v = _v
		self._rangeTable = { }
		--Game:updatePathfinding()
		for x = -v.range, v.range do
			for y = -v.range, v.range do
				if unit:_isWalkable(v.x+x, v.y+y) then
					
					local path, length = pather:getPath(v.x, v.y, v.x+x, v.y+y)
					if path ~= nil then
						for i = 1, length+1 do
							if v.ap > (i + map:getTileCost(v.x+x, v.y+y) ) and length <= v.range and v.x == path[i].x and v.y == path[i].y then
								local temp = {
									_x = (v.x + x),
									_y = (v.y + y),					
									_ax = v.x,
									_ay = v.y,
								}
								table.insert(self._rangeTable, temp)	
							end
						end
					end
				end
			end
		end
end

function irene:getClosestFreePointOnPath(_v, _goalX, _goalY )
	local v = _v
	self._rangeTable = {}
	for x = -v.range, v.range do
		for y = -v.range, v.range do
			if unit:_isWalkable(v.x+x, v.y+y) and unit:isLocEmpty(v.x+x, v.y+y) == nil then
				Game:updatePathfinding()
				local path, length = pather:getPath(v.x, v.y, v.x+x, v.y+y)
				if path ~= nil then
					for i = 1, length+1 do
						if v.ap > (i + map:getTileCost(v.x+x, v.y+y) ) and length <= v.range and v.x == path[i].x and v.y == path[i].y then
							local temp = {
								_x = (v.x + x),
								_y = (v.y + y),					
								_ax = v.x,
								_ay = v.y,
							}
							table.insert(self._rangeTable, temp)
						end
					end
				end
			end
		end
	end
	local score = 0
	local posX = nil
	local posY = nil
	for i,j in ipairs(self._rangeTable) do
		local distCheck = math.dist(j._x, j._y, _goalX, _goalY)
		local atScore = 30 - distCheck

		if atScore > score then
			--print("HERE")
			posX = j._x
			posY = j._y
			score = atScore
		end
	end
	return posX, posY
end