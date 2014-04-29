scriptCore = { }

function scriptCore:init( )
	self._scriptTable = { }
	self._scriptType = 1 --[[
		script types should be:
		1 - on entry - execute once
		2 - on exit - execute once
		3 - loop?

	]]
end