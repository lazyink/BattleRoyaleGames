/*
	File: clientFog.sqf
	Description: Realistic Fog Simulation for BRGH
	Created By: Lystic
	Date: 10/20/2014
	Parameters: n/a
	Returns: n/a
*/

_fog = _this select 0;
_density = _this select 1;
_currentHeight = _this select 2;
_heightChange = _this select 3;

diag_log ('BR FOG: ' + str _this);

if(_heightChange == 0) exitWith {0 setfog [_fog,_density,_currentHeight];};

_dir = if(_heightChange > 0) then {1} else {-1};

for "_i" from 0 to abs(_heightChange) step 2 do {
	_currentHeight = _currentHeight + (2*_dir);
	
	0.2 setfog [_fog,_density,_currentHeight];
	uiSleep 0.2;
};
diag_log ('BR FOG: DONE SETTING FOG');