shark = {}


function shark:init( )
	shark_list = {}
	self._animTex = anim:newDeck("Game/worldMap/shark_sprite.png", 32, g_ActionPhase_UI_Layer)

	--anim:createState("AVAILABLE", 1, 4, 0.04)
	anim:createState("SHARK_UP", 1, 4, 0.1)
	anim:createState("SHARK_LEFT", 5, 8, 0.1)
	anim:createState("SHARK_RIGHT", 9, 12, 0.1)
	anim:createState("SHARK_DOWN", 13, 16, 0.1)

	self._rndState = {}
	self._rndState[1] = "SHARK_UP"
	self._rndState[2] = "SHARK_LEFT"
	self._rndState[3] = "SHARK_RIGHT"
	self._rndState[4] = "SHARK_DOWN"
end

function shark:new(_x, _y)
	local temp = {
		x = _x,
		y = _y,
		act_x = _x*32,
		act_y = _y*32,
		anim = anim:newAnim(self._animTex, 4, _x*32, _y*32, 1),
		goal_x = _x,
		goal_y = _y,
		path = {},
		length = 0,
		isMoving = false,
		moveTimer = Game.worldTimer,
		isThere = true,
		speed = 0.1,
		move_speed = 0.5,
		cur = 1,
	}
	anim:setState(temp.anim, self._rndState[math.random(1,4)])
	table.insert(shark_list, temp)
end
--7 10
function shark:update(_offX, _offY)
	for i,v in ipairs(shark_list) do
		if v.isMoving == false then
			self:getTargetLocation(v, math.random(v.x-10, v.x+10), math.random(v.y-5, v.y+5) )
		else
			self:moveTowardsTarget(v)
		end


		v.act_x = v.x * 32 - 32+_offX
		v.act_y = v.y * 32 - 32+_offY
		anim:updateAnim(v.anim, v.act_x, v.act_y)
	end
end

function shark:getTargetLocation(_unit, _x, _y)
	v = _unit

	if v.isMoving == false then
		v.goal_x = _x
		v.goal_y = _y

		if pather.grid:isWalkableAt(v.goal_x, v.goal_y) then

			local __x = math.floor(v.x)
			local __y = math.floor(v.y)
			v.path, v.length = pather:getPath(__x, __y, v.goal_x, v.goal_y)
			if v.path ~= nil then
				--v.issuedOrder = true -- the unit has been commanded to move
				v.moveTimer = Game.worldTimer
				v.isThere = false
				v.isMoving = true

			end

		end
	end
end

function shark:moveTowardsTarget(_unit)
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
				--v.isMoving = true 
				local _rangeMax = v.length

				if v.x > _x then
					anim:setState(v.anim, "SHARK_LEFT")
				elseif v.x < _x then
					anim:setState(v.anim, "SHARK_RIGHT")
				elseif v.y > _y then
					anim:setState(v.anim, "SHARK_UP")
				elseif v.y < _y then
					anim:setState(v.anim, "SHARK_DOWN")
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

						v.isMoving = false

	
					end
				end
				v.moveTimer = Game.worldTimer

			end

		end
	end

end