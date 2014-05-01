unit_type = {}
unit_type[1] = loadCSVData("data/mutants.csv")
unit_type[2] = loadCSVData("data/robots.csv")

--[[unit_type[1] = {}
unit_type[2] = {}

unit_type[1][1] = { name = "Chainsaw", tex = 1, health = 4, min_range = 0, max_range = 1, mobility = 3, damage = 4, cost = 20, canCapture = true }
unit_type[1][2] = { name = "Pistol",  tex = 2, health = 7, min_range = 0, max_range = 1, mobility = 3, damage = 4, cost = 30, canCapture = true }
unit_type[1][3] = { name = "Machine Gun",  tex = 3, health = 7, min_range = 0, max_range = 1, mobility = 5, damage = 5, cost = 40, canCapture = false }
unit_type[1][4] = { name = "Freeze Ray",  tex = 4, health = 8, min_range = 1, max_range = 3, mobility = 4, damage = 6, cost = 80, canCapture = false }
unit_type[1][5] = { name = "Tank",  tex = 5, health = 10, min_range = 0, max_range = 2, mobility = 5, damage = 7, cost = 130, canCapture = false, secondAbility = true }

unit_type[2][1] = { name = "Chainsaw", tex = 6, health = 4, min_range = 0, max_range = 1, mobility = 3, damage = 4, cost = 15, canCapture = true }
unit_type[2][2] = { name = "Pistol",  tex = 7, health = 7, min_range = 0, max_range = 1, mobility = 3, damage = 4, cost = 25, canCapture = true }
unit_type[2][3] = { name = "Machine Gun",  tex = 8, health = 7, min_range = 0, max_range = 1, mobility = 5, damage = 5, cost = 35, canCapture = false }
unit_type[2][4] = { name = "Freeze Ray",  tex = 9, health = 8, min_range = 1, max_range = 3, mobility = 4, damage = 6, cost = 80, canCapture = false }
unit_type[2][5] = { name = "Mech",  tex = 10, health = 10, min_range = 0, max_range = 1, mobility = 5, damage = 7, cost = 110, canCapture = false, secondAbility = true }


-- PRIMA
-- SIGNAL
-- THUNDERBYTE
-- Twinnings
-- --]]
commander_type = { }
commander_type[1] = loadCSVData("data/commanders.csv")--{ }
commander_type[2] = loadCSVData("data/commanders2.csv")
--[[
commander_type[1][1] = { name = "Prima", tex = 1, health = 20, min_range = 0, max_range = 4, mobility = 4, damage = 4, canCapture = false, start = 1, send = 4 }
commander_type[1][4] = { name = "Twinnings", tex = 4, health = 20, min_range = 0, max_range = 4, mobility = 4, damage = 4, canCapture = false, start = 13, send = 16  }
commander_type[1][3] = { name = "THUNDERBYTE", tex = 3, health =20, min_range = 0, max_range = 4, mobility = 4, damage = 4, canCapture = false, start = 9, send = 12  }
commander_type[1][2] = {  name = "Signal", tex = 2, health = 20, min_range = 0, max_range = 4, mobility = 4, damage = 4, canCapture = false, start = 5, send = 8  }

commander_type[2][1] = { name = "Prima", tex = 5, health = 20, min_range = 0, max_range = 4, mobility = 4, damage = 4, canCapture = false, start = 17, send = 20 }
commander_type[2][4] = { name = "Twinnings", tex = 8, health = 20, min_range = 0, max_range = 4, mobility = 4, damage = 4, canCapture = false, start = 29, send = 32  }
commander_type[2][3] = { name = "THUNDERBYTE", tex = 7, health = 20, min_range = 0, max_range = 4, mobility = 4, damage = 4, canCapture = false, start = 25, send = 28  }
commander_type[2][2] = {  name = "Signal", tex = 6, health = 20, min_range = 0, max_range = 4, mobility = 4, damage = 4, canCapture = false, start = 24, send = 24  }
--]]
power_table = {}
power_table[1] = { name = "HEALTH", cost = 0 }
power_table[2] = { name = "INCREASE DAMAGE", cost = 200}

