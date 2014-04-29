local data = {
	backGround = {
		widget = "image",
		dim = { 100, 100 },
		pos = { 0, 0 },
		images = {
			{

				fileName = "../gui/cmd.png"
			},

		}, -- end of images
		children = {
			textBox = {
				widget = "text box",
				dim = { 90, 80 },
				pos = { 5, 5},

			}, -- end of text box


			inputBoxWid = {
				widget = "edit box",
				dim = { 90, 15 },
				pos = { 5, 82.5 },
				text = "THIS IS A TEST",

			}, -- end of inputBox widgets
		}, -- end of bg children


	}, -- end of bg



}

return data