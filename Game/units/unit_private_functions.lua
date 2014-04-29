----------------------------------------
------ SELECTION/LOCATION --------------
----------------------------------------
function unit:_addSelected(_id)
	unit:_clearPathTable( )
	local v = self._unitTable[_id]
	local selNum = self:_getNumSelections( )	
	if v~= nil then
		if v.isSelected == true then
			self:_clearSelections( )
			unit:_removeRange( )
			unit:_clearPath( )
			interface:_toggleUnitInfoBox(false)
		else

			self:_clearSelections( )
			unit:_removeRange( )
			local _col = self._selectedColor[1]
			image:setColor(v.img.img, _col.r, _col.g, _col.b, _col.a)
			v.isSelected = true
			
			table.insert(self._selectedUnits, _id)

		end
	else
		--print("HOLY FUCK v IS NIL")
	end
	
end

function unit:_getRandomUnitForPlayer(_turn)
	local rUnit = self:_getRandomUnitOfTeam(_turn)
	return rUnit
end

function unit:_removeSelected(_id)
	local v = self._selectedUnits[_id]
	local _unit = self._unitTable[v]
	local _col = self._selectedColor[2]
	image:setColor(_unit.img.img, _col.r, _col.g, _col.b, _col.a)
	_unit.isSelected = false
	self:_removeRange( )
	interface:setTargetAtLoc(-200, 0)
	table.remove(self._selectedUnits, _id)
	--interface:_toggleUnitInfoBox(false)
end

function unit:_getNumSelections( )
	return #self._selectedUnits
end

function unit:_clearSelections( )
	for i = 1, self:_getNumSelections() do
		self:_removeSelected(i)
	end
	--unit:_removeRange( )
	unit:_clearPath( )
end

-- returns the INDEX of a unit in self._unitTable from self._selectedUnit
function unit:_getSelectedUnit( )
	if self:_getNumSelections( ) > 0 then
		return self._selectedUnits[1]
	else
		--print("NO SELECTIONS")
	end
end

function unit:_returnSelectionTable( )
	return self._selectedUnits
end


-- returns the INDEX of the unit found at _x, _y
function unit:_getAtPos(_x, _y, _optional)
	local _unit = nil
	--[[if _x == nil then
		_x = self._msx
		_y = self._msy
	end--]]
	for i,v in ipairs(self._unitTable) do
		if v.x == _x and v.y == _y then
			if _optional ~= nil then
				if v.team ~= _optional then
					if MouseDown == true then
						_unit = i
						MouseDown = false
						--print("LAST ONE HERE WITH OPTIONOL NOT NIL")
					end
				end
			else
				--print("LAST ONE HERE WITH")
				_unit = i
			end
		end
	end

	return _unit
end

function unit:_getBuildingAtPos(_x, _y, _optional)
	local _unit = nil
	--[[if _x == nil then
		_x = self._msx
		_y = self._msy
	end--]]
	local btable = building:_returnBuildingTable( )
	for i,v in ipairs(btable) do
		if v.x == _x and v.y == _y then
			if _optional ~= nil then
				if v.team ~= _optional then
					_unit = i
				end
			else
				--print("LAST ONE HERE WITH")
				_unit = i
			end
		end
	end

	return _unit
end

function unit:isLocEmpty(_x, _y)
	local _unit = nil
	for i,v in ipairs(self._unitTable) do
		if v.x == _x and v.y == _y then
			_unit = i

		end
	end

	return _unit
end

-- returns the INDEX of the unit found at _x, _y ON MOUSE UP ONLY
function unit:GlobalgetAtPos(_x, _y, _optional) 
	local _unit = nil
	--[[if _x == nil then
		_x = self._msx
		_y = self._msy
	end--]]
	for i,v in ipairs(self._unitTable) do
		if v.x == _x and v.y == _y then
			if _optional ~= nil then
				if v.team ~= _optional then
	
					_unit = i

				end
			else
				_unit = i
			end
		end
	end

	return _unit
end


function unit:_MouseToWorld( )
	local msx = self.___msx
	local msy = self.___msy

	local _mx = math.floor( (msx - self._offsetX + self._tileSize) 	/ self._tileSize )
	local _my = math.floor( (msy - self._offsetY + self._tileSize) / self._tileSize )

	self._msx = _mx
	self._msy = _my
	--print("MX: ".._mx.."MY ".._my.."")
	if unit:isLocEmpty(self._msx, self._msy) == nil then
	--	print("NOTHING HERE")
	else
	--	print("A FUCKER IS HERE")
	end
	return _mx, _my
end

---------------------------------------
----- PATHFINDING RELATED -------------
---------------------------------------
function unit:_drawMovementPath(_sx, _sy, _ex, _ey)
	local path = {}
	local length = 0
	if --[[unit:_inRange(_ex, _ey) and --]]_grid:isWalkableAt(_ex, _ey, walkable) then
		Game:updatePathfinding()
		path = pather:getPath(_sx, _sy, _ex, _ey)
		length = path:getLength( )
		if path ~= nil then
			--print("LENGTH IS: "..length.."")
			print("GOT SO FAR...")
			path:fill()
			unit:_colorPath(path, length+1)	
		else
			self:_clearSelections( )
		end
	else
		self:_clearSelections( )
	end
end

function unit:_getTargetLocation(_tPosX, _tPosY, _anUnit)
		--print("GET LOCATION")
	local _unit
	local v
	if self._turn == 1 then
		_unit = self:_getSelectedUnit()
		v =  _anUnit--self._unitTable[_unit]
	else
		_unit = _anUnit
		v = _anUnit
		
	end
	 

	local _x 
	local _y
	if v.team == 1 then
		_x = _tPosX
		_y = _tPosY
	else
		_x = _y
		_tPosX = _tPosY
	end

	if unit:_inRange(_x, _y, _anUnit) then
		--print("IT'sa IN RANGE")
		

		
		if v.isMoving == false then

			if v.team == 2 then

				v.goal_x, v.goal_y = _tPosX, _tPosY --unit:_findFreeSpot(v)
				--if v.goal_x == v.x and v.goal_y == v.y then
				--	unit:_pcPrepareToEndTurn(v)
				--end
			else
				v.goal_x = _tPosX
				v.goal_y = _tPosY
			end
			local length = 0
			if _grid:isWalkableAt(v.goal_x, v.goal_y, walkable) then
				--print("TEAM 2")
				
				local __x = math.floor(v.x)
				local __y = math.floor(v.y)
				v.path, v.length = pather:getPath(__x, __y, v.goal_x, v.goal_y)
				--print("PATH LEGNTH: "..v.length.."")
				if v.path ~= nil then
					--print("LAST IS PATH ~= NIL")
					--print("VX: "..v.x.." VY: "..v.y.." GOAL X: "..v.goal_x.." GOAL Y: "..v.goal_y.."")
					--print("MSX: "..self._msx.." MSY: "..self._msy.." and LENGTH IS: "..v.length.."")
					--unit:_debugGetActualIdOfEnemyUnit( )
					v.issuedOrder = true -- the unit has been commanded to move
					v.moveTimer = Game.worldTimer
					v.isThere = false
					v.objectiveSet = true
					unit:_colorPath(v.path, v.length)		
					--print("DEBUG HERE")
				--[[elseif v.team == 2 then
					Game:updatePathfinding() --- NOT SURE IF OK!
					if self._cpIDX < unit:_returnPcUnits( ) then
						unit:_dropTargetList( )
						unit:_pcNextUnit(v, _id)
						
					else
						unit:_pcPrepareToEndTurn(v, _id)
					end--]]
					
				end
			else
				--print("NOT WALKABLE")
			end
		end
	else
		--print("UNIT IS OUTSIDE RANGE")

	end

	
end

function unit:_debugGetActualIdOfEnemyUnit( )
	--[[local _selectedUnitID = self:_getSelectedUnit( )
	local k = self._unitTable[_selectedUnitID]
	for i,v in ipairs(self._compUnits) do
		local j = self._unitTable[v]
		if k.x == j.x and k.y == j.y then
			print("SELLECTED EN IS: "..v.." while CPIDX IS: "..self._cpIDX.."")
		end
	end--]]
end

-------------------------------
---- POSSIBLE BUG HERE REGARDING LENGHT
-------------------------------
function unit:_findFreeSpot(_unit)
	local _x = 1
	local _y = 1
	repeat

		_x = math.random(_unit.x - _unit.range, _unit.x + _unit.range)
		_y = math.random(_unit.y - _unit.range, _unit.y + _unit.range)


	until self:GlobalgetAtPos(_x, _y, 500) == nil and self:_isWalkable(_x, _y) == true and math.dist(_unit.x, _unit.y, _x, _y) <= _unit.range

	if self:_getAtPos(_x, _y) ~= nil then
		--print("REPEATING GET AT POS")
		unit:_findFreeSpot(_unit)
	else
		return _x, _y
	end
end

function unit:_findNearestEmptySpot(__x, __y, __range, _unit)
	--print("X SET TO 0")
	local _x = nil
	local _y = nil
	local _counter = 0
	--[[repeat

		_x = math.random(__x - __range, __x + __range)
		_y = math.random( __y - __range,  __y + __range)
		print("REPEATING: ".._x.." | ".._y.."")
		_counter = _counter + 1

		if _counter == 10 then
			print("BREAKING")
			break
		end
	until self:GlobalgetAtPos(_x, _y, 500) == nil and self:_isWalkable(_x, _y) == true and self:_playerInRange(_unit, _x, _y) == true
--]]
--	print("CHECKING DISTANCE")
	if math.dist(_unit.x, _unit.y, __x, __y) <= _unit.attack_range then
		_x = _unit.x
		_y = _unit.y
		--print("DISTANCE < ATTACK RANGE")
	else
		--print("LOOPING")
		for i = 1, 15 do
			local _fX, _fY
			_fX = math.random(__x - __range, __x + __range)
			_fY = math.random( __y - __range,  __y + __range)	
			--print(" IN THE LOOP - MIDDLE")
			if self:GlobalgetAtPos(_fX, _fY, 500) == nil and self:_isWalkable(_fX, _fY) == true and self:_playerInRange(_unit, _fX, _fY) == true then
				_x = _fX
				_y = _fY
			--	print("FOUND ONE")
			--else
				--self:_findNearestEmptySpot(__x, __y, __range, _unit)
			end
		end
	end

	--if self:GlobalgetAtPos(_x, _y, 500) ~= nil then
		--print("REPEATING GET AT POS")
	--	unit:_findFreeSpot(_unit)
	--else
--	print("VALUES: ".._x.." | ".._y.."")
	return _x, _y
	--end
end

function unit:_isWalkable(_x, _y) 
	local _bool = _grid:isWalkableAt(_x, _y, walkable)
	return _bool
end

function unit:_getPath(_id)
	local v = self._unitTable[_id]
	return v.path, v.length
end


function unit:_getListOfPcUnits( )
	self:_clearSelections( ) -- if any unit is select at the start of the PC turn, then clear the list
	self:_dropListOfPcUnits( )
	for i,v in ipairs(self._unitTable) do
		if v.team == 2 then
			table.insert(self._compUnits, i)
		end
	end

	return self._compUnits
end

function unit:_dropListOfPcUnits( )
	--[[for i, v in ipairs(self._compUnits) do
		table.remove(i)
	end--]]
	for i = 1, #self._compUnits, -1 do
		table.remove(self._compUnits, i)
	end
	self._compUnits = {}
	unit:_removeRange( )
	unit:_clearSelections( )
	
end

function unit:_getListOfPlUnits( )
	for i,v in ipairs(self._unitTable) do
		if v.team == 1 then
			table.insert(self._plUnits, i)
		end
	end
	return self._plUnits
end

function unit:_dropListOfPlUnits( )
	for i = 1, #self._plUnits, -1 do
		table.remove(self._plUnits, i)
	end
	self._plUnits = {}
end

function unit:_returnPlUnits( )
	return #self._plUnits
end

function unit:_returnPcUnits( )
	return #self._compUnits
end

function unit:_endPcTurn( )



	unit:_resetStats(1)
	self._cpIDX = 1

	unit:_nextStep( )

	building:_resetStats()	
end

function unit:_mvComputerUnits(_tpX, _tpY)
	--local _un = self._compUnits[self._cpIDX]
	--print("HERE")
	local v = self._unitTable[_un]
	local selNum = self:_getNumSelections()

	--if selNum > 0 then
		if v.issuedOrder == false then
			--print("TARG POS X! PROBLEM?")
			_targPosX, _targPosY = _tpX, _tpY
			--print("TP X: ".._tpX.." TP Y:".._tpY.."")
			self:_getTargetLocation( _targPosX, _targPosY )
		else

			unit:_moveOnPath(_un)

		end
	--else
		--self:selectUnit(v.x, v.y)	
	--end

	--camera:setOffset(v.x, v.y)
	--_zoomSetScale(1)
end

function unit:_handlePcUnits( )
	if self:_returnPcUnits( ) == 0 or nil then
		self:_getListOfPcUnits( )
	else
		self:_mvComputerUnits()
	end
end

function unit:_moveOnPath(_id, _optional)
	local v
	if _optional == nil then
		v = self._unitTable[_id]
	else
		v = _id
	end


	if v.path ~= nil then
		--print("LEGTH: "..v.length.." + ID: ".._id.."")
		if v.length >= 1 then
			--print("FCKUP HERE + "..v.x.." AND "..v.y.."")
			if v.isThere == false then
				local _x = math.floor(v.path[v.cur].x)
				local _y = math.floor(v.path[v.cur].y)
				--print("Game Timer: "..Game.worldTimer.."")
				--print("TEAM 2 TIMER: "..v.moveTimer.."")
				--print("LENGTH IS: "..v.length.."")
				if Game.worldTimer > v.moveTimer + v.speed then
					
					unit:_removeRange( )
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

					if v.x > _x then
						anim:setState(v.img, ""..self._animString[v.faction].."MOVE_LEFT")
					elseif v.x <= _x then
						anim:setState(v.img, ""..self._animString[v.faction].."MOVE_RIGHT")
					elseif v.y > _y then
						anim:setState(v.img, ""..self._animString[v.faction].."MOVE_UP")
					elseif v.y < _y then
						anim:setState(v.img, ""..self._animString[v.faction].."MOVE_DOWN")
					end
					--v.x = _x
					--v.y = _y
					--print("UNIT WITH ID: ".._id.." Is at Pos: "..v.x.." and "..v.y.."")
					v.isMoving = true
					if v.x == _x and v.y == _y then
						local _rangeMax

						-- think two steps ahead but only move for 1
						if v.length >= v.range then
							_rangeMax = v.range
						elseif v.length < v.range then
							_rangeMax = v.length
						end

						if v.cur <= _rangeMax then -- range acshually
							v.cur = v.cur + 1
						else
							unit:_clearPathTable( )
							v.isMoving = false
							--unit:_addRange(_id)
							v.cur = 1
							v.isThere = true
							
							
							interface:_toggleUnitInfoBox(false)
							--unit:_debugAttackTest(v)
							--unit:_highlightTargets(v)
							
							v.can_attack = true
							v.done = true						
							self:selectUnit_attack(v.x, v.y)


							if v.team == 2 then
								dave:removeUnitFromTable( )
								--[[if self._cpIDX < unit:_returnPcUnits( ) then
									unit:_dropTargetList( )
									unit:_pcNextUnit(v, _id)
						
								else
									unit:_pcPrepareToEndTurn(v, _id)
								end--]]
							end
			
						end
					end
					--v.done = true
					v.moveTimer = Game.worldTimer
				else
					--print("UNI IS WITHIN RANGE")
				end
			else

			end
		else
			if v.team == 2 then
				
				v.issuedOrder = false
				v.done = false
				--print("GOAL X: "..v.goal_x.."GOAL Y: "..v.goal_y.."")
				--print("PROBLEM!")
				--self._cpIDX = 1
				Game:updatePathfinding( )
				unit:advanceTurn( )

			else
				--print("TEAM 1, it'sa ok")
			end
		end
	--print("MSX: "..self._msx.. " MSY: "..self._msy.."")
	
	end

end

function unit:_pcNextUnit(_v, _id)
	--print("Next PC Unit")
	_v.issuedOrder = false
	--self:_removeSelected(_id)
	unit:_clearSelections( )
	self._cpIDX = self._cpIDX + 1
	self._debugTpX = nil
	self._debugTpY = nil
	self._objectiveSet = false
	self._objectiveState = 1

end

function unit:_pcPrepareToEndTurn(_v, _id)

	unit:_clearSelections( )
	unit:_dropListOfPcUnits( )
	--_v.issuedOrder = false
	--_v.can_attack = false
	unit:_resetStats(2)
	self._cpIDX = 1
	self._debugTpX = nil
	self._debugTpY = nil
	self._objectiveSet = false
	self._objectiveState = 1
	--unit:_dropTargetList( )

	unit:_endPcTurn( )
	
end

function unit:_colorPath(_path, _length)
	if _path ~= nil then
		--for x = 1, _length do
		for node, count in _path:nodes() do
			local temp = {
				x = node:getX(), --_path[x].x,
				y = node:getY(), --_path[x].y,
			}
			--map:updateTile(_path[x].x, _path[x].y, 4)
			local deckIndex = 1

			temp.img = anim:newAnim(self._path_tex, 4,temp.x*self._tileSize - self._tileSize+self._offsetX, temp.y*self._tileSize - self._tileSize+self._offsetY, 1) --image:newDeckImage(self._path_tex, _path[x].x*self._tileSize - self._tileSize+self._offsetX, _path[x].y*self._tileSize - self._tileSize+self._offsetY, deckIndex)
			table.insert(self._pathTable, temp)
		end
	end
end

function unit:_drawPath( )
	for i,v in ipairs(self._pathTable) do

		anim:updateAnim(v.img, v.x*self._tileSize - self._tileSize+self._offsetX, v.y*self._tileSize - self._tileSize+self._offsetY)
	end
end

function unit:_clearPathTable( )
	for i,v in ipairs(self._pathTable) do
		--image:removeProp(v.img, g_RangeLayer)
		anim:delete(v.img)
	end
	self._pathTable = {}
end

function unit:_clearPath( )
	--map:_resetMap( )
end

function unit:_isReachable(_sx, _sy, _ex, _ey)
	local bool = false

	if self:_isWalkable(_ex, _ey) then
		local path, length = pather:getPath(_sx, _sy, _ex, _ey)
		if path ~= nil then
			bool = true
		end
	end

	return bool

end
--------------------------------------
----------- AREA OF ATTACK -----------
--------------------------------------
function unit:_addPathRange(_id, _otherUnit)
	unit:_removeRange( )
	self._inRangeUnitHpTable = { }
	self._internalRangeTable = { }
	local timerStart = Game.worldTimer
	local v
	if _otherUnit == nil then
		v = self._unitTable[_id]
	else
		v = _otherUnit
	end
		Game:updatePathfinding()
	--if v.isSelected == true then
		local i = 0
		for x = -v.range, v.range do
			for y = -v.range, v.range do
				local wstate = self:_isWalkable(v.x+x, v.y+y) 
				local wBool
				--Game:updatePathfinding()
				if wstate == true  then
					local path = pather:getPath(v.x, v.y, v.x+x, v.y+y)
					local length = 0
					if path ~= nil then
						length = path:getLength()
						for node, count in path:nodes() do
							if v.ap > (i*map:getTileCost(v.x+x, v.y+y) ) and length <= v.range and v.x == node:getX() and v.y == node:getY() then
								local temp = {
									_x = (v.x + x),
									_y = (v.y + y),					
									_ax = v.x,
									_ay = v.y,
								}
								local t = {
									_x = (v.x + x),
									_y = (v.y + y),	
								}
								local _unitInRangeAtPos = self:_getAtPos(v.x + x, v.y + y)
								local _buildingAtPos = unit:_getBuildingAtPos(v.x + x, v.y + y, v.team)
								if _buildingAtPos ~= nil and (v.tp == 1 or v.tp == 2) and _unitInRangeAtPos == nil then
									temp.houseIcon = anim:newAnim(self._captureHouse_tex, 4, v.x, v.y, 1)
								end
								if _unitInRangeAtPos == nil then
									temp.img = anim:newAnim(self._movementRange_tex, 4, v.x, v.y, 1)--image:newImage(self._movementRange_tex, -100, - 100)
								else
									local _unn = self._unitTable[_unitInRangeAtPos]
									if _unn.team ~= v.team then
										temp.img = anim:newAnim(self._mvRangeBad_tex, 4, v.x, v.y, 1)
										-- calculate DMG
										local dmg = self:_calculateAttack(v, _unn)
										local scaleFactor = 1 - ( (100 - ( (100 * dmg) / _unn.initital_hp ) ) / 100 )
										--image:_setScale(v.hb_b, scaleFactor, 1)
										local hTemp = {
											id = _unitInRangeAtPos,
											hp = _unn.hp,
										}
										_unn.displayHP = _unn.hp - dmg
										--if _unn.hp < 0.31 then
										--	_unn.hp = 0.31
										--end
										table.insert(self._inRangeUnitHpTable, hTemp )
										--anim:setState(_unn.hb_c, "HB_FLASH")
									end
								end
								--anim:addToPool(temp.img)
								if temp.img ~= nil then
									anim:setSpeed(temp.img, 0.1)
								end
								table.insert(self._rangeTable, temp)	
								table.insert(self._internalRangeTable, t)				
							end

						end
					else
						Game:updatePathfinding()
					end
				else
					--print("RESULT "..i.." : FALSE")
					Game:updatePathfinding()
				end
			end
		end

	--end

	--print("SIZE OF RANGE TABLE: "..#self._rangeTable.."")

	local timerEnd = Game.worldTimer
	local timeTaken = timerStart - timerEnd
	--[[print("TIME TO DO THAT SHIT IS: "..timeTaken.."")
	print("TIME TO DO THAT SHIT IS: "..timeTaken.."")
	print("TIME TO DO THAT SHIT IS: "..timeTaken.."")
	print("TIME TO DO THAT SHIT IS: "..timeTaken.."")
	print("TIME TO DO THAT SHIT IS: "..timeTaken.."")
	print("TIME TO DO THAT SHIT IS: "..timeTaken.."")
	print("TIME TO DO THAT SHIT IS: "..timeTaken.."")
	print("TIME TO DO THAT SHIT IS: "..timeTaken.."")
	print("TIME TO DO THAT SHIT IS: "..timeTaken.."")
	print("TIME TO DO THAT SHIT IS: "..timeTaken.."")
	print("TIME TO DO THAT SHIT IS: "..timeTaken.."")
	print("TIME TO DO THAT SHIT IS: "..timeTaken.."")
	print("TIME TO DO THAT SHIT IS: "..timeTaken.."")
	print("TIME TO DO THAT SHIT IS: "..timeTaken.."")
	print("TIME TO DO THAT SHIT IS: "..timeTaken.."")
	print("TIME TO DO THAT SHIT IS: "..timeTaken.."")
	print("TIME TO DO THAT SHIT IS: "..timeTaken.."")
	print("TIME TO DO THAT SHIT IS: "..timeTaken.."")
	print("TIME TO DO THAT SHIT IS: "..timeTaken.."")
	print("TIME TO DO THAT SHIT IS: "..timeTaken.."")
	print("TIME TO DO THAT SHIT IS: "..timeTaken.."")
	print("TIME TO DO THAT SHIT IS: "..timeTaken.."")
	print("TIME TO DO THAT SHIT IS: "..timeTaken.."")
	print("TIME TO DO THAT SHIT IS: "..timeTaken.."")
	print("TIME TO DO THAT SHIT IS: "..timeTaken.."")
	print("TIME TO DO THAT SHIT IS: "..timeTaken.."")
	print("TIME TO DO THAT SHIT IS: "..timeTaken.."")
	print("TIME TO DO THAT SHIT IS: "..timeTaken.."")
	print("TIME TO DO THAT SHIT IS: "..timeTaken.."")
	print("TIME TO DO THAT SHIT IS: "..timeTaken.."")
	print("TIME TO DO THAT SHIT IS: "..timeTaken.."")
	print("TIME TO DO THAT SHIT IS: "..timeTaken.."")
	print("TIME TO DO THAT SHIT IS: "..timeTaken.."")
	print("TIME TO DO THAT SHIT IS: "..timeTaken.."")
	print("TIME TO DO THAT SHIT IS: "..timeTaken.."")
	print("TIME TO DO THAT SHIT IS: "..timeTaken.."")
	print("TIME TO DO THAT SHIT IS: "..timeTaken.."")
	print("TIME TO DO THAT SHIT IS: "..timeTaken.."")
	print("TIME TO DO THAT SHIT IS: "..timeTaken.."")
	print("TIME TO DO THAT SHIT IS: "..timeTaken.."")
	print("TIME TO DO THAT SHIT IS: "..timeTaken.."")
	print("TIME TO DO THAT SHIT IS: "..timeTaken.."")
	print("TIME TO DO THAT SHIT IS: "..timeTaken.."")--]]
end

function unit:_returnRangeTable( )
	return self._rangeTable
end

function unit:_addRange(_id)
--	unit:_removeRange( )
	self:_addPathRange(_id)
--[[	local v = self._unitTable[_id]
	if v.isSelected == true then --isSelected == true
		for x = -v.range-v.attack_range, v.range+v.attack_range do
			for y = -v.range-v.attack_range, v.range+v.attack_range do

				local distance = math.dist(v.x, v.y, v.x-x, v.y-y) --ap
				
				if distance <= v.range+v.attack_range and self:_isWalkable(v.x-x, v.y-y) == true and v.ap > ( distance+map:getTileCost(v.x-x, v.y-y) ) then
					local temp = {
						_x = (v.x - x),
						_y = (v.y - y),					
					}
					if math.dist(v.x, v.y, v.x-x, v.y-y) > v.range then
						temp.img = anim:newAnim(self._mvRangeBad_tex, 4, -100, - 100, 1)--image:newImage(self._mvRangeBad_tex, -100, - 100)
					elseif math.dist(v.x, v.y, v.x-x, v.y-y) <= v.range then
						local _unit = self:_getAtPos(v.x-x, v.y-y)
						if _unit ~= nil then
							local _v = self._unitTable[_unit]
							if _v.team ~= self._turn then
								temp.img = anim:newAnim(self._mvRangeBad_tex, 4, -100, - 100, 1)
							else
								temp.img = anim:newAnim(self._movementRange_tex, 4, -100, - 100, 1)
							end
						else						
							temp.img = anim:newAnim(self._movementRange_tex, 4, -100, - 100, 1)--image:newImage(self._movementRange_tex, -100, - 100)
						end
					end
					--anim:addToPool(temp.img)
					anim:setSpeed(temp.img, 0.1)
					table.insert(self._rangeTable, temp)
				end
			end
		end
	end--]]
end


function unit:_addAttackRange(_id) 
	unit:_removeRange( )
	local v = self._unitTable[_id]
	if v.targeted == false and v.__debugDispRange == false then --isSelected == true
		for x = -v.range-v.attack_range, v.range+v.attack_range do
			for y = -v.range-v.attack_range, v.range+v.attack_range do
				if math.dist(v.x, v.y, v.x-x, v.y-y) <= v.range+v.attack_range then
					local temp = {
						_x = (v.x - x),
						_y = (v.y - y),	
						_ax = v.x,
						_ay = v.y,				
					}
					if math.dist(v.x, v.y, v.x-x, v.y-y) > v.range then
						temp.img = anim:newAnim(self._mvRangeBad_tex, 4, v.x, v.y, 1)--image:newImage(self._mvRangeBad_tex, -100, - 100)
					elseif math.dist(v.x, v.y, v.x-x, v.y-y) <= v.range then
						temp.img = anim:newAnim(self._movementRange_tex, 4, v.x, v.y, 1)--image:newImage(self._movementRange_tex, -100, - 100)
					end
					--anim:addToPool(temp.img)
					anim:setSpeed(temp.img, 0.1)
					table.insert(self._rangeTable, temp)
				end
			end
		end
	end
end

function unit:_addAttackRangePos(_v, _x, _y) 
	local v = _v

	if v.isSelected == true then

		for x = -v.attack_range, v.attack_range do
			for y = -v.attack_range, v.attack_range do
				local distCheck = math.dist(_x, _y, _x-x, _y-y)
				if distCheck <= v.attack_range then
					--print("IT BE HAPPENING")
					local temp = {
						_x = (_x - x),
						_y = (_y - y),
						_ax = _x,
						_ay = _y,
						img = image:newImage(self._mvRangeBad_tex, temp._ax, temp._ay),
					}
					table.insert(self._rangeTable, temp)
				end
			end
		end
	end
end

function unit:_drawRange( )
	for i,v in ipairs(self._rangeTable) do
		--v.x, v.y
		--[[
			self._x = self._x + (_twX - self._x ) * tTime
			self._y = self._y + (_twY - self._y ) * tTime
		]]
		v._ax = v._ax + (v._x - v._ax) * 0.3
		v._ay = v._ay + (v._y - v._ay) * 0.3
		if v.img ~= nil then
			anim:updateAnim(v.img, v._ax*self._tileSize - self._tileSize+self._offsetX, v._ay*self._tileSize- self._tileSize+self._offsetY)
		end

		if v.houseIcon ~= nil then
			anim:updateAnim(v.houseIcon, v._ax*self._tileSize - self._tileSize+self._offsetX, v._ay*self._tileSize- self._tileSize+self._offsetY)
		end

		if v.touchAnim ~= nil then
			anim:updateAnim(v.touchAnim, v._x*self._tileSize - self._tileSize+self._offsetX, v._y*self._tileSize- self._tileSize+self._offsetY)
		end
		--image:updateImage(v.img, v._x*self._tileSize - self._tileSize+self._offsetX, v._y*self._tileSize- self._tileSize+self._offsetY)
	end
end

function unit:_inRange(_x, _y, __unitV)
	return self:_inPathRange(_x, _y, __unitV)
--[[	local _bool = false
	local _unit
	local v 
	if self._turn == 1 then
		_unit = self:_getSelectedUnit( )
		v = self._unitTable[_unit]
	else
		_unit = __unitV
		v = __unitV
	end
	if __unitV ~= nil then
		_bool = true
	else	
		local distance = math.dist(v.x, v.y, _x, _y) --v.ap > ( distance+map:getTileCost(v.x-x, v.y-y) )
		if distance <= v.range and self:_isWalkable(_x, _y) == true and v.ap > ( distance+map:getTileCost(_x, _y) ) then
			_bool = true
		end
	end

	return _bool--]]
end

function unit:_inPathRange(_x, _y, __unitV)
	local _bool = false
	local _unit
	local v
	if self._turn == 1 then
		_unit = self:_getSelectedUnit( )
		v = self._unitTable[_unit]
	end

	if __unitV ~= nil then
		_bool = true
	else
		for i, v in ipairs(self._rangeTable) do
			if _x == v._x and _y == v._y then
				_bool = true
				--print("V._x: "..v._x.." Y: "..v._y.."")
			end
		end
	end

	return _bool
end

function unit:_playerInRange(_unit, _x, _y)
	local _bool = false
	--local _unit
	local v = _unit

	if math.dist(v.x, v.y, _x, _y) <= v.range then
		_bool = true
	end

	return _bool
end

function unit:_inAttackRange(_x, _y)
	_bool = false
	local _unit

	if self._turn == 1 then
		_unit = self:_getSelectedUnit( )
	else
		_unit = self._compUnits[self._cpIDX]
	end
	local v = self._unitTable[_unit]
	if math.dist(v.x, v.y, _x, _y) <= v.range + v.attack_range then
		_bool = true
	end
	return _bool
end


function unit:_removeRange( )
	for i,v in ipairs(self._inRangeUnitHpTable) do
		local _unn = self._unitTable[v.id]
		if _unn ~= nil then
			if _unn.hp ~= v.hp then
				_unn.displayHP = _unn.hp
			else
				_unn.displayHP = v.hp
			end
			--anim:setState(_unn.hb_c, "HB_BG")
		end
	end

	for i,v in ipairs(self._rangeTable) do

		--image:removeProp(v.img, g_RangeLayer)
		if v.img ~= nil then
			anim:delete(v.img)
		end

		if v.houseIcon ~= nil then
			anim:delete(v.houseIcon)
			v.houseIcon = nil
		end

		if v.touchAnim ~= nil then
			anim:delete(v.touchAnim)
		end
		--print("V IMG LAYER:"..v.img.layer.."")
	end
	self._rangeTable = {}
end

function unit:_flushInternalRange( )
	self._internalRangeTable = {}
end
--------------------------------------
----------- ATTACK CODE --------------
--------------------------------------
function unit:_attack(_target)
--[[local _unit = self:_getSelectedUnit( )
	local v = self._unitTable[_unit] -- we have our attacker
	local k = self._unitTable[_target]

	if v ~= nil then -- just in case check
		k.hp = k.hp - 2
	end]]	
end



function unit:_dropTargetList( )
	for i,v in ipairs(self._targetTable) do
		--print("NO MORE PROPS")
		if v.img ~= nil then
			--print("YES WE HAVE AN IMAGE, AND YES... WE SHALL DROP IT")
			image:removeProp(v.img, g_RangeLayer)
		else

		end
	end
	--print("TARGET TABLE SIZE: "..#self._targetTable.."")
	self._targetTable = {}
end

function unit:_updateTargetList( )
	for i,v in ipairs(self._targetTable) do
		image:updateImage(v.img, v.x*self._tileSize - self._tileSize+self._offsetX, v.y*self._tileSize- self._tileSize+self._offsetY)
	end
end

function unit:_getTargetList(_attacker)
	for i,v in ipairs(self._unitTable) do
		if v.team ~= _attacker.team then
			if math.dist(_attacker.x, _attacker.y, v.x, v.y) <= _attacker.attack_range then
				local temp = {
					_t = i,
					x = v.x,
					y = v.y,
					img = nil,
				}
				table.insert(self._targetTable, temp)
			end
		end
	end
	return self._targetTable
end

function unit:_getTargetListSize( )
	return #self._targetTable
end

-- unit highlight target!
function unit:_highlightTargets(_attacker)
	
	unit:_getTargetList(_attacker)

	for i,v in ipairs(self._targetTable) do
		v.img = image:newImage(self._crossHair_tex, v.x*self._tileSize - self._tileSize+self._offsetX, v.y*self._tileSize - self._tileSize+self._offsetY )
	end
	unit:_removeRange( )
end

function unit:_checkAttack(_v, _id)

end

------------ SOMETHING BROKEN ERROR HAPPEN
function unit:_loopInAttack(_v, _id)


end




function unit:_debugAttackTest(_attacker)


end

function unit:_printTileState(_x, _y)
	if self:GlobalgetAtPos(_x,_y, 30) == nil and self:_isWalkable(_x, _y) == true then
	--	print("SPOT IS FREE")
	else
	--	print("SPOT IS NOT FREE")
	end
end

function unit:g_getTargetLocation(_unit, _x, _y)
	v = _unit
	Game:updatePathfinding()
	if v.isMoving == false then
		v.goal_x = _x
		v.goal_y = _y
	--	print("MOVING SET TO TRUE")
		if _grid:isWalkableAt(v.goal_x, v.goal_y, walkable) then
			--print("GRID WALKABLE AT THERE")
			local __x = math.floor(v.x)
			local __y = math.floor(v.y)
			--print("X : "..__x.." Y: "..__y.."")
			v.path, v.length = pather:getPath(__x, __y, v.goal_x, v.goal_y)
			if v.path ~= nil then
				if v.faction == 1 then
					if v.tp == 5 then
						sound:play(sound.mechWheel)
					else
						sound:play(sound.orgWalk)
					end
				else
					sound:play(sound.mechWalk)
				end				
				--print("LEGTH IS: "..v.length.."")
				v.issuedOrder = true -- the unit has been commanded to move
				v.moveTimer = Game.worldTimer
				v.isThere = false
				v.objectiveSet = true
				--unit:_colorPath(v.path, v.length)	

			else
				--francois:removeUnitFromTable( )
				--self:EndTurn( )
				--print("Something something happened with the path")
			end

		end
	end
end
function unit:_debugMoveToTarget(_unit)
	local v = _unit

	if v.path ~= nil then
		local length = v.path:getLength( )
		--print("LENGTH FOR PATH IS: "..length.."")
		--for node, count in v.path:nodes() do
		--	print(('Step: %d - x: %d - y: %d'):format(count, node:getX(), node:getY()))
		--end
		local nodeList = v.path:getNodeList( )
		print("NODE LIST: "..#nodeList.."")
	end

end

function unit:g_moveTowardsTarget(_unit)
	v = _unit

	if v.path ~= nil then
		if v.isThere == false then
			v.length = v.path:getLength( )
			local nodeList = v.path:getNodeList( )
			local _x = math.floor(nodeList[v.cur]._x)
			local _y = math.floor(nodeList[v.cur]._y)
			--if Game.worldTimer > v.moveTimer + v.speed then
			--[[


			]]
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
					--print("LEGNTH IS BIGGER THEN RANGE BY "..(v.length-v.range).." ")

				elseif v.length <= v.range then
					_rangeMax = v.length
				end--]]

				if v.isCommander == true then
					anim:setState(v.img, self._animStates[3][v.tp].idle )

				else
					if v.x > _x then
						anim:setState(v.img, self._animStates[v.faction][v.tp].left)
					elseif v.x < _x then
						anim:setState(v.img, self._animStates[v.faction][v.tp].idle)
					end
				end
				--[[elseif v.y > _y then
					anim:setState(v.img, ""..self._animString[v.faction].."MOVE_UP")
				elseif v.y < _y then
					anim:setState(v.img, ""..self._animString[v.faction].."MOVE_DOWN")
				end--]]

				if v.x == _x and v.y == _y then
					

					
					if v.cur < #nodeList then
						local _xE
						local _yE
						v.cur = v.cur + 1
						--[[if v.path[v.cur+2] ~= nil then
							_xE = math.floor(v.path[v.cur+2].x)
							_yE = math.floor(v.path[v.cur+2].y)
						else
							_xE = math.floor(v.path[v.cur+1].x)
							_yE = math.floor(v.path[v.cur+1].y)
						end--]]

						--[[if unit:isLocEmpty(_xE, _yE) == nil then
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


							--francois:attackWithUnit(v)
							--- handle attacking here
							--francois:attackWithUnit(v)

							--francois:removeUnitFromTable( )	
							--francois:getListOfUnits( )	
						end--]]
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

						--[[if v.rival ~= nil then
							local _enUnit = unit:_returnTable()[v.rival]
							if _enUnit ~= nil then
								if math.dist(v.x, v.y, _enUnit.x, _enUnit.y) <= v.attack_range then
									_enUnit.hp = _enUnit.hp - v.damage
								end
							end
						end--]]
						--francois:attackWithUnit(v)
						--- handle attacking here
						--francois:attackWithUnit(v)
						interface:setTargetAtLoc(-2000, 200)
						unit:_clearSelections( )
						unit:_clearPathTable( )
						self:_removeRange( )
						self._actionState = 1
						self:__resetRipple( )
						local v2
						local destX
						local destY 
						local __target
						v2, destX, destY, __target = unit:_returnGlobalMovement( )
						__target = v.rival
						if __target ~= nil then
							--print("BEGIN ATTACK")
							self:_do_attack(v, __target)
							--print("GO AND ATTACK")
						end
						self:_resetGlobalMovement( )			
						map:_updateFogOfWar( )	
						--sound:stopAllFromCategory(SOUND_WALKING)		
					end
				end
				--v.moveTimer = Game.worldTimer

			--end

		end
	end

end

function unit:_returnHealEffAnim( )
	return self._healthAnimEffect
end

function unit:_returnDamageEffect( )
	--effect:new("DAMAGE_EFFECT", t.act_x - 16, t.act_y - 16, self._explosionAnimEffect, 7, t )
	return self._explosionAnimEffect
end

function unit:_returnAuraEffect( )
	return self._auraEffect
end

function unit:_applyPowerupHealAll( )
	for i,v in ipairs(self._unitTable) do
		if v.team == self._turn then
			--local oldState = anim:getState(v.img)
			v.hp = v.initital_hp
			v.displayHP = v.hp
			--anim:setState(v.img, "HEALED", oldState)
			effect:new("HEAL_EFFECT", v.x, v.y, self._healthAnimEffect, 10, v )
		end
	end
end

function unit:_getTurnUnitList( )
	--self._teamUnitList
	for i,v in ipairs(self._unitTable) do
		if v.team == self._turn then
			local temp = {
				x = v.x,
				y = v.y,
				--applied = false
				anim = anim:newAnim(self._ssjAnim_tex, 4, v.x, v.y, 1),
			}
			table.insert(self._teamUnitList, temp)
		end
	end

end

function unit:_applyPowerupDmgAll(_nillcheck)
	unit:_dropSSJ( )
	for i,v in ipairs(self._unitTable) do
		if v.team == self._turn then
			local temp = {
				x = v.x,
				y = v.y,
				anim = anim:newAnim(self._ssjAnim_tex, 4, v.x*32, v.y*32, 1),
				currTime = Game.worldTimer,
				id = i,
			}
			if _nillcheck == nil then
				anim:setState(temp.anim, "SSJ_POWER", "SSJ_ON")
			end
			table.insert(self._teamUnitList, temp)
		end
	end
	if self._teamToPlayer[self._turn].cAB == self._teamToPlayer.attackBonus then
		self._teamToPlayer[self._turn].cAB = self._teamToPlayer[self._turn].cAB + 50
	end
end

--[[function unit:_updateUnitPowerUpList(_nillcheck)
	self._teamUnitList = {}
	for i,v in ipairs(self._unitTable) do
		if v.team == self._turn then
			local temp = {
				x = v.x,
				y = v.y,
				id = i,
			}
			if _nillcheck == nil then
				anim:setState(temp.anim, "SSJ_POWER", "SSJ_ON")
			end
			table.insert(self._teamUnitList, temp)
		end
	end
end--]]

function unit:_unitDeadCallback(_id)
	if #self._teamUnitList > 0 then
		print("WTF SIZE: "..#self._teamUnitList.."")
		local bool = false
		for i,v in ipairs(self._teamUnitList) do
			if v.id == _id then
				bool = true
			end
		end

		if bool == true and self._teamUnitList[_id] ~= nil then
			if self._teamUnitList[_id].anim ~= nil then
				anim:delete(self._teamUnitList[_id].anim)
				self._teamUnitList[_id].anim = nil
				table.remove(self._teamUnitList, _id)
			end

		end
		self:_dropSSJ( )
		self:_applyPowerupDmgAll( )
	end
end

function unit:_drawAndUpdatePowerupSSj( )
	for i,v in ipairs(self._teamUnitList) do
		local ssjUnit = self._unitTable[v.id]
		if ssjUnit ~= nil then
			local act_x = ssjUnit.x * self._tileSize - self._tileSize+self._offsetX - 16
			local act_y = ssjUnit.y * self._tileSize - self._tileSize+self._offsetY - 32
			anim:updateAnim(v.anim, act_x, act_y)
		end
	end
end

function unit:_dropSSJ( )
	self._teamToPlayer[self._turn].cAB = self._teamToPlayer[self._turn].attackBonus
	player1.cAB = player1.attackBonus
	player2.cAB = player2.attackBonus
	for i,v in ipairs(self._teamUnitList) do
		anim:delete(v.anim)
		v.anim = nil
	end
	self._teamUnitList = {}
end