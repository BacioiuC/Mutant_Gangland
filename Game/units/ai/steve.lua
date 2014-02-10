---------------------------------------
-------- UNIT CREATION ----------------
---------------------------------------
function unit:_selectBuild_ai( )
	--print("9000 HERE IN SELECT BUILD AI")
	building:createUnits( )
	unit:_nextStep( )
end	


---------------------------------------
-------- UNIT MOVEMENT ----------------
---------------------------------------
function unit:_moveUnit_ai( )

	dave:think( )
	--unit:_nextStep( )

end

function unit:moveComputerUnits( )
	unit:_nextStep( )
end


function unit:_assignObjectives(_unit)

end

---------------------------------------
-------- UNIT COMBAT ------------------
---------------------------------------

function unit:_attackPlayer_ai( )
	unit:_nextStep( )
end

function unit:_selectAttack_Computer( )
	unit:_nextStep( )

end

-- brake this down into smaller functions
function unit:_pcPerformAttack(_v, _id)
	unit:_nextStep( )
end