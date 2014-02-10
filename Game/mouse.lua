mouse = {}

--map.offsetX-map.scale + x * (32+map.scale)
function mouse:getX( )
	local mx = love.mouse.getX()
	local rx = mx / 32
	local sx, sy = camera:returnScale()
	local px, py = camera:returnPosition( )
	return math.floor(rx)
end

function mouse:getY( )
	local my = love.mouse.getY()
	local ry = my / 32
	local sx, sy = camera:returnScale()
	local px, py = camera:returnPosition( )
	return math.floor(ry)
end

function mouse:drawPointer( )
	love.graphics.setColor(0,255,0)
	love.graphics.rectangle("line",mouse:getX()*32, mouse:getY()*32, 32, 32)
	love.graphics.setColor(255,255,255)
end

function mouse:setCalibration( _cx, _cy)
	mouse.cx = _cx
	mouse.cy = _cy

end

function mouse:setTapped(_flag)	
	mouse.tapped = _flag
end

function mouse:returnTapState( )
	return mouse.tapped
end

function mouse:returnCalibration( )
	return mouse.cx, mouse.cy
end