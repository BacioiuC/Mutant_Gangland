function interface:initQuotes( )
	--http://rector-mortis.deviantart.com/art/Battle-Taunts-Drac-64258431 <-- to be added in the credits
	-- andzdroid <-- bear thingy...
	quote = {}
	quote[1] = "Chivu: Start the clock! You die in 5 minutes!"
	quote[2] = "Chivu: There are no bears on the battlefield!" -- happy  ? :D! 
	quote[3] = "Chivu: Thy end is ny!"
	quote[4] = "Chivu: Face me you fool!"
	quote[5] = "Chivu: Your units shall not pass!"
	quote[6] = "Chivu: Garbage... that's what you are!"
	quote[7] = "Chivu: You call that strategy? Ahahahaha!"
	quote[8] = "Chivu: You are no Orange Star commander..."
	quote[9] = "Chivu: I sense a disturbance in your force!"
	quote[10] = "Chivu: Dodge THIS!"

	
	portrait = {}
	portrait[1] = "chivu_avatar.png"
	portrait[2] = "chivu_avatar.png"
end

--[[function unit:_applyPowerupDmgAll( )
	
	for i,v in ipairs(self._unitTable) do
		if v.team == self._turn then
			local temp = {
				x = v.x,
				y = v.y,
				--anim = anim:newAnim(self._ssjAnim_tex, 4, v.x*32, v.y*32, 1),
				id = i,
				currTime = Game.worldTimer,
			}
			table.insert(self._teamUnitList, temp)
		end
	end
	self._ssjAnim = anim:newAnim(self._ssjAnim_tex, 5, -2000, - 2000, 1)
	if #self._teamUnitList > 0 then
		anim:setState(self._ssjAnim, "SSJ_ON")
		self._cpIDX = 1
		self._initUnit = false
		
	end
end

function unit:_drawAndUpdatePowerupSSj( )
	if #self._teamUnitList > 0 then
		_zoomSetScale(1)
		Game.disableInteraction = true
		if self._initUnit == false then
			local ssjUnitID = self._teamUnitList[self._cpIDX]
			local ssjUnit = self._unitTable[ssjUnitID.id]
			ssjUnitID.currTime = Game.worldTimer
			map:setScreen(ssjUnit.act_x, ssjUnit.act_y)
			self._initUnit = true
		else
			map:scroll( )
			if map:getScrollStatus( ) == false then
				
				local ssjUnitID = self._teamUnitList[self._cpIDX]
				local ssjUnit = self._unitTable[ssjUnitID.id]
				anim:updateAnim(self._ssjAnim, ssjUnit.act_x - 16, ssjUnit.act_y - 24 )
				
				if Game.worldTimer > ssjUnitID.currTime + (0.8) then
					if self._cpIDX < #self._teamUnitList then
						self._cpIDX = self._cpIDX + 1
						self._initUnit = false
						--anim:setFrame(self._ssjAnim, 1)
					else
						self._teamUnitList = {}
						anim:updateAnim(self._ssjAnim, - 2000, - 2000)
						_zoomSetScale(3)
						Game.disableInteraction = false
						print("OLD SCALE")
					end
				end
			else
				anim:updateAnim(self._ssjAnim, -2000, -2000 )
			end
		end
	end

end]]