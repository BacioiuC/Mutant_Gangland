input = {}
inputFlag = true
function input:init( )
	self.inputTable = {}
	self._inputFlag = true
	print ( MOAIInputMgr.configuration )
	--print( "pana mea, seems to be workin'")
end

function input:update( )
	

end

function input:setFlagTo(_flag)
	inputFlag = _flag
end

function input:_getFlag( )
	--print("HAPPENING FLLAGG")
	if inputFlag == true then
		--print("FREAKING TRUE")
	end
	return self._inputFlag
end

function input:isMouseDown( )

end

function input.onKeyboardEvent ( key, down )

	if down == true then
		Game:keypressed( key )
		g:injectKeyDown(key)
	elseif down == false then
		Game:keyreleased( key )
		g:injectKeyUp(key)
	end
	print(" "..key.."")

end



function input.onPointerEvent ( x, y )
	--print ( "pointer: "..x.." "..y.."" )
	local flag = input:_getFlag( )
	if inputFlag == true then
		--print("INPUT FLAG IS TRUE")
		g:injectMouseMove(x, y)
		Game.touchLocation( x, y )
	end
end




function input.onMouseLeftEvent ( down, idx )
	local flag = input:_getFlag( )
	if inputFlag == true then
		if down == true then
			g:injectMouseButtonDown(inputconstants.LEFT_MOUSE_BUTTON)
			
			Game:touchPressed (idx)
	    	
	    
		else
			g:injectMouseButtonUp(inputconstants.LEFT_MOUSE_BUTTON)
			Game:touchLeftReleased (idx)
			
		end
	end
end

function input.onMouseRightEvent( down )
	if inputFlag == true then
		if down == true then
			g:injectMouseButtonDown(inputconstants.LEFT_MOUSE_BUTTON)
			
			Game:touchRight ( )
	    	
	    
		else
			g:injectMouseButtonUp(inputconstants.LEFT_MOUSE_BUTTON)
			Game:touchReleased ( )
			
		end
	end
end



function input.touchEvent( eventType, idx, x, y, tapCount )
	if inputFlag == true then
		input.onPointerEvent ( x, y )

		if eventType == MOAITouchSensor.TOUCH_DOWN then
			
			input.onMouseLeftEvent(true, idx)
			
		elseif eventType == MOAITouchSensor.TOUCH_UP then	
			input.onMouseLeftEvent(false, idx)
			--Game:touchLeftReleased ( )
			--g:injectMouseButtonDown(inputconstants.LEFT_MOUSE_BUTTON)

		end
	end
end

function input.joystickEvent( )

end

if  MOAIEnvironment.osBrand ~= "Android" then
	MOAIInputMgr.device.keyboard:setCallback ( input.onKeyboardEvent )
	MOAIInputMgr.device.pointer:setCallback ( input.onPointerEvent )
	MOAIInputMgr.device.mouseLeft:setCallback ( input.onMouseLeftEvent )
	MOAIInputMgr.device.mouseRight:setCallback ( input.onMouseRightEvent )
else
	MOAIInputMgr.device.touch:setCallback ( input.touchEvent )
end

 --