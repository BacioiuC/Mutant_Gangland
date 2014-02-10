local data = {
	background = {
		widget = "image",
		dim = { 100, 100 },
		pos = { 0, 0 },
		images = {
			{

				fileName = "../gui/main_menu/main_menu.png"
			},

		}, -- end of images

		children = {

			logoBg = {
				widget = "image",
				dim = { 35, 65 },
				pos = { 33, 0, },
				images = {
					{
						fileName = "../gui/main_menu/bg3.png"
					},

				},		


				children = {
					logo = {
						widget = "image",
						dim = {35, 50},
						pos = {0, 7},
						images = {
							{
								fileName = "../gui/main_menu/logo.png"
							},
						},						

					},
				},
			}, -- end of logo bg



			battleBg = {
				widget = "image",
				dim = { 35, 36 },
				pos = { -2, 64, },
				images = {
					{
						fileName = "../gui/main_menu/bg2.png"
					},

				},		


				children = {
					btnBattle = {
						widget = "button",
						dim = { 28, 18 },
						pos = { 4, 8 },
						text = "Free Battle",
						images = {
							normal = {
								{
									fileName = "../gui/main_menu/button_temp.png",
									color = {1, 1, 1, 1},
								},
							},

							pushed = {
								{
									fileName = "../gui/main_menu/button_temp_hover.png",
									color = {1, 1, 1, 1},
								},
							},

							hover = {
								{
									fileName = "../gui/main_menu/button_temp_hover.png",
									color = {1, 1, 1, 1},
								},
							},
						},
					}, -- end of button battle
				},

			},

			editorBg = {
				widget = "image",
				dim = { 35, 36 },
				pos = { 33, 64, },
				images = {
					{
						fileName = "../gui/main_menu/bg2.png"
					},

				},		


				children = {
					btnEditor = {
						widget = "button",
						dim = { 28, 18 },
						pos = { 4, 8 },
						text = "Editor",
						images = {
							normal = {
								{
									fileName = "../gui/main_menu/button_temp.png",
									color = {1, 1, 1, 1},
								},
							},

							pushed = {
								{
									fileName = "../gui/main_menu/button_temp_hover.png",
									color = {1, 1, 1, 1},
								},
							},

							hover = {
								{
									fileName = "../gui/main_menu/button_temp_hover.png",
									color = {1, 1, 1, 1},
								},
							},
						},
					}, -- end of button editor
				},

			},

			optionsBg = {
				widget = "image",
				dim = { 35, 36 },
				pos = { 68, 64, },
				images = {
					{
						fileName = "../gui/main_menu/bg2.png"
					},

				},		


				children = {
					btnOptions = {
						widget = "button",
						dim = { 28, 18 },
						pos = { 2, 8 },
						text = "Options",
						images = {
							normal = {
								{
									fileName = "../gui/main_menu/button_temp.png",
									color = {1, 1, 1, 1},
								},
							},

							pushed = {
								{
									fileName = "../gui/main_menu/button_temp_hover.png",
									color = {1, 1, 1, 1},
								},
							},

							hover = {
								{
									fileName = "../gui/main_menu/button_temp_hover.png",
									color = {1, 1, 1, 1},
								},
							},
						},
					}, -- end of button options

					btnQuit = {
						widget = "button",
						dim = { 28, 7 },
						pos = { 2, 26 },
						text = "Quit",
						images = {
							normal = {
								{
									fileName = "../gui/main_menu/button_temp.png",
									color = {1, 1, 1, 1},
								},
							},

							pushed = {
								{
									fileName = "../gui/main_menu/button_temp_hover.png",
									color = {1, 1, 1, 1},
								},
							},

							hover = {
								{
									fileName = "../gui/main_menu/button_temp_hover.png",
									color = {1, 1, 1, 1},
								},
							},
						},
					}, -- end of button options
				},
			}, -- end of options bg



			bgBar = {
				widget = "image",
				dim = { 1, 22 },
				pos = { 60, 70, },
				images = {
					{
						fileName = "../gui/main_menu/bgBar.png"
					},

				},

				children = {





					optMenu = {
						widget = "image",
						dim = { 32, 66 },
						pos = { 100, -70 },
						images = {
							{
								fileName = "../gui/main_menu/bg4.png",
							},
						},
						children = {
							volLabel = {
								widget = "label",
								pos = {2, 2},
								dim = {38, 2},
								text = "MASTER VOLUME ",
							}, -- end of volSlider

							volSlider = { 
								widget = "slider",
								pos = {2, 6},
								dim = {26, 8},
								--vert = false,
								
							}, -- end of volSlider

							lbMusic = {
								widget = "label",
								pos = { 2, 18 },
								dim = { 38, 2 },
								text = "BACKGROUND MUSIC",
							},

							btnMusicOn = {
								widget = "button",
								pos = { 2, 22 },
								dim = { 12, 8 },
								text = "ON",
								images = {
									normal = {
										{
											fileName = "../gui/main_menu/button_temp.png",
											color = {1, 1, 1, 1},
										},
									},

									pushed = {
										{
											fileName = "../gui/main_menu/button_temp_hover.png",
											color = {1, 1, 1, 1},
										},
									},

									hover = {
										{
											fileName = "../gui/main_menu/button_temp_hover.png",
											color = {1, 1, 1, 1},
										},
									},
								}
							},

							btnMusicOff = {
								widget = "button",
								pos = { 16, 22 },
								dim = { 12, 8 },
								text = "OFF",
								images = {
									normal = {
										{
											fileName = "../gui/main_menu/button_temp.png",
											color = {1, 1, 1, 1},
										},
									},

									pushed = {
										{
											fileName = "../gui/main_menu/button_temp_hover.png",
											color = {1, 1, 1, 1},
										},
									},

									hover = {
										{
											fileName = "../gui/main_menu/button_temp_hover.png",
											color = {1, 1, 1, 1},
										},
									},
								}
							}, -- end of bttnMusic

							lbZoom = {
								widget = "label",
								pos = { 2, 32 },
								dim = { 38, 2 },
								text = "ZOOM HANDLE",
							},

							btnZoomOn = {
								widget = "button",
								pos = { 2, 36 },
								dim = { 12, 8 },
								text = "ON",
								images = {
									normal = {
										{
											fileName = "../gui/main_menu/button_temp.png",
											color = {1, 1, 1, 1},
										},
									},

									pushed = {
										{
											fileName = "../gui/main_menu/button_temp_hover.png",
											color = {1, 1, 1, 1},
										},
									},

									hover = {
										{
											fileName = "../gui/main_menu/button_temp_hover.png",
											color = {1, 1, 1, 1},
										},
									},
								}
							},

							btnZoomOff = {
								widget = "button",
								pos = { 16, 36 },
								dim = { 12, 8 },
								text = "OFF",
								images = {
									normal = {
										{
											fileName = "../gui/main_menu/button_temp.png",
											color = {1, 1, 1, 1},
										},
									},

									pushed = {
										{
											fileName = "../gui/main_menu/button_temp_hover.png",
											color = {1, 1, 1, 1},
										},
									},

									hover = {
										{
											fileName = "../gui/main_menu/button_temp_hover.png",
											color = {1, 1, 1, 1},
										},
									},
								}
							}, -- end of bttnMusic

							confLabel = {
								widget = "label",
								pos = { 2, 46 },
								dim = { 38, 2 },
								text = "FULLSCREEN",
							},

							btnConOn = {
								widget = "button",
								pos = { 2, 50 },
								dim = { 12, 8 },
								text = "ON",
								images = {
									normal = {
										{
											fileName = "../gui/main_menu/button_temp.png",
											color = {1, 1, 1, 1},
										},
									},

									pushed = {
										{
											fileName = "../gui/main_menu/button_temp_hover.png",
											color = {1, 1, 1, 1},
										},
									},

									hover = {
										{
											fileName = "../gui/main_menu/button_temp_hover.png",
											color = {1, 1, 1, 1},
										},
									},
								}
							},

							btnConfOff = {
								widget = "button",
								pos = { 16, 50 },
								dim = { 12, 8 },
								text = "OFF",
								images = {
									normal = {
										{
											fileName = "../gui/main_menu/button_temp.png",
											color = {1, 1, 1, 1},
										},
									},

									pushed = {
										{
											fileName = "../gui/main_menu/button_temp_hover.png",
											color = {1, 1, 1, 1},
										},
									},

									hover = {
										{
											fileName = "../gui/main_menu/button_temp_hover.png",
											color = {1, 1, 1, 1},
										},
									},
								}
							}, -- end of bttnMusic
						}, -- end of options menu children
					}, -- end of options menu

				}, -- end of bgBar Children

			}, -- end of bg bar
		}, -- end of background children

	}, -- end of background
}

return data