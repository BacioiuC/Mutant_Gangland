wimage = { }

--[[
	Basic idea: Use a wrapper to check if file exists under /mods/whatever instead of Game/what ever. If that is the case, load it from there
	Going to do the same for animation and everything



]]
function wimage:newTexture(_fileName, _parrentLayer, _name, _isDeck, _tileSize)
	local path = "mods/"..Game.modInUse.."/"
	if file_exists(""..path.."".._fileName.."") == false then
		path = "Game/"
	
	end
	--temp.name, self.imageTable[tableIndex].image, self.imageTable[tableIndex].texture
	local name, tImage, tTexture = image:newTexture(""..path.."".._fileName.."", _parrentLayer, _name, _isDeck, _tileSize)
	return name, tImage, tTexture
end
	

function wimage:newDeckTexture(_fileName, _parrentLayer, _name, _tileSize, _isGrid)
	local path = "mods/"..Game.modInUse.."/"
	if file_exists(""..path.."".._fileName.."") == false then
		path = "Game/"
	end
	local name, tImage, tTexture = image:newDeckTexture(""..path.."".._fileName.."", _parrentLayer, _name, _tileSize, _isGrid)
	return name, tImage, tTexture
end
