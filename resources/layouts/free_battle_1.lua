local data = {
	bgPanel = { -- MAIN BACKGROUND 
		widget = "image",
		pos = { -100, 0 },
		dim = { 200, 150 },
		images = {
			{
				fileName = "../gui/maps/background_mapsel2.png",
			},			
		},
		children = {
			mapDock = {
				widget = "image",
				pos = {3, 8},
				dim = {65, 67},
				images = {
					{
						fileName = "../gui/maps/button_holder_mps.png",
					},			
				},
				children = {

					categoryBar = {
						widget = "image",
						pos = { 6, -4 },
						dim = { 53 , 11 },
						images = {
							{

								fileName = "../gui/maps/bg_normal_4x4.png",
							},

						},  -- end of images

						children = {
							prevButton = {
								widget = "button",
								pos = { 1 , 1.5 },
								dim = { 6, 8 },
								text = " < ",
								images = {
									normal = {
										{
											fileName = "../gui/maps/up_button_up.png",
											--color = {1, 1, 1, 1},
										},
									},

									pushed = {
										{
											fileName = "../gui/maps/up_button_down.png",
											color = {1, 1, 1, 1},
										},
									},

									hover = {
										{
											fileName = "../gui/maps/up_button_down.png",
											color = {1, 1, 1, 1},
										},
									},
								},
							}, -- end of prevButton

							nextButton = {
								widget = "button",
								pos = { 46 , 1.5 },
								dim = { 6 , 8 },
								text = " > ",
								images = {
									normal = {
										{
											fileName = "../gui/maps/up_button_up.png",
											--color = {1, 1, 1, 1},
										},
									},

									pushed = {
										{
											fileName = "../gui/maps/up_button_down.png",
											color = {1, 1, 1, 1},
										},
									},

									hover = {
										{
											fileName = "../gui/maps/up_button_down.png",
											color = {1, 1, 1, 1},
										},
									},
								},
							}, -- end of next button

							categoryNameLabel = {
								widget = "label",
								dim = { 30 , 6 },
								pos = { 20 , 3 },
								text = "NORMAL",

							}, -- end of category label

						}, -- end of categoryBarChildren

					},-- end of category bar

					scroll_holder = {
						widget = "image",
						dim = {32, 16},
						pos = { 20, 67 },
						images = {
							{

								fileName = "../gui/maps/holder_scroll_button.png",
							},

						}, -- end of scroll images

						children = {
							upButton = {
								widget = "button",
								dim = { 8 , 10 },
								pos = { 2 , 2 },
								text = "up",
								images = {
									normal = {
										{
											fileName = "../gui/maps/up_button_up.png",
											--color = {1, 1, 1, 1},
										},
									},

									pushed = {
										{
											fileName = "../gui/maps/up_button_down.png",
											color = {1, 1, 1, 1},
										},
									},

									hover = {
										{
											fileName = "../gui/maps/up_button_down.png",
											color = {1, 1, 1, 1},
										},
									},
								},
							}, -- end of up button

							downButton = {
								widget = "button",
								dim = { 8 , 10 },
								pos = { 22 , 2 },
								text = "down",
								images = {
									normal = {
										{
											fileName = "../gui/maps/up_button_up.png",
											color = {1, 1, 1, 1},
										},
									},

									pushed = {
										{
											fileName = "../gui/maps/up_button_down.png",
											color = {1, 1, 1, 1},
										},
									},

									hover = {
										{
											fileName = "../gui/maps/up_button_down.png",
											color = {1, 1, 1, 1},
										},
									},
								},
							}, -- end of up button

						},

					}, -- end of scroll holder



					mapDetails = { -- info about map size, factories, houses, etc
						widget = "widget list",
						pos = { 65 , 35 },
						dim = { 29 , 30 },
						selectionImage = "selection image.png",
						maxSelect = 1,
						rowHeight = 5,
						columns = {
							{"", 12, "label"},
							{"", 14, "label"},
						},

					}, -- end of map details

					mapImgHolder = { 
						widget = "image",
						pos = {65, 3},
						dim = {28, 36},
						images = {
							{
								fileName = "../gui/maps/map_img_holder.png",
							},

						}, -- end of mapImgHolder Images
						children = {
							mapImage = {
								widget = "image",
								pos = { 0.5, 3 },
								dim = { 25, 30 },
								images = {
									{
									fileName = "../gui/maps/firstfront.png",
									},
								},	

							}, -- end of mapImage
						},
					},


					continueButton = {
						widget = "button",
						pos = { 77, 75 },
						dim = { 16, 12 },
						text = "Continue",
						images = {
							normal = {
								{
									fileName = "../gui/maps/continue_button_up.png",
									color = {1, 1, 1, 1},
								},
							},

							pushed = {
								{
									fileName = "../gui/maps/continue_button_down.png",
									color = {1, 1, 1, 1},
								},
							},

							hover = {
								{
									fileName = "../gui/maps/continue_button_down.png",
									color = {1, 1, 1, 1},
								},
							},
						},
					}, -- end of continue button

					returnToMenu = {
						widget = "button",
						pos = { 3 , 75 },
						dim = { 12 , 12 },
						text = "Back",
						images = {
							normal = {
								{
									fileName = "../gui/maps/back_button_up.png",
									color = {1, 1, 1, 1},
								},
							},

							pushed = {
								{
									fileName = "../gui/maps/back_button_down.png",
									color = {1, 1, 1, 1},
								},
							},

							hover = {
								{
									fileName = "../gui/maps/back_button_down.png",
									color = {1, 1, 1, 1},
								},
							},
						},
					},
				}, -- end of children


			}, -- end of menudock children
		}, -- end of menu dock
	}, -- end of bg panel
}

return data