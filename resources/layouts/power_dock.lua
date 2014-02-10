
local data = {
	dockPanel = {
		widget = "image",
		dim = { 16, 39 },
		pos = { -100, 27 },
		images = {
			{

				fileName = "../gui/action_phase/dock_panel.png"
			},

		}, -- end of images

		children = {
			header = {
				widget = "image",
				dim = { 6, 2 },
				pos = { 0, 0 },
				--[[images = {
					{
						fileName = "../gui/action_phase/header_png.png"
					}

				},--]] -- end of header images

			}, -- end of header

			abilityButton = {
				widget = "button",
				dim = { 6, 9 },
				pos = { 0.5, 0.5 },
			},

			abilityButton2 = {
				widget = "button",
				dim = { 6, 9 },
				pos = { 8, 0.5 },
			},
					
			infoWidget = {
				widget = "widget list",
				pos = { 0.5, 12 },
				dim = { 25 , 35 },
				selectionImage = "../gui/buy_menu/selection_image2.png",
				--backgroundImage = "../gui/buy_menu/selection_image.png",
				maxSelect = 1,
				rowHeight = 6,
				columns = {
					{"", 4, "Image"},
					{"", 5, "label"},
					{"", 6, "label"},
				},

			}, -- end of info widget

		}, -- end of dockPanel Children

	}

} -- end of data

return data