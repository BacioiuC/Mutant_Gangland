local data = {

	menuPanel1 = {
		widget = "image",
		dim = { 26 , 68},
		pos = { 0 , -56 },
		images = { 
			{
				fileName = "../gui/action_phase/comBG2.png",
			},
		},
		children = { 
			menuPanBttn = {
				widget = "button",
				dim = { 26, 20 },
				pos = { 0, 68 },
				images = {
					normal = {
						{
							fileName = "../gui/action_phase/comBG.png",
						},
					},	
					pushed = {
						{
							fileName = "../gui/action_phase/comBG.png",
						},
					},	
					hover = {
						{
							fileName = "../gui/action_phase/comBG.png",
						},
					},	
				},		
				children = {
					menu_button_p = {
						widget = "image",
						dim = {9, 8},
						pos = {12, 0.2},
						text = "MENU",
						images = {
							{

								fileName = "../gui/action_phase/menu_button.png",
							},

						},

					},
					commanderPortrait_HOLDER = {
						widget = "image",
						dim = { 12, 21 },
						pos = { 0, 0},
						images = {
							{
								fileName = "../gui/action_phase/portrait_holder.png",

							},

						}, -- end of images

						children = {

							commanderImage = {
								widget = "image",
								dim = { 9, 15 },
								pos = { 1.5, 3 },
								images = {
									{
										fileName = "../gui/commander/portraits/61.png",
									},
								},

							}, -- end of commander image

						},

					}, -- end of commander portrait



					commanderDay2 = { -- label
						widget = "label",
						pos = { 13 , 8 },
						dim = { 10 , 4 },
						text = "DAY 3",		
					},

					cashIcon2 = { -- image
						widget = "image",
						pos = { 13 , 12 },
						dim = { 4 , 4 },
						images = {
							{
							fileName = "../gui/action_phase/cash.png",
							},
						},
					},

					cashLabel2 = { -- label
						widget = "label",
						pos = { 18 , 12 },
						dim = { 10 , 4 },
						text = "9000",

					}, -- end of cash label

				}, -- end of menuButton Children

			}, -- end of menu button

			endTurnButton2 = {
				widget = "button",
				pos = { 3.5, 5 },
				dim = { 19, 8 },
				text = "END TURN",
				images = {
					normal = {
						{
							fileName = "../gui/action_phase/end_turn_button.png",
							color = {1, 1, 1, 1},
						},
					},
					pushed = {
						{
							fileName = "../gui/action_phase/end_turn_button_hover_pressed.png",
						},
					},	
					hover = {
						{
							fileName = "../gui/action_phase/end_turn_button_hover_pressed.png",
						},
					},
				},
			}, -- end of end turn button

			quuitToMap = {
				widget = "button",
				pos = { 3.5, 15 },
				dim = { 19, 8 },
				text = "QUIT TO START",
				images = {
					normal = {
						{
							fileName = "../gui/action_phase/end_turn_button.png",
							color = {1, 1, 1, 1},
						},
					},
					pushed = {
						{
							fileName = "../gui/action_phase/end_turn_button_hover_pressed.png",
						},
					},	
					hover = {
						{
							fileName = "../gui/action_phase/end_turn_button_hover_pressed.png",
						},
					},
				},
			}, -- end of end turn button

			buttonScrollUp = {
				widget = "button",
				dim = { 22, 10 },
				pos = { 2, 55},
				text = "",
				images = {
					normal = {
						{

							fileName = "../gui/action_phase/scroll_up_background.png",
						},

					},
					pushed = {
						{
							fileName = "../gui/action_phase/scroll_up_background_p.png",
						},
					},	
					hover = {
						{
							fileName = "../gui/action_phase/scroll_up_background_p.png",
						},
					},

				},
			},
			endTurnButton3 = {
					widget = "button",
					dim = { 10, 5 },
					pos = { 1, 89 },
					text = "End",
					images = {
						normal = {
							{

								fileName = "../gui/action_phase/end_turn_small.png",
							},

						},
						pushed = {
							{
								fileName = "../gui/action_phase/end_turn_small_hover.png",
							},
						},	
						hover = {
							{
								fileName = "../gui/action_phase/end_turn_small_hover.png",
							},
						},

					},	-- end of images				
				}, -- smaller, blue one
		}, -- end of menuPanel1 CHILDREN
	},

	computerSign = {
		widget = "image",
		dim = { 30 , 18 },
		pos = { 24 , -500 },
		images = {
			{
				fileName = "../gui/action_phase/computers_turn.png",
			},

		},

	},

	imagePanel = {
		widget = "image",
		pos = { 100 , 0 },
		dim = { 24 , 100 },
		images = {
			{
				fileName = "../gui/action_phase/commander_info_holder.png",
			},
		},
		children = {
			commanderPicture = { -- img
				widget = "image",
				pos = { 1.5 , 1.5 },
				dim = { 6 , 9 },
				images = {
					{
					fileName = "../gui/freeBattle/portraits/51.png",
					},
				},

			},

			commanderName = { -- label
				widget = "label",
				pos = { 9 , 1 },
				dim = { 16 , 2 },
				text = " COMMANDER",	
				textstyle = "blue",		

			},

			commanderDay = { -- label
				widget = "label",
				pos = { 9 , 4 },
				dim = { 15 , 2 },
				text = " DAY 3 ",		
			},

			cashIcon = { -- image
				widget = "image",
				pos = { 9 , 7 },
				dim = { 4 , 4 },
				images = {
					{
					fileName = "../gui/action_phase/cash.png",
					},
				},

			},

			cashLabel = { -- label
				widget = "label",
				pos = { 14 , 8 },
				dim = { 15 , 2 },
				text = "9000",

			}, -- end of cash label


			zoomHolder = {
				widget = "image",
				pos = { 1, 12 },
				dim = { 22 , 8 },
				images = {
					{
						fileName = "../gui/action_phase/zoom_holder.png"
					},
				}, -- end of images

				children = {
					zoomPlus = {
						widget = "button",
						pos = { 1, 1 },
						dim = { 8, 6 },
						text = "ZOOM +",
						images = {
							normal = {
								{
								fileName = "../gui/action_phase/zoom_bttn_plus.png",
								color = {1, 1, 1, 1},
								},
							},
						},					
					}, -- end of zoom+

					zoomMin = {
						widget = "button",
						pos = { 13, 1 },
						dim = { 8, 6 },
						text = "ZOOM -",
						images = {
							normal = {
								{
								fileName = "../gui/action_phase/zoom_bttn_min.png",
								color = {1, 1, 1, 1},
								},
							},
						},					
					}, -- end of zoom-

				}, -- end of zoomHolder_Children

			}, -- end of zoomHolder

			menuDock = {
				widget = "image",
				pos = { 1, 21 },
				dim = { 22 , 6 },
				images = {
					{
						fileName = "../gui/action_phase/zoom_holder.png"
					},
				},
				children = {
					menuButton = {
						widget = "button",
						pos = { 1, 1 },
						dim = { 20, 4 },
						text = "MENU",
						images = {
							normal = {
								{
									fileName = "../gui/action_phase/dock_button.png",
									color = {1, 1, 1, 1},
								},
							},
						},
					}, -- end of menu button

				}, -- end of menuDock Children
			}, -- end of menu dock

			bottomDock = {
				widget = "image",
				pos = { 1, 28 },
				dim = { 22 , 71 },
				images = {
					{
						fileName = "../gui/action_phase/zoom_holder_bottom.png"
					},
				},				
				children = {
					endTurnButton = {
						widget = "button",
						pos = { 2.5, 61 },
						dim = { 19, 5 },
						text = "END TURN",
						images = {
							normal = {
								{
									fileName = "../gui/action_phase/end_turn_button.png",
									color = {1, 1, 1, 1},
								},
							},
						},
					}, -- end of end turn button

					menuChildHolder = {
						widget = "image",
						pos = { 56, 1.5 },
						dim = { 22, 40 },
						children = {
							saveButton = {
								widget = "button",
								pos = { 2.5, 3.5 },
								dim = { 17, 7 },
								text = "SAVE",
								images = {
									normal = {
										{
											fileName = "../gui/action_phase/dock_button.png",
											color = {1, 1, 1, 1},
										},
									},
								},
							}, -- end of save button

							termsButton = {
								widget = "button",
								pos = { 2.5, 11.5 },
								dim = { 17, 7 },
								text = "TERMS",
								images = {
									normal = {
										{
											fileName = "../gui/action_phase/end_turn_button.png",
											color = {1, 1, 1, 1},
										},
									},
								},
							}, -- end of Terms button

							abandonButton = {
								widget = "button",
								pos = { 2.5, 19.5 },
								dim = { 17, 7 },
								text = "QUIT",
								images = {
									normal = {
										{
											fileName = "../gui/action_phase/quit_button.png",
											color = {1, 1, 1, 1},
										},
									},
								},
							}, -- end of Terms button


						}, -- end of menuChildHolder children

					}, -- end of menuChildHolder




				}, -- end of bottomDock Children
			},
		}, -- ned of image panel children
	},

}

return data