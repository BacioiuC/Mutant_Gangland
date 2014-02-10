info = {}

-- used to display messages (dialogue) or tutorials
-- unit and building id's can be binded and pointed out
function info:init( )
	self._infoTable = { }
	self._highlightTable = { }
	self._textStream = { }
	self._streamID = 0

	self._dialogue = 1
	self._tutorial = 2
	self._other = 3

	local roots, widgets, groups = element.gui:loadLayout(resources.getPath("info_dialogueLayout.lua"), "")

	-- bind the panels
	if (nil ~= widgets.dialoguePanel) then
	  self._dialoguePanel = widgets.dialoguePanel.window
	  print("BG PANEL REGISTERED")
	else
		print("ONE FAIL")
	end

	if (nil ~= widgets.picture) then
	  self._picturePanel = widgets.picture.window
	  print("BG PANEL REGISTERED")
	else
		print("ONE FAIL")
	end

	if (nil ~= widgets.dText) then
	  self._textBox = widgets.dText.window
	  print("BG PANEL REGISTERED")
	else
		print("ONE FAIL")
	end

	if (nil ~= widgets.cButton) then
		self._confirmButton = widgets.cButton.window
		self._confirmButton:registerEventHandler(self._confirmButton.EVENT_BUTTON_CLICK, nil, _handleConfirmButtonPressed)
	else

	end

	self._tweenBox = true
end

function info:new(_image, _text)
	 self._picturePanel:setImage(element.resources.getPath("/info/img/".._image..".png"))
	 self._textBox:setText("".._text.."")

end

function info:diplayText(_textStreamID)

end

function info:update( )
	if self._tweenBox == true then
		self._dialoguePanel:tweenPos(0, 75)
	else
		self._dialoguePanel:tweenPos(0, 125)
	end
end

function info:highlight(_type, _id) -- type - type of object to display. 1 for unit, 2 for building

end

function info:setTweenState(_state)
	self._tweenBox = _state
end

function _handleConfirmButtonPressed( )
	print("HAPPENED")
	info:setTweenState(false)
end