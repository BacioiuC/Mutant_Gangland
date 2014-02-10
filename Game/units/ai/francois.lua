francois = {}

function francois:init( )
	self._name = "francois"
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
	self._blockSpawnPoints = 300 -- preffer to not block spawn points in HQ's
	self._engangeEnemy = 400 -- GTA STYLE -- prefference to attack the enemy should be jigh
	self._engageEnemyNearOwnBuilding = 3700
	self._captureTown = 80 -- should capture towns
	self._captureHQ = 90 -- prefference to gain control of a HQ
	self._capturePossibleLocation = 150 -- small weight for a villageo utside of range

	self._unitIDX = 1 -- start with the first unit in the unitList

	self._ONCE = false

	self._bestScore = -25

	self._startTurn = false

	self.gold = 30

	self._goalType = {}
	self._goalType[1] = "FORTIFY"
	self._goalType[2] = "ATTACK"
	self._goalType[3] = "CAPTURE"

	self._OnePath = false

end

function francois:getGoldAvailable( )
	return self.gold
end

function francois:addGold(_value)
	self.gold = self.gold + _value
end

function francois:getCaptureGoals( )
	self._captureGoal = { }
	for i, v in ipairs(building:_returnBuildingTable( )) do
		if v.team ~= unit:_returnTurn( ) then
			table.insert(i, self._captureGoal)
		end
	end

	return self._captureGoal
end


function francois:getKillGoals( )
	self._killGoals = {}
	for i,v in ipairs(unit:_returnTable( ) ) do
		if v.team ~= unit:_returnTurn( ) then
			table.insert(self._killGoals, i)
		end
	end

	return self._killGoals
end

function francois:getCaptureGoals( )

end

function francois:setGoal(_goalObject)

	self._goal = _goalObject
	self._goalX = _goalObject.x 
	self._goalY = _goalObject.y 

end

-- add a table of all enemy units.
function francois:getListOfUnits( )
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

function francois:getListOfEnemyUnits( )
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

function francois:getUnitsLeftToMove( )
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

function francois:getListOfUnitsSize( )
	return #self._enemyUnitList
end

function francois:getListOfBuildings(_list)
	self._buildingList = {}
	self._buildingList = _list
end

function francois:canSurviveAttack(_dUnit, _pUnit) -- francois Unit, Player Unit
	--[[local dHP = _dUnit.hp 
	local pHP = _pUnit.hp 
	local dDmg = _dUnit.damage 
	local pDmg = _dUnit.damage

	dHP = dHP - pDmg 

	if dHP > 0 then
		return true
	else
		return false
	end--]]
	return true
end

function francois:canKillEnemy(_dUnit, _pUnit)
	--[[local dHP = _dUnit.hp 
	local pHP = _pUnit.hp 
	local dDmg = _dUnit.damage 
	local pDmg = _dUnit.damage

	pHP = pHP - dDmg

	if pHP > 0 then
		return false
	else
		return true
	end--]]
	return true
end

function francois:scoreAttackForUnit(_dUnit, _locX, _locY)
	local score = 0
	local posX = nil
	local posY = nil
	--if _locX == _dUnit.x and _locY == _dUnit.y then
	--	score = 0
	--end
	local enemyList = francois:getListOfEnemyUnits( )
	local buildingTable = building:_returnBuildingTable( )
	francois:getListOfBuildings(buildingTable)
	local buildingList = self._buildingList

	local _enUnit = nil

	for i,l in ipairs(enemyList) do
		local v = unit:_returnTable()[l]
		-- first get enemies that are in range
		local distCheck = math.dist(v.x, v.y, _dUnit.x, _dUnit.y)
		if distCheck <= _dUnit.range then
			if distCheck >= _dUnit.range and distCheck <= _dUnit.range + _dUnit.attack_range then
				if francois:canSurviveAttack(_dUnit, v) == true then
					score = score + self._engangeEnemy/2 * (2000 - distCheck)
				else
					score = score - self._engangeEnemy
				end
			else
				if francois:canSurviveAttack(_dUnit, v) == true then
					score = score + self._engangeEnemy*(9000 - distCheck) -- the closer the enemy, the bigger the score
					if francois:canKillEnemy(_dUnit, v) == true then
						score = score + self._engangeEnemy*(500 - distCheck) 
					end
				else
					score = score - self._engangeEnemy
				end
			end
			--score = score + self._engangeEnemy/2 * (90 - distCheck)
--[[			repeat
				posX, posY = unit:_findNearestEmptySpot(v.x, v.y, _dUnit.attack_range, _dUnit)
			until unit:isLocEmpty(posX, posY) == nil--]]
			local _prix, _priy = 0
			for _ri = 1, 30 do
				_prix, _priy = unit:_findNearestEmptySpot(v.x, v.y, _dUnit.attack_range, _dUnit)
				if unit:isLocEmpty(_prix, _priy) == nil then
					posX = _prix
					posY = _priy
				end
			end
			if posX == 0 or posX == nil then
				score = -200 -- don't do that
			end				
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
					score = score + self._engageEnemyNearOwnBuilding * 925 *(990 - distBuildingCheck )
--[[					repeat
						posX, posY = unit:_findNearestEmptySpot(v.x, v.y, _dUnit.attack_range, _dUnit)
					until unit:isLocEmpty(posX, posY) == nil--]]
					local _prix, _priy = 0
					for _ri = 1, 30 do
						_prix, _priy = unit:_findNearestEmptySpot(v.x, v.y, _dUnit.attack_range, _dUnit)
						if unit:isLocEmpty(_prix, _priy) == nil then
							posX = _prix
							posY = _priy
						end
					end
					if posX == 0 or posX == nil then
						score = -200 -- don't do that
					end						
					_enUnit = l
				end
			end
		end
	end


	return score, posX, posY, _enUnit
end

function francois:scoreLocationForUnit(_dUnit, _locX, _locY) 
	score = -5
	if _dUnit.hasGoal == false then
		local posX = nil
		local posY = nil
		--if _locX == _dUnit.x and _locY == _dUnit.y then
		local rndHQ = building:_returnRandomEnemyHq( )
		if rndHQ ~= nil then

			local distChk = math.dist(_locX, _locY, rndHQ.x, rndHQ.y)
			score = score + (30 - distChk)

		end	
		--end
		--score = score + (self._tAttackModifier + self._tDefenseModifier)
		local buildingTable = building:_returnBuildingTable( )
		francois:getListOfBuildings(buildingTable)
		local buildingList = self._buildingList
		for i,v in ipairs(buildingList) do
			if unit:isLocEmpty(v.x, v.y) == nil then 
				-- if it's empty go for it
				if v.team ~= unit:_returnTurn( ) then
					local multiplier = 1
					if v.team == 0 then
						multiplier = 4
					else
						multiplier = 8
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

			end


		end
	end
	return score
end

function francois:getPossibleLocationsInRange(_dUnit)
	--unit:_removeRange( )
	local moveList = {}
	local v = _dUnit
	
	
	for _x = - (_dUnit.range), _dUnit.range do
		for _y = -(_dUnit.range), _dUnit.range do

			if unit:_isWalkable(v.x-_x, v.y-_y) and unit:isLocEmpty(v.x-_x, v.y-_y) == nil then		
				local path, length = pather:getPath(v.x, v.y, v.x-_x, v.y-_y)
				if path ~= nil then
					for i = 1, length do
						if v.ap > (i + map:getTileCost(v.x-_x, v.y-_y) ) and length <= v.range then
							local temp = {
								x = _dUnit.x - _x,
								y = _dUnit.y - _y,
							}
							table.insert(moveList, temp)
						end
					end
				end
			end
		end
	end


	return moveList
end

function francois:_inRange(_x, _y, _dUnit)
	local _bool = false
	local _unit
	local v
	v = _dUnit

	for i, v in ipairs(self._rangeTable) do
		if _x == v.x and _y == v.y then
			_bool = true
		end
	end


	return _bool
end

function francois:getEnemiesInRange(_dUnit)
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


function francois:submitBestMoveForUnit(_dUnit)
	local cBestMove = {}
	cBestMove.x = _dUnit.x
	cBestMove.y = _dUnit.y
	cBestMove.enemy = nil
	local currentScore = -25
	local moveList = self:getPossibleLocationsInRange(_dUnit)
	--for i,v in ipairs(moveList) do
	--repeat
	for i,v in ipairs(moveList) do
		--local rnd = math.random(1, #moveList)
		--local v = moveList[rnd]
		--print("LOOPING")
			local moveScore, posX, posY = self:scoreLocationForUnit(_dUnit, v.x, v.y)

			--print("MOVE SCORE IS: "..moveScore.." and Best Score is: "..self._bestScore.."")
			if moveScore > currentScore then
				cBestMove.x = v.x
				cBestMove.y = v.y
				--print("BEST MOVE: "..v.x.." | "..v.y.."")
				currentScore = moveScore		
				--print("GOING FOR MOVEMENT")	
			end
			--table.remove(moveList, rnd)
	end
	--until #moveList == 2
	--for i,v in ipairs(moveList) do
		local attackScore, _posX, _posY, _enUnit = self:scoreAttackForUnit(_dUnit)
		if attackScore > currentScore then
			cBestMove.x = _posX
			cBestMove.y = _posY
			cBestMove.enemy = _enUnit
			currentScore = attackScore
			--print("ENGANGIN ENEMY")
		end
	--end
	--end
	--if unit:isLocEmpty(cBestMove.x, cBestMove.y) == nil then
	--	print("LOC EMPTY IT IS! GOAL SET, WE SHALL")
		if _dUnit.hasGoal == false then
			--print("AND GOAL WAS SET")
			_dUnit.goal_x = cBestMove.x
			_dUnit.goal_y = cBestMove.y
			_dUnit.rival = cBestMove.enemy
			--print("X: "..cBestMove.x.." Y: "..cBestMove.y.."")
			--print("DISTANCE FROM: ".._dUnit.x.." TO ".._dUnit.goal_x.." IS: "..(_dUnit.x - _dUnit.goal_x).."")
			--print("DISTANCE FROM: ".._dUnit.y.." TO ".._dUnit.goal_y.." IS: "..(_dUnit.y - _dUnit.goal_y).."")
		end
		_dUnit.objectiveSet = true
		--print("LOC IS EMPTY")
	--else
	--	print("SUB MITTING")
		--unit:_removeRange( )
		--self:submitBestMoveForUnit(_dUnit)
		--print("LOC NOT EMPTY")
	--end

end

function francois:assignGoals(_dUnit)
	-- first check if any enemies are close to our buildings
	--for i,v in ipairs(unit:_returnTable( ) ) do
		--if v.team ~= unit:_returnTurn( ) then
			for k, j in ipairs(building:_returnBuildingTable( ) ) do
				if j.team ~= unit:_returnTurn( ) then
					-- check if enemy is near one of our buildings
					if math.dist(_dUnit.x, _dUnit.y, j.x, j.y) <= v.range*8 + v.attack_range then
						if v.hasGoal == false then
							_dUnit.goal_x = j.x
							_dUnit.goal_y = j.y
							--_dUnit.rival = i
							v.hasGoal = true
						end
					end
				end
			end
		--end
	--end
end

function francois:think( )
	if self._startTurn == false then
		building:createUnits(unit:_returnTurn( ) )

		local aSize = self:getListOfUnits( ) -- see what unit she controls
		--print("SIZE: "..#aSize.."")

		if self:getListOfUnitsSize( ) == 0 then
			--print("DEBUG END TURN WHEN LIST == 0")
			self:EndTurn( )

		else
			
			self:getListOfUnits( )
			--print("LAST HERE")
			--unit:_resetStats(1)
			--unit:_resetStats(2)
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

function francois:loopThroughMovableUnits(_list)
	local _id = _list[#_list]
	--print("LIST TOTAL: "..#_list..". ID IS: ".._id.."")
	local v = unit:_returnTable()[_id]
	if v~=nil then
		--self:assignGoals(v)
		if v.objectiveSet == false then
			francois:submitBestMoveForUnit(v)
		else
			francois:moveUnits(v, v.goal_x, v.goal_y)
		end
	else
		francois:EndTurn( )
	end

end




function francois:incIDX( )

	--[[if self._unitIDX < francois:getListOfUnitsSize( ) then
		self._unitIDX = self._unitIDX + 1
	else
		francois:EndTurn( )
		self._unitIDX = 1
	end--]]
	self._unitIDX = 1
end

function francois:EndTurn( )

	
	
		
	self._ONCE = false	
	self._bestScore = -25
	self._startTurn = false
	self._unitIDX = 1	
	unit:advanceTurn( )	
	
	--self._enemyUnitList = {}
end

function francois:removeUnitFromTable( )
	local units = self:getUnitsLeftToMove( )
	--if #units > 0 then
	table.remove(units, self._unitIDX)	
	--else
		
	--end
	print("GETTING LIST OF UNITS" )
	self:getListOfUnits(  ) 
	local szUnits = #units
	--print("SIZE UNITS: "..szUnits.."")
	if szUnits < 0 then
		print(" ENDING TURN" )
		self:EndTurn( )
	end
	--table.remove(self._enemyUnitList, self._unitIDX)
	--francois:incIDX( )
	
	--francois:EndTurn( )
	
	print("DONE WITH FUNCTION")
end

function francois:createUnits( )

end

function francois:moveUnits(_unit, _x, _y)
	if _unit.issuedOrder == false then
		-- check if an enemy next to
		 francois:getTargetLocation(_unit, _unit.goal_x, _unit.goal_y)

	else
		--print("ISSUED ORDER")	
		francois:moveTowardsTarget(_unit)
	end
end

function francois:getTargetLocation(_unit, _x, _y)
	v = _unit
	
	if v.isMoving == false then
		v.goal_x = _x
		v.goal_y = _y
		
		if pather.grid:isWalkableAt(v.goal_x, v.goal_y) then

			local __x = math.floor(v.x)
			local __y = math.floor(v.y)
			v.path, v.length = pather:getPath(__x, __y, v.goal_x, v.goal_y)
			if v.path ~= nil and v.length <= v.range then
				local test = math.dist(__x, __y, v.goal_x, v.goal_y)
				v.issuedOrder = true -- the unit has been commanded to move
				v.moveTimer = Game.worldTimer
				v.isThere = false
				v.objectiveSet = true
				--unit:_colorPath(v.path, v.length)	

			else
				Game:updatePathfinding()
				self:EndTurn( )
				--self:removeUnitFromTable( )
				--self:getTargetLocation(_unit, _x, _y)
				
				--self:removeUnitFromTable( )--self:EndTurn( )
			end

		end
	end
end

function francois:attackWithUnit(_v) 
	local v = _v
	if v.has_attacked == false then
		if v.rival ~= nil then
			local _enUnit = unit:_returnTable()[v.rival]
			if _enUnit ~= nil and v.has_attacked == false then
				if math.dist(v.x, v.y, _enUnit.x, _enUnit.y) <= v.attack_range then
					local dmg_tar = unit:_calculateAttack(v, _enUnit)
					local dmg_attk = unit:_calculateAttack(_enUnit, v)
					--local damage_target = ( v.damage*100/100+math.random(0, 9) ) *(v.hp/10)* ( (200 - ( 100+1*_enUnit.hp ))/100)
					_enUnit.hp = _enUnit.hp - dmg_tar
					anim:setState(_enUnit.img, "HURT", "MOVE_LEFT")
					--print("1 ATTACKED WITH UNIT"..v.name.." rival: "..v.rival.."")
					if _enUnit.hp > 0 then
						--local damage_attacker = ( _enUnit.damage*100/100+math.random(0, 9) ) *(v.hp/10)* ( (200 - ( 100+1*v.hp ))/100)
						v.hp = v.hp - dmg_attk
						anim:setState(v.img, "HURT", "MOVE_LEFT")
					end
					--image:setColor(_enUnit.img.img, 255, 1, 1, 1)
					--anim:updateAnim(damage_anim, _enUnit.act_x, _enUnit.act_y)
					--anim:setPosition(damage_anim, _enUnit.act_x, _enUnit.act_y)
					--if anim:getCurrentFrame(damage_anim) > 4 then
					--	anim:setPosition(damage_anim, 5000, 5000)
					--end
					v.has_attacked = true
				end
			end
		else
			for i,j in ipairs(unit:_returnTable() ) do
				if j.team ~= unit:_returnTurn( ) and v.has_attacked == false then
					if math.dist(j.x, j.y, v.x, v.y) <= v.attack_range then
						local dmg_tar = unit:_calculateAttack(v, j)
						local dmg_attk = unit:_calculateAttack(j, v)
						j.hp = j.hp - dmg_tar
						anim:setState(j.img, "HURT", "MOVE_LEFT")
						--print("2 ATTACKED WITH UNIT"..v.name.." rival: "..i.."")
						if j.hp > 0 then
							v.hp = v.hp - dmg_attk
							anim:setState(v.img, "HURT", "MOVE_LEFT")
						end
						--image:setColor(j.img.img, 255, 1, 1, 1)
						--anim:setPosition(damage_anim, j.act_x, j.act_y)	
						v.has_attacked = true				
					end
				end
			end
		end
	end

	--self:removeUnitFromTable( )	
	--self:getListOfUnits( )		
end

function francois:moveTowardsTarget(_unit)
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
						v.cur = 1
						v.isThere = true	
						v.done = true
						self._bestScore = -55
						v.objectiveSet = false
						v.isMoving = false
						self._OnePath = true
						francois:attackWithUnit(v)
						self:removeUnitFromTable( )
						self:getListOfUnits( )
					
					end
				end
				v.moveTimer = Game.worldTimer

			end

		end
	end

end