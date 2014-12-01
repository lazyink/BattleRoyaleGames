/*
	File: map_simulation.sqf
	Description: Disable damage and simulation for all objects outside of the game area in BRGH
	Created By: Lystic
	Date: 10/20/2014
	Parameters: n/a
	Returns: n/a
*/

[] spawn {
	_isServerTime = false;
	_startTime = time;
	if(_startTime == 0) then {_startTime = serverTime;_isServerTime = true;};
	_objects = [0,0,0] nearObjects 1000000;
	{
		if(_x distance (getMarkerPos 'BRMini_SafeZone') > 400) then {
			if(_x isKindOf 'House') then {
				_x enableSimulationGlobal false;
				_x allowDamage false;
			};
		};
	} forEach _objects;
	_dif = 0;
	if(_isServerTime) then {
		_dif = serverTime - _startTime;
	} else {
		_dif = time - _startTime;
	};
	diag_log format["DISABLED SIMULATION ON ALL OBJECTS IN %1 SECONDS",_dif];
};