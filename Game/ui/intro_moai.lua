function interface:_setupLoadScreen( )
	local roots, widgets, groups = element.gui:loadLayout(resources.getPath("intro_file.lua"), "")

	-- load sounds here
	Game:prepareAllSounds( )

	
	self._introImage = 1
	self._MoaiIntrotimer = Game.worldTimer
end

function interface:_switchTo_introText( )
	if Game.worldTimer > self._MoaiIntrotimer + 2 and self._introImage == 1 then
		print("WELLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL")
		Game:dropUI(g, resources )
		local roots, widgets, groups = element.gui:loadLayout(resources.getPath("story_file.lua"), "")
		self._introImage = 2
		self._newTimer = Game.worldTimer
	end

	if self._introImage == 3 then
		print("moving to MAIN MENU")
		
		_bGuiLoaded = false
		_bGameLoaded = false
		Game:dropUI(g, resources )
		currentState = 2
	end
end

function interface:_introGetIntroState( )
	return self._introImage
end

function interface:_setIntroState( state )
	self._introImage = 3
end