dave = {}

function dave:init( )
	self._name = "Dave"
	self._goal = nil -- no goal at the start

	self._goalX = nil
	self._goalY = nil

	self._enemyUnitList = {} -- keeps track of all units on the route to the goal
	self._pathList = {} -- keeps track of all the possible paths to the goal
	self._buildingList = {} -- keeps track of neutral and enemy buildings towards the goal object

	-- score modifiers
	self._tAttackModifier = 1
	self._tDefenseModifier = 1 -- defense and attack terrain modifiers are not in yet. 
	self._movePrefference = 4 -- preffer to move then keep the unit still
	self._blockSpawnPoints = 3 -- preffer to not block spawn points in HQ's
	self._engangeEnemy = 6 -- prefference to attack the enemy should be jigh
	self._captureTown = 5 -- should capture towns
	self._captureHQ = 7 -- prefference to gain control of a HQ
	self._capturePossibleLocation = 15 -- small weight for a villageo utside of range

	self._unitIDX = 1 -- start with the first unit in the unitList

	self._ONCE = false

	self._bestScore = -200
end

function dave:setGoal(_goalObject)
	--[[
		The goal object here can either be:
		1 unit
		1 building
			- HQ
			- TOWN
	]]

	self._goal = _goalObject
	self._goalX = _goalObject.x 
	self._goalY = _goalObject.y 


end

-- add a table of all enemy units.
function dave:getListOfUnits(_list)
	self._enemyUnitList = {}
	local tempList = {}

	for i,v in ipairs(unit:_returnTable( ) ) do
		if v.team == unit:_returnTurn( ) then
			table.insert(tempList, i)
		end
	end
	self._enemyUnitList = tempList
end

function dave:getListOfUnitsSize( )
	return #self._enemyUnitList
end

function dave:getListOfBuildings(_list)
	self._buildingList = {}
	self._buildingList = _list
end

function dave:canSurviveAttack(_dUnit, _pUnit) -- Dave Unit, Player Unit
	local dHP = _dUnit.hp 
	local pHP = _pUnit.hp 
	local dDmg = _dUnit.damage 
	local pDmg = _dUnit.damage

	dHP = dHP - pDmg 

	--[[if dHP > 0 then
		return true
	else
		return false
	end--]]
	return true
end

function dave:canKillEnemy(_dUnit, _pUnit)
	local dHP = _dUnit.hp 
	local pHP = _pUnit.hp 
	local dDmg = _dUnit.damage 
	local pDmg = _dUnit.damage

	pHP = pHP - dDmg

	--[[if pHP > 0 then
		return false
	else
		return true
	end--]]
	return true
end

function dave:scoreAttackForUnit(_dUnit, _locX, _locY)
	local score = 0
	local enemyList = self:getEnemiesInRange(_dUnit)
	local enemy = nil
	for i, k in ipairs(enemyList) do 
		local v = unit:_returnTable()[k]
		if math.dist(v.x, v.y, _locX, _locY) <= _dUnit.range then
			if self:canSurviveAttack(_dUnit, v) == true then
				if self:canKillEnemy(_dUnit, v) == true then
					score = score + self._engangeEnemy *  40
					enemy = i
					--print("BAAAA")
				else
					score = score + self._engangeEnemy * 40
					enemy = i
					--print("RUPEI FASUU")
				end
			else
				score = score - self._engangeEnemy - v.hp  -- do not engange if will get killed...
				enemy = i
				--print("DAI LA BEREGATAAAAA")
			end
		elseif math.dist(v.x, v.y, _locX, _locY) >= _dUnit.range and math.dist(v.x, v.y, _locX, _locY) <= _dUnit.range*4 then
			if self:canSurviveAttack(_dUnit, v) == true then
				if self:canKillEnemy(_dUnit, v) == true then
					score = score + self._engangeEnemy *  13
				else
					score = score + self._engangeEnemy * 13
				end
			end			
		end
	end

	if enemy ~= nil then
		--[[print("ENEMY IS: "..enemy.."")
		print("ENEMY IS: "..enemy.."")
		print("ENEMY IS: "..enemy.."")
		print("ENEMY IS: "..enemy.."")
		print("ENEMY IS: "..enemy.."")
		print("ENEMY IS: "..enemy.."")
		print("ENEMY IS: "..enemy.."")
		print("ENEMY IS: "..enemy.."")
		print("ENEMY IS: "..enemy.."")--]]
	end
	return score, enemy
end

function dave:scoreLocationForUnit(_dUnit, _locX, _locY) 
	score = 0
	if _locX == _dUnit.x and _locY == _dUnit.y then
		score = -5
	end -- preffer to move, instead of standing still
	score = score + self._tAttackModifier -- update score based on _loc modifier. Not implemented yet :)
	score = score + self._tDefenseModifier -- update score based on _loc modifier. Not implemented yet :)
	
	local buildingTable = building:_returnBuildingTable( )
	dave:getListOfBuildings(buildingTable) -- update list of all game buildings
	local buildingList = self._buildingList
	for i,v in ipairs(buildingList) do
		if unit:isLocEmpty(v.x, v.y) == nil then
			if v.team ~= unit:_returnTurn( ) then -- so it's either a player building or a neutral one
				local multiplier = 1
				if v.team == 0 then
					multiplier = 5
				else
					multiplier = 7
				end
				if v.x == _locX and v.y == _locY then
					local distanceCheck = math.dist(v.x, v.y, _dUnit.x, _dUnit.y)
					if distanceCheck <= _dUnit.range then
						if v._type == 1 then -- is it a HQ?
							score = score + self._captureHQ * 40 *  multiplier
						elseif v._type == 2 then
							score = score + self._captureTown * 40 *  multiplier
						end
					elseif distanceCheck >= _dUnit.range and distanceCheck <= _dUnit.range*4 then
						if v._type == 1 then -- is it a HQ?
							score = score + self._captureHQ * 20 *  multiplier
						elseif v._type == 2 then
							score = score + self._captureTown * 20 *  multiplier
						end
					else
						score = score + self._capturePossibleLocation * distanceCheck 
					end
				else
					local proximityScore = math.dist(v.x, v.y, _locX, _locY)
					score = score*multiplier*proximityScore
				end
			else
				score = score - self._blockSpawnPoints
			end
		end
	end

	return score
end

function dave:getPossibleLocationsInRange(_dUnit)
	--:_isWalkable(_x, _y)
	local moveList = {}
	for _x = - (_dUnit.range), _dUnit.range do
		for _y = -(_dUnit.range), _dUnit.range do
			
			local _team
			if unit:_returnTurn( ) == 1 then
				_team = 3
			else
				_team = 3
			end
			if unit:_inRange(_dUnit.x -_x, _dUnit.y - _y, _dUnit) == true and unit:_isWalkable(_dUnit.x - _x, _dUnit.y - _y) and unit:GlobalgetAtPos(_dUnit.x - _x, _dUnit.y - _y, _team ) == nil then
				local temp = {
					x = _dUnit.x - _x,
					y = _dUnit.y - _y,
				}
				table.insert(moveList, temp)
			else
			--	print("NOT WALKABLE AT: ".._x.." AND ".._y.."")
			end
		end
	end
--[[	local x1 = 1
	local y1 = 1
	local x2, y2 = map:returnSize( )

	for _x = x1, x2 do
		for _y = y1, y2 do
			if unit:_isWalkable(_x, _y) and unit:isLocEmpty(_x, _y) == nil then
				local temp = {
					x = _x,
					y = _y,
				}
				table.insert(moveList, temp)
			else
				--print("NOT WALKABLE AT: ".._x.." AND ".._y.."")
			end
		end
	end--]]
	return moveList
end

function dave:getEnemiesInRange(_dUnit)
	local unitList = self._enemyUnitList
	local enemiesInRange = {}
	for i,v in ipairs( unit:_returnTable( ) ) do 
		--if math.dist(v.x, v.y, _dUnit.x, _dUnit.y) <= _dUnit.range*2 then
		if v.team ~= unit:_returnTurn( ) then
			if math.dist(v.x, v.y, _dUnit.x, _dUnit.y) <= _dUnit.attack_range then
				table.insert(enemiesInRange, i)
			end
		end
		--end
	end


	return enemiesInRange -- return all the enemiesInRange
end


function dave:submitBestMoveForUnit(_dUnit)
	--local bestScore = 0 -- prefer to DO something rather then NOTHING
	local cBestMove = {}
	local currentScore = 0
	local moveX = _dUnit.x
	local moveY = _dUnit.y
	--rival = nil
	--print("UNIT X: ".._dUnit.x.." UNIT Y: ".._dUnit.y.."")
	cBestMove.x = _dUnit.x
	cBestMove.y = _dUnit.y
	local attackScore = 0
	local rival = nil
	local moveList = dave:getPossibleLocationsInRange(_dUnit)
	--print("MOVE LIST SIZE: "..#moveList.."")
	for i,v in ipairs(moveList) do
		--print("Move List size is: "..#moveList.."")
		--print(" UNIT IS: ".._dUnit.x.." AND Y: ".._dUnit.y.."")
		--if math.dist(v.x, v.y, _dUnit.x, _dUnit.y) <= _dUnit.range then
			local moveScore = self:scoreLocationForUnit(_dUnit, v.x, v.y)
			attackScore, rival = self:scoreAttackForUnit(_dUnit, v.x, v.y)

			local endScore = moveScore + attackScore

			if moveScore > attackScore then
				currentScore = moveScore
				moveX = v.x
				moveY = v.y
				--print("MOVE SCORE IS: "..moveScore.."")
			elseif attackScore > moveScore then
				--print(" ATTACK SCORE IS: "..attackScore.."")
				currentScore = attackScore
				moveX, moveY = unit:_findNearestEmptySpot(v.x, v.y, _dUnit.attack_range)

				--moveX = v.x
				--moveY = v.y
			end

			--print("currentScore: "..currentScore.." best score is: "..self._bestScore.."")

			if currentScore > self._bestScore then
				cBestMove.x = moveX
				cBestMove.y = moveY
				self._bestScore = endScore
			end 
		--end
	end

	--return cBestMove.x, cBestMove.y
	_dUnit.goal_x = cBestMove.x
	_dUnit.goal_y = cBestMove.y

	_dUnit.objectiveSet = true

	--[[for x = 1, #moveList do
		
		print("X AND Y: "..moveList[x].x.." "..moveList[x].y.."" )
	end--]]
	

end


function dave:think( )

	local szList = dave:getListOfUnitsSize( )
	if szList > 0 then
		local list = self._enemyUnitList
		local _unit

		if #list > 0 then
			__unit = list[self._unitIDX]
			_unit = unit:_returnTable( )[__unit]

			if _unit.objectiveSet == false then
				self:submitBestMoveForUnit(_unit)
			else
				dave:moveUnits(_unit)
			end
			
		else
			dave:EndTurn( )
		end
	else
		if self._ONCE == false then
			dave:getListOfUnits( unit:_getListOfPcUnits( ) )
			self._ONCE = true
		else
			dave:EndTurn( )
		end
	end
end

function dave:incIDX( )
	local szList = dave:getListOfUnitsSize( )
	if self._unitIDX < szList then
		self._unitIDX = self._unitIDX + 1
	else
		dave:EndTurn( )
		self._unitIDX = 1
	end
end

function dave:EndTurn( )

	unit:_resetStats( unit:_returnTurn( ) )
	self._enemyUnitList = {}
	unit:advanceTurn( )		
	self._ONCE = false	
	self._bestScore = 0
end

function dave:removeUnitFromTable( )
	--table.remove(self._enemyUnitList, self._unitIDX)
	dave:incIDX( )
	
end

function dave:moveUnits(_unit, _x, _y)
	if _unit.issuedOrder == false then
		
		 dave:getTargetLocation(_unit, _unit.goal_x, _unit.goal_y)

	else
		
		dave:moveTowardsTarget(_unit)
	end
end

function dave:getTargetLocation(_unit, _x, _y)
	v = _unit
	if v.isMoving == false then
		v.goal_x = _x
		v.goal_y = _y
		if pather.grid:isWalkableAt(v.goal_x, v.goal_y) then
			local __x = math.floor(v.x)
			local __y = math.floor(v.y)
			v.path, v.length = pather:getPath(__x, __y, v.goal_x, v.goal_y)
			if v.path ~= nil then
				--print("LEGTH IS: "..v.length.."")
				v.issuedOrder = true -- the unit has been commanded to move
				v.moveTimer = Game.worldTimer
				v.isThere = false
				v.objectiveSet = true
				unit:_colorPath(v.path, v.length)	

			else
				--dave:removeUnitFromTable( )
				dave:EndTurn( )
			end

		end
	end
end

function dave:attackWithUnit(_unit) 
	_dUnit = _unit
	local enemiesInRange = dave:getEnemiesInRange(_dUnit)

	for i,k in ipairs(enemiesInRange) do
		v = unit:_returnTable( )[k]
		if self:canSurviveAttack(_dUnit, v) == true then
			v.hp = v.hp - _dUnit.damage
		end
	end
end

function dave:moveTowardsTarget(_unit)
	v = _unit

	if v.path ~= nil then
		if v.isThere == false then
			local _x = math.floor(v.path[v.cur].x)
			local _y = math.floor(v.path[v.cur].y)
			if Game.worldTimer > v.moveTimer + v.speed then
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
				local _rangeMax = v.length

				-- think two steps ahead but only move for 1
				--[[if v.length > v.range then
					_rangeMax = v.range
				elseif v.length <= v.range then
					_rangeMax = v.length
				end--]]
				if v.x == _x and v.y == _y then
					

					
					if v.cur <= _rangeMax then
						v.cur = v.cur + 1
					else
						unit:_clearPathTable( )
						v.isMoving = false
								--unit:_addRange(_id)
						v.cur = 1
						v.isThere = true	
						v.done = true
						self._bestScore = -200
						v.objectiveSet = false

						--- handle attacking here
						--dave:attackWithUnit(v)

						dave:removeUnitFromTable( )				
					end
				end
				v.moveTimer = Game.worldTimer

			end

		end
	end

end