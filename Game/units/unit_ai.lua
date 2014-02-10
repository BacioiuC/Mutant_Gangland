function unit:_handleBuild_ai( )
	self:_selectBuild_ai( )
end



function unit:_handleMove_ai( )
	self:_moveUnit_ai( )
end


function unit:_handleAttacK_ai( )
	unit:_attackPlayer_ai( )
	--unit:_nextStep( )
end

