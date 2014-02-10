function unit:_setWinCondition(_condition)
	self._winBool = false
	self._condition = _condition
	self._conditionTable[1] = building:_returnBuildingTable()
	self._conditionTable[2] = self._unitTable
	--self._conditionTable[3] = 

	if _condition == 1 then
		self._buildingsLeft = 0
		self._unitsLeft = nil
		self._turns = nil
		self._buildingsOwned = nil
		self._buildingsOwnedEnemy = nil
	elseif _condition == 2 then
		self._buildingsLeft = nil
		self._unitsLeft = 0
		self._turns = nil
		self._buildingsOwned = nil
		self._buildingsOwnedEnemy = nil
	elseif _condition == 3 then
		self._buildingsLeft = nil
		self._unitsLeft = nil
		self._turns = 25
		self._buildingsOwned = nil
		self._buildingsOwnedEnemy = nil
	elseif _condition == 4 then
		self._buildingsLeft = nil
		self._unitsLeft = nil
		self._turns = nil
		self._buildingsOwned = 7
		self._buildingsOwnedEnemy = 6
	end

end

function unit:_checkWinCondition( )
	return self._condition
end