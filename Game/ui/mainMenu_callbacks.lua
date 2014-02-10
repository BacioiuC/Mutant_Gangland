function _handleLevelEditorPressed( )
	_bGuiLoaded = false
	_bGameLoaded = false
	sound:stopAllFromCategory(SOUND_MAIN_MENU)
	Game:dropUI(g, resources )
	currentState = 9
end

function _handleCampaignButtonPressed( )
	_bGuiLoaded = false
	_bGameLoaded = false
	--sound:stopAllFromCategory(SOUND_MAIN_MENU)
	Game:dropUI(g, resources )
	currentState = 4
	MOAISim.forceGarbageCollection( )
end

function _handleFreeBattleButtonPressed( )
	_bGuiLoaded = false
	_bGameLoaded = false
	--sound:stopAllFromCategory(SOUND_MAIN_MENU)
	Game:dropUI(g, resources )
	currentState = 10
	MOAISim.forceGarbageCollection( )
end

function _handleOptionsPressed( )
	local bool = interface:_getOptions( )
	interface:_setOptions( not bool)
	
end

function _VolumeSliderValueChanged( event, data )

	print("WORKS?Value: "..data:getCurrValue() )
	Game.masterVolume = data:getCurrValue()/100
	sound:setGeneralVolume(Game.masterVolume)
	Game.optionControls.soundVolume = Game.masterVolume
	Game:saveOptionsState( )
end

function _handleQuitPressed(   )
	os.exit()
end

function _handleFullScrPressed( )
	core:setFullscreen(true)
end

function _handleFullScrOffPressed( )
	core:setFullscreen(false)
end

function _handleZoomOnButtonPressed( )
	Game.optionControls.uiZoomToggle = true
	Game:saveOptionsState( )
	print("UI TOGGLE SET TO TRUE")
end

function _handleZoomOffButtonPressed( )
	Game.optionControls.uiZoomToggle = false
	Game:saveOptionsState( )
	print("UI TOGGLE SET TO FALSE")
end