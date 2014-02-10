local data = {
	dialoguePanel = {
		widget = "image",
		dim = { 100, 25 },
		pos = { 0, 75 },
		images = {
			{

				fileName = "../gui/info/bg.png"
			},

		}, -- end of dialogueImages

		children = {
			picture = {
				widget = "image",
				dim = { 19, 23 },
				pos = { 1, 1 },
			}, -- end of picture

			dText = {
				widget = "text box",
				dim = { 79, 23 },
				pos = { 19, -8 },
				text = "Commander, minion nr 42 reporting for duty", 
			}, -- end of dText	

			cButton = {
				widget = "button",
				dim = { 8, 8 },
				pos = { 90, 16 },
				text = "ok...",

			}, -- end of cButton
		}, -- end of dialoguePanel Children

	},	


} -- end of data

return data