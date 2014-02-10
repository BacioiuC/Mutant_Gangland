influenceMap = {}

function math.clamp(low, n, high) return math.min(math.max(n, low), high) end

function influenceMap:init(_maxInfluence)
	self._influences = {}
	self._minInfluence = -_maxInfluence
	self._maxInfluence = _maxInfluence
	self._width = nil
	self._height = nil

	self._influenceMapping = {}
end

function influenceMap:setDim(_w, _h)
	self._width = _w
	self._height = _h
end


function influenceMap:Key(_p1, _p2)
	self._influences[1] = _p1
	self._influences[2] = _p2
end

function influenceMap:getInfluenceByPlayer(_player) -- most likely, player = unit:_returnTurn( )
	return self._influences[_player]
end

function influenceMap:getTotalInfluence( )
	return self:getInfluenceByPlayer( 1 ) - self:getInfluenceByPlayer( 2 )
end

function influenceMap:setInfluenceForPlayer(_player, _vector)
	self._influences[_player] = math.max(_vector, self._influences[_player] )
end

function influenceMap:getTotalInfluenceAt(_x, _y)
	local ret = 0

	if (_x >= 0 and _x < self._width 
		and _y >= 0 and _y <= self._height ) then
		self._influenceMapping[_y * _width + x] = self:getTotalInfluence( )
		ret = self._influenceMapping[_y * _width + x]
	end

	return math.clamp(ret, self._minInfluence, self._maxInfluence)
end

function influenceMap:getInfluencePercentAt(_x, _y)
	return self:getTotalInfluenceAt(_x, _y) / self._maxInfluence
end

function influenceMap:getInfluenceByPlayerAt(_player, _x, _y)
	local ret = 0

	if (_x >= 0 and _x < self._width 
		and _y >= 0 and _y <= self._height ) then
		self._influenceMapping[_y * _width + x] = self:getInfluenceByPlayer(_player)
		ret = self._influenceMapping[_y * _width + x]
	end

	return ret
end

