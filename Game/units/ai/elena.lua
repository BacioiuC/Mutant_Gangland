elena = {}

function elena:init( )
	self._name = "elena"
	self._goal = nil -- no goal at the start

	self._goalX = nil
	self._goalY = nil

	self._enemyUnitList = {} -- keeps track of all units on the route to the goal
	self._enemyLeftToMove = { } -- keeps track of all our units that have not moved yet

	self._pathList = {} -- keeps track of all the possible paths to the goal
	self._buildingList = {} -- keeps track of neutral and enemy buildings towards the goal object

	self._killGoals = { } -- adds all enemies as a kill goal
	self._captureGoal = { } -- adds all buildings as a capture goal

	-- score modifiers
	self._tAttackModifier = 0
	self._tDefenseModifier = 0 -- defense and attack terrain modifiers are not in yet. 
	self._movePrefference = -3 -- preffer to move then keep the unit still
	self._blockSpawnPoints = 300 -- preffer to not block spawn points in HQ's
	self._engangeEnemy = 7 -- prefference to attack the enemy should be jigh
	self._engageEnemyNearOwnBuilding = 9
	self._captureTown = 6 -- should capture towns
	self._captureHQ = 7 -- prefference to gain control of a HQ
	self._capturePossibleLocation = 15 -- small weight for a villageo utside of range

	self._unitIDX = 1 -- start with the first unit in the unitList

	self._ONCE = false

	self._bestScore = -25

	self._startTurn = false

	self.gold = 30
end

function elena:getGoldAvailable( )
	return self.gold
end

function elena:addGold(_value)
	self.gold = self.gold + _value
end

function elena:setGoal(_goalObject)

	self._goal = _goalObject
	self._goalX = _goalObject.x 
	self._goalY = _goalObject.y 

end

-- add a table of all enemy units.
function elena:getListOfUnits( )
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

function elena:getListOfEnemyUnits( )
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

function elena:getUnitsLeftToMove( )
	self._enemyLeftToMove = {}
	for i,k in ipairs(self._enemyUnitList) do
		local v = unit:_returnTable()[k]
		if v ~= nil then
			if v.done == false then
				table.insert(self._enemyLeftToMove, k)
			end
		else
			self:EndTurn( )
		end
	end

	return self._enemyLeftToMove
end

function elena:getListOfUnitsSize( )
	return #self._enemyUnitList
end

function elena:getListOfBuildings(_list)
	self._buildingList = {}
	self._buildingList = _list
end

function elena:canSurviveAttack(_dUnit, _pUnit) -- elena Unit, Player Unit
	local dHP = _dUnit.hp 
	local pHP = _pUnit.hp 
	local dDmg = _dUnit.damage 
	local pDmg = _dUnit.damage

	dHP = dHP - pDmg 

	if dHP > 0 then
		return true
	else
		return false
	end
	return true
end

function elena:canKillEnemy(_dUnit, _pUnit)
	local dHP = _dUnit.hp 
	local pHP = _pUnit.hp 
	local dDmg = _dUnit.damage 
	local pDmg = _dUnit.damage

	pHP = pHP - dDmg

	if pHP > 0 then
		return false
	else
		return true
	end
	return true
end

function elena:scoreAttackForUnit(_dUnit, _locX, _locY)
	local score = 0
	local posX = nil
	local posY = nil
	if _locX == _dUnit.x and _locY == _dUnit.y then
		score = 0
	end
	local enemyList = elena:getListOfEnemyUnits( )
	local buildingTable = building:_returnBuildingTable( )
	elena:getListOfBuildings(buildingTable)
	local buildingList = self._buildingList

	local _enUnit = nil

	for i,l in ipairs(enemyList) do
		local v = unit:_returnTable()[l]
		-- first get enemies that are in range
		local distCheck = math.dist(v.x, v.y, _dUnit.x, _dUnit.y)
		if distCheck <= _dUnit.range then
			if distCheck >= _dUnit.range and distCheck <= _dUnit.range + _dUnit.attack_range + 2 then
				score = score + self._engangeEnemy/2 * (20 - distCheck)
			else
				score = score + self._engangeEnemy*(20 - distCheck) -- the closer the enemy, the bigger the score
			end
			repeat
				posX, posY = unit:_findNearestEmptySpot(v.x, v.y, _dUnit.attack_range)
			until unit:isLocEmpty(posX, posY) == nil
			--[[if unit:isLocEmpty(posX, posY) ~= nil then
				posX, posY = unit:_findNearestEmptySpot(v.x, v.y, _dUnit.attack_range)
			end--]]
			_enUnit = l
		end

		-- then check if an enemy is enganging or is near one of your own buildings
		for j,k in ipairs(buildingList) do
			if k.team == _dUnit.team then
				local distBuildingCheck = math.dist(k.x, k.y, v.x, v.y)
				if distBuildingCheck <= v.attack_range then
					score = score + self._engageEnemyNearOwnBuilding * 2 *(20 - distBuildingCheck )
					repeat
						posX, posY = unit:_findNearestEmptySpot(v.x, v.y, _dUnit.attack_range)
					until unit:isLocEmpty(posX, posY) == nil
					_enUnit = l
				end
			end
		end
	end


	return score, posX, posY, _enUnit
end

function elena:scoreLocationForUnit(_dUnit, _locX, _locY) 
	score = 0
	local posX = nil
	local posY = nil
	if _locX == _dUnit.x and _locY == _dUnit.y then
		score = -2 -- preffer to move
	end
	--score = score + (self._tAttackModifier + self._tDefenseModifier)
	local buildingTable = building:_returnBuildingTable( )
	elena:getListOfBuildings(buildingTable)
	local buildingList = self._buildingList
	for i,v in ipairs(buildingList) do
		if unit:isLocEmpty(v.x, v.y) == nil then 
			-- if it's empty go for it
			if v.team ~= unit:_returnTurn( ) then
				local multiplier = 1
				if v.team == 0 then
					multiplier = 4
				else
					multiplier = 5
				end
				if v.x == _locX and v.y == _locY then
					if v._type == 1 then
						score = score + self._captureHQ * multiplier
					else
						score = score + self._captureTown * multiplier
					end
				end
			end
			--print("SCORE IS: "..score.."For building id: "..i.."")
		else
			-- if it's not then pffuck! Get closer
			--if v.team == unit:_returnTurn( ) then
				--score = score -  5
			--end
		end


	end

	return score
end

function elena:getPossibleLocationsInRange(_dUnit)

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
			
			end
		end
	end

	return moveList
end

function elena:getEnemiesInRange(_dUnit)
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


function elena:submitBestMoveForUnit(_dUnit)
	local cBestMove = {}
	cBestMove.x = _dUnit.x
	cBestMove.y = _dUnit.y
	cBestMove.enemy = nil
	local currentScore = -5
	local moveList = dave:getPossibleLocationsInRange(_dUnit)
	--for i,v in ipairs(moveList) do
	repeat
		local rnd = math.random(1, #moveList)
		local v = moveList[rnd]
			local moveScore, posX, posY = self:scoreLocationForUnit(_dUnit, v.x, v.y)

			--print("MOVE SCORE IS: "..moveScore.." and Best Score is: "..self._bestScore.."")
			if moveScore > currentScore then
				cBestMove.x = v.x
				cBestMove.y = v.y
				currentScore = moveScore		
				--print("GOING FOR MOVEMENT")	
			end
			table.remove(moveList, rnd)
	until #moveList == 2

		local attackScore, _posX, _posY, _enUnit = elena:scoreAttackForUnit(_dUnit, _dUnit.x, _dUnit.y)
		if attackScore > currentScore then
			cBestMove.x = _posX
			cBestMove.y = _posY
			cBestMove.enemy = _enUnit
			currentScore = attackScore
			--print("ENGANGIN ENEMY")
		end
	--end
	if unit:isLocEmpty(cBestMove.x, cBestMove.y) == nil then
		_dUnit.goal_x = cBestMove.x
		_dUnit.goal_y = cBestMove.y
		_dUnit.rival = cBestMove.enemy
		_dUnit.objectiveSet = true
		--print("LOC IS EMPTY")
	else
		self:submitBestMoveForUnit(_dUnit)
		--print("LOC NOT EMPTY")
	end

end


function elena:think( )
	if self._startTurn == false then
		local aSize = self:getListOfUnits( ) -- see what unit she controls
		--print("SIZE: "..#aSize.."")

		if self:getListOfUnitsSize( ) == 0 then
			self:EndTurn( )
		else
			unit:_resetStats(1)
			unit:_resetStats(2)
			building:createUnits(unit:_returnTurn( ) )
			self:getListOfUnits( )
			self._startTurn = true
			
		end
	else
		local units = self:getUnitsLeftToMove( )
		--print("UNITS LFT TO MOVE: "..#units.."")

		if #units >= 0 then
			self:loopThroughMovableUnits(units)
		else
			self:EndTurn( )
		end
		
	end

end

function elena:loopThroughMovableUnits(_list)
	local _id = _list[#_list]
	--print("LIST TOTAL: "..#_list..". ID IS: ".._id.."")
	local v = unit:_returnTable()[_id]
	if v~=nil then
		if v.objectiveSet == false then
			elena:submitBestMoveForUnit(v)
		else
			elena:moveUnits(v, v.goal_x, v.goal_y)
		end
	else
		elena:EndTurn( )
	end

end




function elena:incIDX( )

	--[[if self._unitIDX < elena:getListOfUnitsSize( ) then
		self._unitIDX = self._unitIDX + 1
	else
		elena:EndTurn( )
		self._unitIDX = 1
	end--]]
	self._unitIDX = 1
end

function elena:EndTurn( )

	
	self._enemyUnitList = {}
		
	self._ONCE = false	
	self._bestScore = -25
	self._startTurn = false
	self._unitIDX = 1	
	unit:advanceTurn( )	
	
end

function elena:removeUnitFromTable( )
	local units = self:getUnitsLeftToMove( )
	--if #units > 0 then
	table.remove(units, self._unitIDX)	
	--else
		
	--end

	local szUnits = #units
	--print("SIZE UNITS: "..szUnits.."")
	if szUnits < 0 then
		self:EndTurn( )
	end
	--table.remove(self._enemyUnitList, self._unitIDX)
	--elena:incIDX( )
	
	--elena:EndTurn( )
end

function elena:createUnits( )

end

function elena:moveUnits(_unit, _x, _y)
	if _unit.issuedOrder == false then
		
		 elena:getTargetLocation(_unit, _unit.goal_x, _unit.goal_y)

	else
		
		elena:moveTowardsTarget(_unit)
	end
end

function elena:getTargetLocation(_unit, _x, _y)
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
				--unit:_colorPath(v.path, v.length)	

			else
				--elena:removeUnitFromTable( )
				self:EndTurn( )
			end

		end
	end
end

function elena:attackWithUnit(_unit) 

end

function elena:moveTowardsTarget(_unit)
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
				if v.length > v.range then
					_rangeMax = v.range
					--print("LEGNTH IS BIGGER THEN RANGE BY "..(v.length-v.range).." ")

				elseif v.length <= v.range then
					_rangeMax = v.length
				end

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
						local _xE
						local _yE
						if v.path[v.cur+2] ~= nil then
							_xE = math.floor(v.path[v.cur+2].x)
							_yE = math.floor(v.path[v.cur+2].y)
						else
							_xE = math.floor(v.path[v.cur+1].x)
							_yE = math.floor(v.path[v.cur+1].y)
						end

						if unit:isLocEmpty(_xE, _yE) == nil then
							v.cur = v.cur + 1
						else
							v.isMoving = false
									--unit:_addRange(_id)
							v.cur = 1
							v.isThere = true	
							v.done = true
							self._bestScore = -55
							v.objectiveSet = false
							v.isMoving = false

							if v.rival ~= nil then
								local _enUnit = unit:_returnTable()[v.rival]
								if _enUnit ~= nil then
									if math.dist(v.x, v.y, _enUnit.x, _enUnit.y) <= v.attack_range + 1 then
										_enUnit.hp = _enUnit.hp - v.damage
									end
								end
							end
							--- handle attacking here
							elena:attackWithUnit(v)

							elena:removeUnitFromTable( )	
							elena:getListOfUnits( )	
						end
					else
						--unit:_clearPathTable( )
						v.isMoving = false
								--unit:_addRange(_id)
						v.cur = 1
						v.isThere = true	
						v.done = true
						self._bestScore = -55
						v.objectiveSet = false
						v.isMoving = false

						if v.rival ~= nil then
							local _enUnit = unit:_returnTable()[v.rival]
							if _enUnit ~= nil then
								if math.dist(v.x, v.y, _enUnit.x, _enUnit.y) <= v.attack_range then
									_enUnit.hp = _enUnit.hp - v.damage
								end
							end
						end
						--- handle attacking here
						elena:attackWithUnit(v)

						elena:removeUnitFromTable( )	
						elena:getListOfUnits( )			
					end
				end
				v.moveTimer = Game.worldTimer

			end

		end
	end

end