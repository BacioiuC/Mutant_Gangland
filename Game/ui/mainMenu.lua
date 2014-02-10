function interface:initMM( )
	
	self._tweenButtons = true
	buttonTextStyle = {
			font = "arial-rounded.TTF",
			size = 17,
			color = {0.1, 0.1, 0.9, 1},			
	}

	--interface:createMainPanel( )
	self:_createMainMenu( )

	local isSoundPlaying = sound:getCategoryPlaying(SOUND_MAIN_MENU)

	if isSoundPlaying == false then
		sound:playFromCategory(SOUND_MAIN_MENU)
	end

	self._showOptions = false
end

function interface:_setOptions( state )
	self._showOptions = state
	if state == false then
		print("IT IS false")
		Game:saveOptionsState( )
	end
end

function interface:_getOptions( )
	return self._showOptions
end

function interface:_createMainMenu( )
	local roots, widgets, groups = element.gui:loadLayout(resources.getPath("mainMenu.lua"), "")

	if (nil ~= widgets.background) then
	  self._mmBgPanel = widgets.background.window
	  print("BG PANEL REGISTERED")
	else
		print("ONE FAIL")
	end

	if (nil ~= widgets.btnBattle) then
	  freeBattleButton = widgets.btnBattle.window
	  print("BbtnBattle REGISTERED")
	else
		print("ONE FAIL")
	end

	if (nil ~= widgets.btnEditor) then
	  lvEditorButton = widgets.btnEditor.window
	  print("BbtnBattle REGISTERED")
	else
		print("ONE FAIL")
	end

	if (nil ~= widgets.btnOptions) then
	  optionsButton = widgets.btnOptions.window
	  print("BbtnBattle REGISTERED")
	else
		print("ONE FAIL")
	end

	if (nil ~= widgets.btnQuit) then
	  quitButton = widgets.btnQuit.window
	  print("btnQuit REGISTERED")
	else
		print("ONE FAIL")
	end

	if (nil ~= widgets.bgBar) then
		mmBgBar = widgets.bgBar.window
	else
		print("BG BAR FAIL")
	end

	if (nil ~= widgets.volSlider) then
		self._volSlider = widgets.volSlider.window
	else
		print("VOL SLIDER FAIL")
	end

	if (nil ~= widgets.btnConOn) then
		fullScreenOnBttn = widgets.btnConOn.window
	else
		print("no fullscreens sennor")
	end

	--btnConfOff

	if (nil ~= widgets.btnConfOff) then
		fullScreenOFfBttn = widgets.btnConfOff.window
	else
		print("no fullscreens sennor")
	end

	if (nil ~= widgets.btnZoomOn) then
		ZoomOnBttn = widgets.btnZoomOn.window
		ZoomOnBttn:registerEventHandler(ZoomOnBttn.EVENT_BUTTON_CLICK, nil, _handleZoomOnButtonPressed)
		
	else
		print("Zoom buttons activated sennor")
	end

	--btnConfOff

	if (nil ~= widgets.btnZoomOff) then
		ZoomOFfBttn = widgets.btnZoomOff.window
		ZoomOFfBttn:registerEventHandler(ZoomOFfBttn.EVENT_BUTTON_CLICK, nil, _handleZoomOffButtonPressed)
	else
		print("no zoom button sennor")
	end


	self._volSlider:setRange(1, 100)
	
	

	local tb, bool = Game:loadOptionsState( )
	if bool == true then
		self._volSlider:setCurrValue(tb.soundVolume*100)
		Game.masterVolume = tb.soundVolume
		Game.optionControls.soundVolume = tb.soundVolume
		Game.optionControls.uiZoomToggle = tb.uiZoomToggle
	else
		self._volSlider:setCurrValue( Game.masterVolume*100 )
		Game.optionControls.uiZoomToggle = false

	end
	sound:setGeneralVolume(Game.masterVolume)
	self._volSlider:registerEventHandler(self._volSlider.EVENT_SLIDER_VALUE_CHANGED, nil, _VolumeSliderValueChanged, self._volSlider)

	freeBattleButton:registerEventHandler(freeBattleButton.EVENT_BUTTON_CLICK, nil, _handleFreeBattleButtonPressed)
	lvEditorButton:registerEventHandler(lvEditorButton.EVENT_BUTTON_CLICK, nil, _handleLevelEditorPressed )
	optionsButton:registerEventHandler(optionsButton.EVENT_BUTTON_CLICK, nil, _handleOptionsPressed )
	quitButton:registerEventHandler(quitButton.EVENT_BUTTON_CLICK, nil, _handleQuitPressed )
	fullScreenOFfBttn:registerEventHandler(fullScreenOFfBttn.EVENT_BUTTON_CLICK, nil, _handleFullScrOffPressed )

	fullScreenOnBttn:registerEventHandler(fullScreenOnBttn.EVENT_BUTTON_CLICK, nil, _handleFullScrPressed )
end

function interface:createMainPanel( )
	mmPanel = element.gui:createImage()
	mmPanel:setDim(100, 100)
	mmPanel:setPos(0,0 )
	mmPanel:setImage(element.resources.getPath("main_menu/main_menu.png"))
	interface:createButtons( )
end

function interface:createButtons( )
	campaignButton = element.gui:createButton( )
	campaignButton:setDim(30, 18)
	campaignButton:setPos(2, 70)
	campaignButton:setText("CAMPAIGN")
	campaignButton:setNormalImage(element.resources.getPath("main_menu/button_temp.png") )
	campaignButton:setHoverImage(element.resources.getPath("main_menu/button_temp_hover.png") )
	campaignButton:setPushedImage(element.resources.getPath("main_menu/button_temp_hover.png") )
	--button_temp
	--button_temp_hover
	campaignButton:registerEventHandler(campaignButton.EVENT_BUTTON_CLICK, nil, _handleCampaignButtonPressed)

	freeBattleButton = element.gui:createButton( )
	freeBattleButton:setDim(30, 18)
	freeBattleButton:setPos(35, 70)
	freeBattleButton:setText("FREE BATTLE")
	freeBattleButton:setNormalImage(element.resources.getPath("main_menu/button_temp.png") )
	freeBattleButton:setHoverImage(element.resources.getPath("main_menu/button_temp_hover.png") )
	freeBattleButton:setPushedImage(element.resources.getPath("main_menu/button_temp_hover.png") )
	
	freeBattleButton:registerEventHandler(freeBattleButton.EVENT_BUTTON_CLICK, nil, _handleFreeBattleButtonPressed)

	lvEditorButton = element.gui:createButton( )
	lvEditorButton:setDim(30, 18)
	lvEditorButton:setPos(34+4+30, 70)
	lvEditorButton:setText("LEVEL EDITOR")
	lvEditorButton:registerEventHandler(lvEditorButton.EVENT_BUTTON_CLICK, nil, _handleLevelEditorPressed )
	lvEditorButton:setNormalImage(element.resources.getPath("main_menu/button_temp.png") )
	lvEditorButton:setHoverImage(element.resources.getPath("main_menu/button_temp_hover.png") )
	lvEditorButton:setPushedImage(element.resources.getPath("main_menu/button_temp_hover.png") )

	
	mmPanel:addChild(lvEditorButton)
	mmPanel:addChild(freeBattleButton)
	mmPanel:addChild(campaignButton)
end

function interface:_updateMMButtons( )
	

	if self._showOptions == true then
		mmBgBar:tweenPos(-32, 70)
	else
		mmBgBar:tweenPos(0, 70)
	end
end