
local data = {
	dockPanel = {
		widget = "image",
		dim = { 35, 48 },
		pos = { -100, 27 },
		images = {
			{

				fileName = "../gui/action_phase/background_for_buy.png"
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

			labelBonus = {
				widget = "label",
				dim = { 30, 6 },
				pos = {3, 3},
				text = "+ Commander Bonus",

			},
					
			infoWidget = {
				widget = "widget list",
				pos = { 3, 10 },
				dim = { 26 , 32 },
				selectionImage = "../gui/buy_menu/selection_image2.png",
				--backgroundImage = "../gui/buy_menu/selection_image.png",
				maxSelect = 1,
				rowHeight = 7,
				columns = {
					{"", 5, "Image"},
					{"", 7, "label"},
					{"", 7, "label"},
				},

			}, -- end of info widget

		}, -- end of dockPanel Children

	}

} -- end of data

return data


