event = {}

function event:init( )
	self._eventTable = { }
	--types of events
	--[[


	--]]
	unit_spawned_event = 1
	unit_moved_event = 2
	unit_battle_event = 3
	unit_killed_event = 4
	building_captured_event = 5
	factory_captured_event = 6

	
end

function event:sendEvent( event_type, _data1, _data2 )
	-- first param = event identifier
	-- second and third = data params
	-- example: sendEvent( unit_spawned_event, unit.team, unit.type )
	local temp = {
		id = #self._eventTable+1,
		data1 = _data1,
		data2 = _data2,
	}
	table.insert(self._eventTable, temp)
end

function event:listener( )

end