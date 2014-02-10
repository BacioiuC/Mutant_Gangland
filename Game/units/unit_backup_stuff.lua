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