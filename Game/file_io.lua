testTable = {}
tableIndex = 1

email = {}

function email:init( )
	self.tCounter = 1
	eTable = {}
	self.inboxTable = {}
	self.inboxCounter = 1
	self.maxParams = 5
	
	email:parseFileToTable(eTable,"Game/emails/mission_1.txt")
	email:parseFileToTable(eTable,"Game/emails/mission_2.txt")
	email:parseFileToTable(eTable,"Game/emails/bank_email.txt")
	email:parseFileToTable(eTable,"Game/emails/research_email.txt")
	--email:debugReadTableContent(2)

	self.unreadEmail = false
end

function email:gotMail( )
	return self.unreadEmail
end

function email:setEmailNotification(_bool)
	self.unreadEmail = _bool

	local emailButton = element.primaryRow:getRow(1):getCell(1)
	if _bool == true then
		emailButton:setImage( element.resources.getPath("newMail.png"))
	elseif _bool == false then
		emailButton:setImage( element.resources.getPath("mail_icon.png") )
	end
end

function email:parseFileToTable(_tableName, _fileName)
	local file = io.open(_fileName, "r");
	--local data = file:read("*a")
	_tableName[self.tCounter] = {}
	for line in file:lines() do
	   table.insert (_tableName[self.tCounter], line);
	end
	self.tCounter = self.tCounter + 1
end

function email:debugReadTableContent(_pos)
	for i = 1, #eTable[_pos] do
		print(""..eTable[_pos][i].."")
	end
end


function email:returnEmailContent(_id)
	local _eString = ""
	for i = 1, #eTable[_id] do
		_eString = "".._eString..""..eTable[_id][i].."\n"
	end
	return _eString
end

function email:sendEmail(_id, _type)
	
	local rawString = email:returnEmailContent(_id)
	--for i = 1, self.maxParams do

	--end
	--self.inboxTable[self.inboxCounter] = {}
	local mthRandom = math.random
	local randomAuthorName = contactTable[mthRandom(1,5)]
	local modString1 = replacetext(rawString, "<NAMEHERE>", randomAuthorName )
	local modString2 = replacetext(modString1, "<RANDOMCASH>", mthRandom(1000,2000) )
	table.insert(self.inboxTable, modString2)

	local mailTitle = "From: "..randomAuthorName..""

	addNewMail_Entry(_id, mailTitle, _type)
	email:setEmailNotification(true)
	--self.inboxCounter = self.inboxCounter + 1
end

function email:sendBankingMail(_id, _type, _funds)
	local rawString = email:returnEmailContent(_id)
	local modString1 = replacetext(rawString, "<TOTAL FUNDS HERE>", bank:availableCash( ))
	local modString2 = replacetext(modString1, "<FUNDS HERE>", "".._funds.."")
	table.insert(self.inboxTable, modString2)

	addNewMail_Entry(_id, "rob@bank.com", _type)
	email:setEmailNotification(true)
end

function email:sendResearchMail(_id, _type, _funds)
	local mthRandom = math.random
	local randomAuthorName = "DYLAN"

	local rawString = email:returnEmailContent(_id)
	local modString1 = replacetext(rawString, "<NAMEHERE>", randomAuthorName)
	local modString2 = replacetext(modString1, "<TOTALSUM>", "".._funds.."$")
	local modString3 = replacetext(modString2, "<SCHEMATICHERE>", email:_makeStringFromTable(cartTable) )
	local modString4 = replacetext(modString3, "<PLAYERNAME>", Game.playerName)

	table.insert(self.inboxTable,modString4)

	addNewMail_Entry(_id, " @Research ", _type)
	email:setEmailNotification(true)

end

function email:_makeStringFromTable(_table)
	local string = ""
	for i,v in ipairs(_table) do
		string = ""..string.."- "..v.text.." \n"
	end
	return string
end


function email:returnEmail(_id)
	print("ID = ".._id.." and table size = "..#self.inboxTable.."")
	print("ID = ".._id.." and table size = "..#self.inboxTable.."")
	print("ID = ".._id.." and table size = "..#self.inboxTable.."")
	print("ID = ".._id.." and table size = "..#self.inboxTable.."")
	print("ID = ".._id.." and table size = "..#self.inboxTable.."")
	print("ID = ".._id.." and table size = "..#self.inboxTable.."")
	print("ID = ".._id.." and table size = "..#self.inboxTable.."")
	print("ID = ".._id.." and table size = "..#self.inboxTable.."")
	print("ID = ".._id.." and table size = "..#self.inboxTable.."")
	print("ID = ".._id.." and table size = "..#self.inboxTable.."")
	print("ID = ".._id.." and table size = "..#self.inboxTable.."")
	print("ID = ".._id.." and table size = "..#self.inboxTable.."")
	print("ID = ".._id.." and table size = "..#self.inboxTable.."")
	print("ID = ".._id.." and table size = "..#self.inboxTable.."")
	print("ID = ".._id.." and table size = "..#self.inboxTable.."")
	print("ID = ".._id.." and table size = "..#self.inboxTable.."")
	return self.inboxTable[_id]

end

function replacetext(source, find, replace)
	wholeword = false
	if wholeword then
		find = '%f[%a]'..find..'%f[%A]'
	end
	return (source:gsub(find,replace))
end