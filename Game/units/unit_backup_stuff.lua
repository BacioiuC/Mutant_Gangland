function unit:_checkAttack(_v, _id)
	if self:_getTargetListSize( ) > 0 then
		print("TARGET LIST > 0 and SIZE = "..self:_getTargetListSize( ) )
	else
		if _v.team == 2 then

		end
		print("NO TARGET IN RANGE")
	end
end

function unit:_loopInAttack(_v)

end


							if self._turn == 2 then
								if self._cpIDX < unit:_returnPcUnits( ) then
									unit:_pcNextUnit(v, _id)
				
								else
									unit:_pcPrepareToEndTurn(v, _id)
								end
							end

				print("TARGET NIL")
				print("TEAM TWO")
				_v.can_attack = false
				if self._cpIDX < unit:_returnPcUnits( ) then
					unit:_dropTargetList( )
					unit:_pcNextUnit(_v, _id)
					
				else
					unit:_pcPrepareToEndTurn(_v, _id)
				end



	--[[anim:createState("SPOTTAH_IDLE", 1, 4, 0.13)
	anim:createState("SPOTTAH_IDLE_LEFT", 5, 8, 0.13)
	anim:createState("SPOTTAH_ATTACK", 10, 18, attack_speed)
	anim:createState("SPOTTAH_ATTACK_LEFT", 19, 27, attack_speed)

	anim:createState("PANZASPOTTAH_IDLE", 1, 4, 0.13)
	anim:createState("PANZASPOTTAH_IDLE_LEFT", 5, 8, 0.13)
	anim:createState("PANZASPOTTAH_ATTACK", 12, 22, attack_speed)
	anim:createState("PANZASPOTTAH_ATTACK_LEFT", 23, 33, attack_speed)

	anim:createState("ATTACKA_IDLE", 1, 4, 0.13)
	anim:createState("ATTACKA_IDLE_LEFT", 5, 8, 0.13)
	anim:createState("ATTACKA_ATTACK", 11, 20, attack_speed)
	anim:createState("ATTACKA_ATTACK_LEFT", 21, 30, attack_speed)

	anim:createState("ROKKIT_IDLE", 1, 4, 0.13)
	anim:createState("ROKKIT_IDLE_LEFT", 5, 8, 0.13)
	anim:createState("ROKKIT_ATTACK", 12, 22, attack_speed)
	anim:createState("ROKKIT_ATTACK_LEFT", 22, 32, attack_speed)

	anim:createState("TANK_IDLE", 1, 4, 0.13)
	anim:createState("TANK_IDLE_LEFT", 5, 8, 0.13)
	anim:createState("TANK_ATTACK", 12, 22, attack_speed)
	anim:createState("TANK_ATTACK_LEFT", 22, 32, attack_speed)

	anim:createState("ROBO_IDLE", 1, 4, 0.13)
	anim:createState("ROBO_IDLE_LEFT", 5, 8, 0.13)
	anim:createState("ROBO_ATTACK", 15, 28, attack_speed)
	anim:createState("ROBO_ATTACK_LEFT", 29, 42, attack_speed)

	anim:createState("ROBO2_IDLE", 1, 4, 0.13)
	anim:createState("ROBO2_IDLE_LEFT", 5, 8, 0.13)
	anim:createState("ROBO2_ATTACK", 11, 19, attack_speed)
	anim:createState("ROBO2_ATTACK_LEFT", 21, 29, attack_speed)

	anim:createState("PUNCHY_IDLE", 1, 4, 0.13)
	anim:createState("PUNCHY_IDLE_LEFT", 5, 8, 0.13)
	anim:createState("PUNCHY_ATTACK", 13, 24, attack_speed)
	anim:createState("PUNCHY_ATTACK_LEFT", 25, 36, attack_speed)

	anim:createState("ROBO_ROKKIT_IDLE", 1, 4, 0.13)
	anim:createState("ROBO_ROKKIT_IDLE_LEFT", 5, 8, 0.13)
	anim:createState("ROBO_ROKKIT_ATTACK", 12, 21, attack_speed)
	anim:createState("ROBO_ROKKIT_ATTACK_LEFT", 22, 31, attack_speed)

	anim:createState("MECHA_IDLE", 1, 4, 0.13)
	anim:createState("MECHA_IDLE_LEFT", 5, 8, 0.13)
	anim:createState("MECHA_ATTACK", 11, 22, attack_speed)
	anim:createState("MECHA_ATTACK_LEFT", 23, 34, attack_speed)
	--]]