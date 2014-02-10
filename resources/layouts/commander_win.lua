local data = {
	bgPanel = {
		widget = "image",
		pos = { 0, 0 },
		dim = { 200, 150 },
		images = {
			{
				fileName = "../gui/maps/background_mapsel2.png",
			},			
		},
		children = {
			commanderInfo1 = {
				widget = "image",
				pos = { 102, 2 },
				dim = { 39, 46 },
				images = {
					{
					fileName = "../gui/commander/bg.png",
					},

				}, -- end of images
				children = {

					commanderPicHolder1 = {
						widget = "image",
						pos = { -0.5, -0.5 },
						dim = { 14, 20 },
						images = {
							{
								fileName = "../gui/commander/profile_holder.png"

							},
						}, -- end of commander pic holder

						children = {
							comander1Pic = {
								widget = "image",
								pos = { 1, 1.5 },
								dim = { 11.5, 16.5 },
								images = {
									{
										fileName = "../gui/commander/temp_pic1.png"

									},
								}, -- end of Commander pic Images

							},-- end of Commander pic 

						}, -- end of commander pic holder 1 CHILDREN

					}, -- end of commander pic holder 1

					labelBackground_1 = {
						widget = "image",
						pos = {13, 4.5},
						dim = { 24, 15},
						images = {
							{

								fileName = "../gui/commander/text_bacground.png"
							},

						}, -- end of images
						children = {
							commanderNameLabel1 = {
								widget = "label",
								pos = { 1, 3 },
								dim = { 25, 1 },
								text = "Commander: Darren",
							}, -- end of commander Name Label

							factionNameLabel1 = {
								widget = "label",
								pos = { 1, 8 },
								dim = { 25, 1 },
								text = "Faction: Mutants",
							}, -- end of commander Faction Name Label


						},

					}, -- end of label background 1


					commander1StatWidget = {
						widget = "widget list",
						dim = {36, 30 },
						pos = { 2, 20 },
						selectionImage = "selection image.png",
						maxSelect = 1,
						rowHeight = 4,
						columns = {
							{"", 10, "label"},
							{"", 4, "image"},
							{"", 4, "image"},
							{"", 4, "image"},
							{"", 4, "image"},
							{"", 4, "image"},
						},						

					}, -- end of commander 1 Stat Widget

				}, -- end of commander Info 1 children
			}, -- end of commander info 1

			commanderInfo2 = {
				widget = "image",
				pos = { 159, 2 },
				dim = { 39, 46 },
				images = {
					{
					fileName = "../gui/commander/bg.png",
					},

				}, -- end of images
				children = {

					commanderPicHolder2 = {
						widget = "image",
						pos = { -0.5, -0.5 },
						dim = { 14, 20 },
						images = {
							{
								fileName = "../gui/commander/profile_holder.png"

							},
						}, -- end of commander pic holder

						children = {
							comander2Pic = {
								widget = "image",
								pos = { 1, 1.5 },
								dim = { 11.5, 16.5 },
								images = {
									{
										fileName = "../gui/commander/temp_pic1.png"

									},
								}, -- end of Commander pic Images

							},-- end of Commander pic 

						}, -- end of comPicChidren
					}, -- end of comPicHold2


					labelBackground_2 = {
						widget = "image",
						pos = {13, 4.5},
						dim = { 24, 15},
						images = {
							{

								fileName = "../gui/commander/text_bacground.png"
							},

						}, -- end of images
						children = {
							commanderNameLabel2 = {
								widget = "label",
								pos = { 1, 3 },
								dim = { 25, 1 },
								text = "Commander: Darren",
							}, -- end of commander Name Label

							factionNameLabel2 = {
								widget = "label",
								pos = { 1, 8 },
								dim = { 25, 1 },
								text = "Faction: Mutants",
							}, -- end of commander Faction Name Label


						},

					}, -- end of label background 2

					commander2StatWidget = {
						widget = "widget list",
						dim = {36, 30 },
						pos = { 2, 20 },
						selectionImage = "selection image.png",
						maxSelect = 1,
						rowHeight = 4,
						columns = {
							{"", 10, "label"},
							{"", 4, "image"},
							{"", 4, "image"},
							{"", 4, "image"},
							{"", 4, "image"},
							{"", 4, "image"},
						},						

					}, -- end of commander 1 Stat Widget

				}, -- end of commander Info 1 children
			}, -- end of commander info 2

			commanderPanel1 = {
				widget = "image",
				pos = { 102, 50 },
				dim = { 39, 46 },
				images = {
					{
					fileName = "../gui/commander/bg.png",
					},
				},

				children = {

					Player1LabelBackground = {
						widget = "image",
						pos = { 0, -5 },
						dim = { 40, 10},
						images = {
							{
								fileName = "../gui/commander/player_text_background.png",

							},

						},
						children = {
							Player1Label = {
								widget = "label",
								pos = { 2, 5 },
								dim = { 10, 1 },
								text = "Player 1",
							},
						},
					},


					humanButton1 = {
						widget = "button",
						pos = { 4, 30 },
						dim = { 15, 10 },
						text = "human",
						images = {
							hover = {
								{
									fileName = "../gui/commander/hover.png",
									color = {1, 1, 1, 1},
								},
							},
							pushed = {
								{
									fileName = "../gui/commander/hover.png"

								},

							},
						},
					},

					aiButton1 = {
						widget = "button",
						pos = { 20, 30 },
						dim = { 15, 10 },
						text = "ai",
						images = {
							hover = {
								{
									fileName = "../gui/commander/hover.png",
									color = {1, 1, 1, 1},
								},
							},
							pushed = {
								{
									fileName = "../gui/commander/hover.png"

								},

							},
						},
					},
				}, -- end of Commander Panel 1 children
			},-- end of commander panel 1

			vsWidget = {
				widget = "image",
				pos = { 140 , 8 },
				dim = { 20, 60 },
				images = {
					{
						fileName = "../gui/commander/vs_background.png",
					},

				},
				children = {

					startButton = {
						widget = "button",
						pos = { 3 , 30 },
						dim = { 14, 11 },
						text = "START",
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
					},

					returnButton = {
						widget = "button",
						pos = { 3 , 43},
						dim = { 14 , 11 },
						text = "BACK",
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


				}, -- vs background children
			},
			commanderPanel2 = {
				widget = "image",
				pos = { 159, 50 },
				dim = { 39, 46 },
				images = {
					{
					fileName = "../gui/commander/bg.png",
					},
				},
				children = {
					Player1LabelBackground = {
						widget = "image",
						pos = { 0, -5 },
						dim = { 40, 10},
						images = {
							{
								fileName = "../gui/commander/player_text_background.png",

							},

						},
						children = {
							Player2Label = {
								widget = "label",
								pos = { 2, 5 },
								dim = { 15, 1 },
								text = "Player 2",
							},
						}, -- end of children
					},


					humanButton2 = {
						widget = "button",
						pos = { 4, 30 },
						dim = { 15, 10 },
						text = "human",
						--unselected_button.png
						images = {
							hover = {
								{
									fileName = "../gui/commander/hover.png",
									color = {1, 1, 1, 1},
								},
							},
							pushed = {
								{
									fileName = "../gui/commander/hover.png"

								},

							},
						},
					},

					aiButton2 = {
						widget = "button",
						pos = { 20, 30 },
						dim = { 15, 10 },
						text = "ai",
						images = {
							hover = {
								{
									fileName = "../gui/commander/hover.png",
									color = {1, 1, 1, 1},
								},
							},
							pushed = {
								{
									fileName = "../gui/commander/hover.png"

								},

							},
						},
					},

				}, -- end of Commander Panel 1 children
			},-- end of commander panel 2


		}, -- end of BG Panel Children

	}, -- end of bg panel

} -- end of data

return data