
local data = {
		bgPanel = {
			widget = "image",
			pos = { -80, 2 },
			dim = { 68 , 84 },
			images = {
				{
					fileName = "../gui/buy_menu/background_for_buy.png",
				},

			},
			children = { -- and controls go here

				unitWidget = {
					widget = "widget list",
					pos = { 2 , 6 },
					dim = { 35 , 90 },
					selectionImage = "../gui/buy_menu/selection_image.png",
					maxSelect = 1,
					rowHeight = 14,
					columns = {
						{"", 8, "Image"},
						{"", 23, "Image"},
					},

				}, -- end unit widget

				infoWidgetBG = {
					widget = "image",
					pos = {34, 6},
					dim = {30, 71},
					images = {
						{
							fileName = "../gui/buy_menu/background_for_buy.png",
						},

					},
					children = {
						infoWidget = {
							widget = "widget list",
							pos = { 1 , 4 },
							dim = { 30 , 71 },
							selectionImage = "../gui/buy_menu/selection_image2.png",
							maxSelect = 1,
							rowHeight = 8,
							columns = {
								{"", 1, "image"},
								{"", 5, "image"},
								{"", 20, "image"},
							},


						}, -- end info widget



						cancelButton = {
							widget = "button",
							pos = { 3 , 58 },
							dim = { 12 , 8 },
							text = "Cancel",
							images = {
								normal = {
									{
										fileName = "../gui/buy_menu/quit_button.png",
										color = {1, 1, 1, 1},
									},
								},

								pushed = {
									{
										fileName = "../gui/buy_menu/cancel_button_hover.png",
										color = {1, 1, 1, 1},
									},
								},

								hover = {
									{
										fileName = "../gui/buy_menu/cancel_button_hover.png",
									},
								},
							},
						},
						buyButton = {
							widget = "button",
							pos = { 16 , 58 },
							dim = { 12 , 8 },
							text = "Buy",
							images = {
								normal = {
									{
										fileName = "../gui/buy_menu/end_turn_button.png",
										color = {1, 1, 1, 1},
									},
								},

								pushed = {
									{
										fileName = "../gui/buy_menu/buy_hover.png",
									},
								},

								hover = {
									{
										fileName = "../gui/buy_menu/buy_hover.png",
									},
								},
							},
						},

					},

				},


			}, -- end children


		},	


	}

return data