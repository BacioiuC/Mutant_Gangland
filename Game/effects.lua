-- @effects module
-- latest revision: v0.0.1
-- maintainer: Bacioiu "Zapa" Ciprian

-- 
function drawscanlines()
	local i
	local shalf = math.floor( screenSize[2]/2)
	local rndY = math.random(-0.5,0.5)
	love.graphics.setColor(0,0,0,128)
	--love.graphics.setLine(1,love.line_rough )
	for i=1,shalf do
		--love.graphics.line(0,i*2-1 + rndY,screenSize[1],i*2-1 + rndY)
		love.graphics.rectangle("fill",0,rndY + i*2-1,screenSize[1],1)
	end
	love.graphics.setColor(255,255,255)
end