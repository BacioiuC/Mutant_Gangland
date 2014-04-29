camera = {}
camera.x = 0
camera.y = 0
camera.scaleX = 1
camera.scaleY = 1
camera.rotation = 0
camera.sensitivity = 8

Game.mouseX = 0
Game.mouseY = 0

Game.pressedX = Game.mouseX
Game.pressedY = Game.mouseY

function camera:init( )
  -- load Joystick pos
  joyStick_base_tex = wimage:newTexture("Game/media/touchPressed_base.png",2,"JOySTICK_BASE")
  joyStick_top_tex = wimage:newTexture("Game/media/touchPressed_joystick.png",2,"JOYSTICK_TOP")

  joyStick_base = image:newImage(joyStick_base_tex, Game.mouseX,Game.mouseY)
  joyStick_top = image:newImage(joyStick_top_tex, Game.mouseX,Game.mouseY)

  image:setVisible(joyStick_base, false)
  image:setVisible(joyStick_top, false)

  self._offX = 0
  self._offY = 0

  self._scrollMap = true
end

function camera:setScroll(_bool)
    self._scrollMap = _bool
end

function camera:getScroll( )
  return self._scrollMap
end

function camera:update( )
    if MouseDown == true and self._scrollMap == true then

      local difMouseX = -math.floor((Game.pressedX - Game.mouseX))
      local difMouseY = -math.floor((Game.pressedY - Game.mouseY))
     
      image:updateImage(joyStick_base, Game.pressedX, Game.pressedY)
      image:updateImage(joyStick_top, Game.mouseX, Game.mouseY)
    --  if Game.currentState == 5 then
      local st = state[currentState]
      if st == "LevelEditor" then
        --print("LOOPIN'")
        lEditor:updateScreen(difMouseX,difMouseY)
      elseif st == "Levels" then

        worldMap:updateScreen(difMouseX, math.floor(difMouseY))
      else
        if unit:_returnTypeOfPlayer( ) == "Human" then
         map:updateScreen(math.floor(difMouseX),math.floor(difMouseY))
        end
      end
     -- elseif Game.currentState == 3 then
      --  isoMap:updateScreen(difMouseX,difMouseY)
      --end

    end
 -- end
  
  if difMouseX ~= nil then
    self._offX = math.floor(difMouseX)
    self._offY = math.floor(difMouseY)
  else
    self._offX = self._offX
    self._offY = self._offY
  end


  Game.pressedX = Game.mouseX
  Game.pressedY = Game.mouseY

  
end

function camera:returnOffset( )
  return  self._offX,  self._offY
end

function camera:setOffset(_offX, _offY, _unit)

  map:setScreen( _offX, _offY,  _unit )

end

function camera:followOffset(_offX, _offY)
  --self._offX = _offX - self._offX
 -- self._offY = _offY - self._offY
 local _nOffX = self._offX 
 local _nOffY = self._offY 
--  self._x = self._x + (_twX - self._x ) * 0.1
--  self._y = self._y + (_twY - self._y ) * 0.1

_nOffX = _nOffX + (-_offX - _nOffX ) * 0.1
_nOffY = _nOffY + (-_offY - _nOffY ) * 0.1
local mapX, mapY = map:returnSize( )
local _mpx = math.floor(mapX * 16  )
local _mpy = math.floor(mapY * 16  )
map:setScreen( _nOffX, _nOffY )

--self._offX = _nOffX
--self._offY = _nOffY
end

function camera:setJoystickVisible( )
 -- if Game.currentState == 5 or Game.currentState == 3 then
    image:setVisible(joyStick_base, true)
    image:setVisible(joyStick_top, true)
    Game.pressedX = Game.mouseX
    Game.pressedY = Game.mouseY
  --mouseClicked = true
 -- end
end

function camera:setJoystickHidden( )
  --if Game.currentState == 5 or Game.currentState == 3 then
    image:setVisible(joyStick_base, false)
    image:setVisible(joyStick_top, false)
    Game.pressedX = Game.mouseX
    Game.pressedY = Game.mouseY
   -- mouseClicked = false
  --end
end