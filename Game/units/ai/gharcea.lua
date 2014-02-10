gharcea = {}


--[[
	TODO: Better search for empty spot! Tailor it specifically to the AI - FOR NOW
	GetTarget -> Move to Target: Make it so there are no more problems with positioning the units
	Get unit to only move, on the spot, somewhere where there is no other unit at the end of length
]]
function gharcea:init( )
	self._name = "Gharcea"
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

	self._pointsPerHp = 6
	self._pointsPerDamage = 9
	self._pointsPerMobility = 40
	self._proximityPerUnit = 90 -- closeness to own buildings


	-- for buildings
	self._pointsPerType = 3 --substract type from points. If it's a HQ it's more important
	self._pointsOwnTeam = -2
	self._pointsNeutral = 4
	self._pointsEnemy = 4

	self._unitPriorityList = {}
	self._buildingPriorityList = {}
	self._unitsNearOurBuildings = {}

	self._dispositionList = {}
	self._dispositionList[1] = { 1, 2, 3 }
	self._dispositionList[2] = { 2, 3 }
	self._dispositionList[3] = { 3, 3 }
	self._dispositionList[4] = { 3, 4 }
	self._dispositionList[5] = { 2, 4 }
	self._dispositionList[6] = { 1, 3 }
end

function gharcea:think( )

	if self._startTurn == true then
		--print("START START START")

		building:createUnits(unit:_returnTurn( ), self._dispositionList[math.random(1, 6)] )
		local aSize = self:getListOfUnits( ) 

		if self:getListOfUnitsSize( ) == 0 then
			self:endTurn( )
		else
			self:getListOfUnits( )
			self:getTactical( )
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

function gharcea:endTurn( )
	self._ONCE = false	
	self._bestScore = -25
	
	self._unitIDX = 1	
	unit:advanceTurn( )	
	self._startTurn = true
end

function gharcea:loopMovableList(_list)
	--print("We Learn so we can obey!!")
	local _id = _list[#_list]
	--print("LIST TOTAL: "..#_list..". ID IS: ".._id.."")
	local v = unit:_returnTable()[_id]
	if v~=nil then
		--self:assignGoals(v)
		
		if v.objectiveSet == false then
		--	self:submitBestMoveForUnit(v)

			local _posX, _posY = self:weightActions(v)
			if _posX ~= nil and _posY ~= nil --[[and self:_enemiesAtTheGames( ) == false--]] then -- so we can do something in this turn 
				print("WE CAN HAZ MOVE")
			--	print("SOMETHING TO TARGET THIS TURN")
				self:getTargetLocation(v, _posX, _posY)

			else -- call home to the tactical component

				_tX, _tY = self:processTacticalInformation(v)
				if _tX ~= nil and _tY ~= nil then
					self:getTargetLocation(v, _tX, _tY)
				else

					v.done = true
					self:removeUnitFromTable( )
				end

			end
		else
		--	self:moveUnits(v, v.goal_x, v.goal_y)
			if v.isMoving == true then
				self:moveTowardsTarget(v)
			end
		end
	else
		--print("WE BE HERE")
		self:endTurn( )
	end

end

function gharcea:scoreUnit(_unit)
	local v = _unit
	local score = 0
	score =  score + (v.hp * self._pointsPerHp) + (v.damage * self._pointsPerDamage) + (v.range * self._pointsPerMobility)
	return score
end
-- Tactic mod - activate! In the form of an ICE MANURA!
function gharcea:getTactical( )
	-- reset all lists
	self._unitPriorityList = {}
	self._buildingPriorityList = {}
	-- get enemy units and prioritize them
	local enemyList = self:getListOfEnemyUnits( )
	local enemyListSz = #enemyList

	local buildingList = building:_returnBuildingTable( )
	local buildingListSz = #buildingList
	--local score = 0
	-- loop through the list and prioritze units based on points
	for i = 1, enemyListSz do
		local score = 0
		local b = enemyList[i]
		local v = unit:_returnTable()[b]
		score = score + (v.hp * self._pointsPerHp) + (v.damage * self._pointsPerDamage) + (v.range * self._pointsPerMobility)
		local temp = {
			unit = i,
			point = score,
		}
		table.insert(self._unitPriorityList, temp) -- insert em all, and let the maker sort 'em up
	end

	-- loop through the building list and prioritize them based on points
	for i = 1, buildingListSz do
		local score = 0
		local b = buildingList[i]
		score = score + (self._pointsPerType - b._type )
		if unit:isLocEmpty(b.x, b.y) == nil then
			if b.team == unit:_returnTurn( ) then
				score = score - self._pointsOwnTeam
			else
				score = score + self._pointsEnemy
			end
			local temp = {
				building = i,
				point = score,
			}
			table.insert(self._buildingPriorityList, temp)
		end
	end

end

function gharcea:processTacticalInformation(_v)
	local v = _v
	local _posX, _posY = nil, nil

	-- first, check to see if we need to reinforce an area
	local enemiesAtTheGates = {}

	for i, j in ipairs(unit:_returnTable()) do
		-- loop through the buildings
		if j.team ~= unit:_returnTurn() then
			for e,k in ipairs(building:_returnBuildingTable() ) do
				if k.team == unit:_returnTurn() then
					--local distCheck = math.dist(j.x, j.y, k.x, k.y)
					local path, length = pather:getPath(j.x, j.y, k.x, k.y)
					if path ~= nil then
						if length <= j.range then
							local temp = {
								unit = i,
								bldType = k._type,
								dist = length,
							}
							table.insert(enemiesAtTheGates, temp)
						end
					end
				end
			end
		end
	end

	local nrEnemies = #enemiesAtTheGates

	if nrEnemies > 0 then

		local score = 0
		local targetID = nil
		for i = 1, nrEnemies do
			local uEnemy = enemiesAtTheGates[i]
			local _enemy = unit:_returnTable()[uEnemy.unit]
			local enemyScore = self:scoreUnit(_enemy)
			local bldScore = 0
			if uEnemy.bldType == 1 then
				bldScore = 90 -- it's a HQ so important
			else
				bldScore = 3
			end
			local dngScore = enemyScore + bldScore + 30 - uEnemy.dist
			if dngScore > score then
				score = dngScore
				targetID = uEnemy.unit
			end
		end

		local _enemy = unit:_returnTable()[targetID]
		local path, length = pather:getPath(v.x, v.y, _enemy.x, _enemy.y)
		local lung = 0
		if path ~= nil then
			if length > v.range then
				_posX, _posY = self:_getGoodPath(v, path, v.range)
			else
				_posX, _posY = self:_getGoodPath(v, path, length)
			end
		end

	else

		if v.tp == 1 or v.tp == 2 then
			local rndHQ = building:_returnRandomEnemyHq( )
			
			if rndHQ ~= nil then

				local path, length = pather:getPath(v.x, v.y, rndHQ.x, rndHQ.y)
				local lung = 0
				if path ~= nil then
					if length > v.range then
						_posX, _posY = self:_getGoodPath(v, path, v.range)
					else
						_posX, _posY = self:_getGoodPath(v, path, length)
					end
				end

			end	
		else
			local rndUn = unit:_returnRandomEnemy()
			if rndUn ~= nil then

				local path, length = pather:getPath(v.x, v.y, rndUn.x, rndUn.y)
				local lung = 0
				if path ~= nil then
					if length > v.range then
						_posX, _posY = self:_getGoodPath(v, path, v.range)
					else
						_posX, _posY = self:_getGoodPath(v, path, length)
					end
				end

			else
				if rndHQ ~= nil then

					local path, length = pather:getPath(v.x, v.y, rndHQ.x, rndHQ.y)
					local lung = 0
					if path ~= nil then
						if length > v.range then
							_posX, _posY = self:_getGoodPath(v, path, v.range)
						else
							_posX, _posY = self:_getGoodPath(v, path, length)
						end
					end

				end
			end
		end

	end
	if _posX ~= nil and _posY ~= nil then
		return _posX, _posY
	end
end

function gharcea:_getGoodPath(_v, _path, _length)
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
			--print("STUCK HERE")
			local _npx, _npy = self:weightActions(v)
			if _npx ~= nil and _npy ~= nil then
				return _npx, _npy
			else
				return v.x, v.y --self:selectWhatToAttack(v)
			end
		end
	end
end

function gharcea:weightActions(_v)
	-- is there an goal that can be performed / completed during this turn?
		-- first check to see if there's a capturable building nearby
		local v = _v
		local _bldList = building:_returnBuildingTable( )
		local atScore = 0
		--local moveScore = 0
		local _posX = nil
		local _posY = nil
		--print("GETTING MOVES ON BUILDING")
		for i = 1, #_bldList do
			local bld = _bldList[i]
			if (bld.team ~= unit:_returnTurn( ) and v.tp == 1) or (bld.team ~= unit:_returnTurn( ) and v.tp == 2) then -- not our team
				local unitInfo = unit:isLocEmpty(bld.x, bld.y)
				if unitInfo == nil then
				
					local distCheck = math.dist(v.x, v.y, bld.x, bld.y)
					local vpx = math.floor(v.x)
					local vpy = math.floor(v.y)
					local path, length = pather:getPath(vpx, vpy, bld.x, bld.y)
					--print("DIST IS: "..distCheck.."")
					if path ~= nil then -- just to be sure you can actually reach da building
						if length <= v.range then
							local moveScore = 0
							moveScore = moveScore + ( 2 ) + self._pointsEnemy + 10 - length
							if moveScore > atScore then
								atScore = moveScore
								_posX = bld.x
								_posY = bld.y
								--print("BUILDING LSIT BETTER SCORE: "..atScore.." AT : ".._posX.." | ".._posY.."")
							end
						end
					end
				else
					local _unit = unit:_returnTable()[unitInfo]
					if _unit.team ~= unit:_returnTurn() then
						local vpx = math.floor(v.x)
						local vpy = math.floor(v.y)
						
						local moveScore = 0
						local distCheck = math.dist(v.x, v.y, _unit.x, _unit.y)
						local path2, length2 = pather:getPath(vpx, vpy, _unit.x, _unit.y)
						if distCheck <= v.range and length2 <= v.range then
							local path, length = pather:getPath(vpx, vpy, _unit.x, _unit.y)
							local unitScore = self:scoreUnit(_unit)
							moveScore = moveScore + (2) + unitScore + 10 - distCheck
							if moveScore > atScore and path ~= nil and length > 1 and length <= v.range then
								--_posX, _posY = self:findFreeSpot(j.x, j.y)
								_posX, _posY = self:findFreeSpot(_unit.x, _unit.y, v.attack_range)

								atScore = moveScore
							--else
								--self:selectWhatToAttack(v)
							end
						end
					end
				end
			end
		end


		-- now, let's see if there's an enemy nearby
		local currentUnitScore = self:scoreUnit(v)
		local unitList = unit:_returnTable( )
		--print("MOVING ON UNITS!")
		for k,j in ipairs(unitList) do
			if j.team ~= unit:_returnTurn( ) then
				local distCheck = math.dist(v.x, v.y, j.x, j.y)
				local path2, length2 = pather:getPath(v.x, v.y, j.x, j.y)
				if distCheck <= v.range and length2 <= v.range then 
					local jScore = self:scoreUnit(j) -- jScore! Like jPOP/jROCK but better <-- am drunk right now :D
					if jScore <= currentUnitScore + 150 then -- so he's probably weaker :D
						local moveScore = 0
						moveScore = jScore + 20 - distCheck + 10
						local enemyEngageCheck, threat = self:isEnemyNearOneOfOurBuildings(j)
						if enemyEngageCheck == true then
							--print("BITCH AT THE GATES")
							if threat == 1 then
								moveScore = moveScore + 9950 -- priority
							else
								moveScore = moveScore + 650
							end
						end

						local emptyX, emptY = self:findFreeSpot(j.x, j.y, v.attack_range)
						if emptyX == nil then
							print("EMPTY X IS NL")
						elseif emptY == nil then
							print("EMPTY Y IS NIL")
						end
						if moveScore >= 0 and emptyX ~= nil and emptY ~= nil then
							print("LET'SAAA DO DIIISSSSSS DWARFS")
							print("MOVE SCORE: "..moveScore.."")
							atScore = moveScore

							--print("MOVING ON UNIT")
							_posX, _posY = emptyX, emptY
							--print("UNITLIST BETTER SCORE: "..atScore.." AT : ".._posX.." | ".._posY.."")
						end
					end
				end
			end
		end

	return _posX, _posY

end

-- add a table of all enemy units.
function gharcea:getListOfUnits( )
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

function gharcea:getListOfEnemyUnits( )
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

function gharcea:getUnitsLeftToMove( )
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

function gharcea:getListOfUnitsSize( )
	return #self._enemyUnitList
end

function gharcea:getListOfBuildings(_list)
	self._buildingList = {}
	self._buildingList = _list
end

function gharcea:removeUnitFromTable( )
	local units = self:getUnitsLeftToMove( )
	--if #units > 0 then
	table.remove(units, self._unitIDX)	
	--else
		
	--end
	--print("GETTING LIST OF UNITS" )
	self:getListOfUnits(  ) 
	local szUnits = #units
	--print("SIZE UNITS: "..szUnits.."")
	if szUnits < 0 then
		--print(" ENDING TURN" )
		self:endTurn( )
	end
	--table.remove(self._enemyUnitList, self._unitIDX)
	--francois:incIDX( )
	
	--francois:endTurn( )
	
	--print("DONE WITH FUNCTION")
	self:getTactical( )
end

function gharcea:getTargetLocation(_unit, _x, _y, _chkForPath)
	local v = _unit

	if v.isMoving == false then
		v.goal_x, v.goal_y = _x, _y
	
		--print("GOAL FUCKING X IS: ".._x.." AND GOAL FUCKING Y IS: ".._y.."")
		if pather.grid:isWalkableAt(v.goal_x, v.goal_y) then
			print("WE CAN HAZ GO")
			local __x = math.floor(v.x)
			local __y = math.floor(v.y)
			Game:updatePathfinding()
			--local __posX, __posY = self:getClosestFreePointOnPath(v, v.goal_x, v.goal_y)
			v.path, v.length = pather:getPath(__x, __y, v.goal_x, v.goal_y)

			if v.path ~= nil --[[and v.length <= v.range--]] then
				print("WE CAN HAZ GO PATH NAO!!!!")
				local test = math.dist(__x, __y, v.goal_x, v.goal_y)
				v.issuedOrder = true -- the unit has been commanded to move
				v.moveTimer = Game.worldTimer
				v.isThere = false
				v.objectiveSet = true
				v.isMoving = true
				--unit:_colorPath(v.path, v.length)	

			else
				--Game:updatePathfinding()
				--self:endTurn( )
				v.done = true
				self:removeUnitFromTable( )
				--self:getTargetLocation(_unit, _x, _y)
				
				--self:removeUnitFromTable( )--self:endTurn( )
			end
		else
			Game:updatePathfinding()
			--self:endTurn( )
			v.done = true
			self:removeUnitFromTable( )
		end
	end
end

function gharcea:moveTowardsTarget(_unit)
	v = _unit

	if v.path ~= nil then
		if v.isThere == false then
			--camera:followOffset(v.x, v.y)
			--[[print("LENGTH IS: "..#v.path.." AND CUR IS: "..v.cur.."")
			print("LENGTH IS: "..#v.path.." AND CUR IS: "..v.cur.."")
			print("LENGTH IS: "..#v.path.." AND CUR IS: "..v.cur.."")
			print("LENGTH IS: "..#v.path.." AND CUR IS: "..v.cur.."")
			print("LENGTH IS: "..#v.path.." AND CUR IS: "..v.cur.."")--]]
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
					

					
					if v.cur <= _rangeMax then
						v.cur = v.cur + 1
					else
						--unit:_clearPathTable( )
						v.isMoving = false
								--unit:_addRange(_id)
						
						v.isThere = true	
						v.done = true
						self._bestScore = -55
						v.objectiveSet = false
						v.isMoving = false
						self._OnePath = true
						self:selectWhatToAttack(v)
						v.cur = 1
						self:removeUnitFromTable( )
						self:getListOfUnits( )
					
					end
				end
			--	v.moveTimer = Game.worldTimer

			--end

		end
	end

end

function gharcea:selectWhatToAttack(_v)
	local v = _v

	-- get list of enemis near our unit
	local unitList = unit:_returnTable( )
	local targetID = nil
	local unitScore = self:scoreUnit(v)

	local scoreModifier = 0 -- if enemies are at the gates, they will kamikaze the enemy
	local enemyEngageCheck, threat = self:isEnemyNearOneOfOurBuildings(v)
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
				print("CHOOSING TARGET")
				local targetScore = self:scoreUnit(j)

				if targetScore <= unitScore + scoreModifier + 2000 then
					targetID = i
					print("WE HAZ TARGET")
				end
			end
		end
	end

	if targetID ~= nil then
		local target = unit:_returnTable()[targetID]
		local dmg_tar = unit:_calculateAttack(v, target)
		local dmg_attk = unit:_calculateAttack(target, v)
		target.hp = target.hp - dmg_tar
		anim:setState(target.img, "HURT", "MOVE_LEFT")
		local distCheck = math.dist(target.x, target.y, v.x, v.y)
		if target.hp > 0.02 and distCheck <= target.attack_range then
			v.hp = v.hp - dmg_attk
			anim:setState(v.img, "HURT", "MOVE_LEFT")
		end

	end
end

function gharcea:findFreeSpot(_x, _y, _range)
	local posX = nil
	local posY = nil
	local rScore = 0
	for x = -_range, _range do
		for y = -_range, _range do
			--if x ~= 0 and y ~= 0 then
				local distCheck = math.dist(x, y, _x + x, _y + y )
				if unit:_isWalkable(_x + x, _y + y) and unit:isLocEmpty(_x + x, _y + y) == nil then
						print("WALKABLE")
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
		print("FREE SPOT X: "..posX.." FREE SPOT Y: "..posY.."")

	end
	return posX, posY
end

function gharcea:moveToPathZone(_unit, _path)
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

function gharcea:getClosestPointToPoint(_unit, _destX, _destY)
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
					--	print("LENGTH "..length.."")
						local distCheck = math.dist(v.x-x, v.y-y, _destX, _destY)
						--if distCheck < score then
							score = distCheck
							posX = v.x-x
							posY = v.y-y
							--print("NEW POS X: "..posX.." NEW POST Y "..posY.."")
						--end
					end
				end
			end
		end
	end

	return posX, posY
end

function gharcea:_enemiesAtTheGames( )
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

function gharcea:isEnemyNearOneOfOurBuildings(_v)
	local _unit = _v
	for i, v in ipairs(building:_returnBuildingTable( ) ) do
		if v.team == unit:_returnTurn( ) then
			local distCheck = math.dist(_unit.x, _unit.y, v.x, v.y) 
			if distCheck <= _unit.range then
					local id = 0
					if v._type == 1 then
						id = 1
					end

				return true, id
			end
		end
	end
end

function gharcea:getClosestFreePointOnPath(_v, _goalX, _goalY )
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
			print("HERE")
			posX = j._x
			posY = j._y
			score = atScore
		end
	end
	return posX, posY
end