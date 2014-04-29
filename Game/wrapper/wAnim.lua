wanim = { }

function wanim:newDeck(_deckName, _tileSize, _layer)
	local path = "mods/"..Game.modInUse.."/"
	if file_exists(""..path.."".._deckName.."") == false then
		path = "Game/"
	
	end
	local temp = anim:newDeck(""..path.."".._deckName.."", _tileSize, _layer)
	return temp
end