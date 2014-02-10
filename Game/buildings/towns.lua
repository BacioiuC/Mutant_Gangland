function building:_setCaptured(_id)
	-- check if any unit is on the building's position
		-- check unit flags and teams
		  -- assign building to team
	
	local unitList = unit:_returnTable( )
	local townBuilding = self._bldTable[_id]

	--if townBuilding._type == 2 then
		for i,v in ipairs(unitList) do

			if v.x == townBuilding.x and v.y == townBuilding.y then

				if townBuilding.team ~= v.team and unit:_returnTurn() == v.team and v.canConquer == true then
					--print("TOWN TEAM =: "..townBuilding.team.." UNIT TEAM: "..v.team.."")

					--else
					townBuilding.team = v.team
						--image:setIndex(townBuilding.img, v.team+1) -- adjust for correct index
						--if townBuilding._type == 1 then
					--anim:setState(townBuilding.img, self._capturedTeam[townBuilding.team], self._hqTeam[townBuilding.team+1])
					if townBuilding._type == 1 then
						local capAnim = effect:new("FACTORY_CAPTURED", townBuilding.x,  townBuilding.y, self._captureAnimFactory[v.team], 8, townBuilding, false, false )
						effect:setSpeed(capAnim, 0.15)
					else
						local capAnim =  effect:new("TOWN_CAPTURED", townBuilding.x,  townBuilding.y, self._captureAnimTown[v.team], 8, townBuilding, false, false )
						effect:setSpeed(capAnim, 0.15)
					end
					--------------------------------
					--------------------------------
					---- SOUND HERE ----------------
					sound:play(sound.buildingCaptured)
					---- SOUND HERE ----------------
					--------------------------------
					--------------------------------					
					--anim:setState(townBuilding.roof, self._capturedTeam[townBuilding.faction], self._hqTeam[townBuilding.faction+1])
						--else
						--	anim:setState(townBuilding.img, "BUILDING_IDLE")
						--end
					--end
				elseif townBuilding.team == v.team and v.done == false and unit:_returnTurn() == v.team then
					v.hp = v.hp + 2
					if v.hp > v.initital_hp then
						v.hp = v.initital_hp
					end
					v.displayHP = v.hp
					local healEffect = unit:_returnHealEffAnim( )
					local hlEf = effect:new("HEAL_EFFECT", v.x, v.y, healEffect, 10)
					sound:play(sound.powerHeal)
					
					effect:setSpeed(hlEf, 0.075)
					--anim:setState(v.img, "HEALED", "MOVE_LEFT" )

				end


			end
		end
	--end
end