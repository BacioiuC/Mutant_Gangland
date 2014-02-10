function interface:_initEndScreen( )
	self._panel1 = element.gui:createImage( )
	self._panel1:setImage(element.resources.getPath("win/vict.png"))
	self._panel1:setPos(-50,0)
	self._panel1:setDim(50, 100)

	self._panel2 = element.gui:createImage( )
	self._panel2:setImage(element.resources.getPath("win/ory.png"))
	self._panel2:setPos(100,0)
	self._panel2:setDim(50, 100)



	self._backToWorldMapButton = element.gui:createButton( )
	self._backToWorldMapButton:setDim(40, 18)
	self._backToWorldMapButton:setPos(5, 40)
	self._backToWorldMapButton:setNormalImage(element.resources.getPath("win/worldmap_backButton.png"))
	self._backToWorldMapButton:setHoverImage(element.resources.getPath("win/worldmap_backButton_hover.png"))
	self._backToWorldMapButton:registerEventHandler(self._backToWorldMapButton.EVENT_BUTTON_CLICK, nil, _handleBackToWorldPressed )

	self._panel2:addChild(self._backToWorldMapButton)	

	self._showEndScreen = false
end

function interface:_setEndScreen(_state)
	self._showEndScreen = _state
end

function interface:_tweenEndPanels( )
	if self._showEndScreen == true then
		self._panel1:tweenPos(0, 0)
		self._panel2:tweenPos(50, 0)
	else
		self._panel1:tweenPos(-50, 0)
		self._panel2:tweenPos(100, 0)
	end
end

function _handleBackToWorldPressed( )
	unit:_quitToWorldMap( )
	sound:stopAll( )
end