weffect = { }

function weffect:new(_stringName, _x, _y, _animToUse, _maxFrames, _attachTo, _loop, _doOffset)
	local path = "mods/"..Game.modInUse.."/"
	if file_exists(""..path.."".._stringName.."") == false then
		path = "Game/"
	
	end

	local temp = effect:new(_stringName, _x, _y, _animToUse, _maxFrames, _attachTo, _loop, _doOffset)
	return temp
end