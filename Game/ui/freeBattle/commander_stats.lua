commander = { }
commander[1] = { name = "Mortel V", team = 1, attackBonus = 100, defenseBonus = 100, critChance = 0.5, powerup = "Healing" }
commander[2] = { name = "Twinning", team = 1, attackBonus = 100, defenseBonus = 140, critChance = 19, powerup = "Dmg"  }
commander[3] = { name = "Karl", team = 2, attackBonus = 180, defenseBonus = 80, critChance = 10, powerup = "Healing" }
commander[4] = { name = "Boby", team = 2, attackBonus = 200, defenseBonus = 100, critChance = 19, powerup = "Dmg"  }
commander[5] = { name = "Amy", team = 1, attackBonus = 130, defenseBonus = 100, critChance = 10, powerup = "Healing" }
commander[6] = { name = "Buzzmaw", team = 1, attackBonus = 116, defenseBonus = 100, critChance = 19, powerup = "Dmg"  }
commander[7] = { name = "Bumbs", team = 2, attackBonus = 107, defenseBonus = 105, critChance = 10, powerup = "Healing" }
commander[8] = { name = "Fart", team = 2, attackBonus = 128, defenseBonus = 120, critChance = 19, powerup = "Dmg"  }

stat_table = {}
stat_table[1] = {stat = "TEAM: ", value = commander[1].team }
stat_table[2] = {stat = "ATTK: ", value = commander[1].attackBonus }
stat_table[3] = {stat = "DEF: ", value = commander[1].defenseBonus }
stat_table[4] = {stat = "CRIT: ", value = commander[1].critChance }
stat_table[5] = {stat = "POW:  ", value = commander[1].powerup }


function _setStatValue(_id)
	local string = "Mutants"
	if commander[_id].team == 2 then
		string = "Robots"
	end
	stat_table[1] = {stat = "TEAM: ", value = string }
	stat_table[2] = {stat = "ATTK: ", value = commander[_id].attackBonus }
	stat_table[3] = {stat = "DEF: ", value = commander[_id].defenseBonus }
	stat_table[4] = {stat = "CRIT: ", value = commander[_id].critChance }
	stat_table[5] = {stat = "POW:  ", value = commander[_id].powerup }
	
end

map_table = {}
map_table[1] = {stat = "" }
map_table[2] = {stat = "SIZE: " }
map_table[3] = {stat = "FACTORIES: " }
map_table[4] = {stat = "HOUSES: " }