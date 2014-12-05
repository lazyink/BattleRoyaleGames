/*
	File: waitForPlayers.sqf
	Description: Player connection delay for BRGH
	Created By: Lystic
	Date: 10/20/2014
	Parameters: n/a
	Returns: n/a
*/
_countPlayers = {
	_count = 0;
	{
		if(_x getVariable ["JoinedGame",false]) then {_count = _count + 1;};
	} forEach playableUnits;
	_count;
};

while{true} do {
	_players = call _countPlayers;
	if(_players >= BRMini_Min_Players) exitWith {};
	while{true} do {
		BR_DT_PVAR = [format[(localize "str_BRGH_waitingFor") + " %1 " + (localize "str_BRGH_morePlayers") + "!",BRMini_Min_Players - _players],0,0.45,5,0];
		publicVariable "BR_DT_PVAR";
		if(_players >= BRMini_Min_Players) exitWith {};
		_time = time + 30;
		waitUntil{_players != (call _countPlayers) || time >= _time};
		_players = call _countPlayers;
	};
};	

uiSleep 30;